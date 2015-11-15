//
//  ProjectApprovedVC.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-8-28.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ProjectApprovedVC.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "XmspDetailsController.h"

extern MPAppDelegate *g_appDelegate;

@implementation ProjectApprovedVC
@synthesize isGotJsonString,isLoading,currentPage,isScroll,isEnd;
@synthesize curParsedData,webHelper,webResultAry,infoAry;
@synthesize currentTag,popController,dateController;

#pragma mark - Private methods

- (void)getWebDataWithProjectName:(NSString *)name approver:(NSString *)person startDate:(NSString *)s_date endDate:(NSString *)e_date pageCount:(int)page
{
    scrollImage.hidden = YES;
    isLoading = YES;
    NSString *param = [WebServiceHelper createParametersWithKey:@"WRYBH" value:@"",@"XMMC",name,@"CXKSSJ",s_date,@"CXJSSJ",e_date,@"SPR",person,@"SFTGSP",@"",@"pagenum",@"50",@"page",[NSString stringWithFormat:@"%d",page],nil];
    NSString *URL = [NSString stringWithFormat:WRYJBXX_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL 
                                                     method:@"NewGetXmsp" 
                                                  nameSpace:@"http://tempuri.org/" 
                                                 parameters:param 
                                                   delegate:self] autorelease];
    [webHelper runAndShowWaitingView:self.view];
}

- (IBAction)searchBtnPressed:(id)sender
{
    [projectName resignFirstResponder];
    [approver resignFirstResponder];
    
    NSString *xmmc = nil;
    NSString *spr = nil;
    NSString *cxkssj = nil;
    NSString *cxjssj = nil;
    
    if ([projectName.text length] == 0)
        xmmc = @"";
    else
        xmmc = projectName.text;
    
    if ([approver.text length] == 0)
        spr = @"";
    else
        spr = approver.text;
    
    if ([startDate.text length] == 0)
        cxkssj = @"";
    else
        cxkssj = startDate.text;
    
    if ([endDate.text length] == 0)
        cxjssj = @"";
    else
        cxjssj = endDate.text;
    
    currentPage = 1;
    isEnd = NO;
    isScroll = NO;
    
    [self getWebDataWithProjectName:xmmc approver:spr startDate:cxkssj endDate:cxjssj pageCount:currentPage];
}

- (void)chooseDate:(id)sender
{
    UITextField *tfd =(UITextField*)sender;
    currentTag = tfd.tag;
    
    
    if (currentTag == 1)
    {
        startDate.text = @"";
    }
    
    if (currentTag == 2)
    {
        endDate.text = @"";
    }
    
	[self.popController presentPopoverFromRect:[tfd bounds] inView:tfd permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

- (void)dealloc
{
    [curParsedData release];
    [webHelper release];
    [webResultAry release];
    [infoAry release];
    [popController release];
    [dateController release];
    [super dealloc];
}

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
    self.title = @"建设项目审批查询";
    
    //日期选择弹窗初始化
    PopupDateViewController *date = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = date;
	self.dateController.delegate = self;
	[date release];	
	UINavigationController *navDate = [[UINavigationController alloc] initWithRootViewController:dateController];	
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:navDate];
	self.popController = popover;
	//popController.delegate = self; 
	[popover release];
	[navDate release];
    [startDate addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchDown];
    [endDate addTarget:self action:@selector(chooseDate:) forControlEvents:UIControlEventTouchDown];
    
    self.infoAry = [NSMutableArray array];
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *defaultEndTime = [dateFormatter stringFromDate:[NSDate date]];
    NSArray *dateAry = [defaultEndTime componentsSeparatedByString:@"-"];
    NSString *defaultStartTime = [NSString stringWithFormat:@"%@-01-01",[dateAry objectAtIndex:0]];
    
    startDate.text = defaultStartTime;
    endDate.text = defaultEndTime;
    
    currentPage = 1;
    isEnd = NO;
    isScroll = NO;
    [scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    
    
    [self getWebDataWithProjectName:@"" approver:@"" startDate:startDate.text endDate:endDate.text pageCount:currentPage];
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

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

#pragma mark - Choose Date delegate

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date {
    [self.popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		[dateFormatter release];  
        
        if (currentTag == 1)
        {
            startDate.text = dateString;
        }
        if (currentTag == 2)
        {
            endDate.text = dateString;
        }
    }
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData{
    
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

#pragma mark - NSXMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"NewGetXmspResult"])
        isGotJsonString = YES;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (isGotJsonString) {
        [self.curParsedData appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if (isGotJsonString && [elementName isEqualToString:@"NewGetXmspResult"]) 
    {
        
        self.webResultAry = [curParsedData objectFromJSONString];
        
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{   
    if ([curParsedData length] > 0) {
        
        if (!isScroll)
            [self.infoAry removeAllObjects];
        
        [self.infoAry addObjectsFromArray:webResultAry];
        
        [resultTable reloadData];
        
        if ([webResultAry count] == 50)
            scrollImage.hidden = NO;
    } else {
        isEnd = YES;
        [scrollImage setImage:[UIImage imageNamed:@"finishScroll.png"]];
        NSString *msg = nil;
        if (isScroll) {
            msg = @"已经滚动至底部";
        }
        else
        {
            msg = @"没有符合查询条件审批项目";
            [self.infoAry removeAllObjects];
            [resultTable reloadData];
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    isLoading = NO;
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
    return [infoAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 72;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if ([infoAry count] > 0) 
    {
        NSDictionary *aItem = [infoAry objectAtIndex:indexPath.row];
        NSString *aTitle = [NSString stringWithFormat:@"项目名称：%@",[aItem objectForKey:@"项目名称"]];
        
        NSString *aMode = [NSString stringWithFormat:@"建设单位：%@",[aItem objectForKey:@"WRYMC"]];
        
        NSString *aCode = [aItem objectForKey:@"审批日期"];
        if ([aCode length] > 10)
            aCode = [NSString stringWithFormat:@"审批日期：%@",[aCode substringToIndex:10]];
        else
            aCode = @"审批日期：无";
        
        NSString *aCDate = [aItem objectForKey:@"是否通过"];
        
        NSString *person = [aItem objectForKey:@"审批员"];
        
        cell = [UITableViewCell makeSubCell:tableView withTitle:aTitle andSubvalue1:aMode andSubvalue2:aCDate andSubvalue3:aCode andSubvalue4:[NSString stringWithFormat:@"审批人：%@" ,person] andNoteCount:indexPath.row];
        
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    else
    {
        static NSString *CellIdentifier = @"Cell_NoInformation";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        if (!isLoading)
            cell.textLabel.text = @"该污染源没有建设项目审批信息。";
        else
            cell.textLabel.text = @"正在读取数据...";
       
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else
        cell.backgroundColor = [UIColor whiteColor];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *aItem = [infoAry objectAtIndex:indexPath.row];
    
    XmspDetailsController *childView = [[XmspDetailsController alloc] initWithInfoDic:aItem andDataType:0];
    
    [self.navigationController pushViewController:childView animated:YES];
    [childView release];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
		
        currentPage++;
        
        if (!isEnd) {
            NSString *xmmc = nil;
            NSString *spr = nil;
            NSString *cxkssj = nil;
            NSString *cxjssj = nil;
            
            if ([projectName.text length] == 0)
                xmmc = @"";
            else
                xmmc = projectName.text;
            
            if ([approver.text length] == 0)
                spr = @"";
            else
                spr = approver.text;
            
            if ([startDate.text length] == 0)
                cxkssj = @"";
            else
                cxkssj = startDate.text;
            
            if ([endDate.text length] == 0)
                cxjssj = @"";
            else
                cxjssj = endDate.text;
            
            
            isScroll = YES;
            
            [self getWebDataWithProjectName:xmmc approver:spr startDate:cxkssj endDate:cxjssj pageCount:currentPage];
        }
		
    }
}

@end
