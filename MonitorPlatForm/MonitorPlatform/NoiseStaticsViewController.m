//
//  NoiseStaticsViewController.m
//  MonitorPlatform
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
// 噪声许可统计

#import "NoiseStaticsViewController.h"
#import "NSDateUtil.h"
#import "ServiceUrlString.h"
#import "JSonKit.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "MBProgressHUD.h"

#define kDeptDataStatusTag 1
#define kMonthDataStatusTag 2

@interface NoiseStaticsViewController ()
@property(nonatomic,retain)NSString *fromDateStr;
@property(nonatomic,retain)NSString *endDateStr;
@property(nonatomic,retain) ASINetworkQueue * networkQueue ;
@property(nonatomic,retain) NSArray *aryAYFDatas;
@property(nonatomic,retain) NSArray *aryABMDatas;
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseDateRangeController *dateController;
@property (nonatomic,strong) MBProgressHUD *HUD;
@property (nonatomic,assign) BOOL alertData;

@end

@implementation NoiseStaticsViewController
@synthesize fromDateStr,endDateStr,dateController,popController;
@synthesize networkQueue,aryABMDatas,aryAYFDatas,HUD;
-(id)init{
    if(self = [super initWithNibName:@"ShowStaticsGraphVC" bundle:nil]){
        
    }
    return self;
}

//按月份统计返回的数据
-(void)requestAYFTJDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取按月份统计数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([aryTmp count] == 1&&_alertData == YES){
        
        
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查无数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            _alertData = NO;
            return;
        }
    }
    if (_alertData == NO) {
        return;
    }
    self.aryAYFDatas = aryTmp;
}

//按部门统计返回的数据
-(void)requestABMTJDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取按部门统计数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([aryTmp count] == 1&&_alertData == YES){
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查无数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            _alertData = NO;
            return;
        }
       
    }
    if (_alertData == NO) {
        return;
    }
    self.aryABMDatas = aryTmp;
}

-(void) allSyncFinished :(ASINetworkQueue *)queue{
    [HUD hide:YES];
    [self clearAllDataItems];

    if([aryAYFDatas count] > 0)
    {
        NSArray *cols = [NSArray arrayWithObjects:@"月份",@"许可数量", nil];
        NSArray *aryWidth = [NSArray arrayWithObjects:@"0.5",@"0.5", nil];
        NSMutableArray *aryTableVal = [NSMutableArray arrayWithCapacity:12];
        
        float currentYearCount = 0;
        
        for(NSDictionary *dic in aryAYFDatas){
            NSString *slStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"XKSL"]];
            NSDictionary *dicVal = [NSDictionary dictionaryWithObject:slStr forKey:@"数量"];
            NSString *yf = [dic objectForKey:@"YF"];
            [self addGraphDataType:@"按月份"  withGroupName:yf
                         colValues:dicVal];
            currentYearCount += [[dic objectForKey:@"XKSL"] floatValue];
            
            NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yf,slStr, nil] forKeys:cols];
            [aryTableVal addObject:dicTableVal];
            
        }
        NSString *currentYearStr = [NSString stringWithFormat:@"%.0f",currentYearCount];
        NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",currentYearStr, nil] forKeys:cols];
        [aryTableVal addObject:dicTableVal];
        
        [self addTableDataType:@"按月份" withColumns:cols columnWidthPercent:aryWidth itemValues:aryTableVal showImage:NO];
    }
    
    if([aryABMDatas count] > 0)
    {
        NSArray *cols = [NSArray arrayWithObjects:@"行政区划",@"许可数量", nil];
        NSArray *aryWidth = [NSArray arrayWithObjects:@"0.5",@"0.5", nil];
        NSMutableArray *aryTableVal = [NSMutableArray arrayWithCapacity:12];
        float currentYearCount = 0;
        for(NSDictionary *dic in aryABMDatas){
            NSString *slStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"XKSL"]];
            NSDictionary *dicVal = [NSDictionary dictionaryWithObject:slStr forKey:@"数量"];
            NSString *qh = [dic objectForKey:@"XZQH"];
            if([qh length] <=0)
                qh = @"其它";
            [self addGraphDataType:@"按行政区划"  withGroupName:qh
                         colValues:dicVal];
            currentYearCount += [[dic objectForKey:@"XKSL"] floatValue];
            NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:qh,slStr, nil] forKeys:cols];
            [aryTableVal addObject:dicTableVal];
            
        }
        NSString *currentYearStr = [NSString stringWithFormat:@"%.0f",currentYearCount];
        NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",currentYearStr, nil] forKeys:cols];
        [aryTableVal addObject:dicTableVal];
        [self addTableDataType:@"按行政区划" withColumns:cols columnWidthPercent:aryWidth itemValues:aryTableVal showImage:NO];
    }
    
    [self showGraphDatas];
}

-(void)requestData
{
    _alertData = YES;
    if (! networkQueue ) {
        self.networkQueue = [[[ ASINetworkQueue alloc ] init ] autorelease];
    }
    
    [networkQueue setShowAccurateProgress:YES];
    [ networkQueue reset ]; // 队列清零
    [ networkQueue setDelegate : self ]; // 设置队列的代理对象
    [networkQueue setQueueDidFinishSelector:@selector(allSyncFinished:)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"GET_JCGL_ZSXKAYTJ" forKey:@"service"];
    [params setObject:fromDateStr forKey:@"kssj"];
    [params setObject:endDateStr forKey:@"jssj"];
    
    NSString *urlStrAYFTJ = [ServiceUrlString generateUrlByParameters:params];
    ASIHTTPRequest *requestAYFTJ;
    requestAYFTJ = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrAYFTJ]];
    [requestAYFTJ setDelegate:self];
    [requestAYFTJ setDidFinishSelector: @selector (requestAYFTJDone:)];
    [requestAYFTJ setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestAYFTJ];
    
    [params setObject:@"GET_JCGL_ZSXKABMTJ" forKey:@"service"];
    NSString *urlStrABMTJ = [ServiceUrlString generateUrlByParameters:params];
    ASIHTTPRequest *requestABMTJ = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrABMTJ]];
    [requestABMTJ setDelegate:self];
    [requestABMTJ setDidFinishSelector: @selector (requestABMTJDone:)];
    [requestABMTJ setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestABMTJ];
    [networkQueue go ]; // 队列任务开始
    
    [HUD show:YES];
}

- ( void )requestWentWrong:(ASIHTTPRequest *)request
{
    NSLog(@"requestWentWrong ZSXK");
}

//弹出日期可选
-(void)chooseDateRange:(id)sender{
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController dismissPopoverAnimated:YES];
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fromDateStr = [NSDateUtil firstDateThisYear];
    self.endDateStr= [NSDateUtil todayDateStringWithFMT:@"yyyy-MM-dd"];
    [self doNotShowChartNumCol];

    self.title = [NSString stringWithFormat:@"噪声许可(%@至%@)",fromDateStr,endDateStr];
    
    self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc] initWithTitle:@"选择时间段" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDateRange:)] autorelease];
    
    ChooseDateRangeController *date = [[ChooseDateRangeController alloc] init];
	self.dateController = date;
	dateController.delegate = self;
	[date release];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
	[popover release];
	[nav release];
    
    //等待提示初始化
    self.HUD = [[[MBProgressHUD alloc] initWithView:self.view] autorelease];
    [self.view addSubview:HUD];
    HUD.labelText = @"正在请求数据，请稍候...";
    
    [self requestData];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)viewWillDisappear:(BOOL)animated{
    [networkQueue cancelAllOperations];
    [HUD hide:YES];
    if (popController)
        [popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}


-(void)dealloc{
    [fromDateStr release];
    [endDateStr release];
    [dateController release];
    [popController release];
    [super dealloc];
}

#pragma mark - Choose date range

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate{
    if (self.popController != nil)
        [popController dismissPopoverAnimated:YES];
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    
    self.title = [NSString stringWithFormat:@"噪声许可(%@至%@)",fromDateStr,endDateStr];
    [self requestData];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
}

@end
