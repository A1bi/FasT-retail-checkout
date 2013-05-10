//
//  FasTOrdersTableCell.h
//  FasT-retail-checkout
//
//  Created by Albrecht Oster on 10.05.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FasTOrder;

@interface FasTOrdersTableCell : UITableViewCell
{
    IBOutlet UILabel *leftLabel;
    IBOutlet UILabel *middleLabel;
    IBOutlet UILabel *rightLabel;
}

- (void)updateWithOrder:(FasTOrder *)order;

@end
