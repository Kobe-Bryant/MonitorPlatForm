//
//  GufeiController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "GufeiController.h"
#import "WebServiceHelper.h"
#import "JSONKit.h"
#import "GufeiDetailInfoController.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;
@implementation GufeiController
@synthesize resultTableView,btnTitleView,wrybh,wryjc;
@synthesize currentMethod,nParserStatus,myToolbar,detailController;
@synthesize gfld,zyba,isGotJsonString,curParsedData;
@synthesize fromDateStr,endDateStr,infoArray;
@synthesize popController,dateController,curretTag,webHelper;
@synthesize isEnd,isScroll,currentPage,isLoading;

#define nLast5_liandan 1
#define nLast5_beian 2
#define nTimeLimit_liandan 3
#define nTimeLimit_beian 4

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
	
	
	nc.view.frame =  CGRectMake(768 - 481, 0, 481 , 1004);
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
	
	[nc viewWillAppear:YES];
	[self.view addSubview:nc.view];
	[nc viewDidAppear:YES];
}



#pragma mark - Private Methods

-(void)selectPolutionSrc
{
    PollutionSelectedController *controller = [[PollutionSelectedController alloc] initWithStyle:UITableViewStyleGrouped];	

	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	nav.modalPresentationStyle =  UIModalPresentationFormSheet;
    
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIInterfaceOrientationLandscapeRight || statusBarOrientation == UIInterfaceOrientationLandscapeLeft)
        nav.view.superview.frame = CGRectMake(162, 30, 700, 700);
    else
        nav.view.superview.frame = CGRectMake(30, 100, 700, 700);
	[self presentModalViewController:nav animated:YES];
	[controller release];
    [nav release];
    
}

- (void)liandanItemPressed
{
    [self.gfld setStyle:UIBarButtonItemStyleDone];
    [self.zyba setStyle:UIBarButtonItemStyleBordered];
    nParserStatus = nLast5_liandan;
    
    isScroll = NO;
    
    [self getWebData];
}

- (void)beianItemPressed
{
    [self.zyba setStyle:UIBarButtonItemStyleDone];
    [self.gfld setStyle:UIBarButtonItemStyleBordered];
    nParserStatus = nLast5_beian;
    
    isScroll = NO;
    [self getWebData];
}

- (void)getWebData{
    
    NSString *param;
    NSString *strUrl = [NSString stringWithFormat:SOLIDLIKAGE_URL,g_appDelegate.xxcxServiceIP];
    
    isLoading = YES;
    
    switch (nParserStatus) {
        case nLast5_liandan:
            param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wrybh,@"wryjc",wryjc,nil];
            self.currentMethod = @"GetLastLinkage";
            self.webHelper = [[[WebServiceHelper alloc] initWithUrl:strUrl 
                                                         method:currentMethod 
                                                      nameSpace:@"http://tempuri.org/" 
                                                     parameters:param 
                                                       delegate:self] autorelease];
            [webHelper runAndShowWaitingView:self.view];
            break;
        
        case nLast5_beian:
            param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wrybh,@"wryjc",wryjc,nil];
            self.currentMethod = @"GetLastZybeiAn";
            self.webHelper  = [[[WebServiceHelper alloc] initWithUrl:strUrl 
                                                         method:currentMethod 
                                                      nameSpace:@"http://tempuri.org/" 
                                                     parameters:param 
                                                       delegate:self] autorelease];
            [webHelper runAndShowWaitingView:self.view];
            break;
            
        case nTimeLimit_liandan:
            param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wrybh,@"ysqd",@"",@"yszd",@"",@"qsysrq",fromDateStr,@"jzysrq",endDateStr,@"page",[NSString stringWithFormat:@"%d",currentPage],@"pagenum",@"20",nil];
            self.currentMethod = @"GetTimeRangeLinkage";
            self.webHelper  = [[[WebServiceHelper alloc] initWithUrl:strUrl 
                                                         method:currentMethod 
                                                      nameSpace:@"http://tempuri.org/" 
                                                     parameters:param 
                                                       delegate:self] autorelease];
            [webHelper runAndShowWaitingView:self.view];
            break;
            
        case nTimeLimit_beian:
            param = [WebServiceHelper createParametersWithKey:@"wrybh" value:wrybh,@"wryjc",wryjc,@"qssqrq",fromDateStr,@"jzsqrq",endDateStr,@"page",[NSString stringWithFormat:@"%d",currentPage],@"pagenum",@"20",nil];
            self.currentMethod = @"GetTimeRangeBeiAn";
            self.webHelper  = [[[WebServiceHelper alloc] initWithUrl:strUrl 
                                                         method:currentMethod 
                                                      nameSpace:@"http://tempuri.org/" 
                                                     parameters:param 
                                                       delegate:self] autorelease];
            [webHelper runAndShowWaitingView:self.view];
            break;
            
        default:
            break;
    }
}

-(void)chooseDateRange:(id)sender{

    [popController dismissPopoverAnimated:YES];
    
    UIBarButtonItem *bar =(UIBarButtonItem*)sender;
    
    [popController presentPopoverFromBarButtonItem:bar permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}
#pragma mark - ChooseDateRange delegate

-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate{
    [popController dismissPopoverAnimated:YES];
    self.fromDateStr = fromDate;
    self.endDateStr = endDate;
    if (self.gfld.style == UIBarButtonItemStyleDone)
    {
        nParserStatus = nTimeLimit_liandan;
        
        isEnd = NO;
        isScroll = NO;
        currentPage = 1;
        [self getWebData];
    }
    
    if (self.zyba.style == UIBarButtonItemStyleDone)
    {
        isEnd = NO;
        isScroll = NO;
        currentPage = 1;
        nParserStatus = nTimeLimit_beian;
        [self getWebData];
    }
}

-(void)cancelSelectDateRange{
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

- (void)dealloc
{
    [wrybh release];
    [wryjc release];
    [currentMethod release];
    [curParsedData release];
    [infoArray release];
    
    [myToolbar release];
    [gfld release];
    [zyba release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    /*self.btnTitleView = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    self.btnTitleView.frame = CGRectMake(0, 0, 400, 35);
    [self.btnTitleView addTarget:self action:@selector(selectPolutionSrc) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = btnTitleView;*/
    
    self.title = [NSString stringWithFormat:@"%@危废查询",wryjc];
    
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
    
    [self.gfld setTarget:self];
    [self.gfld setAction:@selector(liandanItemPressed)];
    
    [self.zyba setTarget:self];
    [self.zyba setAction:@selector(beianItemPressed)];
    
    self.infoArray = [NSMutableArray array];
    
    [self liandanItemPressed];

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

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - NSURLConnHelper delegate

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
                          delegate:nil 
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
    self.currentMethod = [NSString stringWithFormat:@"%@Result",currentMethod];
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qualifiedName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:currentMethod])
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
    if (isGotJsonString && [elementName isEqualToString:currentMethod]) 
    {
        NSRange range = [curParsedData rangeOfString:@"\n"];
        while (range.location != NSNotFound) {
            [curParsedData deleteCharactersInRange:range];
            range = [curParsedData rangeOfString:@"\n"];
        }
        
        NSArray *webResultAry = [curParsedData objectFromJSONString];
        
        if (!isScroll)
            [self.infoArray removeAllObjects];
        
        [self.infoArray addObjectsFromArray:webResultAry];
        
        isGotJsonString = NO;
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser
{    
    isLoading = NO;
    
    if ([curParsedData length] > 0)
    {
        [resultTableView reloadData];
    } 
    else
    {
        isEnd = YES;
        
        NSString *msg;
        
        if (nParserStatus == nLast5_liandan || nParserStatus == nLast5_beian) {
            
                msg = @"该污染源没有该项数据,是否重选污染源？";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
                [alert show];
                [alert release];
            
        }
        else if (nParserStatus == nTimeLimit_liandan || nParserStatus == nTimeLimit_beian) {
            if (isScroll) 
            {
                msg = @"已经滚动至底部";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                
            } 
            else
            {
                msg = @"输入时间段内没有该项数据,请重新输入时间！";
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
            }
        }
        
    }
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
	return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    NSDictionary *tmpDic = [infoArray objectAtIndex:indexPath.row];
    
    NSString *date;
    NSString *transfer;
    NSString *receiver;
    NSString *other;
    if (nParserStatus == nLast5_beian || nParserStatus == nTimeLimit_beian) {
        date = [[tmpDic objectForKey:@"申请日期"] length] > 0 ? [tmpDic objectForKey:@"申请日期"]:@"";
        transfer = [[tmpDic objectForKey:@"运输者单位名称"] length] > 0 ? [tmpDic objectForKey:@"运输者单位名称"]:@"";
       // receiver = [[tmpDic objectForKey:@"接受者单位名称"] length] > 0 ? [tmpDic objectForKey:@"接受者单位名称"]:@"";
        other = [[tmpDic objectForKey:@"是否同意"] length] > 0 ? [tmpDic objectForKey:@"是否同意"]:@"";
        
        cell.textLabel.text = [NSString stringWithFormat:@"申请日期：%@",date];
        //cell.detailTextLabel.text = [NSString stringWithFormat:@"运输者单位：%@  接受者单位：%@  是否同意：%@",transfer,receiver,other];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"接收者单位：%@  是否同意：%@",transfer,other];
    } 
    if (nParserStatus == nLast5_liandan || nParserStatus == nTimeLimit_liandan) {
        date = [[tmpDic objectForKey:@"运输日期"] length] > 0 ? [tmpDic objectForKey:@"运输日期"]:@"";
        receiver = [[tmpDic objectForKey:@"接受者单位名称"] length] > 0 ? [tmpDic objectForKey:@"接受者单位名称"]:@"";
        
        cell.textLabel.text = [NSString stringWithFormat:@"运输日期：%@",date];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"接受者单位：%@",receiver];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *sectionTitle=@"";
    switch (nParserStatus) {
        case nLast5_liandan:
            sectionTitle = @"最近五次转移联单";
            break;
        case nLast5_beian:
            sectionTitle = @"最近五次转移备案";
            break;
        case nTimeLimit_liandan:
            sectionTitle = @"输入时间段内的转移联单";
            break;
        case nTimeLimit_beian:
            sectionTitle = @"输入时间段内的转移备案";
             break;
        default:
            sectionTitle = @"";
            break;
    }
    return sectionTitle;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [infoArray objectAtIndex:indexPath.row];
    GufeiDetailInfoController *childView = [[[GufeiDetailInfoController alloc] initWithStyle:UITableViewStylePlain] autorelease];
    [childView setWrybh:self.wrybh];
    if (nParserStatus == nLast5_liandan || nParserStatus == nTimeLimit_liandan) {
        [childView setNParserStatus:1];
        [childView setCode:[tmpDic objectForKey:@"联单号码"]];
    }
    else {
        [childView setNParserStatus:2];
        [childView setCode:[tmpDic objectForKey:@"申请序号"]];
    }
    
    [self showDetailController:childView animated:YES];
}

#pragma mark - UIAlert view delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
        
        if (nParserStatus == nTimeLimit_liandan || nParserStatus == nTimeLimit_beian)
            if (!isEnd) {
                currentPage++;
                isScroll = YES;
                [self getWebData];;
            }
		
    }
}

@end
