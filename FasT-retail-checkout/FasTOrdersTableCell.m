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

- (void)updateWithOrder:(FasTOrder *)order
{
    [leftLabel setText:[order queueNumber]];
    [middleLabel setText:[FasTFormatter stringForEventDate:[order created]]];
    [rightLabel setText:[FasTFormatter stringForPrice:[order total]]];
}

@end
