//
//  MainRecordController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-6.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "MainRecordController.h"

#import "UITableViewCell+Custom.h"
#import "JSONKit.h"
#import "MPAppDelegate.h"
#import "RecordDetailsController.h"

extern MPAppDelegate *g_appDelegate;
@implementation MainRecordController
@synthesize recordTable,defaultEndTime;
@synthesize infoAry,isGotJsonString;
@synthesize wrymcLab,zfryLab,qsrqLab,wrymcFie,zfryFie;
@synthesize qsrqFie,searchBtn,jzrqLab,jzrqFie;
@synthesize webHelper,defaultStartTime,currentTag;
@synthesize dateController,popController,scrollImage;
@synthesize curParsedData,webResultAry;
@synthesize isLoading,isScroll,currentPage,isEnd;


#pragma mark - Private methods

- (void)setLandscape
{
    self.wrymcLab.frame = CGRectMake(185, 20, 85, 31);
    self.wrymcFie.frame = CGRectMake(278, 20, 203, 31);
    self.zfryLab.frame = CGRectMake(511, 20, 85, 31);
    self.zfryFie.frame = CGRectMake(604, 20, 175, 31);
    self.qsrqLab.frame = CGRectMake(185, 66, 85, 31);
    self.qsrqFie.frame = CGRectMake(278, 66, 203, 31);
    self.jzrqLab.frame = CGRectMake(511, 66, 85, 31);
    self.jzrqFie.frame = CGRectMake(604, 66, 175, 31);
    self.searchBtn.frame = CGRectMake(799, 20, 41, 77);
}

- (void)setPortrait
{
    self.wrymcLab.frame = CGRectMake(57, 20, 85, 31);
    self.wrymcFie.frame = CGRectMake(150, 20, 203, 31);
    self.zfryLab.frame = CGRectMake(383, 20, 85, 31);
    self.zfryFie.frame = CGRectMake(476, 20, 175, 31);
    self.qsrqLab.frame = CGRectMake(57, 66, 85, 31);
    self.qsrqFie.frame = CGRectMake(150, 66, 203, 31);
    self.jzrqLab.frame = CGRectMake(383, 66, 85, 31);
    self.jzrqFie.frame = CGRectMake(476, 66, 175, 31);
    self.searchBtn.frame = CGRectMake(671, 20, 41, 77);
    
}

- (void)getWebDataWithCompany:(NSString *)aCompany person:(NSString *)aPerson startTime:(NSString *)start endTime:(NSString *)end pageCount:(int)page
{
    self.scrollImage.hidden = YES;
    
    NSString *param = [WebServiceHelper createParametersWithKey:@"StartCheckTime" value:start,@"CheckedInstituteName",aCompany,@"ExcutingLawPerson",aPerson,@"EndCheckTime",end,@"pagenum",@"50",@"page",[NSString stringWithFormat:@"%d",page], nil];
    NSString *strUrl = [NSString stringWithFormat:RECORD_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:strUrl method:@"NewRetrieveCheckRecord" nameSpace:@"http://tempuri.org/" parameters:param delegate:self] autorelease];
    
    isLoading = YES;
    [webHelper runAndShowWaitingView:self.view];
    
    //NSLog(@"%@ %@", param, strUrl);
}

- (IBAction)touchFromDate:(id)sender {
    UITextField *tfd =(UITextField*)sender;
    currentTag = tfd.tag;
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    if (currentTag == 1)
    {
        self.qsrqFie.text = @"";
    }
    if (currentTag == 2)
    {
        self.jzrqFie.text = @"";
    }
    
	[self.popController presentPopoverFromRect:[tfd bounds] inView:tfd permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)searchBtnPressed:(id)sender
{
    NSLog(@"111");
    if ([qsrqFie.text length] == 0)
    {
        NSString* msg = @"起始日期不能为空";
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
    if ([jzrqFie.text length] == 0)
    {
        NSString* msg = @"截止日期不能为空";
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
    
    [wrymcFie resignFirstResponder];
    [zfryFie resignFirstResponder];
    [infoAry removeAllObjects];
    NSString *dwmc;
    NSString *zfry;
    NSString *qssj;
    NSString *jzsj;
    //单位名称
    if ([zfryFie.text length] > 0)
        dwmc = zfryFie.text;
    else
        dwmc = @"";
    //检查人员
    if ([wrymcFie.text length] > 0)
        zfry = wrymcFie.text;
    else
        zfry = @"";
    
    if ([qsrqFie.text length] > 0)
        qssj = qsrqFie.text;
    else
        qssj = defaultStartTime;
    
    if ([jzrqFie.text length] > 0)
        jzsj = jzrqFie.text;
    else
        jzsj = defaultEndTime;
    
    currentPage = 1;
    isEnd = NO;
    isScroll = NO;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    
    [self getWebDataWithCompany:dwmc person:zfry startTime:qssj endTime:jzsj pageCount:currentPage];
    
}

#pragma mark - View lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    self.title = @"执法台账";
    
    self.scrollImage.hidden = YES;
    
    [self.qsrqFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    [self.jzrqFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    
    NSDate *nowDate = [NSDate date];
    NSDate *fromDate = [NSDate dateWithTimeInterval:-1*60*60*24*7 sinceDate:nowDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.defaultStartTime = [dateFormatter stringFromDate:fromDate];
    self.defaultEndTime = [dateFormatter stringFromDate:nowDate];
    [dateFormatter release];
    
    qsrqFie.text = defaultStartTime;
    jzrqFie.text = defaultEndTime;
    
    //日期可选
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
    
    self.infoAry = [NSMutableArray array];
    
    currentPage = 1;
    isEnd = NO;
    isScroll = NO;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    
    [self getWebDataWithCompany:@"" person:@"" startTime:defaultStartTime endTime:defaultEndTime pageCount:currentPage];
    
    //[self setPortrait];
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

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
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
            self.qsrqFie.text = dateString;
            self.defaultStartTime = dateString;
        }
        if (currentTag == 2)
        {
            self.jzrqFie.text = dateString;
            self.defaultEndTime = dateString;
        }
    }
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData{
    
    /*NSString *str = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    [str release];*/
    
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
    if ([elementName isEqualToString:@"NewRetrieveCheckRecordResult"])
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
    if (isGotJsonString && [elementName isEqualToString:@"NewRetrieveCheckRecordResult"]) 
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
        
        [self.recordTable reloadData];
        
        if ([webResultAry count] == 20)
            self.scrollImage.hidden = NO;
        
    } else {
        isEnd = YES;
        [self.scrollImage setImage:[UIImage imageNamed:@"finishScroll.png"]];
        NSString *msg = nil;
        if (isScroll) {
            msg = @"已经滚动至底部";
        }
        else{
            
            msg = @"没有符合查询条件的执法任务";
            [infoAry removeAllObjects];
            [recordTable reloadData];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [infoAry count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSDictionary *tmpDic = [infoAry objectAtIndex:indexPath.row];
    //现场检查人  询问人
    NSString *person = [NSString stringWithFormat:@"监察人员：%@",[tmpDic objectForKey:@"现场检查人"]];
    if ([[tmpDic objectForKey:@"现场检查人"] isEqualToString:@""]) {
        person = [NSString stringWithFormat:@"监察人员：%@",[tmpDic objectForKey:@"询问人"]];
    }
    NSString *date = [tmpDic objectForKey:@"调查开始时间"];
    date = [date substringToIndex:10];
    
    cell = [UITableViewCell makeSubCell:tableView withTitle:[tmpDic objectForKey:@"被检查单位"] andSubvalue1:person andSubvalue2:[NSString stringWithFormat:@"检查时间：%@",date] andSubvalue3:@"" andSubvalue4:@"" andNoteCount:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"查询结果";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else
        cell.backgroundColor = [UIColor whiteColor];
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [infoAry objectAtIndex:indexPath.row];
    RecordDetailsController *childView = [[[RecordDetailsController alloc] initWithNibName:@"RecordDetailsController" bundle:nil] autorelease];
    [childView setDataDic:tmpDic];
    
    [self.navigationController pushViewController:childView animated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
		
        currentPage++;
        
        if (!isEnd) {
            NSString *dwmc;
            NSString *zfry;
            NSString *qssj;
            NSString *jzsj;
            
            if ([wrymcFie.text length] > 0)
                dwmc = wrymcFie.text;
            else
                dwmc = @"";
            
            if ([zfryFie.text length] > 0)
                zfry = zfryFie.text;
            else
                zfry = @"";
            
            if ([qsrqFie.text length] > 0)
                qssj = qsrqFie.text;
            else
                qssj = defaultStartTime;
            
            if ([jzrqFie.text length] > 0)
                jzsj = jzrqFie.text;
            else
                jzsj = defaultEndTime;

            isScroll = YES;
            
            [self getWebDataWithCompany:dwmc person:zfry startTime:qssj endTime:jzsj pageCount:currentPage];
        }
		
    }
}

@end
