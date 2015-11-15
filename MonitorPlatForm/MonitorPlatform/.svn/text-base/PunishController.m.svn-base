//
//  PunishController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-14.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "PunishController.h"
#import "PunishOpinionController.h"
#import "MPAppDelegate.h"
#import "UITableViewCell+Custom.h"
#import "JSONKit.h"
#import "LoginedUsrInfo.h"
#import "ServiceUrlString.h"

extern MPAppDelegate *g_appDelegate;

@implementation PunishController
@synthesize punishArray,nDataType,webservice;

#define nDataNormal 1
#define nDataException 2
#define nDataNone 3

#pragma mark - private methods

- (void)getWebData
{
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_COMPLAINTS_LIST" forKey:@"service"];
    [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
    [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
    NSString *requestString = [ServiceUrlString generateXZCFUrlByParameters:param];
    
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
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

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"处罚案件任务列表";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData) name:@"refreshData" object:nil];
    
    [self getWebData];
}

- (void)refreshData{
    
    [self getWebData];
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
    if (webservice)
        [webservice cancel];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [punishArray release];
    [super dealloc];
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
    {

        self.tableView.hidden = YES;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 960)];
        [self.tableView.superview addSubview:bgView];
        
        UIImageView *emptyView = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)*0.5, (960-290)*0.35, 350, 290)];
        emptyView.image = [UIImage imageNamed:@"bg_empty.png"];
        [bgView addSubview:emptyView];
        [emptyView release];
        [bgView release];
        return;
    }
    NSString *resultJSON =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x09];
    NSString *str =[resultJSON stringByReplacingOccurrencesOfString:ctrlChar withString:@""]; 
    self.nDataType = nDataNormal;
    
    //异常或无数据的处理
    NSArray *aryJson = [str objectFromJSONString];
    if(aryJson == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"未获取到相关数据。" 

                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:aryJson];
    NSDictionary *resultDic = [resultArray objectAtIndex:0];
    NSArray *keys = [resultDic allKeys];
    for (NSString *key in keys) {
        if ([key isEqualToString:@"COUNT"]) {
            self.nDataType = nDataNone;
            break;
        }
        if ([key isEqualToString:@"exception"]) {
            self.nDataType = nDataException;
            break;
        }
    }
    
    if (nDataType == nDataNormal) {
        [resultArray removeLastObject];
        self.punishArray = resultArray;
        [self.tableView reloadData];
    }  else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有未处理的处罚案件..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
}


- (void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败,请检查网络连接并重试。" 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [punishArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath row];
    NSDictionary *aItem = [punishArray objectAtIndex:index];
    
    NSString *code = [NSString stringWithFormat:@"办理人：%@",[aItem objectForKey:@"YHMC"]];
    NSString *phase = [NSString stringWithFormat:@"办理阶段：%@",[aItem objectForKey:@"BZMC"]];
    NSString *reason = [NSString stringWithFormat:@"执法事项：%@",[aItem objectForKey:@"ZFSX"]];
    NSString *timeLimit = [NSString stringWithFormat:@"办理期限：%@",[aItem objectForKey:@"LCRWQX"]];
    
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView 
                                               withTitle:[aItem objectForKey:@"DWMC"] 
                                                caseCode:code
                                           complaintDate:phase 
                                                 endDate:reason 
                                                    Mode:timeLimit];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *str = [aItem objectForKey:@"BZREMAIN"];
    if ([str intValue]>2)
        cell.imageView.image =  [UIImage imageNamed:@"a1.png"];
    else if ([str intValue]<=2 && [str intValue]>=0)
        cell.imageView.image =  [UIImage imageNamed:@"a3.png"];
    else
        cell.imageView.image = [UIImage imageNamed:@"a2.png"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 72;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [punishArray objectAtIndex:indexPath.row];
    
    PunishOpinionController *childView = [[PunishOpinionController alloc] initWithNibName:@"PunishOpinionController" bundle:nil];
    childView.userid = [tmpDic objectForKey:@"BZCLR"];
    [childView setItemID:[tmpDic objectForKey:@"BWBH"]];
    [self.navigationController pushViewController:childView animated:YES];
    [childView release];
}

@end
