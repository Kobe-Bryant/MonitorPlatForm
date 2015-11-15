//
//  SolidLinkageDataModel.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-27.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "SolidLinkageDataModel.h"
#import "JSONKit.h"
#import "WebServiceHelper.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "GufeiDetailInfoController.h"

extern MPAppDelegate *g_appDelegate;

@implementation SolidLinkageDataModel

@synthesize infoArray;
@synthesize fromDateStr;
@synthesize endDateStr;
@synthesize isLoading;
@synthesize currentPage;
@synthesize isScroll;
@synthesize isEnd,scrollImage;
@synthesize detailController;

#pragma mark - Detail Controller methods

-(id)initWithWryBH:(NSString*)bh 
  parentController:(UIViewController*)controller 
      andTableView:(UITableView*)tableView
      andImageView:(UIImageView *)img
{
    
    self = [super init];
    if (self)
    {
        self.wrybh = bh;
        self.displayTableView = tableView;
        self.parentController = controller;
        self.scrollImage = img;
        isDataRequested = NO;
    }
    return self;
}

-(void)hideDetailController:(BOOL)animated
{
    if(animated)
    {
        [UIView beginAnimations:@"hidedetailcontroller" context:nil];
        [UIView	 setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationDuration:0.4];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
        
        CGRect rect = CGRectMake(768, 44, 768 - 277, 1024 - 20);        
        
        detailController.view.alpha = 0;
        detailController.view.frame = rect;
        [UIView commitAnimations];
    }
    
    else
    {
        [detailController.view removeFromSuperview];
        self.detailController  = nil;
    }	
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
	//nc.delegate = self;
	[nc release];
	
	
	nc.view.frame =  CGRectMake(768 - 481, 44, 481 , 1004);
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
	[parentController.view addSubview:nc.view];
	//[nc viewDidAppear:YES];
}


#pragma mark - Private methods

-(void)getWebData
{
    NSString *param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wrybh,@"qsysrq",fromDateStr,@"jzysrq",endDateStr,@"page",[NSString stringWithFormat:@"%d",currentPage],@"pagenum",@"50",nil];
    NSString *currentMethod = @"GetTimeRangeLinkage";
    NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];
    self.webHelper = [[[WebServiceHelper alloc] initWithUrl:strUrl 
                                                                   method:currentMethod 
                                                                nameSpace:@"http://tempuri.org/" 
                                                               parameters:param 
                                                                 delegate:self] autorelease];
    
    isLoading = YES;
    [self.webHelper runAndShowWaitingView:parentController.view];
}

-(void)requestData{
    displayTableView.delegate = self;
    displayTableView.dataSource = self;
    if(isDataRequested){
        [displayTableView reloadData];
        return;
    }
    
    self.infoArray = [NSMutableArray array];
    
    NSDate *nowDate = [NSDate date];
    NSDate *fromDate = [NSDate dateWithTimeInterval:-1*60*60*24*365*5 sinceDate:nowDate];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.fromDateStr = [dateFormatter stringFromDate:fromDate];
    self.endDateStr = [dateFormatter stringFromDate:nowDate];
    [dateFormatter release];
    
    currentPage = 1;
    isEnd = NO;
    isScroll = NO;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    [self getWebData];
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
    if ([elementName isEqualToString:@"GetTimeRangeLinkageResult"])
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
    if (isGotJsonString && [elementName isEqualToString:@"GetTimeRangeLinkageResult"]) 
    {
        NSArray *webResult = [curParsedData objectFromJSONString];
        
        if (!isScroll)
            [self.infoArray removeAllObjects];
        
        [self.infoArray addObjectsFromArray:webResult];
        
        if ([webResult count] == 50)
            self.scrollImage.hidden = NO;
    }
    isGotJsonString = NO;
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{   
    if ([curParsedData length] > 0) {
        [self.displayTableView reloadData];
        
    } else {
        isEnd = YES;
        
        NSString *msg = nil;
        if (isScroll) {
            msg = @"已经滚动至底部";
            [self.scrollImage setImage:[UIImage imageNamed:@"finishScroll.png"]];
        }
        else
            msg = @"该污染源没有转移联单数据";
        
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
    return [infoArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 72;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    NSDictionary *tmpDic = [infoArray objectAtIndex:indexPath.row];
    NSString *date = [[tmpDic objectForKey:@"运输日期"] length] > 0 ? [tmpDic objectForKey:@"运输日期"]:@"";
    if ([date length] > 0)
        date = [date substringToIndex:10];
    NSString *transfer = [[tmpDic objectForKey:@"废物运输者单位名称"] length] > 0 ? [tmpDic objectForKey:@"废物运输者单位名称"]:@"";
    
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:[NSString stringWithFormat:@"接收单位：%@",transfer] andSubvalue1:[NSString stringWithFormat:@"运输日期：%@",date] andSubvalue2:[NSString stringWithFormat:@"数量：%@kg",[tmpDic objectForKey:@"数量"]] andSubvalue3:[NSString stringWithFormat:@"废物名称：%@",[tmpDic objectForKey:@"废物名称"]] andSubvalue4:@"" andNoteCount:indexPath.row];
    
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
    NSDictionary *tmpDic = [infoArray objectAtIndex:indexPath.row];
    GufeiDetailInfoController *childView = [[[GufeiDetailInfoController alloc] initWithNibName:@"GufeiDetailInfoController" bundle:nil] autorelease];
    [childView setWrybh:@""];
    [childView setNParserStatus:1];
    [childView setCode:[tmpDic objectForKey:@"联单号码"]];
    
    [self showDetailController:childView animated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
		
        currentPage++;
        
        if (!isEnd) {
            
            isScroll = YES;
            
            [self getWebData];
        }
		
    }
}

@end
