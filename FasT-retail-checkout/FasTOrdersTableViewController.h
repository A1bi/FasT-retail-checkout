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

@interface FasTOrdersTableViewController : UITableViewController
{
    NSArray *orders;
    FasTOrdersTableViewControllerType type;
}

- (id)initWithType:(FasTOrdersTableViewControllerType)type;

@end
