//
//  STSViewController.m
//  MonitorPlatform
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "STSViewController.h"
#import "NSURLConnHelper.h"
#import "NSDateUtil.h"
#import "ServiceUrlString.h"
#import "JSonKit.h"
@interface STSViewController ()
@property(nonatomic,strong)NSURLConnHelper *urlConnHelper;
@property(nonatomic,retain)NSString *fromDate;
@property(nonatomic,retain)NSString *endDate;
@end

@implementation STSViewController
@synthesize urlConnHelper,fromDate,endDate;
-(id)init{
    if(self = [super initWithNibName:@"ShowStaticsGraphVC" bundle:nil]){
        
    }
    return self;
}

-(void)requestData{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"GET_JCGL_STSTJ" forKey:@"service"];
    [params setObject:fromDate forKey:@"kssj"];
    [params setObject:endDate forKey:@"jssj"];
    NSString *urlStr = [ServiceUrlString generateUrlByParameters:params];
    
    self.urlConnHelper = [[[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self] autorelease];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"年初到现在的三同时统计";
    self.fromDate = [NSDateUtil firstDateThisYear];
    self.endDate = [NSDateUtil todayDateStringWithFMT:@"yyyy-MM-dd"];
   // self.fromDate = @"2011-01-01";
   // self.endDate =  @"2012-01-01";
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
    [self clearAllDataItems];
    NSArray *cols = [NSArray arrayWithObjects:@"月份",@"数量", nil];
    NSArray *aryWidth = [NSArray arrayWithObjects:@"0.5",@"0.5", nil];
    NSMutableArray *aryTableVal = [NSMutableArray arrayWithCapacity:12];
    for(int i = 1; i <= 12; i++){
        int SL = 0;
        for(NSDictionary *dic in aryTmp){
            if([[dic objectForKey:@"YF"] intValue] == i){
                SL = [[dic objectForKey:@"SL"] intValue];
                break;
            }
        }
        NSString *slStr = [NSString stringWithFormat:@"%d",SL];
        NSDictionary *dicVal = [NSDictionary dictionaryWithObject:slStr forKey:@"数量"];
        NSString *yf = [NSString stringWithFormat:@"%d月",i];
        [self addGraphDataType:@"月份"  withGroupName:yf
                     colValues:dicVal];

        NSDictionary *dicTableVal = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:yf,slStr, nil] forKeys:cols];
        [aryTableVal addObject:dicTableVal];
    }

    [self addTableDataType:@"月份" withColumns:cols columnWidthPercent:aryWidth itemValues:aryTableVal showImage:NO];

    
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
    [fromDate release];
    [endDate release];
    [urlConnHelper release];
    [super dealloc];
}@end
