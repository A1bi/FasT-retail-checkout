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
- (void)registerCellNibForTableView:(UITableView *)tableView;

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
        
        [self registerCellNibForTableView:[self tableView]];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[FasTApi defaultApi] getOrders];
    
    if (type == FasTOrdersTableViewControllerRecent) {
        UISearchBar *searchBar = [[[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)] autorelease];
        [searchBar setKeyboardType:UIKeyboardTypeDecimalPad];
        [searchBar setPlaceholder:NSLocalizedStringByKey(@"orderNumber")];
        [[self tableView] setTableHeaderView:searchBar];
        
        searchDisplay = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        [searchDisplay setDelegate:self];
        [searchDisplay setSearchResultsDataSource:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [orders release];
    [foundOrders release];
    [searchDisplay release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tableOrders count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FasTOrdersTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell updateWithOrder:tableOrders[[indexPath row]] withRecentStyle:(type == FasTOrdersTableViewControllerRecent)];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FasTOrderViewController *ovc = [[[FasTOrderViewController alloc] initWithOrder:[orders objectAtIndex:[indexPath row]]] autorelease];
    [[self navigationController] pushViewController:ovc animated:YES];
}

#pragma mark search display delegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"number beginswith %@", searchString];
    [foundOrders release];
    tableOrders = foundOrders = [[orders filteredArrayUsingPredicate:predicate] retain];
    
    return YES;
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller
{
    tableOrders = orders;
}

- (void)searchDisplayController:(UISearchDisplayController *)controller didLoadSearchResultsTableView:(UITableView *)tableView
{
    [self registerCellNibForTableView:tableView];
    [tableView setDelegate:self];
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
    tableOrders = [orders retain];
    
    [[[self navigationController] tabBarItem] setBadgeValue:[NSString stringWithFormat:@"%i", [orders count]]];
    
    [[self tableView] reloadData];
}

- (void)registerCellNibForTableView:(UITableView *)tableView
{
    [tableView registerNib:[UINib nibWithNibName:@"FasTOrdersTableCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:cellIdentifier];
}

@end
