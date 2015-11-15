//
//  WryOnlineMonitorConroller.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-15.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "WryOnlineMonitorConroller.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"

extern MPAppDelegate *g_appDelegate;
#define kRequestZhiBiao 1 //指标
#define kRequestPfData  2 //排放数据

@implementation WryOnlineMonitorConroller

@synthesize dataTableView,resultDataDic,popController,resultDataAry,itemName;
@synthesize curParsedData,isGotJsonString,btnTitleView,graphView,unit,bWarn;
@synthesize wrybh,wrymc,resultWebView,webHelper,dateController,imgView;
@synthesize nRequestDataType,fromDateStr,endDateStr,html,valueAry,timeAry;


#pragma mark - Private methods

- (void)addView:(UIView *)view type:(NSString *)type subType:(NSString *)subType
{
    if(view.superview !=nil)
       [view removeFromSuperview];
    CATransition *transition = [CATransition animation];
    transition.duration = 1.0;
    transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    transition.type = type;
    transition.subtype = subType;
    [self.view addSubview:view];
    [[view layer] addAnimation:transition forKey:@"ADD"];
    

}

-(void)selectPolutionSrc
{
    OCPSelectedController *controller = [[OCPSelectedController alloc] initWithStyle:UITableViewStyleGrouped];	

	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	nav.modalPresentationStyle =  UIModalPresentationFormSheet;
    nav.view.superview.frame = CGRectMake(30, 100, 700, 700);
	[self presentModalViewController:nav animated:YES];
	[controller release];
    [nav release];
    
}


-(void)requestData{
    [resultDataDic removeAllObjects];
    [self.dataTableView reloadData];
    

    
    if ([valueAry count] > 0)
        [self.valueAry removeAllObjects];
    if ([timeAry count] > 0)
        [self.timeAry removeAllObjects];
    //[self.graphView reloadData];
    
    nRequestDataType = kRequestZhiBiao;
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"QYCode" value:wrybh, @"WryMc",wrymc,
                       @"StartTime",fromDateStr,@"EndTime",endDateStr,nil];
    NSString *strUrl = [NSString stringWithFormat:OnLineControl_URL,g_appDelegate.xxcxServiceIP];
    
    if (webHelper) {
        [webHelper cancel];
    }
    
    self.webHelper =[[[WebServiceHelper alloc]initWithUrl:strUrl
                                                       method:@"OnlineMonitorEquipmentList"
                                                    nameSpace:@"http://tempuri.org/"
                                                   parameters:param
                                                     delegate:self] autorelease];
    
    
    [webHelper runAndShowWaitingView:self.view];
    //NSLog(@"%@ %@?op=OnlineMonitorEquipmentList", param, strUrl);
}

-(void)chooseDateRange:(id)sender{
    if (popController)
        [popController dismissPopoverAnimated:YES];
    
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
        
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - ChooseDateRange delegate

-(void)choosedFromTime:(NSString *)fromTime andEndTime:(NSString *)endTime{
    if (popController)
        [popController dismissPopoverAnimated:YES];
    
    self.fromDateStr = fromTime;
    self.endDateStr = endTime;
    
    [self requestData];
}

-(void)cancelSelectTimeRange{
    [popController dismissPopoverAnimated:YES];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    /*
    self.btnTitleView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnTitleView.frame = CGRectMake(0, 0, 400, 35);
    [self.btnTitleView addTarget:self action:@selector(selectPolutionSrc) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = btnTitleView;
     [self.btnTitleView setTitle:@"点击此处选择污染源" forState:UIControlStateNormal];
    */
    self.title = [NSString stringWithFormat:@"%@在线监测",wrymc];
    
    if (!bWarn)
    {
        self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc] initWithTitle:@"选择时间段" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDateRange:)] autorelease];
        ChooseTimeRangeVC *date = [[ChooseTimeRangeVC alloc] init];
        self.dateController = date;
        dateController.delegate = self;
        [date release];
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
        UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
        self.popController = popover;
        [popover release];
        [nav release];
    }
    
    
    self.dataTableView = [[[UITableView alloc] initWithFrame:CGRectMake(11, 503, 289, 421) style:UITableViewStyleGrouped] autorelease];
    self.dataTableView.dataSource = self;
    self.dataTableView.delegate = self;
    [self.view addSubview:dataTableView];
    
    self.resultWebView = [[[UIWebView alloc] initWithFrame:CGRectMake(305, 504, 452, 421)] autorelease];
    [self.view addSubview:resultWebView];
    
    self.graphView = [[[S7GraphView alloc] initWithFrame:CGRectMake(10, 5, 740, 500)] autorelease];
	self.graphView.dataSource = self;
	NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
	[numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
	[numberFormatter setMinimumFractionDigits:1];
	[numberFormatter setMaximumFractionDigits:1];
	
	self.graphView.yValuesFormatter = numberFormatter;
    
	[numberFormatter release];
	
	self.graphView.backgroundColor = [UIColor whiteColor];
	
	self.graphView.drawAxisX = YES;
	self.graphView.drawAxisY = YES;
	self.graphView.drawGridX = YES;
	self.graphView.drawGridY = YES;
	
	self.graphView.xValuesColor = [UIColor blackColor];
	self.graphView.yValuesColor = [UIColor blackColor];
	
	self.graphView.gridXColor = [UIColor blackColor];
	self.graphView.gridYColor = [UIColor blackColor];
	
	self.graphView.drawInfo = YES;
	self.graphView.infoColor = [UIColor blackColor];
    
    [self.view addSubview:graphView];
    
    self.html = [NSMutableString string];
    self.curParsedData = [NSMutableString stringWithCapacity:1000];
    self.valueAry = [NSMutableArray array];
    self.timeAry = [NSMutableArray array];
    
    if (!bWarn)
    {
        NSDate *nowDate = [NSDate date];
        NSDate *fromDate = [NSDate dateWithTimeInterval:-1*60*60*24 sinceDate:nowDate];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
        self.fromDateStr = [dateFormatter stringFromDate:fromDate];
        self.endDateStr = [dateFormatter stringFromDate:nowDate];
        [dateFormatter release];
    }
    
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    if (popController)
        [popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{   
    [self.navigationController setNavigationBarHidden:NO animated:NO];
	[super viewDidAppear:animated];
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
        self.graphView.frame = CGRectMake(9, 19, 1002, 369);
        self.dataTableView.frame = CGRectMake(10, 412, 323, 268);
        self.resultWebView.frame = CGRectMake(339, 409, 672, 273);
        self.imgView.image = [UIImage imageNamed:@"zxjc_landscape.jpg"];
    } else {
        self.graphView.frame = CGRectMake(11, 19, 746, 461);
        self.dataTableView.frame = CGRectMake(11, 503, 289, 421);
        self.resultWebView.frame = CGRectMake(305, 504, 452, 421);
        self.imgView.image = [UIImage imageNamed:@"zxjc_BG.jpg"];
    }  
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation ==UIInterfaceOrientationLandscapeRight) {
        self.graphView.frame = CGRectMake(9, 19, 1002, 369);
        self.dataTableView.frame = CGRectMake(10, 412, 323, 268);
        self.resultWebView.frame = CGRectMake(339, 409, 672, 273);
        self.imgView.image = [UIImage imageNamed:@"zxjc_landscape.jpg"];
        
        NSRange widthRang = [html rangeOfString:@"452px"];
        if (widthRang.location != NSNotFound)
        {
            [html replaceCharactersInRange:widthRang withString:@"672px"];
            widthRang = [html rangeOfString:@"452px"];
            [html replaceCharactersInRange:widthRang withString:@"672px"];
        }

    }
    else {
        self.graphView.frame = CGRectMake(11, 19, 746, 461);
        self.dataTableView.frame = CGRectMake(11, 503, 289, 421);
        self.resultWebView.frame = CGRectMake(305, 504, 452, 421);
        self.imgView.image = [UIImage imageNamed:@"zxjc_BG.jpg"];
        
        NSRange widthRang = [html rangeOfString:@"672px"];
        if (widthRang.location != NSNotFound)
        {
            [html replaceCharactersInRange:widthRang withString:@"452px"];
            widthRang = [html rangeOfString:@"672px"];
            [html replaceCharactersInRange:widthRang withString:@"452px"];
        }   
    }
    
    [self.resultWebView loadHTMLString:html baseURL:nil];
    [self.graphView reloadData];
    [self.dataTableView reloadData];
}

- (void)dealloc
{
    [graphView release];
    [dataTableView release];
    [resultWebView release];
    [super dealloc];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


#pragma mark - URL ConnHelper Delegate

-(void)processWebData:(NSData*)webData{
    /*
    NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",logstr);
    */
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}

-(void)processError:(NSError *)error{
    NSString *msg = @"请求数据失败，请检查网络。";
    
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:msg 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
}

#pragma mark - Xml parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    isGotJsonString = NO;
    [self.curParsedData setString:@""];
    [self.html setString:@""];
    if ([valueAry count] > 0)
        [self.valueAry removeAllObjects];
    if ([timeAry count] > 0)
        [self.timeAry removeAllObjects];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    NSString *tag = nil;
    if(nRequestDataType == kRequestPfData)
        tag =  @"OnlineMonitorDetailtoJsonResult";
    else
        tag = @"OnlineMonitorEquipmentListResult";
    
    if ([elementName isEqualToString:tag])
        isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

    if(nRequestDataType == kRequestPfData){
        if (isGotJsonString && [elementName isEqualToString:@"OnlineMonitorDetailtoJsonResult"]) 
        {
            if ([curParsedData length] > 0) {
                
                self.resultDataAry = [[curParsedData objectFromJSONString] objectForKey:@"Table1"];
                
                NSDictionary *infoDic = [[[curParsedData objectFromJSONString] objectForKey:@"Table2"] lastObject];
                self.graphView.yHighLimit = [[infoDic objectForKey:@"上限"] floatValue]; 
                self.graphView.yLowLimit = [[infoDic objectForKey:@"下限"] floatValue];
                
                if([itemName isEqualToString:@"电导"])
                    self.unit = @"μS/cm";
                else
                    self.unit = [[infoDic objectForKey:@"单位"] length] > 0 ? [infoDic objectForKey:@"单位"]:@"";
                
                self.graphView.info = unit;
                UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
                NSString *width = nil;
                if (UIDeviceOrientationIsLandscape(deviceOrientation))
                    width = @"672px";
                else
                    width = @"452px";
                
                [self.html appendFormat:@"<html><body topmargin=0 leftmargin=0><table width=\"%@\" bgcolor=\"#FFCC32\" border=1 bordercolor=\"#893f7e\" frame=below rules=none><tr><th><font color=\"Black\">%@监测详细信息</font></th></tr><table><table width=\"%@\" bgcolor=\"#893f7e\" border=0 cellpadding=\"1\"><tr bgcolor=\"#e6e7d5\" ><th>监测时间</th><th>监测数据</th></tr>",width,itemName,width];
                
                BOOL boolColor = true;
                for (NSDictionary *tmpDic in resultDataAry) {
                    [self.html appendFormat:@"<tr bgcolor=\"%@\">",boolColor ? @"#cfeeff" : @"#ffffff"];
                    boolColor = !boolColor;
                    [self.html appendFormat:@"<td align=center>%@</td><td align=center>%@</td>",[tmpDic objectForKey:@"监测时间"],[NSString stringWithFormat:@"%@%@",[tmpDic objectForKey:@"监测数据"],unit]];
                    [self.html appendString:@"</tr>"];
                }
            
                [self.html appendString:@"</table></body></html>"];
     
                for (int i = [resultDataAry count]-1 ; i>=0 ; i--) {
                    NSDictionary *tmpDic = [resultDataAry objectAtIndex:i];
                    
                    NSString *time = [tmpDic objectForKey:@"监测时间"];
                    NSString *count = [tmpDic objectForKey:@"监测数据"];

                    [valueAry addObject:count];
                    [timeAry addObject:time];
                }
                
            } else {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"所选设备没有收集到监测数据..." delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
            
            isGotJsonString = NO;
        }
        
    }
    else{
        
        if (isGotJsonString && [elementName isEqualToString:@"OnlineMonitorEquipmentListResult"]) 
        {
            // NSDictionary *tmpNameDic = [curParsedData JSONValue];
            NSArray *tmpDataAry = [curParsedData objectFromJSONString];
            //按照设备名称分组
            NSMutableDictionary *dicTmp = [[NSMutableDictionary alloc] initWithCapacity:5];
            for (NSDictionary * aDicZhiBiao in tmpDataAry) {
                NSString *sbmc = [aDicZhiBiao objectForKey:@"设备名称"];
                NSMutableArray *aryItem = [dicTmp objectForKey:sbmc];
                if (aryItem) {
                    [aryItem addObject:aDicZhiBiao];
                }
                else{
                    aryItem = [[NSMutableArray alloc] initWithCapacity:5];
                    [aryItem addObject:aDicZhiBiao];
                    [dicTmp setObject:aryItem forKey:sbmc];
                    [aryItem release];
                }
            }
            self.resultDataDic = dicTmp;
            [dicTmp release];
            isGotJsonString = NO;
        }
        
    }
    
    
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    if(nRequestDataType == kRequestPfData) {
        //添加统计图
        [self.graphView reloadData];
        [self addView:self.graphView type:@"rippleEffect" subType:kCATransitionFromTop];
        //添加webview
        
        [self.resultWebView loadHTMLString:html baseURL:nil];
        [self addView:self.resultWebView type:@"pageCurl" subType:kCATransitionFromRight];
    } 
    else
    {
     
        [self.dataTableView reloadData];

        NSArray *keys = [resultDataDic allKeys];
        if(keys == nil || [keys count] <= 0)return;
        NSArray *aryTmp = [resultDataDic objectForKey:[keys objectAtIndex:0]];
        if(aryTmp == nil || [aryTmp count] <= 0)return;
        NSDictionary *dicTmp = [aryTmp objectAtIndex:0];
        self.itemName = [dicTmp objectForKey:@"指标名称"];
        [dataTableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:nil];
        nRequestDataType = kRequestPfData;
        NSString *param = [WebServiceHelper createParametersWithKey:@"wrymc" value:wrymc, @"sbid",[dicTmp objectForKey:@"设备编号"],
                           @"sbname",[dicTmp objectForKey:@"指标名称"],@"xuhao",[dicTmp objectForKey:@"指标序号"], @"startTime",fromDateStr,@"endTime",endDateStr,nil];
        NSString *strUrl = [NSString stringWithFormat:OnLineControl_URL,g_appDelegate.xxcxServiceIP];
        WebServiceHelper *webservice =[[[WebServiceHelper alloc]initWithUrl:strUrl 
                                                                     method:@"OnlineMonitorDetailtoJson" 
                                                                  nameSpace:@"http://tempuri.org/" 
                                                                 parameters:param 
                                                                   delegate:self] autorelease];
        
        [webservice runAndShowWaitingView:self.view];
    }
}

#pragma mark - protocol S7GraphViewDataSource

- (NSUInteger)graphViewNumberOfPlots:(S7GraphView *)graphView {
	/* Return the number of plots you are going to have in the view. 1+ */
	if (valueAry == nil || 0 == [valueAry count]) {
		return 0;//还未取到数据
	}
	return 1;
}

- (NSArray *)graphViewXValues:(S7GraphView *)graphView {
	/* An array of objects that will be further formatted to be displayed on the X-axis.
	 The number of elements should be equal to the number of points you have for every plot. */
    
	
	int xCount = [timeAry count];
	NSMutableArray *array = [NSMutableArray arrayWithCapacity:xCount];
	for ( int i = 0 ; i < xCount ; i ++ ) {
		NSString *str =[timeAry objectAtIndex:i];
		[array addObject:[str substringFromIndex:5]];	
	}
	return array;
}

- (NSArray *)graphView:(S7GraphView *)graphView yValuesForPlot:(NSUInteger)plotIndex {
    
	NSMutableArray* ary = [[NSMutableArray alloc] initWithCapacity:10];
	for (NSString *value in valueAry) {
		[ary addObject:[NSNumber numberWithFloat:[value floatValue]]];
	}
	return [ary autorelease];
}

- (BOOL)graphViewIfSumValues:(S7GraphView *)graphView
{
    if (itemName && [itemName isEqualToString:@"污水流量"])
        return YES;
    else
        return NO;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return [resultDataDic count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSArray *keys = [resultDataDic allKeys];
    NSArray *aryTmp = [resultDataDic objectForKey:[keys objectAtIndex:section]];
    return [aryTmp count];

}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
        NSArray *keys = [resultDataDic allKeys];
    return [keys objectAtIndex:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"] autorelease];
    
    
    cell.textLabel.textAlignment = UITextAlignmentCenter;
    
    NSArray *keys = [resultDataDic allKeys];
    NSArray *aryTmp = [resultDataDic objectForKey:[keys objectAtIndex:indexPath.section]];
    NSDictionary *dicTmp = [aryTmp objectAtIndex:indexPath.row];
    cell.textLabel.text =[dicTmp objectForKey:@"指标名称"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    nRequestDataType = kRequestPfData;
    
    NSArray *keys = [resultDataDic allKeys];
    NSArray *aryTmp = [resultDataDic objectForKey:[keys objectAtIndex:indexPath.section]];
    NSDictionary *dicTmp = [aryTmp objectAtIndex:indexPath.row];

    self.itemName = [dicTmp objectForKey:@"指标名称"];
    NSString *param = [WebServiceHelper createParametersWithKey:@"wrymc" value:wrymc, @"sbid",[dicTmp objectForKey:@"设备编号"],
                       @"sbname",[dicTmp objectForKey:@"指标名称"],@"xuhao",[dicTmp objectForKey:@"指标序号"], @"startTime",fromDateStr,@"endTime",endDateStr,nil];
    NSString *strUrl = [NSString stringWithFormat:OnLineControl_URL,g_appDelegate.xxcxServiceIP];
    if (webHelper) {
        [webHelper cancel];
        
    }
        
    self.webHelper =[[[WebServiceHelper alloc]initWithUrl:strUrl
                                                       method:@"OnlineMonitorDetailtoJson"
                                                    nameSpace:@"http://tempuri.org/"
                                                   parameters:param
                                                     delegate:self] autorelease];
    
    
    
    [webHelper runAndShowWaitingView:self.view];
}
@end