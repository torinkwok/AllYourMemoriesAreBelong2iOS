//
//  MemoryWarningInducer.m
//  MemoryWarningInducer
//
//  Created by Tong G. on 6/21/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#if ( DEBUG )
#   pragma clang diagnostic push
#   pragma clang diagnostic ignored "-Wundeclared-selector"
#
#   import "AllYourMemoriesAreBelong2iOS.h"
#   import <AVFoundation/AVFoundation.h>
#   import <objc/runtime.h>
#   import <objc/message.h>
#
// UIApplication + MWISwizzling
@interface UIApplication ( MWISwizzling )
- ( void ) mwi_swizzling_setDelegate: ( id <UIApplicationDelegate> )_New;
@end // UIApplication + MWISwizzling

static BOOL mwi_check_if_object_overrides_selector( id _Object, SEL _Selector )
    {
    Class objSuperClass = [ _Object superclass ];

    BOOL isMethodOverridden =
        [ _Object methodForSelector: _Selector ]
            != [ objSuperClass instanceMethodForSelector: _Selector ];

    return isMethodOverridden;
    }

static void mwi_swizzle_stick ( Class _LhsClass, SEL _LhsSelector, Class _RhsClass, SEL _RhsSelector )
    {
    Method lhsMethod = class_getInstanceMethod( _LhsClass, _LhsSelector );
    IMP lhsImp = method_getImplementation( lhsMethod );

    Method rhsMethod = class_getInstanceMethod( _RhsClass, _RhsSelector );
    IMP rhsImp = method_getImplementation( rhsMethod );

    method_setImplementation( lhsMethod, rhsImp );
    method_setImplementation( rhsMethod, lhsImp );
    }

__attribute__( ( constructor ) )
static void mwi_swizzling_factory ()
    {
    mwi_swizzle_stick(
        [ UIApplication class ]
        , @selector( setDelegate: )
        , [ UIApplication class ]
        , @selector( mwi_swizzling_setDelegate: )
        );
    }

static void mwi_trigger_memory_warning ()
    {
    dispatch_async( dispatch_get_main_queue(), ( dispatch_block_t )^{
        [ [ UIApplication sharedApplication ] performSelector: @selector( _performMemoryWarning ) ];
        } );
    }

void static* asObserverContext = &asObserverContext;
void static* const kKVOControllerAssKey = @"kKVOControllerAssKey";

static id mwi_backup_kvo_callback_imp
    ( id _Sender
    , SEL _Selector
    , NSString* _KeyPath
    , id _Object
    , NSDictionary <NSString*, id>* _Change
    , void* _Context )
    {
    // struct objc_super dad;
    // dad.receiver = _Sender;
    // dad.super_class = class_getSuperclass( object_getClass( _Sender ) );
    //
    // ( ( void (*)( id, SEL, NSString*, id, NSDictionary <NSString*, id>*, void* ) )objc_msgSendSuper )
    //     ( ( __bridge id )( &dad ), _Selector, _KeyPath, _Object, _Change, _Context );

    /* FIXME: The commented code fragment above causes an uncaught exception:

      "Terminating app due to uncaught exception 'NSInternalInconsistencyException', 
       reason: '<AppDelegate: 0x13fe16ea0>: An -observeValueForKeyPath:ofObject:change:context: message was received 
       but not handled. Key path: outputVolume".

       Refer to the discussions here: http://stackoverflow.com/questions/12270429/message-was-received-but-not-handled-kvo
     */

    if ( _Context == asObserverContext )
        mwi_trigger_memory_warning();
    return nil;
    }

// UIApplication + MWISwizzling
@implementation UIApplication ( MWISwizzling )

- ( void ) mwi_swizzling_observeValueForKeyPath:
              ( NSString* )_KeyPath
    ofObject: ( id )_Object
      change: ( NSDictionary <NSString*, id>* )_Change
     context: ( void* )_Context
    {
    if ( _Context == asObserverContext )
        mwi_trigger_memory_warning();

    [ self mwi_swizzling_observeValueForKeyPath: _KeyPath ofObject: _Object change: _Change context: _Context ];
    }

- ( void ) mwi_swizzling_setDelegate: ( id <UIApplicationDelegate> )_NewDelegate
    {
    // Debug code that lets us simulate memory warnings by pressing the device's volume buttons.
    // Don't ever ship this code in releasing version, as it will be rejected by Apple.

    AVAudioSession* sharedSession = [ AVAudioSession sharedInstance ];
    [ sharedSession setActive: YES withOptions: AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error: nil ];

    NSKeyValueObservingOptions kvoOptions = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionNew;
    NSString* keypath = NSStringFromSelector( @selector( outputVolume ) );

    Class FBKVOControllerClass = nil;

    // FBKVOController.framework is hot-swappaable.
    // Take advantage of FBKVOController.framework if the host app has incorporated it...
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
            , [ ^( id _Observer, id _Observing, NSDictionary <NSString*, id>* _Change ){ mwi_trigger_memory_warning(); } copy ]
            );
        }
    else // otherwise, the raw, of course, ugly KVO API would be applied instead...
        {
        SEL kvoNativeCallback = @selector( observeValueForKeyPath:ofObject:change:context: );
        SEL kvoSwizzledCallback = @selector( mwi_swizzling_observeValueForKeyPath:ofObject:change:context: );

        char const* typeEncoding = "v@:{NSString=#}{AVAudioSession=#}{NSDictionary=#}^type";
        BOOL resultOfClassAddtion = NO;

        // If the AppDelegate object of host app overrides `observeValueForKeyPath:ofObject:change:context:`...
        if ( mwi_check_if_object_overrides_selector( _NewDelegate, kvoNativeCallback ) )
            {
            mwi_swizzle_stick( [ _NewDelegate class ], kvoNativeCallback, [ self class ], kvoSwizzledCallback );

            IMP imp = class_getMethodImplementation( [ self class ], kvoSwizzledCallback );
            resultOfClassAddtion =
                class_addMethod( [ _NewDelegate class ], kvoSwizzledCallback, imp, typeEncoding );
            }
        else // otherwise, insert the backup implementation on the fly...
            {
            resultOfClassAddtion =
                class_addMethod(
                    [ _NewDelegate class ]
                    , kvoNativeCallback
                    , ( IMP )mwi_backup_kvo_callback_imp
                    , typeEncoding
                    );
            }

        NSAssert( resultOfClassAddtion, @"class_addMethod() fails" );

        [ sharedSession addObserver: _NewDelegate forKeyPath: keypath options: kvoOptions context: &asObserverContext ];
        }

    return [ self mwi_swizzling_setDelegate: _NewDelegate ];
    }

@end // UIApplication + MWISwizzling
#
#   pragma clang diagnostic pop
#endif