//
//  FasTOrderViewController.m
//  FasT-retail-checkout
//
//  Created by Albrecht Oster on 10.05.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTOrderViewController.h"
#import "FasTOrder.h"
#import "FasTFormatter.h"
#import "FasTApi.h"
#import "FasTTicketPrinter.h"

@interface FasTOrderViewController ()

- (void)markAsPaid;
- (void)tappedPriceButton;
- (void)printTickets;

@end

@implementation FasTOrderViewController

- (id)initWithOrder:(FasTOrder *)o
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        order = [o retain];
        
        sections = [@[
                       @{@"title": NSLocalizedStringByKey(@"general"), @"rows": @[
                           @[NSLocalizedStringByKey(@"order"), [order number]],
                           @[NSLocalizedStringByKey(@"orderedAt"), [NSDateFormatter localizedStringFromDate:[order created] dateStyle:NSDateFormatterShortStyle timeStyle:NSDateFormatterMediumStyle]]
                       ]},
                       @{@"title": NSLocalizedStringByKey(@"details"), @"rows": @[
                           @[NSLocalizedStringByKey(@"tickets"), [NSString stringWithFormat:@"%i", [[order tickets] count]]],
                           @[NSLocalizedStringByKey(@"totalPrice"), [FasTFormatter stringForPrice:[order total]]]
                       ]}
                    ] retain];
        
        [[self navigationItem] setTitle:[NSString stringWithFormat:NSLocalizedStringByKey(@"orderWithNumber"), [order number]]];
        
        [[self tableView] setAllowsSelection:NO];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [sections release];
    [order release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [sections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return sections[section][@"title"];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section != 0) return nil;
    
    UIView *view = [[NSBundle mainBundle] loadNibNamed:@"FasTOrderPriceView" owner:nil options:nil][0];
    
    UILabel *priceLabel = (UILabel *)[view viewWithTag:1];
    [priceLabel setText:[FasTFormatter stringForPrice:[order total]]];
    UIButton *markBtn = (UIButton *)[view viewWithTag:2];
    [markBtn addTarget:self action:@selector(tappedPriceButton) forControlEvents:UIControlEventTouchUpInside];
    if ([order paid]) {
        [priceLabel setTextColor:[UIColor greenColor]];
        [markBtn setTitle:NSLocalizedStringByKey(@"reprintTickets") forState:UIControlStateNormal];
    }
         
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return (section == 0) ? 73 : 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [sections[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
    }
    
    NSArray *rows = sections[[indexPath section]][@"rows"][[indexPath row]];
    [[cell textLabel] setText:rows[0]];
    [[cell detailTextLabel] setText:rows[1]];
    
    return cell;
}

- (void)markAsPaid
{
    [[FasTApi defaultApi] markOrderAsPaid:order withCallback:^(NSDictionary *response) {
        if ([response[@"ok"] boolValue]) {
            [order setPaid:YES];
            [self printTickets];
            [[self tableView] reloadData];
        }
    }];
}

- (void)tappedPriceButton
{
    if ([order paid]) {
        UIAlertView *alert = [[[UIAlertView alloc] initWithTitle:NSLocalizedStringByKey(@"reprintTickets") message:NSLocalizedStringByKey(@"reprintTicketsConfirmation") delegate:self cancelButtonTitle:NSLocalizedStringByKey(@"no") otherButtonTitles:NSLocalizedStringByKey(@"yes"), nil] autorelease];
        [alert show];
        
    } else {
        [self markAsPaid];
    }
}

- (void)printTickets
{
    [[FasTTicketPrinter sharedPrinter] printTicketsForOrder:order];
}

#pragma mark alert delegate

- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) [self printTickets];
}

@end
