//
//  ZsxkUndealVC.m
//  MonitorPlatform
//
//  Created by 王哲义 on 12-12-1.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ZsxkUndealVC.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import "ZrsUtils.h"
#import "DoneNoiseAllowDetailVC.h"
#import "UITableViewCell+Custom.h"

@interface ZsxkUndealVC ()
@property (nonatomic,strong) NSURLConnHelper *webservice;
@property (nonatomic,strong) NSArray *doneDataAry;
@end

@implementation ZsxkUndealVC
@synthesize yhid,fromStr,endStr,webservice,doneDataAry;

#pragma mark - Private methods

- (void)getWebData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    [param setObject:@"GET_JCGL_ZSXKTJWWCSL" forKey:@"service"];
    
    [param setObject:fromStr forKey:@"kssj"];
    [param setObject:endStr forKey:@"jssj"];
    [param setObject:yhid forKey:@"yhid"];
    
    
    NSString *requestString = [ServiceUrlString generateUrlByParameters:param];
    
    self. webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
}

#pragma mark - View lifeCycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"流程未结束的噪声许可任务列表";
    
    [self getWebData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [yhid release];
    [doneDataAry release];
    [webservice release];
    [fromStr release];
    [endStr release];
    [super dealloc];
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    NSString *resultJSON =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x09];
    NSString *str =[resultJSON stringByReplacingOccurrencesOfString:ctrlChar withString:@""];
    
    NSArray *aryJson = [str objectFromJSONString];
    if(aryJson == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"访问异常"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:aryJson];
    //异常或无数据的处理
    NSDictionary *resultDic = [resultArray objectAtIndex:0];
    id count = [resultDic objectForKey:@"COUNT"];
    id exception = [resultDic objectForKey:@"exception"];
    
    if (count)
    {
        [ZrsUtils showAlertMsg:@"查无数据" andDelegate:nil];
        return;
    }
    else if (exception)
    {
        [ZrsUtils showAlertMsg:@"查询出错" andDelegate:nil];
        return;
    }
    
    self.doneDataAry = resultArray;
    [listTable reloadData];
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
    else
        cell.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 80;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [doneDataAry count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger index = [indexPath row];
    NSDictionary *tmpDic = [doneDataAry objectAtIndex:index];
    NSString *xmmc = [tmpDic objectForKey:@"GCXMMC"];
    NSString *jsdw = [NSString stringWithFormat:@"建设单位：%@",[tmpDic objectForKey:@"JSDW"]];
    NSString *qpsj = [tmpDic objectForKey:@"QPSJ"];
    if ([qpsj length] > 10)
        qpsj = [qpsj substringToIndex:10];
    
    //cell editing
    CGRect tRect1;
    CGRect tRect2;
    CGRect tRect3;
    NSString *cellIdentifier;
    
    tRect1 = CGRectMake(20, 0, 708, 55);
    tRect2 = CGRectMake(20, 55, 454, 25);
    tRect3 = CGRectMake(474, 55, 254, 25);
    cellIdentifier = @"cell_portraitProjectsList";
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
	UILabel* lblTitle = nil;
	UILabel* lblCode = nil;
	UILabel* lblCDate = nil;
	
	if (cell.contentView != nil)
	{
		lblTitle = (UILabel *)[cell.contentView viewWithTag:1];
		lblCode = (UILabel *)[cell.contentView viewWithTag:2];
		lblCDate = (UILabel *)[cell.contentView viewWithTag:3];
	}
	
    
	if (lblTitle == nil) {
		
		lblTitle = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor blackColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:20.0];
		lblTitle.textAlignment = UITextAlignmentLeft;
		lblTitle.numberOfLines = 2;
		lblTitle.tag = 1;
		[cell.contentView addSubview:lblTitle];
		[lblTitle release];
		
		
		lblCode = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblCode setBackgroundColor:[UIColor clearColor]];
		[lblCode setTextColor:[UIColor grayColor]];
		lblCode.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblCode.textAlignment = UITextAlignmentLeft;
		lblCode.tag = 2;
		[cell.contentView addSubview:lblCode];
		[lblCode release];
		
		
		
		lblCDate = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lblCDate setBackgroundColor:[UIColor clearColor]];
		[lblCDate setTextColor:[UIColor grayColor]];
		lblCDate.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblCDate.textAlignment = UITextAlignmentLeft;
		lblCDate.tag = 3;
		[cell.contentView addSubview:lblCDate];
		[lblCDate release];
        
        
		
		lblTitle.backgroundColor = [UIColor clearColor];
		lblCode.backgroundColor = [UIColor clearColor];
		lblCDate.backgroundColor = [UIColor clearColor];
	}
	
	if (lblTitle != nil)	[lblTitle setText:xmmc];
	if (lblCode != nil)     [lblCode setText:jsdw];
	if (lblCDate != nil)	[lblCDate setText:[NSString stringWithFormat:@"签批时间：%@",qpsj]];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSDictionary *tmpDic = [doneDataAry objectAtIndex:row];
    
    DoneNoiseAllowDetailVC *childView = [[[DoneNoiseAllowDetailVC alloc] initWithNibName:@"DoneNoiseAllowDetailVC" bundle:nil] autorelease];
    
    NSString *complaintNum = [tmpDic objectForKey:@"SQDJBH"];
    childView.complaintNum = complaintNum;
	[self.navigationController pushViewController:childView animated:YES];
}


@end
