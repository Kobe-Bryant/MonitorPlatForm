//
//  XZCFStaticsViewController.m
//  MonitorPlatform
//
//  Created by zhang on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
// 行政处罚部门统计

#import "XZCFStaticsViewController.h"
#import "NSURLConnHelper.h"
#import "NSDateUtil.h"
#import "ServiceUrlString.h"
#import "JSonKit.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"
#import "NTChartView.h"
#import "ChartItem.h"
#import "GraphTypeDataItem.h"
#import "GraphGroupDataItem.h"
#import "TableDataItem.h"
#import "UITableViewCell+Custom.h"
#import "MBProgressHUD.h"

@interface XZCFStaticsViewController ()
@property(nonatomic,copy)NSString *fromDateStr;
@property(nonatomic,copy)NSString *endDateStr;
@property(nonatomic,retain) ASINetworkQueue * networkQueue ;
@property(nonatomic,retain) NSArray *aryAYFDatas;
@property(nonatomic,retain) NSArray *aryABMDatas;
@property (nonatomic,strong) NSArray *aryAYFAllDatas;
@property (nonatomic,strong) NSArray *aryABMAllDatas;
@property (nonatomic,retain) NSMutableArray *aryAYF;
@property (nonatomic,strong) NSMutableArray *aryAYF_ALL;
@property (nonatomic,retain) NSMutableArray *aryABM;
@property (nonatomic,strong) NSMutableArray *aryABM_ALL;

@property(nonatomic,retain) NTChartView *chartViewTop;
@property(nonatomic,retain) NTChartView *chartViewBottom;
@property(nonatomic,assign) NSInteger typeIndex;
@property(nonatomic,retain)UITableView *tableView;
@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseDateRangeController *dateController;
@property (nonatomic,strong) MBProgressHUD *HUD;
@end

@implementation XZCFStaticsViewController
@synthesize fromDateStr,endDateStr;
@synthesize networkQueue,popController;
@synthesize aryABM,aryAYF,aryABM_ALL,aryAYF_ALL;
@synthesize aryAYFDatas,aryABMDatas,typeIndex;
@synthesize scrollView,pageControl,segCtrl,chartViewTop,chartViewBottom;
@synthesize tableView,dateController,HUD;
@synthesize aryABMAllDatas,aryAYFAllDatas;

-(id)init{
    if(self = [super initWithNibName:@"ShowStaticsGraphVC" bundle:nil]){
        
    }
    return self;
}

//按月份统计返回的数据
//----支队数据
-(void)requestAYFTJDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([aryTmp count] == 1){
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"年初到现在的数据为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
    }
    
    NSString *yearStr = nil;
    NSString *monthStr = nil;
    
    for (int i=0;i<[aryTmp count];i++)
    {
        NSDictionary *aDic = [aryTmp objectAtIndex:i];
        
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:aDic];
        NSString *ny = [aDic objectForKey:@"M"];
        if ([ny length] != 8)
        {
            int lastMonth = [monthStr intValue];
            int lastYear = [yearStr intValue];
            
            if (lastMonth == 12)
            {
                yearStr = [NSString stringWithFormat:@"%d",lastYear+1];
                monthStr = @"1";
            }
            else
            {
                monthStr = [NSString stringWithFormat:@"%d",lastMonth+1];
            }
            
            ny = [NSString stringWithFormat:@"%@年%@月",yearStr,monthStr];
            [newDic setObject:ny forKey:@"M"];
        }
        else
        {
            yearStr = [ny substringToIndex:4];
            monthStr = [ny substringFromIndex:5];
            monthStr = [monthStr substringToIndex:3];
        }
        [aryAYF addObject:newDic];
    }
    
    self.aryAYFDatas = [NSArray arrayWithArray: aryAYF];
    
    float totalCFS = 0;
    float totalJYS = 0;
    float totalCFJE = 0;
    
    for (NSDictionary *dic in aryAYFDatas)
    {
        float CFSCalue = [[dic objectForKey:@"CFS"] floatValue];
        float JYSCalue = [[dic objectForKey:@"JYS"] floatValue];
        float CFJECalue = [[dic objectForKey:@"CFJE"] floatValue];
        
        totalCFS += CFSCalue;
        totalJYS += JYSCalue;
        totalCFJE += CFJECalue;
    }
    NSString *CFSString = [NSString stringWithFormat:@"%.0f",totalCFS];
    NSString *JYSString = [NSString stringWithFormat:@"%.0f",totalJYS];
    NSString *CFJEString = [NSString stringWithFormat:@"%.0f",totalCFJE];
    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",CFSString,JYSString,CFJEString, nil] forKeys:[NSArray arrayWithObjects:@"M",@"CFS",@"JYS",@"CFJE", nil]];
    
    [aryAYF addObject:tmpDic];
}
//全市数据
-(void)requestAYFTJALLDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([aryTmp count] == 1){
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"年初到现在的数据为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
    }
    
    NSString *yearStr = nil;
    NSString *monthStr = nil;

    for (int i=0;i<[aryTmp count];i++)
    {
        NSDictionary *aDic = [aryTmp objectAtIndex:i];
        
        NSMutableDictionary *newDic = [NSMutableDictionary dictionaryWithDictionary:aDic];
        NSString *ny = [aDic objectForKey:@"M"];
        if ([ny length] != 8)
        {
            int lastMonth = [monthStr intValue];
            int lastYear = [yearStr intValue];
            
            if (lastMonth == 12)
            {
                yearStr = [NSString stringWithFormat:@"%d",lastYear+1];
                monthStr = @"1";
            }
            else
            {
                monthStr = [NSString stringWithFormat:@"%d",lastMonth+1];
            }
            
            ny = [NSString stringWithFormat:@"%@年%@月",yearStr,monthStr];
            [newDic setObject:ny forKey:@"M"];
        }
        else
        {
            yearStr = [ny substringToIndex:4];
            monthStr = [ny substringFromIndex:5];
            monthStr = [monthStr substringToIndex:3];
        }
        [aryAYF_ALL addObject:newDic];
    }
    self.aryAYFAllDatas = [NSArray arrayWithArray:aryAYF_ALL];
    
    float totalCFS = 0;
    float totalJYS = 0;
    float totalCFJE = 0;
    
    for (NSDictionary *dic in aryAYFAllDatas)
    {
        float CFSCalue = [[dic objectForKey:@"CFS"] floatValue];
        float JYSCalue = [[dic objectForKey:@"JYS"] floatValue];
        float CFJECalue = [[dic objectForKey:@"CFJE"] floatValue];
        
        totalCFS += CFSCalue;
        totalJYS += JYSCalue;
        totalCFJE += CFJECalue;
    }
    NSString *CFSString = [NSString stringWithFormat:@"%.0f",totalCFS];
    NSString *JYSString = [NSString stringWithFormat:@"%.0f",totalJYS];
    NSString *CFJEString = [NSString stringWithFormat:@"%.0f",totalCFJE];
    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",CFSString,JYSString,CFJEString, nil] forKeys:[NSArray arrayWithObjects:@"M",@"CFS",@"JYS",@"CFJE", nil]];
    
    [aryAYF_ALL addObject:tmpDic];
}

//按部门统计返回的数据
//--支队数据
-(void)requestABMTJDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([aryTmp count] == 1){
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取的数据为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
    }
    self.aryABMDatas = aryTmp;
    [aryABM addObjectsFromArray:aryTmp];
    
    float totalCFS = 0;
    float totalJYS = 0;
    float totalCFJE = 0;
    
    for (NSDictionary *dic in aryABMDatas)
    {
        float CFSCalue = [[dic objectForKey:@"CFS"] floatValue];
        float JYSCalue = [[dic objectForKey:@"JYS"] floatValue];
        float CFJECalue = [[dic objectForKey:@"CFJE"] floatValue];
        
        totalCFS += CFSCalue;
        totalJYS += JYSCalue;
        totalCFJE += CFJECalue;
    }
    NSString *CFSString = [NSString stringWithFormat:@"%.0f",totalCFS];
    NSString *JYSString = [NSString stringWithFormat:@"%.0f",totalJYS];
    NSString *CFJEString = [NSString stringWithFormat:@"%.0f",totalCFJE];
    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",CFSString,JYSString,CFJEString, nil] forKeys:[NSArray arrayWithObjects:@"BMMC",@"CFS",@"JYS",@"CFJE", nil]];
    
    [aryABM addObject:tmpDic];
    
}
//--全市数据
-(void)requestABMTJALLDone:(ASIHTTPRequest *)request{
    NSString *resultJSON = [request responseString];
    NSArray *aryTmp = [resultJSON objectFromJSONString];
    
    if (aryTmp == nil||[aryTmp count]==0)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取数据失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        return;
    }
    else if([aryTmp count] == 1){
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSDictionary *dic = [aryTmp objectAtIndex:0];
        NSString *str = [dic objectForKey:@"result"];
        if(str != nil && [str isEqualToString:@"failed"]){
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取的数据为空。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
    }
    self.aryABMAllDatas = aryTmp;
    [aryABM_ALL addObjectsFromArray:aryTmp];
    
    float totalCFS = 0;
    float totalJYS = 0;
    float totalCFJE = 0;
    
    for (NSDictionary *dic in aryABMAllDatas)
    {
        float CFSCalue = [[dic objectForKey:@"CFS"] floatValue];
        float JYSCalue = [[dic objectForKey:@"JYS"] floatValue];
        float CFJECalue = [[dic objectForKey:@"CFJE"] floatValue];
        
        totalCFS += CFSCalue;
        totalJYS += JYSCalue;
        totalCFJE += CFJECalue;
    }
    NSString *CFSString = [NSString stringWithFormat:@"%.0f",totalCFS];
    NSString *JYSString = [NSString stringWithFormat:@"%.0f",totalJYS];
    NSString *CFJEString = [NSString stringWithFormat:@"%.0f",totalCFJE];
    NSDictionary *tmpDic = [NSDictionary dictionaryWithObjects:[NSArray arrayWithObjects:@"汇总",CFSString,JYSString,CFJEString, nil] forKeys:[NSArray arrayWithObjects:@"SJBMMC",@"CFS",@"JYS",@"CFJE", nil]];
    
    [aryABM_ALL addObject:tmpDic];
    
}

-(void) allSyncFinished :(ASINetworkQueue *)queue{
    [self clearAllDataItems];
    [HUD hide:YES];
    [self showGraphDatas];
}

//弹出日期可选
-(void)chooseDateRange:(id)sender{
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController dismissPopoverAnimated:YES];
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)requestData{
    
    if ([aryAYF count] > 0)
        [aryAYF removeAllObjects];
    if ([aryABM count] > 0)
        [aryABM removeAllObjects];
    if ([aryABM_ALL count] > 0)
        [aryABM_ALL removeAllObjects];
    if ([aryAYF_ALL count] > 0)
        [aryAYF_ALL removeAllObjects];
    
    if (! networkQueue ) {
        self.networkQueue = [[[ ASINetworkQueue alloc ] init ] autorelease];
    }
    
    [networkQueue setShowAccurateProgress:YES];
    [networkQueue reset ]; // 队列清零
    [networkQueue setDelegate : self ]; // 设置队列的代理对象
    [networkQueue setQueueDidFinishSelector:@selector(allSyncFinished:)];
        
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"GET_XZCF_XZCFAYFTJ" forKey:@"service"];
    [params setObject:fromDateStr forKey:@"kssj"];
    [params setObject:endDateStr forKey:@"jssj"];
    
    NSString *urlStrAYFTJ = [ServiceUrlString generateUrlByParameters:params];    
    ASIHTTPRequest *requestAYFTJ;
    requestAYFTJ = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrAYFTJ]];
    [requestAYFTJ setDelegate:self];
    [requestAYFTJ setDidFinishSelector: @selector (requestAYFTJDone:)];
    [requestAYFTJ setDidFailSelector: @selector (requestWentWrong:)];    
    [networkQueue addOperation :requestAYFTJ];
    
    [params setObject:@"GET_XZCF_XZCFAYFTJ_ALL" forKey:@"service"];
    NSString *urlStrAYFTJ_ALL = [ServiceUrlString generateUrlByParameters:params];
    ASIHTTPRequest *requestAYFTJ_ALL;
    requestAYFTJ_ALL = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrAYFTJ_ALL]];
    [requestAYFTJ_ALL setDelegate:self];
    [requestAYFTJ_ALL setDidFinishSelector: @selector (requestAYFTJALLDone:)];
    [requestAYFTJ_ALL setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestAYFTJ_ALL];
    
    [params setObject:@"GET_XZCF_XZCFABMTJ" forKey:@"service"];
    NSString *urlStrABMTJ = [ServiceUrlString generateUrlByParameters:params];
    ASIHTTPRequest *requestABMTJ = [ ASIHTTPRequest requestWithURL :[ NSURL URLWithString :urlStrABMTJ]];
    [requestABMTJ setDelegate:self];
    [requestABMTJ setDidFinishSelector: @selector (requestABMTJDone:)];
    [requestABMTJ setDidFailSelector: @selector (requestWentWrong:)];
    [networkQueue addOperation :requestABMTJ];
    
    [params setObject:@"GET_XZCF_XZCFABMTJ_ALL" forKey:@"service"];
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
    NSLog(@"requestWentWrong XZCF");
}

-(void)refreshDatasByIndex:(NSInteger)index{
    self.typeIndex = index;
    
    [chartViewBottom clearItems];
    [chartViewTop clearItems];
    NSArray *aryData = aryAYFDatas;
    if(index == 1)
        aryData = aryABMDatas;
    else if(index == 2)
        aryData = aryAYFAllDatas;
    else if(index == 3)
        aryData = aryABMAllDatas;
    
    NSMutableArray *colorAry = [[ChartItem makeColorArray] retain];//不加retain会释放掉出错
    
    for(NSDictionary *dic in aryData){
        NSString *groupName = @"";
        if(index == 0 || index == 2)
            groupName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"M"]];
        else if (index == 1 ){
            groupName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"BMMC"]];
            if([groupName isEqualToString:@""])
                groupName = @"其它部门";
        }
        else if (index == 3)
        {
            groupName = [NSString stringWithFormat:@"%@",[dic objectForKey:@"SJBMMC"]];
            if([groupName isEqualToString:@""])
                groupName = @"其它";
        }
        
        CGFloat CFSCalue = [[dic objectForKey:@"CFS"] floatValue];
        CGFloat JYSCalue = [[dic objectForKey:@"JYS"] floatValue];
        CGFloat CFJECalue = [[dic objectForKey:@"CFJE"] floatValue];
        
        UIColor *color1 = [colorAry objectAtIndex:0];
        UIColor *color2 = [colorAry objectAtIndex:1];
        UIColor *color3 = [colorAry objectAtIndex:2];
        ChartItem *aItem1 = [ChartItem itemWithValue:CFSCalue Name:@"处罚数" Color:color1.CGColor];
        ChartItem *aItem2 = [ChartItem itemWithValue:JYSCalue Name:@"建议数" Color:color2.CGColor];
        ChartItem *aItem3 = [ChartItem itemWithValue:CFJECalue Name:@"处罚金额(万元)" Color:color3.CGColor];
        
        [chartViewTop addGroupArray:[NSArray arrayWithObjects:aItem2,aItem1, nil] withGroupName:groupName];
        [chartViewBottom addGroupArray:[NSArray arrayWithObjects:aItem3, nil] withGroupName:groupName];
        
        
    }
    [chartViewTop setNeedsDisplay];
    [chartViewBottom setNeedsDisplay];
    scrollView.scrollEnabled = YES;
    [self.tableView reloadData];
    
}

-(void)segCtrlValueChanged:(id)sender{
    
    [self refreshDatasByIndex:segCtrl.selectedSegmentIndex];
    
}

-(void)showGraphDatas{
    self.segCtrl = [[[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"按月份统计-支队",@"按部门统计-支队",@"按月份统计-全市",@"按部门统计-全委", nil]] autorelease];
    segCtrl.segmentedControlStyle = UISegmentedControlStyleBar;
    [segCtrl addTarget:self action:@selector(segCtrlValueChanged:) forControlEvents:UIControlEventValueChanged];
    segCtrl.frame = CGRectMake(100,10,568,40);
    [self.view addSubview:segCtrl];
    segCtrl.selectedSegmentIndex = 0;
    [self refreshDatasByIndex:segCtrl.selectedSegmentIndex];
}

-(void)addCustomUI{
    
    
    UIImageView *detailTopView = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"edgeBG.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]] autorelease];
    detailTopView.frame = CGRectMake(5, 0, 758, 855);
    [self.scrollView addSubview:detailTopView];
    
    UIImageView *detailTopView2 = [[[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"edgeBG.png"] stretchableImageWithLeftCapWidth:20 topCapHeight:20]] autorelease];
    detailTopView2.frame = CGRectMake(773, 0, 758, 855);
    [self.scrollView addSubview:detailTopView2];
    
    self.chartViewTop = [[[NTChartView alloc] initWithFrame:CGRectMake(20, 20, 728, 805/2)] autorelease];
    [self.scrollView addSubview:chartViewTop];
    
    self.chartViewBottom = [[[NTChartView alloc] initWithFrame:CGRectMake(20, 20+805/2, 728, 805/2)] autorelease];
    [self.scrollView addSubview:chartViewBottom];
    
    self.tableView = [[[UITableView alloc] initWithFrame:CGRectMake(788, 20, 728, 805) style:UITableViewStylePlain] autorelease];
    [scrollView addSubview:tableView];
    tableView.delegate = self;
    tableView.dataSource = self;

    [self.scrollView addSubview:tableView];
    [scrollView setContentSize:CGSizeMake(768*2, 855)];
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.aryAYF = [NSMutableArray arrayWithCapacity:20];
    self.aryABM = [NSMutableArray arrayWithCapacity:20];
    self.aryABM_ALL = [NSMutableArray arrayWithCapacity:20];
    self.aryAYF_ALL = [NSMutableArray arrayWithCapacity:20];
    
    [self doNotShowChartNumCol];

    self.fromDateStr = [NSDateUtil firstDateThisYear];
    self.endDateStr = [NSDateUtil todayDateStringWithFMT:@"yyyy-MM-dd"];
    self.title = [NSString stringWithFormat:@"行政处罚(%@至%@)",fromDateStr,endDateStr];
    
    scrollView.delegate = self;
	[scrollView setCanCancelContentTouches:NO];
	
	scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;
	scrollView.clipsToBounds = YES;
	scrollView.scrollEnabled = YES;
	scrollView.pagingEnabled = YES;
	scrollView.backgroundColor = [UIColor clearColor];
    [self addCustomUI];
    
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


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 748, 60)];
    
    
    NSArray *aryCols = [NSArray arrayWithObjects:@"月份",@"建议数",@"处罚数",@"处罚金额(万元)", nil];
    if(typeIndex == 1 || typeIndex == 3)
            aryCols = [NSArray arrayWithObjects:@"科室",@"建议数",@"处罚数",@"处罚金额(万元)", nil];            
    int colCount = 4;
    CGRect tRect = CGRectMake(0, 0, 0, 60);
    CGFloat colWidth;
    for (int i =0; i < colCount; i++) {
        colWidth = 748/colCount;
        tRect.size.width = colWidth;
        UILabel *label =[[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor blackColor]];
        label.font = [UIFont fontWithName:@"Helvetica" size:19.0];
        
        label.textAlignment = UITextAlignmentCenter;
        tRect.origin.x += colWidth;
        [label setText:[aryCols objectAtIndex:i]];
        [view addSubview:label];
        [label release];
    }
    view.backgroundColor = CELL_HEADER_COLOR2;
    return view;
}

-(CGFloat)tableView:(UITableView *)tableView  heightForHeaderInSection:(NSInteger)section{
    return 60;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Return the number of rows in the section.
    NSArray *aryData = aryAYF;
    if(typeIndex == 1)
        aryData = aryABM;
    else if(typeIndex == 2)
        aryData = aryAYF_ALL;
    else if(typeIndex == 3)
        aryData = aryABM_ALL;
    
    return [aryData count];
}

- (UITableViewCell *)tableView:(UITableView *)aTableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *aryData = aryAYF;
    NSArray *aryKeys = [NSArray arrayWithObjects:@"M",@"JYS",@"CFS",@"CFJE", nil];
    if(typeIndex == 1){
        aryData = aryABM;
        aryKeys = [NSArray arrayWithObjects:@"BMMC",@"JYS",@"CFS",@"CFJE", nil];
    }
    else if (typeIndex == 2)
    {
        aryData = aryAYF_ALL;
    }
    else if (typeIndex == 3)
    {
        aryData = aryABM_ALL;
        aryKeys = [NSArray arrayWithObjects:@"SJBMMC",@"JYS",@"CFS",@"CFJE",nil];
    }
    
    NSDictionary *dic = [aryData objectAtIndex:indexPath.row];
    NSMutableArray *aryValues = [NSMutableArray arrayWithCapacity:4];
    for(NSString *aKey in aryKeys){
        [aryValues addObject:[NSString stringWithFormat:@"%@",[dic objectForKey:aKey]]];
    }
    
    NSString *cellIdentifier = @"cellStatics";
    UITableViewCell *cell = [UITableViewCell makeMultiLabelsCell:aTableView withTexts:aryValues  andHeight:60 andWidth:768 andIdentifier:cellIdentifier];
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)aTableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR2;
    else {
        cell.backgroundColor = [UIColor whiteColor];
    }
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)dealloc{
    [aryABM release];
    [aryAYF release];
    [aryABMDatas release];
    [aryAYFDatas release];
    [networkQueue release];
    [fromDateStr release];
    [endDateStr release];
    [dateController release];
    [popController release];
    //[chartViewTop release];
    [super dealloc];
}

#pragma mark - Choose date range

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate{
    if (self.popController != nil)
        [popController dismissPopoverAnimated:YES];
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    self.title = [NSString stringWithFormat:@"行政处罚(%@至%@)",fromDateStr,endDateStr];
    [self requestData];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
}
@end
