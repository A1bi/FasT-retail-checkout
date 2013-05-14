//
//  FasTOrderViewController.h
//  FasT-retail-checkout
//
//  Created by Albrecht Oster on 10.05.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FasTOrder;

@interface FasTOrderViewController : UITableViewController <UIAlertViewDelegate>
{
    NSArray *sections;
    FasTOrder *order;
}

- (id)initWithOrder:(FasTOrder *)order;

@end
