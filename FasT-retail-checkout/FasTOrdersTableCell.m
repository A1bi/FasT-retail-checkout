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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    return self;
}

- (void)updateWithOrder:(FasTOrder *)order
{
    [[self textLabel] setText:@"2"];
    [[self detailTextLabel] setText:[FasTFormatter stringForPrice:[order total]]];
}

@end
