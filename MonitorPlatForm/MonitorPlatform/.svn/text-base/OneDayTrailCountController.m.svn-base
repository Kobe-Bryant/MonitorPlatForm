//
//  OneDayTrailCountController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-9.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "OneDayTrailCountController.h"
#import "WebServiceHelper.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;
@implementation OneDayTrailCountController
@synthesize resultTableView,curParsedData,isGotJsonString,resultDataAry;
@synthesize popController,dateController,selDateStr,webHelper;

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

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date{ 
	[popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		[dateFormatter release];  
		self.selDateStr = dateString;
        [self requestDataWithDate];
	}
}


-(void)chooseDate:(id)sender{
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateController.myPicker.date = [dateFormatter dateFromString:selDateStr];
	[popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc] initWithTitle:@"选择日期" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDate:)] autorelease];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormatter stringFromDate:[NSDate date]];
    [dateFormatter release];  
    self.selDateStr = dateString;
    
    PopupDateViewController *date = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = date;
	dateController.delegate = self;
	[date release];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
	[popover release];
	[nav release];
    
    [self requestDataWithDate];
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
    [popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}


-(void)requestDataWithDate{

    NSString *param = [WebServiceHelper createParametersWithKey:@"pDate" value:selDateStr,
                       @"orgid",@"",nil];
    NSString *strUrl = [NSString stringWithFormat:MapNavigation_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl 
                                                                  method:@"OneDayTrailCount" 
                                                               nameSpace:@"http://tempuri.org/" 
                                                              parameters:param 
                                                                delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
    
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

#pragma mark - Xml parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    self.isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"OneDayTrailCountResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"OneDayTrailCountResult"]) 
    {
 
        self.resultDataAry = [curParsedData objectFromJSONString];
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    [self.resultTableView reloadData];
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


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    NSArray *aryTmp = [NSArray arrayWithObjects:@"部门名称",
                       @"人员",@"轨迹数",
                       nil];
    
    UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 45)];
    
    int width = 740.0/3;
    CGRect tRect = CGRectMake(14, 5, width, 33);
    
    for (int i =0; i < 3; i++) {
        UILabel *label =[[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
        [label setBackgroundColor:[UIColor clearColor]];
        [label setTextColor:[UIColor blackColor]];
        label.font = [UIFont fontWithName:@"Helvetica" size:18.0];
        label.textAlignment = UITextAlignmentCenter;
        tRect.origin.x += width;
        [label setText:[aryTmp objectAtIndex:i]];
        [view addSubview:label];
        [label release];
    }
    view.backgroundColor = CELL_HEADER_COLOR;
    return [view autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSString *identifierStr = @"rygjCell";
    NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
    NSArray *aryTmp = [NSArray arrayWithObjects:[dicTmp objectForKey:@"部门"],
                       [dicTmp objectForKey:@"人员"],
                       [dicTmp objectForKey:@"轨迹数"],
                       nil];
    cell = [UITableViewCell makeMultiLabelsCell:tableView
                                      withTexts:aryTmp andHeight:40 andWidth:768 andIdentifier:identifierStr];
    return cell;
}

@end
