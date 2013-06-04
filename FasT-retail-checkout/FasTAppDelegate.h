//
//  FasTAppDelegate.h
//  FasT-retail-checkout
//
//  Created by Albrecht Oster on 08.05.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MBProgressHUD;

@interface FasTAppDelegate : UIResponder <UIApplicationDelegate>
{
    MBProgressHUD *hud;
}

@property (strong, nonatomic) UIWindow *window;

@end
