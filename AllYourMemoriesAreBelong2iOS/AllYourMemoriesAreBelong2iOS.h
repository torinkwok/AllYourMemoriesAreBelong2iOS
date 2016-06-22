//
//  AllYourMemoriesAreBelong2iOS.h
//  AllYourMemoriesAreBelong2iOS
//
//  Created by Tong G. on 6/22/16.
//  Copyright © 2016 Tong Kuo. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for AllYourMemoriesAreBelong2iOS.
FOUNDATION_EXPORT double AllYourMemoriesAreBelong2iOSVersionNumber;

//! Project version string for AllYourMemoriesAreBelong2iOS.
FOUNDATION_EXPORT const unsigned char AllYourMemoriesAreBelong2iOSVersionString[];

// In this header, you should import all the public headers of your framework using statements like #import <AllYourMemoriesAreBelong2iOS/PublicHeader.h>

// UIApplication + MWISwizzling
@interface UIApplication ( MWISwizzling )

- ( instancetype ) swizzling_init_;

@end // UIApplication + MWISwizzling