//
//  WcltjController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-16.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "WcltjController.h"
#import "WebServiceHelper.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;
@implementation WcltjController
@synthesize dataTableView,resultDataAry,curParsedData,isGotJsonString;
@synthesize dateController,popController,endDateStr,fromDateStr,scrollImage;
@synthesize webHelper,isEnd,isScroll,isLoading,currentPage,wasteType;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc{
    [dataTableView release];
    [resultDataAry release];
    [curParsedData release];
    [dateController release];
    //[popController release];
    //[endDateStr release];
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

-(void)getFromDate:(NSDate*)fromDate andEndDate:(NSDate*)endDate andWaste:(NSString *)category{
    [popController dismissPopoverAnimated:YES];
	NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.fromDateStr = [dateFormatter stringFromDate:fromDate];
    self.endDateStr = [dateFormatter stringFromDate:endDate];
    self.wasteType = category;
    [dateFormatter release];  
    self.title = [NSString stringWithFormat:@"误差量统计(%@ - %@)",fromDateStr,endDateStr];
    
    currentPage = 1;
    isScroll = NO;
    isEnd = NO;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    [self requestDataWithStartTime:fromDateStr endTime:endDateStr pageCount:currentPage waste:category];
}

-(void)cancelInputCondition{
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
    
    self.navigationItem.rightBarButtonItem =[[[UIBarButtonItem alloc] initWithTitle:@"选择时间段" style:UIBarButtonItemStyleBordered  target:self action:@selector(chooseDateRange:)] autorelease];
    
    NSDate *nowDate = [NSDate date];
    NSDate *fromDate = [NSDate dateWithTimeInterval:-1*60*60*24 sinceDate:nowDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.fromDateStr = [dateFormatter stringFromDate:fromDate];
    self.endDateStr = [dateFormatter stringFromDate:nowDate];
    [dateFormatter release];
    self.title = [NSString stringWithFormat:@"误差量统计(%@ - %@)",fromDateStr,endDateStr];
    
    self.resultDataAry = [NSMutableArray array];
    
    currentPage = 1;
    isEnd = NO;
    isScroll = NO;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    self.wasteType = @"";
    [self requestDataWithStartTime:fromDateStr endTime:endDateStr pageCount:currentPage waste:wasteType];
    
    WcltjConditionController *date = [[WcltjConditionController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = date;
	dateController.delegate = self;
	[date release];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
	[popover release];
	[nav release];
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

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.dataTableView reloadData];
}

-(void)requestDataWithStartTime:(NSString *)startT endTime:(NSString *)endT pageCount:(int)page waste:(NSString *)wasteCategory
{
    self.scrollImage.hidden = YES;
    isLoading = YES;
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"StartTime" value:fromDateStr,@"EndTime",endDateStr,@"wrymc",@"",@"page",[NSString stringWithFormat:@"%d",page],@"pagenum",@"50",@"WasteCategory",wasteCategory,nil];
    NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc]initWithUrl:strUrl 
                                                    method:@"GetWcltj" 
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
    if ([elementName isEqualToString:@"GetWcltjResult"])
        self.isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString)
        [self.curParsedData appendString:string];
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"GetWcltjResult"]) 
    {
        NSArray *webResultAry = [curParsedData objectFromJSONString];
        
        if (!isScroll)
            [self.resultDataAry removeAllObjects];
        
        [self.resultDataAry addObjectsFromArray:webResultAry];
        
        if ([webResultAry count] == 50)
            self.scrollImage.hidden = NO;
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{
    isLoading = NO;
    
    if ([curParsedData length] > 0)
    {
        [self.dataTableView reloadData];
        
    }
    else
    {
        isEnd = YES;
        [self.scrollImage setImage:[UIImage imageNamed:@"finishScroll.png"]];
        NSString *msg = nil;
        if (isScroll) {
            msg = @"已经滚动至底部";
        }
        else
            msg = @"输入时间段内没有相应数据";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
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
     NSArray *aryTmp = [NSArray arrayWithObjects:@"产废单位",@"废物名称",
                        @"确认数量",@"联单转移量",@"误差量",
                        nil];
     
     
     CGFloat headerWidth = 768.;
     CGFloat width[5]  = {200.,200.,120.,100.,100.};
     

     CGRect tRect = CGRectMake(4, 5, width[0], 33);
     UIView *view= [[UIView alloc] initWithFrame:CGRectMake(0, 0, headerWidth, 45)];
     
     for (int i =0; i < 5; i++) {
         tRect.size.width = width[i];
         UILabel *label =[[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
         [label setBackgroundColor:[UIColor clearColor]];
         [label setTextColor:[UIColor blackColor]];
         label.font = [UIFont fontWithName:@"Helvetica" size:15.0];
         label.textAlignment = UITextAlignmentCenter;
         tRect.origin.x += (width[i]+10);
         [label setText:[aryTmp objectAtIndex:i]];
         [view addSubview:label];
         [label release];
     }
     view.backgroundColor = CELL_HEADER_COLOR;
     return view;
 }
 
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else
        cell.backgroundColor = [UIColor whiteColor];
}


-(UITableViewCell*)makeCustomCellWithTexts:(NSArray *)valueAry
                             andHeight:(CGFloat)height
{
    int labelCount = [valueAry count];
    if (labelCount <= 0 || labelCount > 10) {
        return nil;
    }
    UILabel *lblTitle[10];
	UITableViewCell *aCell = nil;
    aCell = [dataTableView dequeueReusableCellWithIdentifier:@"cellcustom_portrait"];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellcustom_portrait"] autorelease];
    }
	
	if (aCell.contentView != nil)
	{
        for (int i =0; i < labelCount; i++)
            lblTitle[i] = (UILabel *)[aCell.contentView viewWithTag:i+1];
	}
	
	if (lblTitle[0] == nil) {
        int width[5] = {200,200,120,100,100};

        CGRect tRect = CGRectMake(4, 5, width[0], height);
        
        for (int i =0; i < labelCount; i++) {
            tRect.size.width = width[i];
            lblTitle[i] = [[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
            [lblTitle[i] setBackgroundColor:[UIColor clearColor]];
            
            lblTitle[i].font = [UIFont fontWithName:@"Helvetica" size:15.0];
            lblTitle[i].textAlignment = UITextAlignmentCenter;
            lblTitle[i].numberOfLines =2;
            if (i == 4) {
                [lblTitle[i] setTextColor:[UIColor redColor]];
            }
            else{
                [lblTitle[i] setTextColor:[UIColor blackColor]];
            }
            lblTitle[i].tag = i+1;
            [aCell.contentView addSubview:lblTitle[i]];
            [lblTitle[i] release];
            tRect.origin.x += (width[i]+10);
            
        }
        
	}
    
    for (int i =0; i < labelCount; i++){
        [lblTitle[i] setText:@""];
        
    }
    for (int i =0; i < labelCount; i++){
        [lblTitle[i] setText:[valueAry objectAtIndex:i]];
        
    }
    
    aCell.accessoryType = UITableViewCellAccessoryNone;
	return aCell;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ([resultDataAry count] == 0) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"defaultcell"] autorelease];
        
        cell.textLabel.text = @"没有相关数据";
		cell.textLabel.textAlignment = UITextAlignmentCenter;
        return cell;
    }
    
    NSDictionary *dicTmp = [resultDataAry objectAtIndex:indexPath.row];
    
    NSArray *aryTmp = [NSArray arrayWithObjects:[dicTmp objectForKey:@"产废单位"],
                       [dicTmp objectForKey:@"FWMC"],
                       [dicTmp objectForKey:@"确认数量"],
                       [dicTmp objectForKey:@"联单转移量"],
                       [dicTmp objectForKey:@"误差量"],
                       
                       nil];
    cell = [self makeCustomCellWithTexts:aryTmp andHeight:50];
    return cell;
        
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
		
        currentPage++;
        
        if (!isEnd) {
            
            isScroll = YES;
            
            [self requestDataWithStartTime:fromDateStr endTime:endDateStr pageCount:currentPage waste:wasteType];
        }
		
    }
}

@end