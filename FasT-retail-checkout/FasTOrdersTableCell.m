//
//  FasTOrdersTableCell.m
//  FasT-retail-checkout
//
//  Created by Albrecht Oster on 10.05.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTOrdersTableCell.h"
#import "FasTFormatter.h"
#import "FasTOrder.h"

@implementation FasTOrdersTableCell

- (void)updateWithOrder:(FasTOrder *)order withRecentStyle:(BOOL)recent
{
    [leftLabel setText:(recent) ? [order number] : [order queueNumber]];
    [middleLabel setText:[NSDateFormatter localizedStringFromDate:[order created] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterShortStyle]];
    [rightLabel setText:[FasTFormatter stringForPrice:[order total]]];
    
    if (recent) {
        UIColor *color = ([order paid]) ? [UIColor greenColor] : [UIColor redColor];
        [rightLabel setTextColor:color];
    }
}

@end
