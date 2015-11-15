//
//  DoneNoiseAllowDetailVC.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-9.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "DoneNoiseAllowDetailVC.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"
#import "ServiceUrlString.h"
#import "HtmlTableGenerator.h"
#import "UITableViewCell+Custom.h"

extern MPAppDelegate *g_appDelegate;

@implementation DoneNoiseAllowDetailVC
@synthesize complaintNum,networkQueue;
@synthesize hud,listAry;

#pragma mark - Private methods

- ( void )requestWentWrong:(ASIHTTPRequest *)request
{
    NSLog(@"request of ZSDetail went wrong.");
}

-(void)requestDetailsDone:(ASIHTTPRequest *)request
{
    NSString *resultJSON = [request responseString];
    NSArray *resultAry = [resultJSON objectFromJSONString];
    
    NSDictionary *tmpDic = [resultAry objectAtIndex:0];  
    NSArray *keyAry = [tmpDic allKeys];  
    BOOL bSuccess = YES;   
    for (NSString *key in keyAry)   
    {         
        if ([key isEqualToString:@"result"])   
        {             
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查无详情数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];    
            [alert release];   
            bSuccess = NO;     
            break;        
        }  
    }          
    if (bSuccess)   
    {         
        NSDictionary *reDic = [resultAry lastObject];

        NSString *htmlStr = [HtmlTableGenerator getContentWithTitle:@"噪声许可详情" andParaMeters:reDic andServiceName:@"GET_ZSXK_DETAIL"];
        resultWebView.dataDetectorTypes = UIDataDetectorTypeNone;
        
        [resultWebView loadHTMLString:htmlStr baseURL:[[NSBundle mainBundle] bundleURL]];
    }
}

- (void)requestXMZSXKDone:(ASIHTTPRequest *)request
{
    NSString *resultJSON = [request responseString];
    NSArray *resultAry = [resultJSON objectFromJSONString];
    
    NSDictionary *testDic = [resultAry objectAtIndex:0];
    BOOL bSuccess = YES;   
    NSString *judge = [testDic objectForKey:@"result"];
    
    if (judge)
        bSuccess = NO;
    
    if (bSuccess)   
    {
        self.listAry = resultAry;
        
        [listTable reloadData];
    }
}

- (void)allSyncFinished:(ASIHTTPRequest *)request
{
    [hud hide:YES];
}

- (void)requestData
{
    if (! networkQueue ) {
        self.networkQueue = [[[ ASINetworkQueue alloc ] init ] autorelease];
    }
    
    [networkQueue setShowAccurateProgress:YES];
    [ networkQueue reset ]; // 队列清零
    [ networkQueue setDelegate : self ]; // 设置队列的代理对象
    [networkQueue setQueueDidFinishSelector:@selector(allSyncFinished:)];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_ZSXK_DETAIL" forKey:@"service"];
    [param setObject:complaintNum forKey:@"sqdjbh"];
    
    NSString *urlStrDetails = [ServiceUrlString generateUrlByParameters:param];
    ASIHTTPRequest *requestDetails;
    requestDetails = [ASIHTTPRequest requestWithURL :[NSURL URLWithString :urlStrDetails]];
    [requestDetails setDelegate:self];
    [requestDetails setDidFinishSelector: @selector (requestDetailsDone:)];
    [requestDetails setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestDetails];
    
    [param setObject:@"QUERY_GCXM_ZCXK_LIST" forKey:@"service"];
    [param setObject:complaintNum forKey:@"gcxmsqdjh"];
    
    NSString *urlStrXMZSXK = [ServiceUrlString generateUrlByParameters:param];
    ASIHTTPRequest *requestXMZSXK;
    requestXMZSXK = [ASIHTTPRequest requestWithURL :[NSURL URLWithString :urlStrXMZSXK]];
    [requestXMZSXK setDelegate:self];
    [requestXMZSXK setDidFinishSelector: @selector (requestXMZSXKDone:)];
    [requestXMZSXK setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestXMZSXK];
    
    [networkQueue go];
    
    [hud show:YES];
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

- (void)dealloc 
{
    [complaintNum release];
    [networkQueue release];
    
    [super dealloc];    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"噪声许可详细信息";
    //等待提示初始化
    self.hud = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:hud];
    hud.labelText = @"正在请求数据，请稍候...";
    
    [self requestData];
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
    [networkQueue cancelAllOperations];
    [hud hide:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Table view data source 
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{    
    if(indexPath.row%2 == 0)     
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}  

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{    
    return 1;
}  

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (listAry && [listAry count] > 0)
        return [listAry count];
    else
        return 1;
} 

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{ 	
    return 72; 
} 

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{     
    if (listAry && [listAry count] > 0)
    {
        NSDictionary *tmpDic = [listAry objectAtIndex:indexPath.row];
    
        NSString *sgkssj = [tmpDic objectForKey:@"SGKSSJ"];
        NSString *sgjzsj = [tmpDic objectForKey:@"SGJZSJ"];
        if ([sgkssj length] > 10)
            sgkssj = [sgkssj substringToIndex:10];
        if ([sgjzsj length] > 10)
            sgjzsj = [sgjzsj substringToIndex:10];
    
        UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:[tmpDic objectForKey:@"SGNR"] andSubvalue1:[NSString stringWithFormat:@"施工开始时间：%@",sgkssj] andSubvalue2:[NSString stringWithFormat:@"施工截止时间：%@",sgjzsj] andSubvalue3:@"" andSubvalue4:@"" andNoteCount:indexPath.row];
    
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else
    {
        NSString *cellIdentifier = @"nodata_Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil)
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        
        cell.textLabel.text = @"本项目没有通过许可的施工时间安排";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark - Table view delegate

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"许可施工时间表";
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{     
}

@end
