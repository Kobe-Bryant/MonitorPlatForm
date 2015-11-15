//
//  MonitorWarnItemController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-14.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "MonitorWarnItemController.h"
#import "TDBadgedCell.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"
#import "UITableViewCell+Custom.h"
#import "WryOnlineMonitorConroller.h"

extern MPAppDelegate *g_appDelegate;

@implementation MonitorWarnItemController

@synthesize dataTableView,resultDataAry,curParsedData,isGotJsonString;
@synthesize endDateStr,fromDateStr,wrybh,webHelper,wrymc;
@synthesize dateController,popController,bChooseDate;

-(void)chooseDateRange:(id)sender{
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController dismissPopoverAnimated:YES];
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

-(id)initWithWryBh:(NSString*)bh wryMc:(NSString*)mc fromDateStr:(NSString*)fromDate
     andEndDateStr:(NSString*)endDate
{
    self = [super initWithNibName:@"MonitorWarnItemController" bundle:nil];
    if (self) {
        // Custom initialization
        self.fromDateStr = fromDate;
        self.endDateStr = endDate;
        self.wrybh = bh;
        self.wrymc = mc;
    }
    return self;
}

-(void)dealloc
{
    [dataTableView release];
    [resultDataAry release];
    [curParsedData release];
    [endDateStr release];
    [fromDateStr release];
    [wrybh release];
    [webHelper release];
    [super dealloc];
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
    self.title = wrymc;
    if (bChooseDate)
    {
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
    if(popController)
    {
        [popController dismissPopoverAnimated:YES];
    }
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


-(void)requestData{
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wrybh, @"pStartTime",fromDateStr,
                       @"pEndTime",endDateStr,nil];
    NSString *strUrl = [NSString stringWithFormat:OnLineControl_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper =[[[WebServiceHelper alloc]initWithUrl:strUrl 
                                                                method:@"OnlineMonitorWarnItem" 
                                                               nameSpace:@"http://tempuri.org/" 
                                                              parameters:param 
                                                                delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
    //NSLog(@"%@ %@?op=OnlineMonitorWarnItem", param, strUrl);
}

#pragma mark - URL ConnHelper Delegate

-(void)processWebData:(NSData*)webData{
    /*
     NSString *logstr = [[NSString alloc] initWithBytes:[webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
     NSLog(@"%@",logstr);*/
    
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

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.dataTableView reloadData];
}


#pragma mark - Xml parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"OnlineMonitorWarnItemResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"OnlineMonitorWarnItemResult"]) 
    {
        // NSDictionary *tmpNameDic = [curParsedData JSONValue];
        self.resultDataAry = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
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

    return [resultDataAry count];

}
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
   
    NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];

    NSString *cbrq = [dicTmp objectForKey:@"超标时刻"];
    if ([cbrq length]>10)
        cbrq = [cbrq substringToIndex:10];
    cbrq = [NSString stringWithFormat:@"超标日期：%@",cbrq];
    
    NSString *cbsb = [NSString stringWithFormat:@"超标设备：%@",[dicTmp objectForKey:@"超标设备"]];
    NSString *cbxm = [NSString stringWithFormat:@"超标项目：%@",[dicTmp objectForKey:@"超标项目"]];
    
    cell = [UITableViewCell makeSubCell:tableView withTitle:cbrq andSubvalue1:cbsb andSubvalue2:cbxm andSubvalue3:@"" andSubvalue4:@"" andNoteCount:indexPath.row];
    
    return cell;    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
    NSString *cbrq = [dicTmp objectForKey:@"超标时刻"];
    if ([cbrq length]>10)
        cbrq = [cbrq substringToIndex:10];
    
    WryOnlineMonitorConroller *childView = [[WryOnlineMonitorConroller alloc] initWithNibName:@"WryOnlineMonitorConroller" bundle:nil];
    childView.wrybh = wrybh;
    childView.wrymc = wrymc;
    childView.fromDateStr = [NSString stringWithFormat:@"%@ 00:00",cbrq];
    childView.endDateStr = [NSString stringWithFormat:@"%@ 23:59",cbrq];
    childView.bWarn = YES;
    [self.navigationController pushViewController:childView animated:YES];
    [childView release];
}

#pragma mark - Choose date range delegate

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate{
    if (self.popController != nil)
        [popController dismissPopoverAnimated:YES];
    
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    [self requestData];
}

-(void)cancelSelectDateRange{
    [popController dismissPopoverAnimated:YES];
}

@end
