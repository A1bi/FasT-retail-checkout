//
//  FasTOrdersViewController.m
//  FasT-retail-checkout
//
//  Created by Albrecht Oster on 10.05.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTOrdersTableViewController.h"
#import "FasTApi.h"
#import "FasTOrdersTableCell.h"
#import "FasTOrderViewController.h"

@interface FasTOrdersTableViewController ()

- (void)updateOrdersWithNotification:(NSNotification *)note;

@end

static NSString *cellIdentifier = @"OrderCell";

@implementation FasTOrdersTableViewController

- (id)initWithType:(FasTOrdersTableViewControllerType)t
{
    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        type = t;
        
        NSString *titleKey = (type == FasTOrdersTableViewControllerUnpaid) ? @"unpaidOrders" : @"recentOrders";
        [self setTitle:NSLocalizedStringByKey(titleKey)];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateOrdersWithNotification:) name:@"updateOrders" object:nil];
        
        [[self tableView] registerNib:[UINib nibWithNibName:@"FasTOrdersTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
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
    [cell updateWithOrder:orders[[indexPath row]] withRecentStyle:(type == FasTOrdersTableViewControllerRecent)];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FasTOrderViewController *ovc = [[[FasTOrderViewController alloc] initWithOrder:[orders objectAtIndex:[indexPath row]]] autorelease];
    [[self navigationController] pushViewController:ovc animated:YES];
}

#pragma mark - class methods

- (void)updateOrdersWithNotification:(NSNotification *)note
{
    [orders release];
    NSArray *allOrders = [note userInfo][@"orders"];
    
    if (type == FasTOrdersTableViewControllerUnpaid) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"paid == NO"];
        orders = [allOrders filteredArrayUsingPredicate:predicate];
    } else {
        orders = allOrders;
    }
    
    [orders retain];
    
    [[[self navigationController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%i", [orders count]]];
    
    [[self tableView] reloadData];
}

@end
