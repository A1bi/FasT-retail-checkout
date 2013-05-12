//
//  FasTOrdersViewController.h
//  FasT-retail-checkout
//
//  Created by Albrecht Oster on 10.05.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    FasTOrdersTableViewControllerUnpaid,
    FasTOrdersTableViewControllerRecent
} FasTOrdersTableViewControllerType;

@interface FasTOrdersTableViewController : UITableViewController <UISearchDisplayDelegate>
{
    NSArray *orders;
    NSArray *foundOrders;
    NSArray *tableOrders;
    FasTOrdersTableViewControllerType type;
    UISearchDisplayController *searchDisplay;
}

- (id)initWithType:(FasTOrdersTableViewControllerType)type;

@end
