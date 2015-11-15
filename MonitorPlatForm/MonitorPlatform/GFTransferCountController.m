//
//  GFTransferCountController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-16.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "GFTransferCountController.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"
#import "UITableViewCell+Custom.h"
#import "WebServiceHelper.h"
#import "NumberUtil.h"
#import "GFTypeStatisticController.h"
#import "NSDateUtil.h"

extern MPAppDelegate *g_appDelegate;

@implementation GFTransferCountController
@synthesize dataTableView,popController,dateController;
@synthesize fromDateStr,endDateStr,isGotJsonString,widthAry;
@synthesize curParsedData,resultDataAry,bLoaded,webHelper;


#pragma mark - Private methods

-(void)requestData
{
    NSString *param = [WebServiceHelper createParametersWithKey:@"fwlbbh" value:@"",@"jszdwbh",@"",@"kssj",fromDateStr,@"jssj",endDateStr,nil];
    NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl 
                                                    method:@"GetJszFwzlTjEx" 
                                                 nameSpace:@"http://tempuri.org/" 
                                                parameters:param 
                                                  delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
}

-(void)chooseDateRange:(id)sender{

    [popController dismissPopoverAnimated:YES];
    
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.bLoaded = NO;
        self.widthAry = [NSArray arrayWithObjects:@"0.54",@"0.1", @"0.18",@"0.18",nil];
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
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
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
    
    NSDate *nowDate = [NSDate date];
    //NSDate *fromDate = [NSDate dateWithTimeInterval:-90*60*60*24 sinceDate:nowDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.endDateStr = [dateFormatter stringFromDate:nowDate];
    self.fromDateStr = [NSDateUtil firstDateThisMonth];
    [dateFormatter release];
    self.title = [NSString stringWithFormat:@"按经营单位统计(%@ ~ %@)",fromDateStr,endDateStr];
    [self requestData];
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
    [popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.dataTableView reloadData];
}

#pragma mark - Choose Date Range Delegate

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate{
    [popController dismissPopoverAnimated:YES];
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    self.title = [NSString stringWithFormat:@"危废转移量统计(%@ - %@)",fromDateStr,endDateStr];
    [self requestData];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
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
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"GetJszFwzlTjExResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"GetJszFwzlTjExResult"]) 
    {
        // NSDictionary *tmpNameDic = [curParsedData JSONValue];
        self.resultDataAry = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    bLoaded = YES;
    if ([resultDataAry count] != 0)
    {
        CGFloat totalCount = 0;
        NSMutableArray *tmpArray = [NSMutableArray arrayWithCapacity:20];
        CGFloat wfTotalCount = 0.0;
        for (NSDictionary *tmpDic in resultDataAry)
        {
            NSString *sl = [tmpDic objectForKey:@"JSZQRSL"];
            float slCount = [sl floatValue];
            totalCount += slCount;
            NSString *wfsl = [tmpDic objectForKey:@"JSZQRSL1"];
            float wfslCount = [wfsl floatValue];
            wfTotalCount += wfslCount;
        }
    
        for (NSDictionary *aDic in resultDataAry)
        {
            NSString *sl = [aDic objectForKey:@"JSZQRSL"];
            float slCount = [sl floatValue];
        
            NSMutableDictionary *mulDic = [NSMutableDictionary dictionaryWithDictionary:aDic];
            NSString *percent = [NSString stringWithFormat:@"%.2f%%",slCount/totalCount*100];
            [mulDic setObject:percent forKey:@"PERCENT"];
        
            [tmpArray addObject:mulDic];
        }
    
        NSMutableDictionary *tmpDic = [NSMutableDictionary dictionaryWithCapacity:3];
        [tmpDic setObject:[NSString stringWithFormat:@"%.2f",totalCount] forKey:@"JSZQRSL"];
        [tmpDic setObject:[NSString stringWithFormat:@"%.2f",wfTotalCount] forKey:@"JSZQRSL1"];
        [tmpDic setObject:@"汇总" forKey:@"JSZDWMC"];
        [tmpDic setObject:@" " forKey:@"PERCENT"];
    
        [tmpArray addObject:tmpDic];
        self.resultDataAry = tmpArray;
    }
    [self.dataTableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if ([resultDataAry count] > 0)
        return [resultDataAry count];
    else
        return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *aryTmp = [NSArray arrayWithObjects:
                       @" 序号  经营单位",@"占总量百分比",@"转移总量",@"危废转移量  ",
                       nil];
    
    
    UIView *view;
    CGFloat cellWidth = 758.0;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 45)];
    
    CGFloat width[5] = {cellWidth*0.55,cellWidth*0.1,cellWidth*0.17,cellWidth*0.18};
    CGRect tRect = CGRectMake(0, 0, width[0], 45.0);
    
    for (int i =0; i < [aryTmp count]; i++) {
        tRect.size.width = width[i];
        UILabel *label =[[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
        label.backgroundColor = [UIColor clearColor];
        label.numberOfLines = 0;
        [label setTextColor:[UIColor whiteColor]];
        label.font = [UIFont systemFontOfSize:18];
        if (i == 0)
            label.textAlignment = UITextAlignmentLeft;
        else
            label.textAlignment = UITextAlignmentCenter;
        tRect.origin.x += width[i];
        
        [label setText:[aryTmp objectAtIndex:i]];
        [view addSubview:label];
        [label release];
    }
    view.backgroundColor =  CELL_HEADER_COLOR;
    return [view autorelease];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 55;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (!bLoaded) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"unload_cell"] autorelease];
        
        cell.textLabel.text = @"";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if ([resultDataAry count] == 0) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"] autorelease];
        
        cell.textLabel.text = @"没有相关数据";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    else{
        
        NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
        NSString *xh = [NSString stringWithFormat:@"%d",indexPath.row+1];
        NSString *num = [dicTmp objectForKey:@"JSZQRSL"];
        num = [NSString stringWithFormat:@"%@ 吨",num];
        NSString *wfnum = [dicTmp objectForKey:@"JSZQRSL1"];
        wfnum = [NSString stringWithFormat:@"%@ 吨",wfnum];
        if (indexPath.row == [resultDataAry count]-1)
            xh = @" ";
       
            
         NSString *mc = [NSString stringWithFormat:@"  %@  %@",xh,[dicTmp objectForKey:@"JSZDWMC"]];
        
        NSArray *valueArr = [NSArray arrayWithObjects:mc,[dicTmp objectForKey:@"PERCENT"],num,wfnum, nil];
        
       // UITableViewCell *cell = [UITableViewCell makeTDCellForTableView:tableView valueArray:valueArr statisticNum:num cellHeight:55 andWidths:widthAry];
        
        
        UITableViewCell *cell = [UITableViewCell makeMultiLabelsCell:tableView withTexts:valueArr andWidths:widthAry andHeight:55 andIdentifier:@"GFTransferIdentity" firstAlign:NSTextAlignmentLeft];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        
        return cell;
    }
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([resultDataAry count] == 0 || [indexPath row] == [resultDataAry count] - 1)
        return;
    
    NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
    GFTypeStatisticController *childVC = [[GFTypeStatisticController alloc] initWithNibName:@"GFTypeStatisticController" bundle:nil];
    childVC.nEntrance = 3;
    childVC.dwmc = [dicTmp objectForKey:@"JSZDWMC"];
    childVC.jszbh = [dicTmp objectForKey:@"JSZDWBH"];
    childVC.fromDateStr = self.fromDateStr;
    childVC.endDateStr = self.endDateStr;
    
    [self.navigationController pushViewController:childVC animated:YES];
    [childVC release];
}


@end
