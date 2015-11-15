//
//  JSSGStaticsViewController.m
//  MonitorPlatform
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "JSSGStaticsViewController.h"
#import "NSURLConnHelper.h"
#import "NSDateUtil.h"
#import "ServiceUrlString.h"
#import "JSonKit.h"

@interface JSSGStaticsViewController ()
@property(nonatomic,strong)NSURLConnHelper *urlConnHelper;
@property(nonatomic,retain)NSString *fromDateStr;
@property(nonatomic,retain)NSString *endDateStr;
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseDateRangeController *dateController;



@end

@implementation JSSGStaticsViewController
@synthesize urlConnHelper,fromDateStr,endDateStr;
@synthesize popController,dateController;
//@synthesize networkQueue,aryABMDatas,HUD,aryAcMDatas;

-(id)init{
    if(self = [super initWithNibName:@"ShowStaticsGraphVC" bundle:nil]){
        
    }
    return self;
}

-(void)chooseDateRange:(id)sender{
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController dismissPopoverAnimated:YES];
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


-(void)requestData{

    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"GET_JCGL_JZSGTJ" forKey:@"service"];
    [params setObject:fromDateStr forKey:@"kssj"];
    [params setObject:endDateStr forKey:@"jssj"];
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
    
    self.urlConnHelper = [[[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self] autorelease];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fromDateStr = [NSDateUtil firstDateThisYear];
    self.endDateStr = [NSDateUtil todayDateStringWithFMT:@"yyyy-MM-dd"];
    [self doNotShowChartNumCol];

    self.title = [NSString stringWithFormat:@"建筑工地(%@至%@)",fromDateStr,endDateStr];
    
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
    [urlConnHelper cancel];
    if (popController)
        [popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}
#pragma mark - URLConnHelper delegate
-(void)processWebData:(NSData*)webData
{
    NSString *resultJSON =[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    [resultJSON release];
    
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    [self clearAllDataItems];
    
    float totalCount = 0;
    float addCount = 0;
    
    for(NSDictionary *dic in aryTmp){
        NSMutableDictionary *dicTmp1 = [NSMutableDictionary dictionaryWithCapacity:2];
        NSString *xzqh = [dic objectForKey:@"XZQH"];
        if([xzqh length] <=0)
            xzqh = @"其它";
        [dicTmp1 setValue:[dic objectForKey:@"GDSL"] forKey:@"今年工地个数"];
        [dicTmp1 setValue:[dic objectForKey:@"XZGDSL"] forKey:@"新增工地个数"];
        
        totalCount += [[dic objectForKey:@"GDSL"] floatValue];
        addCount += [[dic objectForKey:@"XZGDSL"] floatValue];
        
        [self addGraphDataType:@"行政区划"  withGroupName:xzqh
                     colValues:dicTmp1];
    }
    NSArray *cols1 = [NSArray arrayWithObjects:@"行政区划",@"今年工地个数",@"新增工地个数", nil];
    NSArray *aryWidth1 = [NSArray arrayWithObjects:@"0.33",@"0.33",@"0.33", nil];
    NSMutableArray *aryVal1 = [NSMutableArray arrayWithCapacity:10];
    for(NSDictionary *dic in aryTmp){
        NSMutableDictionary *dicVal = [NSMutableDictionary dictionaryWithCapacity:3];
        NSString *xzqh = [dic objectForKey:@"XZQH"];
        if([xzqh length] <=0)
            xzqh = @"其它";
        [dicVal setObject:xzqh  forKey:@"行政区划"];
        [dicVal setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"GDSL"]] forKey:@"今年工地个数"];
        [dicVal setObject:[NSString stringWithFormat:@"%@",[dic objectForKey:@"XZGDSL"]] forKey:@"新增工地个数"];
        [aryVal1 addObject:dicVal];
    }
    NSString *totalStr = [NSString stringWithFormat:@"%.0f",totalCount];
    NSString *addStr = [NSString stringWithFormat:@"%.0f",addCount];
    NSDictionary *dicVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",totalStr,addStr, nil] forKeys:cols1];
    [aryVal1 addObject:dicVal];
    
    [self addTableDataType:@"行政区划" withColumns:cols1 columnWidthPercent:aryWidth1 itemValues:aryVal1 showImage:NO];
    
    
    [self showGraphDatas];
    
    
}

-(void)processError:(NSError *)error
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

-(void)dealloc{
    [fromDateStr release];
    [endDateStr release];
    [urlConnHelper release];
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
    

    self.title = [NSString stringWithFormat:@"建筑工地(%@至%@)",fromDateStr,endDateStr];
    [self requestData];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
}


@end
