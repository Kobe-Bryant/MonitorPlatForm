//
//  MonitorWarnCountController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-14.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "MonitorWarnCountController.h"
#import "TDBadgedCell.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"
#import "UITableViewCell+Custom.h"
#import "MonitorWarnItemController.h"
#import "NumberUtil.h"
#import "PollutionSelectVC.h"

extern MPAppDelegate *g_appDelegate;

@implementation MonitorWarnCountController

@synthesize dataTableView,resultDataAry,curParsedData,isGotJsonString;
@synthesize dateController,popController,endDateStr,fromDateStr;
@synthesize webHelper,isLoading;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        isLoading = NO;
    }
    return self;
}

-(void)dealloc{
    [dataTableView release];
    [resultDataAry release];
    [curParsedData release];
    //[dateController release];
    //[popController release];
    [endDateStr release];
    [fromDateStr release];
    [webHelper release];
    [super dealloc];
}
    
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate
{
    [popController dismissPopoverAnimated:YES];
    
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    self.title = [NSString stringWithFormat:@"超标次数(%@ - %@)",fromDateStr,endDateStr];
    [self requestData];
}

- (void)queryPollution:(id)sender
{
    PollutionSelectVC *childView = [[[PollutionSelectVC alloc] initWithNibName:@"PollutionSelectVC" bundle:nil] autorelease];
    childView.status = 3;
    [self.navigationController pushViewController:childView animated:YES];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
}

-(void)chooseDateRange:(id)sender{

    [popController dismissPopoverAnimated:YES];
    
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    
	//[popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //导航栏按钮
    UIToolbar *toolBar = [[[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 200, 44)] autorelease];
    UIBarButtonItem *flexItem = [[[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil] autorelease];
    
    
    UIBarButtonItem *item2 = [[[UIBarButtonItem alloc] initWithTitle:@"选择时间段" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDateRange:)] autorelease];
    
    UIBarButtonItem *item3 = [[[UIBarButtonItem alloc] initWithTitle:@"查询污染源" style:UIBarButtonItemStyleBordered  target:self action:@selector(queryPollution:)] autorelease];
    
    toolBar.items = [NSArray arrayWithObjects:item3,flexItem,item2,nil];
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithCustomView:toolBar] autorelease];
    /*
    UIBarButtonItem *fixed = [[UIBarButtonItem  alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    fixed.width = 20;
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithTitle:@"选择时间段" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDateRange:)];
    UIBarButtonItem *item3 = [[UIBarButtonItem alloc] initWithTitle:@"查询污染源" style:UIBarButtonItemStyleBordered  target:self action:@selector(queryPollution:)];
    NSArray *rightButtons = [NSArray arrayWithObjects:item2, fixed, item3, nil];
    self.navigationItem.rightBarButtonItems = rightButtons;
    [fixed release];
    [item3 release];
    [item2 release];*/
    
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
    NSDate *fromDate = [NSDate dateWithTimeInterval:-90*60*60*24 sinceDate:nowDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.fromDateStr = [dateFormatter stringFromDate:fromDate];
    self.endDateStr = [dateFormatter stringFromDate:nowDate];
    [dateFormatter release];
    self.title = [NSString stringWithFormat:@"超标次数(%@ - %@)",fromDateStr,endDateStr];
    [self requestData];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillDisappear:(BOOL)animated
{
    if (webHelper)
    {
        [webHelper cancel];
    }
    if(popController)
    {
        [popController dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.dataTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)requestData
{
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"pStartTime" value:fromDateStr,
                       @"pEndTime",endDateStr,nil];
    NSString *strUrl = [NSString stringWithFormat:OnLineControl_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl 
                                                                  method:@"OnlineMonitorWarnCount" 
                                                               nameSpace:@"http://tempuri.org/" 
                                                              parameters:param 
                                                                delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
    //NSLog(@"%@?op=%@ %@", strUrl, @"OnlineMonitorWarnCount", param);
    
}

#pragma mark - URL ConnHelper Delegate

-(void)processWebData:(NSData*)webData
{
    /*
     NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
     NSLog(@"%@",logstr);*/
    
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData: webData ] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}

-(void)processError:(NSError *)error
{
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
    if ([elementName isEqualToString:@"OnlineMonitorWarnCountResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"OnlineMonitorWarnCountResult"]) 
    {
        // NSDictionary *tmpNameDic = [curParsedData JSONValue];
        self.resultDataAry = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    isLoading = YES;
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

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSArray *aryTmp = [NSArray arrayWithObjects:@"序号",@"单位名称",@"监管属性",@"次数",nil];
    
    UIView *view;
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 45)];
    
    CGFloat width[4] = {80.0,388.0,200,100.0};
    CGRect tRect = CGRectMake(14, 5, width[0], 33);
    
    for (int i =0; i < 4; i++) {
        tRect.size.width = width[i];
        UILabel *label =[[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor blackColor]];
        label.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        if(i == 0 || i == 1)
            label.textAlignment = UITextAlignmentLeft;
        else
            label.textAlignment = UITextAlignmentCenter;
        tRect.origin.x += width[i];
        
        [label setText:[aryTmp objectAtIndex:i]];
        [view addSubview:label];
        [label release];
    }
    view.backgroundColor = CELL_HEADER_COLOR;
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    
    if (!isLoading) {
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
        return cell;
    }
    else{
        
        NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
        NSString *xh = [NSString stringWithFormat:@"%d",indexPath.row+1];
        NSString *num = [dicTmp objectForKey:@"超标次数"];
        NSArray *valueArr = [NSArray arrayWithObjects:xh,[dicTmp objectForKey:@"企业名称"],[dicTmp objectForKey:@"监管属性"], nil];

        CGRect tRect1;
        CGRect tRect2;
        CGRect tRect3;
        NSString *cellIdentifier;
        
        cellIdentifier = @"cell_portraitTD";
        tRect1 = CGRectMake(14, 5, 40, 33);
        tRect2 = CGRectMake(64, 5, 428, 33);
        tRect3 = CGRectMake(492, 5, 200, 33);
        
        TDBadgedCell *aCell = [[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier] autorelease];
        
        UILabel *tLabel1 = nil;
        UILabel *tLabel2 = nil;
        UILabel *tLabel3 = nil;
        
        if (aCell.contentView != nil)
        {
            tLabel1 = (UILabel *)[aCell.contentView viewWithTag:1];
            tLabel2 = (UILabel *)[aCell.contentView viewWithTag:2];
            tLabel3 = (UILabel *)[aCell.contentView viewWithTag:3];
        }
        
        if (tLabel1 == nil) {
            tLabel1 = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
            [tLabel1 setBackgroundColor:[UIColor clearColor]];
            [tLabel1 setTextColor:[UIColor blackColor]];
            tLabel1.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            tLabel1.textAlignment = UITextAlignmentLeft;
            tLabel1.numberOfLines = 2;
            tLabel1.tag = 1;
            [aCell.contentView addSubview:tLabel1];
            [tLabel1 release];
            
            tLabel2 = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
            [tLabel2 setBackgroundColor:[UIColor clearColor]];
            [tLabel2 setTextColor:[UIColor blackColor]];
            tLabel2.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            tLabel2.textAlignment = UITextAlignmentLeft;
            tLabel2.numberOfLines = 2;
            tLabel2.tag = 2;
            [aCell.contentView addSubview:tLabel2];
            [tLabel2 release];
            
            tLabel3 = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
            [tLabel3 setBackgroundColor:[UIColor clearColor]];
            [tLabel3 setTextColor:[UIColor blackColor]];
            tLabel3.font = [UIFont fontWithName:@"Helvetica" size:18.0];
            tLabel3.textAlignment = UITextAlignmentCenter;
            tLabel3.numberOfLines = 2;
            tLabel3.tag = 3;
            [aCell.contentView addSubview:tLabel3];
            [tLabel3 release];
        }
        
        if (tLabel1 != nil) [tLabel1 setText:[valueArr objectAtIndex:0]];
        if (tLabel2 != nil) [tLabel2 setText:[valueArr objectAtIndex:1]];
        if (tLabel3 != nil) [tLabel3 setText:[valueArr objectAtIndex:2]];
        
        aCell.badgeString = num;
        
        aCell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
        aCell.showShadow = YES;
        aCell.badge.radius = 9;
        
        aCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        return aCell;
        
    }

}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
    MonitorWarnItemController *itemController = [[MonitorWarnItemController alloc] initWithWryBh:[dicTmp objectForKey:@"企业编号"] wryMc:[dicTmp objectForKey:@"企业名称"] fromDateStr:fromDateStr andEndDateStr:endDateStr];
    itemController.bChooseDate = NO;
    [self.navigationController pushViewController:itemController animated:YES];
    [itemController release];
}

@end