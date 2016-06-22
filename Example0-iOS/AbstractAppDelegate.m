//
//  AbstractAppDelegate.m
//  AllYourMemoriesAreBelong2iOS
//
//  Created by Tong G. on 6/22/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import "AbstractAppDelegate.h"

@interface AbstractAppDelegate ()
@end

@implementation AbstractAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    UISlider* slider = [ self.window.rootViewController.view viewWithTag: 1000 ];
    [ slider addObserver: self forKeyPath: NSStringFromSelector( @selector( value ) ) options: NSKeyValueObservingOptionNew | NSKeyValueObservingOptionNew context: NULL ];

    return YES;
}

//- ( void ) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)contextn
//    {
//    NSLog( @"from super %@", change );
//    }

@end
