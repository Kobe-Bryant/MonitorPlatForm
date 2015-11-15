//
//  XftsUndealVC.m
//  MonitorPlatform
//
//  Created by 王哲义 on 12-12-1.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "XftsUndealVC.h"
#import "ServiceUrlString.h"
#import "JSONKit.h"
#import "ZrsUtils.h"
#import "DoneComplaintDetailController.h"
#import "UITableViewCell+Custom.h"

@interface XftsUndealVC ()
@property (nonatomic,strong) NSURLConnHelper *webservice;
@property (nonatomic,strong) NSArray *doneDataAry;
@end

@implementation XftsUndealVC
@synthesize bmid,fromStr,endStr,webservice,doneDataAry;

#pragma mark - Private methods

- (void)getWebData
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    [param setObject:@"GET_HJXF_HJXFTJWWCSL" forKey:@"service"];
    
    [param setObject:fromStr forKey:@"kssj"];
    [param setObject:endStr forKey:@"jssj"];
    [param setObject:bmid forKey:@"blbm"];
    
    
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
    self.title = @"流程未结束的信访投诉任务列表";
    
    [self getWebData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [bmid release];
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
	return 72;
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
    
    NSString *dwmc = [tmpDic objectForKey:@"BTSDWMC"];
    NSString *bzmc = [NSString stringWithFormat:@"地址：%@",[tmpDic objectForKey:@"BTSDWDZ"]];
    NSString *kssj = [tmpDic objectForKey:@"CLQXDT"];
    if ([kssj length] > 10)
        kssj = [kssj substringToIndex:10];
    kssj = [NSString stringWithFormat:@"处理期限：%@",kssj];
    
    UITableViewCell *cell;
    
    NSString * tssj = [tmpDic objectForKey:@"TSSJ"];
    if ([tssj length] > 10)
        tssj = [tssj substringToIndex:10];
    tssj = [NSString stringWithFormat:@"投诉时间：%@",tssj];
    
    cell = [UITableViewCell makeSubCell:tableView withTitle:dwmc andSubvalue1:bzmc andSubvalue2:tssj andSubvalue3:kssj  andSubvalue4:@"" andNoteCount:index];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSDictionary *tmpDic = [doneDataAry objectAtIndex:row];
    
    DoneComplaintDetailController *childView = [[[DoneComplaintDetailController alloc] initWithNibName:@"DoneComplaintDetailController" bundle:nil] autorelease];
    
    NSString *complaintNum = [tmpDic objectForKey:@"XFXH"];
    childView.complaintNum = complaintNum;
    childView.orgid = [NSString stringWithFormat:@"440301"];
	[self.navigationController pushViewController:childView animated:YES];
}


@end
