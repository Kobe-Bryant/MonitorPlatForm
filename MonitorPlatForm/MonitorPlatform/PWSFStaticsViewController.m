//
//  NoiseStaticsViewController.m
//  MonitorPlatform
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.


#import "PWSFStaticsViewController.h"
#import "NSDateUtil.h"
#import "ServiceUrlString.h"
#import "JSonKit.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "MBProgressHUD.h"


@interface PWSFStaticsViewController ()
@property(nonatomic,retain)NSString *fromDateStr;
@property(nonatomic,retain)NSString *endDateStr;
@property(nonatomic,retain) ASINetworkQueue * networkQueue ;
@property(nonatomic,retain) NSArray *aryAYFDatas;
@property(nonatomic,retain) NSArray *aryAYFAllDatas;
@property(nonatomic,retain) NSArray *aryABMDatas;
@property(nonatomic,retain) NSArray *aryABMAllDatas;
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseDateRangeController *dateController;
@property (nonatomic,strong) MBProgressHUD *HUD;
@end

@implementation PWSFStaticsViewController
@synthesize fromDateStr,endDateStr,popController,dateController,HUD;
@synthesize networkQueue,aryABMDatas,aryAYFDatas;
@synthesize aryABMAllDatas,aryAYFAllDatas;


-(id)init{
    if(self = [super initWithNibName:@"ShowStaticsGraphVC" bundle:nil]){
        
    }
    return self;
}

//弹出日期可选
-(void)chooseDateRange:(id)sender{
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController dismissPopoverAnimated:YES];
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

//按月份统计返回的数据
//支队数据
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
    else if([aryTmp count] == 1){
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查无数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
    }
    self.aryAYFDatas = aryTmp;
}
//全部数据
-(void)requestAYFTJALLDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取按月份统计数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([aryTmp count] == 1){
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查无数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
    }
    self.aryAYFAllDatas = aryTmp;
}

//按部门统计返回的数据
//支队数据
-(void)requestABMTJDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获按部门统计取数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([aryTmp count] == 1){
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查无数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
    }
    self.aryABMDatas = aryTmp;
}
//全市数据
-(void)requestABMTJALLDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获按部门统计取数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([aryTmp count] == 1){
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"查无数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
    }
    self.aryABMAllDatas = aryTmp;
}

-(void) allSyncFinished :(ASINetworkQueue *)queue{
    [HUD hide:YES];
    [self clearAllDataItems];
    if([aryAYFDatas count] > 0){
        NSArray *cols = [NSArray arrayWithObjects:@"月份",@"发单收款率",@"所收金额（万元）",@"去年同期（万元）",@"同比", nil];
        NSArray *aryWidth = [NSArray arrayWithObjects:@"0.2",@"0.2",@"0.2",@"0.2",@"0.2",  nil];
        NSMutableArray *aryTableVal = [NSMutableArray arrayWithCapacity:12];
        
        float currentYearCount = 0;
        float lastYearCount = 0;
        float currentYearFDS = 0;
        
        for(NSDictionary *dic in aryAYFDatas){
            
            NSString *yf = [dic objectForKey:@"NY"];
            //除以10000计算万元
            NSString *SNJEStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"SNJE"] floatValue]/10000];
            NSString *JEStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"JE"] floatValue]/10000];
            
            NSDictionary *dicVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:JEStr,SNJEStr, nil] forKeys:[NSArray arrayWithObjects:@"所收金额（万元）",@"去年同期（万元）", nil]];
                                                                                                        
            NSString *FDSStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"TZSJE"] floatValue]/10000];
            
            [self addGraphDataType:@"按月份-支队"  withGroupName:yf
                         colValues:dicVal];
            
            currentYearCount += [JEStr floatValue];
            lastYearCount += [SNJEStr floatValue];
            currentYearFDS += [FDSStr floatValue];
            
            float changeCount = ([JEStr floatValue] - [SNJEStr floatValue])*100 /[SNJEStr floatValue];
            NSString *changePercent = [NSString stringWithFormat:@"%.2f%%",changeCount];
            
            float fdskl = [[dic objectForKey:@"JE"] floatValue]/[[dic objectForKey:@"TZSJE"] floatValue]*100;
            
            NSString *fdsklStr = [NSString stringWithFormat:@"%.2f%%",fdskl];
            
            NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yf,fdsklStr,JEStr,SNJEStr,changePercent,nil] forKeys:cols];
            
            [aryTableVal addObject:dicTableVal];
            
        }
        float changeCount = (currentYearCount - lastYearCount)*100/lastYearCount;
        NSString *changePercent = [NSString stringWithFormat:@"%.2f%%",changeCount];
        
        float fdskl_hz = currentYearCount/currentYearFDS*100;
        
        NSString *fdsklStr_hz = [NSString stringWithFormat:@"%.2f%%",fdskl_hz];
        
        NSString *currentYearStr = [NSString stringWithFormat:@"%.3f",currentYearCount];
        NSString *lastYearStr = [NSString stringWithFormat:@"%.3f",lastYearCount];
        
        NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",fdsklStr_hz,currentYearStr,lastYearStr,changePercent, nil] forKeys:cols];
        [aryTableVal addObject:dicTableVal];
        [self addTableDataType:@"按月份-支队" withColumns:cols columnWidthPercent:aryWidth itemValues:aryTableVal showImage:YES];
    }
    
    if([aryAYFAllDatas count] > 0){
        NSArray *cols = [NSArray arrayWithObjects:@"月份",@"发单收款率",@"所收金额（万元）",@"去年同期（万元）",@"同比", nil];
        NSArray *aryWidth = [NSArray arrayWithObjects:@"0.2",@"0.2",@"0.2",@"0.2",@"0.2",  nil];
        NSMutableArray *aryTableVal = [NSMutableArray arrayWithCapacity:12];
        
        float currentYearCount = 0;
        float lastYearCount = 0;
        float currentYearFDS = 0;
        
        for(NSDictionary *dic in aryAYFAllDatas){
            
            NSString *yf = [dic objectForKey:@"NY"];
            //除以10000计算万元
            NSString *SNJEStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"SNJE"] floatValue]/10000];
            NSString *JEStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"JE"] floatValue]/10000];
            
            NSDictionary *dicVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:JEStr,SNJEStr, nil] forKeys:[NSArray arrayWithObjects:@"所收金额（万元）",@"去年同期（万元）", nil]];
            
            NSString *FDSStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"TZSJE"] floatValue]/10000];
            
            [self addGraphDataType:@"按月份-全市"  withGroupName:yf
                         colValues:dicVal];
            
            currentYearCount += [JEStr floatValue];
            lastYearCount += [SNJEStr floatValue];
            currentYearFDS += [FDSStr floatValue];
            
            float changeCount = ([JEStr floatValue] - [SNJEStr floatValue])*100 /[SNJEStr floatValue];
            NSString *changePercent = [NSString stringWithFormat:@"%.2f%%",changeCount];
            
            float fdskl = [[dic objectForKey:@"JE"] floatValue]/[[dic objectForKey:@"TZSJE"] floatValue]*100;
            
            NSString *fdsklStr = [NSString stringWithFormat:@"%.2f%%",fdskl];
            
            NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yf,fdsklStr,JEStr,SNJEStr,changePercent,nil] forKeys:cols];
            
            [aryTableVal addObject:dicTableVal];
            
        }
        float changeCount = (currentYearCount - lastYearCount)*100/lastYearCount;
        NSString *changePercent = [NSString stringWithFormat:@"%.2f%%",changeCount];
        
        float fdskl_hz = currentYearCount/currentYearFDS*100;
        
        NSString *fdsklStr_hz = [NSString stringWithFormat:@"%.2f%%",fdskl_hz];
        
        NSString *currentYearStr = [NSString stringWithFormat:@"%.3f",currentYearCount];
        NSString *lastYearStr = [NSString stringWithFormat:@"%.3f",lastYearCount];
        
        NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",fdsklStr_hz,currentYearStr,lastYearStr,changePercent, nil] forKeys:cols];
        [aryTableVal addObject:dicTableVal];
        [self addTableDataType:@"按月份-全市" withColumns:cols columnWidthPercent:aryWidth itemValues:aryTableVal showImage:YES];
    }
    
    if([aryABMDatas count] > 0){
        NSArray *cols = [NSArray arrayWithObjects:@"科室",@"发单收款率",@"所收金额(万元)",@"去年同期(万元)",@"同比", nil];
        NSArray *aryWidth = [NSArray arrayWithObjects:@"0.2",@"0.2",@"0.2",@"0.2",@"0.2",  nil];
        NSMutableArray *aryTableVal = [NSMutableArray arrayWithCapacity:12];
        float currentYearCount = 0;
        float lastYearCount = 0;
        float currentYearFDS = 0;
        
        for(NSDictionary *dic in aryABMDatas){
            
            NSString *keshi = [dic objectForKey:@"ZZJC"];
            
            NSString *SNJEStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"SNJE"] floatValue]/10000];
            NSString *BNJEStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"BNJE"] floatValue]/10000];
            
            
            NSDictionary *dicVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:BNJEStr,SNJEStr, nil] forKeys:[NSArray arrayWithObjects:@"所收金额(万元)",@"去年同期(万元)", nil]];
            
            [self addGraphDataType:@"按科室-支队"  withGroupName:keshi
                         colValues:dicVal];
            
            NSString *FDSStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"TZSJE"] floatValue]/10000];
            
            currentYearCount += [BNJEStr floatValue];
            lastYearCount += [SNJEStr floatValue];
            currentYearFDS += [FDSStr floatValue];
            
            float changeCount = ([BNJEStr floatValue] - [SNJEStr floatValue])*100 /[SNJEStr floatValue];
            NSString *changePercent = [NSString stringWithFormat:@"%.2f%%",changeCount];
            
            float fdskl = [[dic objectForKey:@"BNJE"] floatValue]/[[dic objectForKey:@"TZSJE"] floatValue]*100;
            
            NSString *fdsklStr = [NSString stringWithFormat:@"%.2f%%",fdskl];
            
            NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:keshi,fdsklStr,BNJEStr,SNJEStr,changePercent,nil] forKeys:cols];
            [aryTableVal addObject:dicTableVal];
            
        }
        
        float changeCount = (currentYearCount - lastYearCount)*100/lastYearCount;
        NSString *changePercent = [NSString stringWithFormat:@"%.2f%%",changeCount];
        
        float fdskl_hz = currentYearCount/currentYearFDS*100;
        
        NSString *fdsklStr_hz = [NSString stringWithFormat:@"%.2f%%",fdskl_hz];
        
        NSString *currentYearStr = [NSString stringWithFormat:@"%.3f",currentYearCount];
        NSString *lastYearStr = [NSString stringWithFormat:@"%.3f",lastYearCount];
        
        NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",fdsklStr_hz,currentYearStr,lastYearStr,changePercent, nil] forKeys:cols];
        [aryTableVal addObject:dicTableVal];
        
        [self addTableDataType:@"按科室-支队" withColumns:cols columnWidthPercent:aryWidth itemValues:aryTableVal showImage:YES];
    }
    
    if([aryABMAllDatas count] > 0){
        NSArray *cols = [NSArray arrayWithObjects:@"部门",@"发单收款率",@"所收金额(万元)",@"去年同期(万元)",@"同比", nil];
        NSArray *aryWidth = [NSArray arrayWithObjects:@"0.2",@"0.2",@"0.2",@"0.2",@"0.2",  nil];
        NSMutableArray *aryTableVal = [NSMutableArray arrayWithCapacity:12];
        float currentYearCount = 0;
        float lastYearCount = 0;
        float currentYearFDS = 0;
        
        for(NSDictionary *dic in aryABMAllDatas){
            
            NSString *keshi = [dic objectForKey:@"BMMC"];
            
            NSString *SNJEStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"SNJE"] floatValue]/10000];
            NSString *BNJEStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"BNJE"] floatValue]/10000];
            
            
            NSDictionary *dicVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:BNJEStr,SNJEStr, nil] forKeys:[NSArray arrayWithObjects:@"所收金额(万元)",@"去年同期(万元)", nil]];
            
            [self addGraphDataType:@"按部门-全市"  withGroupName:keshi
                         colValues:dicVal];
            
            NSString *FDSStr = [NSString stringWithFormat:@"%.3f",[[dic objectForKey:@"TZSJE"] floatValue]/10000];
            
            currentYearCount += [BNJEStr floatValue];
            lastYearCount += [SNJEStr floatValue];
            currentYearFDS += [FDSStr floatValue];
            
            float changeCount = ([BNJEStr floatValue] - [SNJEStr floatValue])*100 /[SNJEStr floatValue];
            NSString *changePercent = [NSString stringWithFormat:@"%.2f%%",changeCount];
            
            float fdskl = [[dic objectForKey:@"BNJE"] floatValue]/[[dic objectForKey:@"TZSJE"] floatValue]*100;
            
            NSString *fdsklStr = [NSString stringWithFormat:@"%.2f%%",fdskl];
            
            NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:keshi,fdsklStr,BNJEStr,SNJEStr,changePercent,nil] forKeys:cols];
            [aryTableVal addObject:dicTableVal];
            
        }
        
        float changeCount = (currentYearCount - lastYearCount)*100/lastYearCount;
        NSString *changePercent = [NSString stringWithFormat:@"%.2f%%",changeCount];
        
        float fdskl_hz = currentYearCount/currentYearFDS*100;
        
        NSString *fdsklStr_hz = [NSString stringWithFormat:@"%.2f%%",fdskl_hz];
        
        NSString *currentYearStr = [NSString stringWithFormat:@"%.3f",currentYearCount];
        NSString *lastYearStr = [NSString stringWithFormat:@"%.3f",lastYearCount];
        
        NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",fdsklStr_hz,currentYearStr,lastYearStr,changePercent, nil] forKeys:cols];
        [aryTableVal addObject:dicTableVal];
        
        [self addTableDataType:@"按部门-全市" withColumns:cols columnWidthPercent:aryWidth itemValues:aryTableVal showImage:YES];
    }
    
    [self showGraphDatas];
}

-(void)requestData{
    
    if (! networkQueue ) {
        self.networkQueue = [[[ ASINetworkQueue alloc ] init ] autorelease];
    }
    
    [networkQueue setShowAccurateProgress:YES];
    [ networkQueue reset ]; // 队列清零
    [ networkQueue setDelegate : self ]; // 设置队列的代理对象
    [networkQueue setQueueDidFinishSelector:@selector(allSyncFinished:)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"GET_JCGL_PWSFAYFTJ_TEST" forKey:@"service"];
    NSInteger curYear = [NSDateUtil currentYear];
    NSString *jnsj = [NSString stringWithFormat:@"%d",curYear];
    NSString *qnsj = [NSString stringWithFormat:@"%d",curYear-1];
    [params setObject:fromDateStr forKey:@"kssj"];
    [params setObject:endDateStr forKey:@"jssj"];
    [params setObject:jnsj forKey:@"jnsj"];
    [params setObject:qnsj forKey:@"qnsj"];
    
    NSString *urlStrAYFTJ = [ServiceUrlString generateUrlByParameters:params];
    ASIHTTPRequest *requestAYFTJ;
    requestAYFTJ = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrAYFTJ]];
    [requestAYFTJ setDelegate:self];
    [requestAYFTJ setDidFinishSelector: @selector (requestAYFTJDone:)];
    [requestAYFTJ setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestAYFTJ];
    
    [params setObject:@"GET_JCGL_PWSFAYFTJ_ALL_TEST" forKey:@"service"];
    NSString *urlStrAYFTJ_ALL = [ServiceUrlString generateUrlByParameters:params];
    ASIHTTPRequest *requestAYFTJ_ALL;
    requestAYFTJ_ALL = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrAYFTJ_ALL]];
    [requestAYFTJ_ALL setDelegate:self];
    [requestAYFTJ_ALL setDidFinishSelector: @selector (requestAYFTJALLDone:)];
    [requestAYFTJ_ALL setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestAYFTJ_ALL];
    
    [params setObject:@"GET_JCGL_PWSFABMTJ_TEST" forKey:@"service"];
    NSString *urlStrABMTJ = [ServiceUrlString generateUrlByParameters:params];
    ASIHTTPRequest *requestABMTJ = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrABMTJ]];
    [requestABMTJ setDelegate:self];
    [requestABMTJ setDidFinishSelector: @selector (requestABMTJDone:)];
    [requestABMTJ setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestABMTJ];
    
    [params setObject:@"GET_JCGL_PWSFABMTJ_ALL_TEST" forKey:@"service"];
    NSString *urlStrABMTJ_ALL = [ServiceUrlString generateUrlByParameters:params];
    ASIHTTPRequest *requestABMTJ_ALL = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrABMTJ_ALL]];
    [requestABMTJ_ALL setDelegate:self];
    [requestABMTJ_ALL setDidFinishSelector: @selector (requestABMTJALLDone:)];
    [requestABMTJ_ALL setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestABMTJ_ALL];
    
    [networkQueue go ]; // 队列任务开始
    [HUD show:YES];
}

- ( void )requestWentWrong:(ASIHTTPRequest *)request
{
    NSLog(@"requestWentWrong PWSF");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fromDateStr = [NSDateUtil firstDateThisYear];
    self.endDateStr = [NSDateUtil todayDateStringWithFMT:@"yyyy-MM-dd"];
    [self doNotShowChartNumCol];

    self.title = [NSString stringWithFormat:@"排污收费(%@至%@)",fromDateStr,endDateStr];
    [self doNotShowChartNumCol];
    
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

-(void)viewWillDisappear:(BOOL)animated{
    [networkQueue cancelAllOperations];
    [HUD hide:YES];
    if (popController)
        [popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
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
    self.title = [NSString stringWithFormat:@"排污收费(%@至%@)",fromDateStr,endDateStr];
    [self requestData];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
}
@end
