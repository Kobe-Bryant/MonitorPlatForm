//
//  PWSFStatisticListVC.m
//  MonitorPlatform
//
//  Created by 王哲义 on 12-12-7.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "PWSFStatisticListVC.h"
#import "PWSFStaticsViewController.h"
#import "PWSFCountVC.h"

@interface PWSFStatisticListVC ()
@property (nonatomic,strong) NSArray *nameAry;
@end

@implementation PWSFStatisticListVC
@synthesize nameAry;

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.nameAry = [NSArray arrayWithObjects:@"按月份和部门统计",@"按排污类型统计", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"排污收费统计类型列表";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [nameAry release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [nameAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"Cell_PWSF_Statistics_List";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:20];
    
    NSInteger row = [indexPath row];
    NSString *rowTitle = [nameAry objectAtIndex:row];
    
    cell.textLabel.text = rowTitle;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = [indexPath row];
    UIViewController *controller = nil;
    if (row == 0)
    {
        PWSFStaticsViewController *aCtrl = [[PWSFStaticsViewController alloc] init];
        controller = aCtrl;
    }
    else
    {
        controller = [[PWSFCountVC alloc] initWithNibName:@"PWSFCountVC" bundle:nil];
    }
    
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}
@end
