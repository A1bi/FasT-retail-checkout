//
//  FasTAppDelegate.m
//  FasT-retail-checkout
//
//  Created by Albrecht Oster on 08.05.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTAppDelegate.h"
#import "FasTApi.h"
#import "FasTTicketPrinter.h"
#import "FasTOrdersTableViewController.h"
#import "FasTSettingsTableViewController.h"
#import "MBProgressHUD.h"

@interface FasTAppDelegate ()

- (void)showLocalizedHUDMessageWithKey:(NSString *)key mode:(MBProgressHUDMode)mode animated:(BOOL)animated;
- (void)showOutOfOrderMessage;

@end

@implementation FasTAppDelegate

- (void)dealloc
{
    // TODO: observers with blocks have to be removed differently
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [hud release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    [self.window makeKeyAndVisible];
    

    FasTApi *api = [FasTApi defaultApi];
    [api initWithClientType:@"retail-checkout"];
    [[NSNotificationCenter defaultCenter] addObserverForName:FasTApiIsReadyNotification object:api queue:nil usingBlock:^(NSNotification *note) {
        [api getOrders];
    }];
    
    [FasTTicketPrinter sharedPrinter];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    
    UITabBarController *tbc = [[[UITabBarController alloc] init] autorelease];
    [self.window setRootViewController:tbc];
    
    UIViewController *vc = [[[FasTOrdersTableViewController alloc] initWithType:FasTOrdersTableViewControllerUnpaid] autorelease];
    UINavigationController *nvc = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    
    vc = [[[FasTOrdersTableViewController alloc] initWithType:FasTOrdersTableViewControllerRecent] autorelease];
    UINavigationController *nvc2 = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];
    
    vc = [[[FasTSettingsTableViewController alloc] init] autorelease];
    UINavigationController *nvc3 = [[[UINavigationController alloc] initWithRootViewController:vc] autorelease];

    [tbc setViewControllers:@[nvc, nvc2, nvc3]];
    
    hud = [[MBProgressHUD showHUDAddedTo:self.window animated:YES] retain];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserverForName:FasTApiIsReadyNotification object:nil queue:nil usingBlock:^(NSNotification *note) {
        [hud hide:YES];
    }];
    [center addObserver:self selector:@selector(showOutOfOrderMessage) name:FasTApiDisconnectedNotification object:nil];
    [center addObserver:self selector:@selector(showOutOfOrderMessage) name:FasTApiCannotConnectNotification object:nil];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [self showLocalizedHUDMessageWithKey:@"connecting" mode:MBProgressHUDModeIndeterminate animated:NO];
}

- (void)showLocalizedHUDMessageWithKey:(NSString *)key mode:(MBProgressHUDMode)mode animated:(BOOL)animated
{
    [hud setMode:mode];
    [hud setLabelText:NSLocalizedStringByKey(key)];
    NSString *detailsKey = [NSString stringWithFormat:@"%@Details", key],
             *detailsMessage = NSLocalizedStringByKey(detailsKey);
    if (![detailsKey isEqualToString:detailsMessage]) {
        [hud setDetailsLabelText:detailsMessage];
    }
    [hud show:animated];
}

- (void)showOutOfOrderMessage
{
    [self showLocalizedHUDMessageWithKey:@"outOfOrder" mode:MBProgressHUDModeText animated:YES];
}

@end
