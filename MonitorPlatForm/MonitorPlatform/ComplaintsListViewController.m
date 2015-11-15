//
//  ComplaintsListViewController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-2-13.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ComplaintsListViewController.h"
#import "LoginedUsrInfo.h"
#import "MPAppDelegate.h"
#import "UITableViewCell+Custom.h"
#import "ComplaintDetailsViewController.h"
#import "JSONKit.h"
#import "ServiceUrlString.h"

extern MPAppDelegate *g_appDelegate;

@implementation ComplaintsListViewController
@synthesize listTable,nDataType,webservice;
@synthesize resultAry;

#define nDataNormal 1
#define nDataException 2
#define nDataNone 3

#pragma mark - private methods

- (void)getWebData
{
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    [param setObject:@"GET_XFTS_LIST" forKey:@"service"];
    [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
    [param setObject:@"41389071-3226-4dab-9c01-61eed5c944b4" forKey:@"lcbh"];

    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
    
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
}

#pragma mark - View lifecycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    self.title = @"环境信访投诉列表";
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

- (void)viewWillDisappear:(BOOL)animated
{
    if (webservice)
        [webservice cancel];
    
    [super viewWillDisappear:YES];
}

- (void)dealloc 
{
    [listTable release];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [super dealloc];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.listTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma mark - NSURLConnHelperDelegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
    {
        listTable.hidden = YES;
        
        UIImageView *emptyView = [[UIImageView alloc] initWithFrame:CGRectMake((768-350)*0.5, (960-290)*0.35, 350, 290)];
        emptyView.image = [UIImage imageNamed:@"bg_empty.png"];
        [self.view addSubview:emptyView];
        [emptyView release];
        
        return;
    }
    NSString *resultJSON =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    
    self.nDataType = nDataNormal;
    
    
    NSArray *aryJson = [resultJSON objectFromJSONString];
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
    //异常或无数据的处理
    NSDictionary *resultDic = [aryJson objectAtIndex:0];
    id count = [resultDic objectForKey:@"COUNT"];
    id exception = [resultDic objectForKey:@"exception"];
    if (count)
        self.nDataType = nDataNone;
    if (exception)
        self.nDataType = nDataException;
    
    if (nDataType == nDataNormal) {
        self.resultAry = aryJson;
        [self.listTable reloadData];   
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您没有未处理的信访投诉案件..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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

#pragma mark - Table View Data Source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 72;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [resultAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger index = [indexPath row];
    NSDictionary *complaintDic = [resultAry objectAtIndex:index];
    NSString *btsdw = [complaintDic objectForKey:@"BTSDW"];
    NSString *labh = [NSString stringWithFormat:@"办理人:%@",[complaintDic objectForKey:@"YHMC"]];
    NSString *tssj = [NSString stringWithFormat:@"投诉时间:%@",[[complaintDic objectForKey:@"TSSJ"] substringToIndex:10]];
    NSString *xffs = [NSString stringWithFormat:@"信访方式:%@",[complaintDic objectForKey:@"XFFS"]];
    NSString *yfrq = [NSString stringWithFormat:@"应返日期:%@",[complaintDic objectForKey:@"YFRQ"]];
    

    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView
                                               withTitle:btsdw
                                                caseCode:labh 
                                           complaintDate:tssj 
                                                 endDate:yfrq 
                                                    Mode:xffs];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    NSString *str = [complaintDic objectForKey:@"BZREMAIN"];
    if ([str intValue]>2)
        cell.imageView.image =  [UIImage imageNamed:@"a1.png"];
    else if ([str intValue]<=2 && [str intValue]>=0)
        cell.imageView.image =  [UIImage imageNamed:@"a3.png"];
    else
        cell.imageView.image = [UIImage imageNamed:@"a2.png"];

    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSDictionary *tmpDic = [resultAry objectAtIndex:row];
    
    ComplaintDetailsViewController *childView = [[ComplaintDetailsViewController alloc] initWithNibName:@"ComplaintDetailsViewController" bundle:nil];
    
    NSString *complaintNum = [tmpDic objectForKey:@"XFXH"];
    childView.complaintNum = complaintNum;
    childView.orgid = [NSString stringWithFormat:@"440301"];
    childView.stepNum = [tmpDic objectForKey:@"BZBH"];
    //对比办理人信息，看是否是协办
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    if (![usrInfo.userPinYinName isEqualToString:[tmpDic objectForKey:@"BZCLR"]])
        childView.isChangeUser = YES;
    else
        childView.isChangeUser = NO;
    
    childView.changeUserID = [tmpDic objectForKey:@"BZCLR"];
	[self.navigationController pushViewController:childView animated:YES];
    [childView release];
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
}
@end
