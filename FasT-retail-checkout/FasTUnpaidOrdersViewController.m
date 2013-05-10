//
//  FasTOrdersViewController.m
//  FasT-retail-checkout
//
//  Created by Albrecht Oster on 10.05.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTUnpaidOrdersViewController.h"
#import "FasTApi.h"
#import "FasTOrdersTableCell.h"

@interface FasTUnpaidOrdersViewController ()

- (void)updateOrdersWithNotification:(NSNotification *)note;

@end

static NSString *cellIdentifier = @"Cell";

@implementation FasTUnpaidOrdersViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        [[self tabBarItem] setTitle:@"Unbezahlte Bestellungen"];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrdersWithNotification:) name:@"updateOrders" object:nil];
        
        [[self tableView] registerClass:[FasTOrdersTableCell class] forCellReuseIdentifier:cellIdentifier];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[FasTApi defaultApi] getOrders];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [orders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FasTOrdersTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell updateWithOrder:orders[[indexPath row]]];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

#pragma mark - class methods

- (void)updateOrdersWithNotification:(NSNotification *)note
{
    NSArray *allOrders = [note userInfo][@"orders"];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"paid == NO"];
    [orders release];
    orders = [[allOrders filteredArrayUsingPredicate:predicate] retain];
    
    [[self tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%i", [orders count]]];
    
    [[self tableView] reloadData];
}

@end
