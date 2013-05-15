//
//  FasTSettingsTableViewController.m
//  FasT-retail-checkout
//
//  Created by Albrecht Oster on 15.05.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTSettingsTableViewController.h"
#import "FasTPrintersTableViewController.h"

@interface FasTSettingsTableViewController ()

@end

@implementation FasTSettingsTableViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        [self setTitle:NSLocalizedStringByKey(@"settings")];
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

- (void)viewWillAppear:(BOOL)animated
{
    [[self tableView] reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return NSLocalizedStringByKey(@"general");
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *printerName = [[NSUserDefaults standardUserDefaults] objectForKey:FasTPrinterDescriptionPrefKey];
    
    static NSString *cellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier] autorelease];
        [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    }
    [[cell textLabel] setText:NSLocalizedStringByKey(@"printer")];
    [[cell detailTextLabel] setText:(printerName) ? printerName : NSLocalizedStringByKey(@"select")];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    FasTPrintersTableViewController *printersVC = [[[FasTPrintersTableViewController alloc] init] autorelease];
    [[self navigationController] pushViewController:printersVC animated:YES];
}

@end
