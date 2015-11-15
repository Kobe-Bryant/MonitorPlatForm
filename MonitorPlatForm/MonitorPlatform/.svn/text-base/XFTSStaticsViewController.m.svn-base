//
//  NoiseStaticsViewController.m
//  MonitorPlatform
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
// 噪声许可统计

#import "XFTSStaticsViewController.h"
#import "NSDateUtil.h"
#import "ServiceUrlString.h"
#import "JSonKit.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "MBProgressHUD.h"

@interface XFTSStaticsViewController ()
@property(nonatomic,retain)NSString *fromDateStr;
@property(nonatomic,retain)NSString *endDateStr;
@property(nonatomic,retain) ASINetworkQueue * networkQueue ;
@property(nonatomic,retain) NSArray *aryAQYDatas;
@property(nonatomic,retain) NSArray *aryAZNDatas;
@property(nonatomic,retain) NSArray *aryAJLXDatas;
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseDateRangeController *dateController;
@property (nonatomic,strong) MBProgressHUD *HUD;
@end

@implementation XFTSStaticsViewController
@synthesize fromDateStr,endDateStr,popController,dateController;
@synthesize networkQueue,aryAQYDatas,aryAZNDatas,aryAJLXDatas,HUD;

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

//按总汇统计返回的数据
-(void)requestASNTJDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取按月统计数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
    self.aryAZNDatas = aryTmp;
}

//按类型统计返回的数据
-(void)requestALXTJDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取按类型统计数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
        
    }
    else if([aryTmp count] == 1){
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有查到相关数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
    }
    self.aryAJLXDatas = aryTmp;
}

//按区域统计返回的数据
-(void)requestAQYTJDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取按区域统计数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([aryTmp count] == 1){
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有查到相关数据。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
    }
    self.aryAQYDatas = aryTmp;
}

-(void) allSyncFinished :(ASINetworkQueue *)queue{
    [HUD hide:YES];
    [self clearAllDataItems];
    if([aryAZNDatas count] > 0){
        NSArray *cols = [NSArray arrayWithObjects:@"月份",@"投诉案件数量",@"去年同期",@"同比", nil];
        NSArray *aryWidth = [NSArray arrayWithObjects:@"0.25",@"0.25",@"0.25",@"0.25",  nil];
        NSMutableArray *aryTableVal = [NSMutableArray arrayWithCapacity:12];
        
        float currentYearCount = 0;
        float lastYearCount = 0;
        
        for(NSDictionary *dic in aryAZNDatas){
            
            NSString *yf = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SLSJ"]];
            
            NSString *SNJEStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"ZS"]];
            NSString *JEStr = [NSString stringWithFormat:@"%@",[dic objectForKey:@"TQS"]];
            
            NSDictionary *dicVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:SNJEStr,JEStr, nil] forKeys:[NSArray arrayWithObjects:@"投诉案件数量",@"去年同期", nil]];
            
            currentYearCount += [SNJEStr floatValue];
            lastYearCount += [JEStr floatValue];
            
            [self addGraphDataType:@"按月份"  withGroupName:yf
                         colValues:dicVal];
            
            float changeCount = ([SNJEStr floatValue] - [JEStr floatValue])*100/[JEStr floatValue];
            NSString *changePercent = [NSString stringWithFormat:@"%.2f%%",changeCount];
            
            NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yf,SNJEStr,JEStr,changePercent,nil] forKeys:cols];
            [aryTableVal addObject:dicTableVal];
            
        }
        
        float changeCount = (currentYearCount - lastYearCount)*100/lastYearCount;
        NSString *changePercent = [NSString stringWithFormat:@"%.2f%%",changeCount];
        NSString *currentYearStr = [NSString stringWithFormat:@"%.0f",currentYearCount];
        NSString *lastYearStr = [NSString stringWithFormat:@"%.0f",lastYearCount];
        
        NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",currentYearStr,lastYearStr,changePercent, nil] forKeys:cols];
        [aryTableVal addObject:dicTableVal];
        
        [self addTableDataType:@"按月份" withColumns:cols columnWidthPercent:aryWidth itemValues:aryTableVal showImage:YES];
    }
    
    
    if([aryAQYDatas count] > 0){
        NSMutableArray *aryQH = [NSMutableArray arrayWithCapacity:10];
        NSMutableDictionary *dicSL = [NSMutableDictionary dictionaryWithCapacity:10];
        for(NSArray *aryYF in aryAQYDatas){
            for(NSDictionary *dic in aryYF){
                NSString *qh = [dic objectForKey:@"XZQH"];
                if([aryQH containsObject:qh]){
                    NSNumber *num = [dicSL objectForKey:qh];
                    NSInteger count = [[dic objectForKey:@"ZS"] intValue];
                    num = [NSNumber numberWithInt:count+[num intValue]];
                    [dicSL setObject:num forKey:qh];
                    
                }else{
                    NSInteger count = [[dic objectForKey:@"ZS"] intValue];
                    NSNumber *num = [NSNumber numberWithInt:count];
                    [dicSL setObject:num forKey:qh];
                    [aryQH addObject:qh];
                }
            }
            
        }
        
        NSArray *cols = [NSArray arrayWithObjects:@"行政区划",@"投诉案件数量", nil];
        NSArray *aryWidth = [NSArray arrayWithObjects:@"0.5",@"0.5", nil];
        NSMutableArray *aryTableVal = [NSMutableArray arrayWithCapacity:12];
        float currentYearCount = 0;
        
        for(NSString *qh in aryQH){
            NSNumber *num = [dicSL objectForKey:qh];
            NSString *slStr = [NSString stringWithFormat:@"%@",num];
            NSDictionary *dicVal = [NSDictionary dictionaryWithObject:slStr forKey:@"投诉案件数量"];
            
            currentYearCount += [num floatValue];
            
            if([qh length] <=0)
                qh = @"其它";
            [self addGraphDataType:@"按行政区划"  withGroupName:qh
                         colValues:dicVal];
            
            NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:qh,slStr, nil] forKeys:cols];
            [aryTableVal addObject:dicTableVal];
            
        }
        
        NSString *currentYearStr = [NSString stringWithFormat:@"%.0f",currentYearCount];
        NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",currentYearStr, nil] forKeys:cols];
        [aryTableVal addObject:dicTableVal];
        
        [self addTableDataType:@"按行政区划" withColumns:cols columnWidthPercent:aryWidth itemValues:aryTableVal showImage:NO];
    }
    
    if([aryAJLXDatas count] > 0){
        NSMutableArray *aryAJLX = [NSMutableArray arrayWithCapacity:10];
        NSMutableDictionary *dicSL = [NSMutableDictionary dictionaryWithCapacity:10];
        //先汇总起来
        
        for(NSArray *aryYF in aryAJLXDatas){
            for(NSDictionary *dic in aryYF){
                NSString *qh = [dic objectForKey:@"DMNR"];
                if([aryAJLX containsObject:qh]){
                    NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithDictionary:[dicSL objectForKey:qh]];
                    NSNumber *num1 = [itemDic objectForKey:@"ZS"];
                    NSInteger count1 = [[dic objectForKey:@"ZS"] intValue];
                    num1 = [NSNumber numberWithInt:count1+[num1 intValue]];
                    [itemDic setObject:num1 forKey:@"ZS"];
                    
                    NSNumber *num2 = [dicSL objectForKey:@"SNZS"];
                    NSInteger count2 = [[dic objectForKey:@"SNZS"] intValue];
                    num2 = [NSNumber numberWithInt:count2+[num2 intValue]];
                    [itemDic setObject:num2 forKey:@"SNZS"];
                    [dicSL setObject:itemDic  forKey:qh];
                }else{
                    NSInteger count1 = [[dic objectForKey:@"ZS"] intValue];
                    NSInteger count2 = [[dic objectForKey:@"SNZS"] intValue];
                    NSNumber *num1 = [NSNumber numberWithInt:count1];
                    NSNumber *num2 = [NSNumber numberWithInt:count2];
                    
                    NSMutableDictionary *itemDic = [NSMutableDictionary dictionaryWithCapacity:4];
                    [itemDic setObject:num1 forKey:@"ZS"];
                    [itemDic setObject:num2 forKey:@"SNZS"];
                    [dicSL setObject:itemDic  forKey:qh];
                    [aryAJLX addObject:qh];
                }
            }
            
        }
        
        NSNumber *zs_hz = [NSNumber numberWithInt:0];
        NSNumber *tqs_hz = [NSNumber numberWithInt:0];
        for (NSString *lx in aryAJLX)
        {
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:[dicSL objectForKey:lx]];
            NSNumber *zs = [tmpDic objectForKey:@"ZS"];
            NSNumber *tqs = [tmpDic objectForKey:@"SNZS"];
            //计算同比
            NSString *tbStr = nil;
            if ([tqs floatValue] == 0 && [zs floatValue] == 0)
                tbStr = @"0%";
            else if ([tqs floatValue] == 0)
                tbStr = @"——";
            else
            {
                float tb = ([zs floatValue]-[tqs floatValue])/[tqs floatValue]*100;
                tbStr = [NSString stringWithFormat:@"%.2f%%",tb];
            }
            [tmpDic setObject:tbStr forKey:@"TB"];
            [dicSL setObject:tmpDic forKey:lx];
            //汇总出最后一行的数值
            zs_hz = [NSNumber numberWithInt:[zs_hz intValue]+[zs intValue]];
            tqs_hz = [NSNumber numberWithInt:[tqs_hz intValue]+[tqs intValue]];
        }
        //计算每种类型占总数百分比
        for (NSString *lx in aryAJLX)
        {
            NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithDictionary:[dicSL objectForKey:lx]];
            NSNumber *zs = [tmpDic objectForKey:@"ZS"];
            float szbfb = [zs floatValue]/[zs_hz floatValue]*100;
            NSString *szbfbStr = [NSString stringWithFormat:@"%.2f%%",szbfb];
            [tmpDic setObject:szbfbStr forKey:@"SZBFB"];
            [dicSL setObject:tmpDic forKey:lx];
        }
        
        NSArray *cols = [NSArray arrayWithObjects:@"案件类型",@"投诉案件数量",@"占总数百分比",@"同期案件数量",@"同比", nil];
        NSArray *aryWidth = [NSArray arrayWithObjects:@"0.2",@"0.2",@"0.2",@"0.2",@"0.2", nil];
        NSMutableArray *aryTableVal = [NSMutableArray arrayWithCapacity:12];
        
        for(NSString *qh in aryAJLX){
            NSMutableDictionary *dicItem = [dicSL objectForKey:qh];
            NSNumber *num1 = [dicItem objectForKey:@"ZS"];
            NSString *slStr1 = [NSString stringWithFormat:@"%@",num1];
            NSNumber *num2 = [dicItem objectForKey:@"SNZS"];
            NSString *slStr2 = [NSString stringWithFormat:@"%@",num2];
            NSDictionary *dicVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:slStr1,slStr2, nil] forKeys:[NSArray arrayWithObjects:@"投诉案件数量",@"同期案件数量", nil]];
     
            if([qh length] <=0)
                qh = @"其它";
            [self addGraphDataType:@"按案件类型"  withGroupName:qh
                         colValues:dicVal];
            
            NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:qh,slStr1,[dicItem objectForKey:@"SZBFB"],slStr2,[dicItem objectForKey:@"TB"], nil] forKeys:cols];
            [aryTableVal addObject:dicTableVal];
            
        }
        //计算最后一行汇总的同比
        NSString *tb_hzStr = nil;
        if ([tqs_hz floatValue] == 0 && [zs_hz floatValue] == 0)
            tb_hzStr = @"0%";
        else if ([tqs_hz floatValue] == 0)
            tb_hzStr = @"--";
        else
        {
            float tb_hz =([zs_hz floatValue]-[tqs_hz floatValue])/[tqs_hz floatValue]*100;
            tb_hzStr = [NSString stringWithFormat:@"%.2f%%",tb_hz];
        }
        
        
        //加入最后一行的信息
        
        NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",[zs_hz stringValue],@"100%",[tqs_hz stringValue],tb_hzStr, nil] forKeys:cols];
        [aryTableVal addObject:dicTableVal];
        
        [self addTableDataType:@"按案件类型" withColumns:cols columnWidthPercent:aryWidth itemValues:aryTableVal showImage: YES];
    }
    
    [self showGraphDatas];
}

-(void)requestData{
    
    if (!networkQueue ) {
        self.networkQueue = [[[ASINetworkQueue alloc ] init ] autorelease];
    }
    
    [networkQueue setShowAccurateProgress:YES];
    [networkQueue reset ]; // 队列清零
    [networkQueue setDelegate : self ]; // 设置队列的代理对象
    [networkQueue setQueueDidFinishSelector:@selector(allSyncFinished:)];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"GET_HJXF_HJXFAQYTJ" forKey:@"service"];
    [params setObject:fromDateStr forKey:@"kssj"];
    [params setObject:endDateStr forKey:@"jssj"];
    
    NSString *urlStrAQYTJ = [ServiceUrlString generateUrlByParameters:params];
    ASIHTTPRequest *requestAQYTJ;
    requestAQYTJ = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrAQYTJ]];
    [requestAQYTJ setDelegate:self];
    [requestAQYTJ setDidFinishSelector: @selector (requestAQYTJDone:)];
    [requestAQYTJ setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestAQYTJ];
    
    [params setObject:@"GET_HJXF_HJXFASNTJ" forKey:@"service"];
    NSString *urlStrASNTJ = [ServiceUrlString generateUrlByParameters:params];
    ASIHTTPRequest *requestASNTJ = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrASNTJ]];
    [requestASNTJ setDelegate:self];
    [requestASNTJ setDidFinishSelector: @selector (requestASNTJDone:)];
    [requestASNTJ setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestASNTJ];
    
    [params setObject:@"GET_HJXF_HJXFALXTJ" forKey:@"service"];
    NSString *urlStrAJTJ = [ServiceUrlString generateUrlByParameters:params];
    ASIHTTPRequest *requestAJTJ = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrAJTJ]];
    [requestAJTJ setDelegate:self];
    [requestAJTJ setDidFinishSelector: @selector (requestALXTJDone:)];
    [requestAJTJ setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestAJTJ];
    
    [networkQueue go]; // 队列任务开始
    
    [HUD show:YES];
}

- ( void )requestWentWrong:(ASIHTTPRequest *)request
{
    //  NSLog(@"requestWentWrong XFTS");
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fromDateStr = [NSDateUtil firstDateThisYear];
    self.endDateStr = [NSDateUtil todayDateStringWithFMT:@"yyyy-MM-dd"];
    [self doNotShowChartNumCol];
    
    self.title = [NSString stringWithFormat:@"信访投诉(%@至%@)",fromDateStr,endDateStr];
    
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
   return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)viewWillDisappear:(BOOL)animated{
    [networkQueue cancelAllOperations];
    if (popController)
        [popController dismissPopoverAnimated:YES];
    [HUD hide:YES];
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
    
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    
    self.title = [NSString stringWithFormat:@"信访投诉(%@至%@)",fromDateStr,endDateStr];
    [self requestData];
    if (self.popController != nil)
        [popController dismissPopoverAnimated:YES];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
}

@end
