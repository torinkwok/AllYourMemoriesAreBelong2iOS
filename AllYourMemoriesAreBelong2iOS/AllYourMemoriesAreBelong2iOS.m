//
//  MemoryWarningInducer.m
//  MemoryWarningInducer
//
//  Created by Tong G. on 6/21/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "AllYourMemoriesAreBelong2iOS.h"

#import <AVFoundation/AVFoundation.h>

#import <objc/runtime.h>
#import <objc/message.h>

// UIApplication + MWISwizzling
@interface UIApplication ( MWISwizzling )
- ( void ) swizzling_setDelegate: ( id <UIApplicationDelegate> )_New;
@end // UIApplication + MWISwizzling

__attribute__( ( constructor ) )
static void swizzling_stick ()
    {
    Method oldMethod = class_getInstanceMethod( [ UIApplication class ], @selector( setDelegate: ) );
    IMP oldImp = method_getImplementation( oldMethod );

    Method newMethod = class_getInstanceMethod( [ UIApplication class ], @selector( swizzling_setDelegate: ) );
    IMP newImp = method_getImplementation( newMethod );

    method_setImplementation( oldMethod, newImp );
    method_setImplementation( newMethod, oldImp );
    }

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

void ( ^TriggerMemoryWarning_ )() = ^{
    dispatch_async( dispatch_get_main_queue(), ( dispatch_block_t )^{
        [ [ UIApplication sharedApplication ] performSelector: @selector( _performMemoryWarning ) ];
        } );
    };

void static* asObserverContext = &asObserverContext;
Class static FBKVOControllerClass = nil;
void static* const kKVOControllerAssKey = @"kKVOControllerAssKey";

//id kvo_callback_imp ( id _Sender, SEL _Selector, NSString* _KeyPath,  )
//    {
//    if ( _Context == asObserverContext )
//        TriggerMemoryWarning_();
//
//    return
//    }

// UIApplication + MWISwizzling
@implementation UIApplication ( MWISwizzling )

- ( void ) swizzling_setDelegate: ( id <UIApplicationDelegate> )_NewDelegate
    {
    // Debug code that lets us simulate memory warnings by pressing the device's volume buttons.
    // Don't ever ship this code in releasing version, as it will be rejected by Apple.

    AVAudioSession* sharedSession = [ AVAudioSession sharedInstance ];
    [ sharedSession setActive: YES error: nil ];

    NSKeyValueObservingOptions kvoOptions = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionNew;
    NSString* keypath = NSStringFromSelector( @selector( outputVolume ) );

    if ( ( FBKVOControllerClass = objc_lookUpClass( "FBKVOController" ) ) )
        {
        id kvoController = kvoController = objc_msgSend( [ FBKVOControllerClass alloc ], @selector( initWithObserver:retainObserved: ), _NewDelegate, NO );
        objc_setAssociatedObject( _NewDelegate, kKVOControllerAssKey, kvoController, OBJC_ASSOCIATION_RETAIN );

        ( ( void (*)( id, SEL, id, NSString*, NSKeyValueObservingOptions, void ( ^FBKVONotificationBlock )( id _Nullable, id, NSDictionary <NSString*, id>* ) ) )objc_msgSend )
            ( ( id )kvoController
            , @selector( observe:keyPath:options:block: )
            , sharedSession
            , keypath
            , kvoOptions
            , [ ^( id _Observer, id _Observing, NSDictionary <NSString*, id>* _Change ){ TriggerMemoryWarning_(); } copy ]
            );
        }
    else
        [ sharedSession addObserver: _NewDelegate forKeyPath: keypath options: kvoOptions context: &asObserverContext ];

    return [ self swizzling_setDelegate: _NewDelegate ];
    }

- ( void ) observeValueForKeyPath: ( NSString* )_KeyPath ofObject: ( id )_Object change: ( NSDictionary <NSString*, id>* )_Change context: ( void* )_Context
    {
    if ( _Context == asObserverContext )
        TriggerMemoryWarning_();
    }

#pragma clang diagnostic pop

@end // UIApplication + MWISwizzling