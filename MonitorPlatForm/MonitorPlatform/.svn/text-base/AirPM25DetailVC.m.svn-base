//
//  AirPM25DetailVC.m
//  PDBaseFrame
//
//  Created by 王哲义 on 13-1-28.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import "AirPM25DetailVC.h"
#import "JSONKit.h"
//#import "ZrsUtil.h"
#import "NSDateUtil.h"

@interface AirPM25DetailVC ()
@property (nonatomic,strong) NSURLConnHelper *webHelper;
@property (nonatomic,strong) PM25GraphView *graphView;
@property (nonatomic,strong) NSArray *finalDataAry;
@property (nonatomic,strong) NSArray *yValueAry;
@property (nonatomic,strong) NSArray *xValueAry;
@property (nonatomic,strong) PopupDateViewController *dateController;
@property (nonatomic,strong) UIPopoverController *datePopover;
@property (nonatomic,copy) NSString *dateStr;
@end

@implementation AirPM25DetailVC
@synthesize webHelper,graphView,finalDataAry;
@synthesize xValueAry,yValueAry;
@synthesize dateController,datePopover,dateStr;

#pragma mark - Private methods

- (void)addView:(UIView *)view type:(NSString *)type subType:(NSString *)subType
{
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;
    transition.subtype = subType;
    [self.view addSubview:view];
    [[view layer] addAnimation:transition forKey:@"ADD"];
}

- (void)removeView:(UIView *)view
{
    [view removeFromSuperview];
}

- (void)selectDate:(id)sender
{
    UIBarButtonItem *btn =(UIBarButtonItem *)sender;
    
	[datePopover presentPopoverFromBarButtonItem:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date
{
	[datePopover dismissPopoverAnimated:YES];
	if (bSaved)
    {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		[dateFormatter release];
		
		self.dateStr = dateString;
	}
    [self requestData];
}

#pragma mark - Get webData

- (void)requestData
{
    NSString *urlStr = [NSString stringWithFormat:@"http://www.szhec.gov.cn/pages/szepb/kqzl/TGzfwHjKqzlzsPm10.jsp?jcsj=%@",dateStr];
    self.webHelper = [[[NSURLConnHelper alloc] initWithUrl:urlStr andParentView:self.view delegate:self] autorelease];
}
#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    
    NSString *resultJSON =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];

    NSArray *resultAry = [resultJSON objectFromJSONString];
    
    if (resultAry == nil || [resultAry count] == 0)
    {
//        [ZrsUtil showAlertMsg:@"查无数据" andDelegate:nil];
        return;
    }
    
    NSMutableArray *dataAry = [NSMutableArray arrayWithCapacity:50];
    for (NSDictionary *tmpDic in resultAry)
    {
        NSString *name = [tmpDic objectForKey:@"JCDWMC"];
        NSRange timeRange;
        timeRange.location = 11;
        timeRange.length = 5;
        NSString *time = [[tmpDic objectForKey:@"JCSJ"] substringWithRange:timeRange];
        NSString *count = [tmpDic objectForKey:@"KLWXY25ND"];
        
        if ([dataAry count] == 0)
        {
            NSMutableDictionary *cedianDic = [NSMutableDictionary dictionaryWithCapacity:3];
            [cedianDic setObject:name forKey:@"title"];
            NSMutableArray *timeAry = [NSMutableArray arrayWithObjects:time, nil];
            NSMutableArray *countAry = [NSMutableArray arrayWithObjects:count, nil];
            [cedianDic setObject:timeAry  forKey:@"time"];
            [cedianDic setObject:countAry  forKey:@"count"];
            [dataAry addObject:cedianDic];
        }
        else
        {
            BOOL bExist = NO;
            int i;
            for (i = 0; i<[dataAry count]; i++)
            {
                NSDictionary *cdTmpDic = [dataAry objectAtIndex:i];
                NSString *oldName = [cdTmpDic objectForKey:@"title"];
                if ([oldName isEqualToString:name])
                {
                    bExist = YES;
                    break;
                }
            }
            
            if (bExist)
            {
                NSMutableDictionary *dicTmp = [dataAry objectAtIndex:i];
                NSMutableArray *timeAry = [dicTmp objectForKey:@"time"];
                NSMutableArray *countAry = [dicTmp objectForKey:@"count"];
                [timeAry addObject:time];
                [countAry addObject:count];
            }
            else
            {
                NSMutableDictionary *cedianDic = [NSMutableDictionary dictionaryWithCapacity:3];
                [cedianDic setObject:name forKey:@"title"];
                NSMutableArray *timeAry = [NSMutableArray arrayWithObjects:time, nil];
                NSMutableArray *countAry = [NSMutableArray arrayWithObjects:count, nil];
                [cedianDic setObject:timeAry  forKey:@"time"];
                [cedianDic setObject:countAry  forKey:@"count"];
                [dataAry addObject:cedianDic];
            }
        }
    }
    
    self.finalDataAry = dataAry;
    
    [cedianList reloadData];
    
    NSIndexPath * idex = [NSIndexPath indexPathForRow:0 inSection:0];
    [cedianList selectRowAtIndexPath:idex animated:YES scrollPosition:UITableViewScrollPositionNone];
    [self tableView:cedianList didSelectRowAtIndexPath:idex];
    
}

-(void)processError:(NSError *)error
{
//    [ZrsUtil showAlertMsg:@"请求数据失败,请检查网络连接并重试。" andDelegate:nil];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"PM2.5实时监测数据";
    self.yValueAry = nil;
    self.xValueAry = nil;
    //时间选择弹窗初始化
    PopupDateViewController *tmpdate = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = tmpdate;
	dateController.delegate = self;
	[tmpdate release];
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.datePopover = popover;
	[popover release];
	[nav release];
    
    //导航栏按钮初始化
    
    UIBarButtonItem *btnItem = [[UIBarButtonItem alloc] initWithTitle:@"选择日期" style:UIBarButtonItemStyleBordered target:self action:@selector(selectDate:)];
    self.navigationItem.rightBarButtonItem = btnItem;
    [btnItem release];
    
    //折线图初始化
    self.graphView = [[[PM25GraphView alloc] initWithFrame:CGRectMake(20, 5, 740, 460)] autorelease];
	self.graphView.dataSource = self;
	NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMinimumFractionDigits:2];
	[numberFormatter setMaximumFractionDigits:2];
	
	self.graphView.yValuesFormatter = numberFormatter;
    
	[numberFormatter release];
	
	self.graphView.backgroundColor = [UIColor clearColor];
	
	self.graphView.drawAxisX = YES;
	self.graphView.drawAxisY = YES;
	self.graphView.drawGridX = NO;
	self.graphView.drawGridY = NO;
	
	self.graphView.xValuesColor = [UIColor colorWithRed:(0xf1/255.0f) green:(0xf1/255.0f) blue:(0xf1/255.0f) alpha:1];
	self.graphView.yValuesColor = [UIColor colorWithRed:(0xf1/255.0f) green:(0xf1/255.0f) blue:(0xf1/255.0f) alpha:1];
	

	self.graphView.drawInfo = YES;
    self.graphView.info = @"";

    self.graphView.infoColor = [UIColor clearColor];
    
    self.graphView.xValuesColor = [UIColor blackColor];
	self.graphView.yValuesColor = [UIColor blackColor];
	
	self.graphView.gridXColor = [UIColor blackColor];
	self.graphView.gridYColor = [UIColor blackColor];
	self.graphView.infoColor = [UIColor blackColor];

    [self.view addSubview:graphView];
    
    
    self.resultWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(305, 504, 452, 421)] autorelease];
    [self.view addSubview:_resultWebView];

    self.dateStr = [NSDateUtil stringFromDate:[NSDate date] andTimeFMT:@"yyyy-MM-dd"];
    [self requestData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
        [webHelper cancel];
    if(datePopover)
       [datePopover dismissPopoverAnimated:YES];
    
    [super viewWillDisappear:YES];
}

- (void)dealloc
{
    [webHelper release];
    [graphView release];
    [finalDataAry release];
    [yValueAry release];
    [xValueAry release];
    [dateController release];
    [datePopover release];
    [dateStr release];
    [super dealloc];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *sectionTitle = [NSString stringWithFormat:@"PM2.5监测站点：%d个",[finalDataAry count]];
    
    return sectionTitle;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [finalDataAry count];
}


- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.row%2 == 1)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 35;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	static NSString *identifier = @"CellIdentifier";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier] autorelease];
        cell.textLabel.numberOfLines =2;
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17.0];
	}
    NSInteger row = [indexPath row];
    NSDictionary *tmpDic = [finalDataAry objectAtIndex:row];

    cell.textLabel.text = [tmpDic objectForKey:@"title"];
    
	return cell;
	
}


#pragma mark - UITableViewDelegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self removeView:graphView];
    NSDictionary *tmpDic = [finalDataAry objectAtIndex:indexPath.row];
    
    self.yValueAry = [tmpDic objectForKey:@"count"];
    self.xValueAry = [tmpDic objectForKey:@"time"];
    
    [graphView reloadData];
    [self addView:graphView type:@"rippleEffect" subType:kCATransitionFromTop];
    
    if (self.graphView.superview)
        [graphView removeFromSuperview];
    [self refreshWebViewWith:tmpDic];

}

-(void)refreshWebViewWith:(NSDictionary *)info{
    
    NSString *titleStr = [info objectForKey:@"title"];
    NSString *width = @"452px";
    
    NSMutableString *html = [NSMutableString stringWithCapacity:0];
    [html appendFormat:@"<html><body topmargin=0 leftmargin=0><table width=\"%@\" bgcolor=\"#FFCC32\" border=1 bordercolor=\"#893f7e\" frame=below rules=none><tr><th><font color=\"Black\">%@PM2.5实时监测详细信息</font></th></tr><table><table width=\"%@\" bgcolor=\"#893f7e\" border=0 cellpadding=\"1\"><tr bgcolor=\"#e6e7d5\" ><th>监测时间</th><th>监测数据</th></tr>",width,titleStr,width];
    
    BOOL boolColor = true;
    NSArray *valueAry = [info objectForKey:@"count"];
    NSArray *timeArr = [info objectForKey:@"time"];
    for (int i = [valueAry count]-1; i >=0 ; i--) {
        NSString *time = [NSString stringWithFormat:@"%@ %@",dateStr,[timeArr objectAtIndex:i]];
        
        [html appendFormat:@"<tr bgcolor=\"%@\">",boolColor ? @"#cfeeff" : @"#ffffff"];
        boolColor = !boolColor;
        [html appendFormat:@"<td align=center>%@</td><td align=center>%@</td>",time ,[valueAry objectAtIndex:i]];
        [html appendString:@"</tr>"];
        
    }
    
    [html appendString:@"</table></body></html>"];
    
    //添加webview
    [self.resultWebView loadHTMLString:html baseURL:nil];
    [self addView:self.resultWebView type:@"pageCurl" subType:kCATransitionFromRight];
    
    //添加统计图
    self.graphView.drawInfo = NO;
    [self.graphView reloadData];
    [self addView:self.graphView type:@"rippleEffect" subType:kCATransitionFromTop];
}



#pragma mark - protocol S7GraphViewDataSource

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView
{
	/* Return the number of plots you are going to have in the view. 1+ */
    return 1;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView
{
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
    NSMutableArray *xValueArr = nil;
    if (xValueAry == nil)
    {
        xValueArr = [NSArray arrayWithObjects:@"0时",@"1时",@"2时",@"3时",@"4时",@"5时",@"6时",@"7时",@"8时",@"9时",@"10时",@"11时",@"12时",@"13时",@"14时",@"15时",@"16时",@"17时",@"18时",@"19时",@"20时",@"21时",@"22时",@"23时", nil];
    }
    else
    {
        xValueArr = [NSMutableArray arrayWithCapacity:25];
        for (int i = [xValueAry count] - 1;i>=0;i--)
        {
            NSString *time = [xValueAry objectAtIndex:i];
            [xValueArr addObject:time];
        }
    }
    
	return xValueArr;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex
{
    NSMutableArray *valueArray;
    
    if (yValueAry == nil)
    {
        valueArray = [NSMutableArray arrayWithCapacity:25];
        for (int i = 0; i < 24 ;i++)
        {
            [valueArray addObject:[NSNumber numberWithInt:0]];
        }
    }
    else
    {
        valueArray = [NSMutableArray arrayWithCapacity:25];
        for (int i = [yValueAry count] - 1;i>=0;i--)
        {
            NSString *count = [yValueAry objectAtIndex:i];
            [valueArray addObject:count];
        }
    }
    
	return valueArray;
}

- (BOOL)graphViewIfSumValues:(S7GraphView *)graphView
{
    return NO;
}
@end
