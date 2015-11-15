//
//  SearchLinkageController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-17.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "SearchLinkageController.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
extern MPAppDelegate *g_appDelegate;

@implementation SearchLinkageController
@synthesize resultTable,searchBtn,detailController;
@synthesize linkageInfoLbl,startTimeLbl,endTimeLbl,ldhLbl;
@synthesize linkageInfoTfd,startTimeTfd,endTimeTfd,ldhTfd;
@synthesize infoAry,isGotJsonString,curParsedData,currentDic;
@synthesize webHelper,defaultStartTime,defaultEndTime,scrollImage;
@synthesize dateController,popController,currentTag,bLandScape;
@synthesize isEnd,isScroll,isLoading,currentPage,bDetailShow;

#pragma mark - Detail Controller methods

-(void)hideDetailController:(BOOL)animated
{
    if(animated)
    {
        [UIView beginAnimations:@"hidedetailcontroller" context:nil];
        [UIView	 setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        CGRect rect = CGRectZero;
        
        if(bLandScape)
            rect = CGRectMake(1024, 0, 1024 - 535, 768 - 20);
        else
            rect = CGRectMake(768, 0, 768 - 277, 1024 - 20);
        
        detailController.view.alpha = 0;
        detailController.view.frame = rect;
        [UIView commitAnimations];
    }
    
    else
    {
        [detailController.view removeFromSuperview];
        self.detailController  = nil;
    }	
    
    bDetailShow = NO;
}

-(void)detailSwipeFromLeft
{
	if(detailController == nil || detailController.view.superview == nil)
	{
		return;
	}
	[self hideDetailController:YES];
	/*
     //detailcontroller 不是导航控制器
     if(![detailController isKindOfClass:[UINavigationController class]])
     {
     [self hideDetailController:YES];
     }
     
     //detailconroller是导航控制器
     
     UINavigationController *nc = (UINavigationController *)detailController;
     
     if(nc.viewControllers.count == 1)
     {
     [self hideDetailController:YES];
     }
     
     else {
     [nc popViewControllerAnimated:YES];
     }
     */
}

-(void)showDetailController:(UIViewController *)viewController animated:(BOOL)animated
{
	if(detailController && detailController.view.superview != nil)
	{
		[self hideDetailController:NO];
	}
	
	
	UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:viewController];
	self.detailController = nc;
	nc.delegate = self;
	[nc release];
	
	
	nc.view.frame = bLandScape ? CGRectMake(1024 - 481 , 0, 481 , 748) : CGRectMake(768 - 481, 0, 481 , 1004);
	viewController.view.frame = CGRectMake(0, 0, nc.view.frame.size.width, nc.view.frame.size.height - 44);
	
    viewController.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(hideDetailController:)] autorelease];
    
	
	//添加手势 向右滑的手势
	UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(detailSwipeFromLeft)];
	swipeGesture.direction =  UISwipeGestureRecognizerDirectionRight;
	[nc.view addGestureRecognizer:swipeGesture];
	[swipeGesture release];
	
	UIImageView *iv = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"detailView_left_shadow.png"]];
	iv.frame = CGRectMake(-25, 0, 27, nc.view.frame.size.height);
	[nc.view addSubview:iv];
	iv.tag = 888;
	[iv release];
	
	[nc willAnimateRotationToInterfaceOrientation:[[UIApplication sharedApplication] statusBarOrientation] duration:1.0];
    
	if(animated)
	{
		CATransition *transition = [CATransition animation];
		transition.duration = 0.4;
		transition.delegate = nil;
		transition.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
		transition.type =   kCATransitionPush;
		transition.subtype = kCATransitionFromRight;
		[detailController.view.layer addAnimation:transition forKey:nil];
	}
	
	//[nc viewWillAppear:YES];
	[self.view addSubview:nc.view];
	//[nc viewDidAppear:YES];
    
    bDetailShow = YES;
}

#pragma mark - Private methods


- (void)getWebDataWithCode:(NSString *)wryCode wryMC:(NSString *)startP ldbh:(NSString *)endP startDate:(NSString *)startD endDate:(NSString *)endD pageCount:(int)page
{
    self.scrollImage.hidden = YES;
    

    NSString *param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wryCode,@"cszdwmc",startP,@"ldhm",endP,@"kssj",startD,@"jssj",endD,@"page",[NSString stringWithFormat:@"%d",page],@"pagenum",@"50",nil];

    NSString *currentMethod = @"GetWKSolidLinkage";
    NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper  = [[[WebServiceHelper alloc] initWithUrl:strUrl 
                                                      method:currentMethod 
                                                   nameSpace:@"http://tempuri.org/"
                                                  parameters:param 
                                                    delegate:self] autorelease];
    
    isLoading = YES;
    [webHelper runAndShowWaitingView:self.view];
    //NSLog(@"%@?op=%@ %@", strUrl, currentMethod, param);
}

- (IBAction)touchFromDate:(id)sender {
    UITextField *tfd =(UITextField*)sender;
    currentTag = tfd.tag;
    
    if (currentTag == 1)
        self.startTimeTfd.text = @"";
    
    if (currentTag == 2)
        self.endTimeTfd.text = @"";
    
	[self.popController presentPopoverFromRect:[tfd bounds] inView:tfd permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)searchBtnPressed:(id)sender
{
    [linkageInfoTfd resignFirstResponder];
    [ldhTfd resignFirstResponder];
    /*
    if ([ldhTfd.text length] > 0)
    {
        GufeiDetailInfoController *childView = [[[GufeiDetailInfoController alloc] initWithNibName:@"GufeiDetailInfoController" bundle:nil] autorelease];
        [childView setWrybh:@""];
        [childView setNParserStatus:1];
        [childView setCode:ldhTfd.text];
        
        [self showDetailController:childView animated:YES];
        
        return;
    }
    */
    
    NSString *ysqd;
    NSString *qssj;
    NSString *jzsj;
    NSString *ldbh;
    
    if ([linkageInfoTfd.text length] > 0)
        ysqd = linkageInfoTfd.text;
    else
        ysqd = @"";
    
    
    if ([startTimeTfd.text length] > 0)
        qssj = startTimeTfd.text;
    else
        qssj = defaultStartTime;
    
    if ([endTimeTfd.text length] > 0)
        jzsj = endTimeTfd.text;
    else
        jzsj = defaultEndTime;
    if ([ldhTfd.text length] > 0)
        ldbh = ldhTfd.text;
    else
        ldbh = @"";
    
    currentPage = 1;
    isScroll = NO;
    isEnd = NO;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    
    [self getWebDataWithCode:@"" wryMC:ysqd ldbh:ldbh startDate:qssj endDate:jzsj pageCount:currentPage];
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
    self.title = @"转移联单列表";
    
    [self.startTimeTfd addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    [self.endTimeTfd addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    
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
    bDetailShow = NO;
    self.currentDic = nil;
  
    NSDate *nowDate = [NSDate date];
    NSDate *fromDate = [NSDate dateWithTimeInterval:-1*60*60*24*7 sinceDate:nowDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.defaultStartTime = [dateFormatter stringFromDate:fromDate];
    self.defaultEndTime = [dateFormatter stringFromDate:nowDate];
    [dateFormatter release];
    
    startTimeTfd.text = defaultStartTime;
    endTimeTfd.text = defaultEndTime;
    
    currentPage = 1;
    isScroll = NO;
    isEnd = NO;
    [self getWebDataWithCode:@"" wryMC:@"" ldbh:@"" startDate:defaultStartTime endDate:defaultEndTime pageCount:currentPage];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    if (webHelper) {
        [webHelper cancel];
    }
    [popController dismissPopoverAnimated:YES];
    [super viewWillDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
       
    [self.resultTable reloadData];
    
    if (bDetailShow)
    {
        GufeiDetailInfoController *childView = [[[GufeiDetailInfoController alloc] initWithNibName:@"GufeiDetailInfoController" bundle:nil] autorelease];
        [childView setWrybh:@""];
        [childView setNParserStatus:1];
        [childView setCode:[currentDic objectForKey:@"联单号码"]];
        
        [self showDetailController:childView animated:YES];
    }
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
            self.startTimeTfd.text = dateString;
        
        if (currentTag == 2)
            self.endTimeTfd.text = dateString;
    }
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData{
    /*
    NSString *str = [[NSString alloc] initWithData:webData encoding:NSUTF8StringEncoding];
    NSLog(@"%@",str);
    [str release];
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

#pragma mark - NSXMLParser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser
{
    isGotJsonString = NO;
    self.curParsedData = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
//    if ([elementName isEqualToString:@"GetTimeRangeLinkageResult"])
    if ([elementName isEqualToString:@"GetWKSolidLinkageResult"])
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
//    if (isGotJsonString && [elementName isEqualToString:@"GetTimeRangeLinkageResult"])
    if (isGotJsonString && [elementName isEqualToString:@"GetWKSolidLinkageResult"])
    
    {
        NSArray *webResult = [curParsedData objectFromJSONString];
        
        if (!isScroll)
            [self.infoAry removeAllObjects];
            
        [self.infoAry addObjectsFromArray:webResult];
        
        if ([webResult count] == 50)
            self.scrollImage.hidden = NO;
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{   
    if ([curParsedData length] == 0)
    {
        isEnd = YES;
        [self.scrollImage setImage:[UIImage imageNamed:@"finishScroll.png"]];
        NSString *msg = nil;
        if (isScroll) {
            msg = @"已经滚动至底部";
        }
        else
            msg = @"没有符合查询条件的转移联单";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    [self.resultTable reloadData];
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
    
    NSString *date = [[tmpDic objectForKey:@"YSRQ"] length] > 0 ? [tmpDic objectForKey:@"YSRQ"]:@"";
    if ([date length] > 0)
        date = [date substringToIndex:10];
    NSString *transfer = [[tmpDic objectForKey:@"FWYSZDWMC"] length] > 0 ? [tmpDic objectForKey:@"FWYSZDWMC"]:@"";
    //NSString *receiver = [[tmpDic objectForKey:@"接受者单位名称"] length] > 0 ? [tmpDic objectForKey:@"接受者单位名称"]:@"";
    
    cell = [UITableViewCell makeSubCell:tableView withTitle:[NSString stringWithFormat:@"产废单位：%@",[tmpDic objectForKey:@"CSZDWMC"]] andSubvalue1:[NSString stringWithFormat:@"接收单位：%@",transfer] andSubvalue2:[NSString stringWithFormat:@"运输日期：%@",date] andSubvalue3:[NSString stringWithFormat:@"数量：%@ kg",[tmpDic objectForKey:@"JSZQRSL"]] andSubvalue4:[NSString stringWithFormat:@"废物名称：%@",[tmpDic objectForKey:@"FWMC"]] andNoteCount:indexPath.row];
    
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
    self.currentDic = [infoAry objectAtIndex:indexPath.row];
    GufeiDetailInfoController *childView = [[[GufeiDetailInfoController alloc] initWithNibName:@"GufeiDetailInfoController" bundle:nil] autorelease];
    [childView setWrybh:@""];
    [childView setNParserStatus:1];
    [childView setCode:[currentDic objectForKey:@"LDHM2"]];
    
    [self showDetailController:childView animated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
		
        currentPage++;
        
        if (!isEnd) {
            NSString *ysqd;
            NSString *qssj;
            NSString *jzsj;
            NSString *ldbh;
            
            if ([linkageInfoTfd.text length] > 0)
                ysqd = linkageInfoTfd.text;
            else
                ysqd = @"";
            
            if ([ldhTfd.text length] > 0)
                ldbh = ldhTfd.text;
            else
                ldbh = @"";
            
            if ([startTimeTfd.text length] > 0)
                qssj = startTimeTfd.text;
            else
                qssj = defaultStartTime;
            
            if ([endTimeTfd.text length] > 0)
                jzsj = endTimeTfd.text;
            else
                jzsj = defaultEndTime;

            isScroll = YES;

            [self getWebDataWithCode:@"" wryMC:ysqd ldbh:ldbh startDate:qssj endDate:jzsj pageCount:currentPage];
        }
		
    }
}

@end
