//
//  OCPSelectedController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-12.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "OCPSelectedController.h"
#import "DBHelper.h"
#import "WryOnlineMonitorConroller.h"
#import "WryEntity.h"
@implementation OCPSelectedController
@synthesize bLastSelected;
@synthesize dataResultAry;
@synthesize lastPollutionName,searchBar;

#pragma mark - Private methods

-(IBAction)cancelSelect:(id)sender{
	[self dismissModalViewControllerAnimated:YES];
}


#pragma mark - View lifecycle

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)dealloc
{
    [dataResultAry release];

    [lastPollutionName release];
    [searchBar release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 400.0, 0.0)];
    searchBar.delegate = self;
    
    self.navigationItem.titleView = searchBar;
    
    //self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelSelect:)] autorelease];
    


    self.dataResultAry = [[DBHelper sharedInstance] queryZXJCWrysByMC:@""];

}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [dataResultAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell_PollutionName";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    WryEntity *aEntity = [dataResultAry objectAtIndex:indexPath.row];
    
    cell.textLabel.text = aEntity.WRYMC;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WryOnlineMonitorConroller *childView = [[WryOnlineMonitorConroller alloc] initWithNibName:@"WryOnlineMonitorConroller" bundle:nil];
    WryEntity *aEntity = [dataResultAry objectAtIndex:indexPath.row];
    childView.wrybh = aEntity.WRYBH;
    childView.wrymc = aEntity.WRYMC;
    childView.bWarn = NO;
    [self.navigationController pushViewController:childView animated:YES];
    [childView release];
}

#pragma mark - Search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    self.dataResultAry = [[DBHelper sharedInstance] queryZXJCWrysByMC:searchText];
    [self.tableView reloadData];
}

@end
