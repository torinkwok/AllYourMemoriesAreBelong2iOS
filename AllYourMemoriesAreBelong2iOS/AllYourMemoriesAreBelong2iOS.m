//
//  MemoryWarningInducer.m
//  MemoryWarningInducer
//
//  Created by Tong G. on 6/21/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "AllYourMemoriesAreBelong2iOS.h"

#import <objc/runtime.h>
#import <objc/message.h>

// UIApplication + MWISwizzling
@interface UIApplication ( MWISwizzling )
- ( instancetype ) swizzling_init_;
@end // UIApplication + MWISwizzling

// UIApplication + MWISwizzling
@implementation UIApplication ( MWISwizzling )

- ( instancetype ) swizzling_init_
    {
    NSLog( @"\U0001F383" );
    return [ self swizzling_init_ ];
    }

@end // UIApplication + MWISwizzling

__attribute__( ( constructor ) )
void test ( void )
    {
    Method oldMethod = class_getInstanceMethod( [ UIApplication class ], @selector( init ) );
    IMP oldImp = method_getImplementation( oldMethod );

    Method newMethod = class_getInstanceMethod( [ UIApplication class ], @selector( swizzling_init_ ) );
    IMP newImp = method_getImplementation( newMethod );

    method_setImplementation( oldMethod, newImp );
    method_setImplementation( newMethod, oldImp );
    }