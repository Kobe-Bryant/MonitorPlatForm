//
//  SearchDoneComplaintsController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-9.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "SearchDoneComplaintsController.h"
#import "MPAppDelegate.h"
#import "UITableViewCell+Custom.h"
#import "NSString+Custom.h"
#import "DoneComplaintDetailController.h"
#import "JSONKit.h"
#import "NSDateUtil.h"
#import "LoginedUsrInfo.h"
#import "ServiceUrlString.h"

extern MPAppDelegate *g_appDelegate;

@implementation SearchDoneComplaintsController
@synthesize listTable,nDataType,scrollImage,webservice;
@synthesize doneDataAry,completedType,totalPages,listType;
@synthesize taskInfoLabel,completedTypeLabel,taskInfoField;
@synthesize completedTypeSeg,searchBtn,startDateLbl,endDateLbl;
@synthesize endDateTfd,startDateTfd,isLoading,currentPage;
@synthesize dateController,popController,currentTag,isScroll;
@synthesize totalDataCount;

#define nDataNormal 1
#define nDataException 2
#define nDataNone 3

#define nYB 1
#define nTZ 2

#pragma mark - private methods

- (void)setLandscape
{
    self.taskInfoLabel.frame = CGRectMake(127, 20, 85, 31);
    self.taskInfoField.frame = CGRectMake(220, 20, 215, 31);
    self.completedTypeLabel.frame = CGRectMake(478, 20, 85, 31);
    self.completedTypeSeg.frame = CGRectMake(571, 21, 215, 30);
    self.startDateLbl.frame = CGRectMake(127, 61, 85, 31);
    self.startDateTfd.frame = CGRectMake(220, 61, 215, 31);
    self.endDateLbl.frame = CGRectMake(478, 61, 85, 31);
    self.endDateTfd.frame = CGRectMake(571, 61, 215, 31);
    self.searchBtn.frame = CGRectMake(845, 20, 50, 72);
}

- (void)setPortrait
{
    self.taskInfoLabel.frame = CGRectMake(20, 20, 85, 31);
    self.taskInfoField.frame = CGRectMake(113, 20, 215, 31);
    self.completedTypeLabel.frame = CGRectMake(371, 20, 85, 31);
    self.completedTypeSeg.frame = CGRectMake(464, 21, 215, 30);
    self.startDateLbl.frame = CGRectMake(20, 61, 85, 31);
    self.startDateTfd.frame = CGRectMake(113, 61, 215, 31);
    self.endDateLbl.frame = CGRectMake(371, 61, 85, 31);
    self.endDateTfd.frame = CGRectMake(464, 61, 215, 31);
    self.searchBtn.frame = CGRectMake(698, 20, 50, 72);
}

- (void)getWebData
{
    self.scrollImage.hidden = YES;
    
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];

    if (listType == nYB)
    {
        [param setObject:@"GET_XFTS_DONELIST" forKey:@"service"];
        [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
    }
    else
        [param setObject:@"GET_XFTS_INFO_LIST" forKey:@"service"];
    
    [param setObject:@"41389071-3226-4dab-9c01-61eed5c944b4" forKey:@"lclx"];
    [param setObject:@"50" forKey:@"pageSize"];
    
    if ([taskInfoField.text length] > 0){
        if (listType == nYB)
            [param setObject:taskInfoField.text forKey:@"dwmc"];
        else
            [param setObject:taskInfoField.text forKey:@"bzmc"];
    }
    
    if (completedTypeSeg.selectedSegmentIndex == 0)
        [param setObject:@"zcwc" forKey:@"type"];
    
    if (completedTypeSeg.selectedSegmentIndex == 1)
        [param setObject:@"cswc" forKey:@"type"];
    
    if ([startDateTfd.text length] > 0)
        [param setObject:startDateTfd.text forKey:@"kssj"];
    
    if ([endDateTfd.text length] > 0)
        [param setObject:endDateTfd.text forKey:@"jssj"];
    
    if (currentPage > 0)
        [param setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"currentPage"];
        
    
    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
        
    isLoading = YES;
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
    //NSLog(@"%@", urlString);
}

- (IBAction)touchFromDate:(id)sender {
    UITextField *tfd =(UITextField*)sender;
    currentTag = tfd.tag;
    
    if (currentTag == 1)
        self.startDateTfd.text = @"";
    
    if (currentTag == 2)
        self.endDateTfd.text = @"";
    
	[self.popController presentPopoverFromRect:[tfd bounds] inView:tfd permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)searchBtnPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    currentPage = 1;
    totalPages = 0;
    isScroll = NO;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    [self getWebData];
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
    [listTable release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (listType == nYB)
    {
        self.title = @"已办信访列表";
    }
    else
    {
        self.title = @"信访投诉台账列表";
        self.completedTypeLabel.hidden = YES;
        self.completedTypeSeg.hidden  = YES;
    }
    
    [self.startDateTfd addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    [self.endDateTfd addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    
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
    
    self.completedTypeSeg.selectedSegmentIndex = 2;
    
    self.doneDataAry = [NSMutableArray array];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endDateStr = [formatter stringFromDate:[NSDate date]];
    NSString *fromDateStr = [NSDateUtil firstDateThisMonth];
    startDateTfd.text = fromDateStr;
    endDateTfd.text = endDateStr;
    
    currentPage = 1;
    totalPages = 0;
    isScroll = NO;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    [self getWebData];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES];
    /*
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) 
        [self setLandscape];
    else 
        [self setPortrait];*/
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webservice)
        [webservice cancel];
    
    [super viewWillDisappear:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{/*
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation ==UIInterfaceOrientationLandscapeRight) 
        [self setLandscape];
    else 
        [self setPortrait];
    
    [self.listTable reloadData];*/
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - NSURLConnHelperDelegate

-(void)processWebData:(NSData*)webData
{    
    if([webData length] <=0 )
        return;
    NSString *str =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x0A];
    NSString *resultJSON =[str stringByReplacingOccurrencesOfString:ctrlChar withString:@""];
    
    self.nDataType = nDataNormal;
    
    NSArray *aryJson = [resultJSON objectFromJSONString];
    if(aryJson == nil)
    {
        currentPage = 0;
        totalPages = 0;
        totalDataCount = 0;
        [self.doneDataAry removeAllObjects];
        [self.listTable reloadData];
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:str
                              delegate:self 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        
        
        return;
    }
    NSMutableArray *resultArray = [NSMutableArray arrayWithArray:aryJson];
    
    //异常或无数据的处理
    NSDictionary *resultDic = [resultArray objectAtIndex:0];
    NSArray *keys = [resultDic allKeys];
    for (NSString *key in keys) {
        if ([key isEqualToString:@"COUNT"]) {
            self.nDataType = nDataNone;
            break;
        }
        if ([key isEqualToString:@"exception"]) {
            self.nDataType = nDataException;
            break;
        }
    }
    
    if (nDataType == nDataNormal) {
        
        NSDictionary *pageInfoDic = [resultArray lastObject];
        currentPage = [[pageInfoDic objectForKey:@"currentPage"] intValue];
        totalPages = [[pageInfoDic objectForKey:@"pageCount"] intValue];
        totalDataCount = [[pageInfoDic objectForKey:@"pageAmount"] intValue];
        
        [resultArray removeLastObject];
        
        if (!isScroll)
            [self.doneDataAry removeAllObjects];
        
        [self.doneDataAry addObjectsFromArray:resultArray];
        [self.listTable reloadData];
        
        if ([resultArray count] == 50)
            self.scrollImage.hidden = NO;
        
    } else {
        
        currentPage = 0;
        totalPages = 0;
        totalDataCount = 0;
        [self.doneDataAry removeAllObjects];
        [self.listTable reloadData];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有满足查询条件的已办信访案件或出现错误" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    
    isLoading = NO;
}


- (void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败,请检查网络连接并重试。" 
                          delegate:self 
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    isLoading = NO;
    
    return;
}

#pragma mark - Table View Data Source
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
    else
        cell.backgroundColor = [UIColor whiteColor];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 72;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [doneDataAry count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    //int count = 50*currentPage > totalDataCount ? totalDataCount : 50*currentPage;
    //NSString *str = [NSString stringWithFormat:@"当前显示%d条，总共查到数据%d条",count,totalDataCount];
    //return str;
    return @"查询结果";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger index = [indexPath row];
    NSDictionary *tmpDic = [doneDataAry objectAtIndex:index];
    
    NSString *dwmc = listType == nYB ? [tmpDic objectForKey:@"B_DWMC"]:[tmpDic objectForKey:@"BTSDWMC"];
    NSString *lcmc = listType == nYB ? [NSString stringWithFormat:@"流程名称：%@",[tmpDic objectForKey:@"LCMC"]]:[NSString stringWithFormat:@"投诉次数：%@",[tmpDic objectForKey:@"TSCS"]];
    if ([lcmc length] == 5 && listType == nTZ)
        lcmc = @"投诉次数：1";
    
    NSString *bzmc = listType == nYB ? [NSString stringWithFormat:@"步骤名称：%@",[tmpDic objectForKey:@"BZMC"]]:[NSString stringWithFormat:@"投诉方式：%@",[tmpDic objectForKey:@"TSFSMC"]];
    NSString *kssj = listType == nYB ? [NSString stringWithFormat:@"步骤开始时间：%@",[[tmpDic objectForKey:@"KSSJ"] substringToIndex:10]]:[NSString stringWithFormat:@"来源行业：%@",[tmpDic objectForKey:@"LYHYMC"]];
    NSString *jssj = listType == nYB ? [NSString stringWithFormat:@"步骤结束时间：%@",[[tmpDic objectForKey:@"XGSJ"] substringToIndex:10]]:[NSString stringWithFormat:@"行政区划：%@",[tmpDic objectForKey:@"XZQH"]];
    
    UITableViewCell *cell;
    
    if (listType == nYB)
        cell = [UITableViewCell makeSubCell:tableView withTitle:dwmc andSubvalue1:bzmc andSubvalue2:jssj andSubvalue3:kssj  andSubvalue4:lcmc andNoteCount:index];
    else
    {
      /*  NSString * tssj = [tmpDic objectForKey:@"SJ"];
        if ([tssj length] > 10)
            tssj = [tssj substringToIndex:10];
        tssj = [NSString stringWithFormat:@"投诉时间：%@",tssj];*/
        
        cell = [UITableViewCell makeSubCell:tableView withTitle:dwmc andSubvalue1:bzmc andSubvalue2:jssj andSubvalue3:kssj  andSubvalue4:lcmc andNoteCount:index];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger row = [indexPath row];
    NSDictionary *tmpDic = [doneDataAry objectAtIndex:row];
    
    DoneComplaintDetailController *childView = [[[DoneComplaintDetailController alloc] initWithNibName:@"DoneComplaintDetailController" bundle:nil] autorelease];
    
    NSString *complaintNum = [tmpDic objectForKey:@"XFXH"];
    childView.complaintNum = complaintNum;
    childView.orgid = [NSString stringWithFormat:@"440301"];
	[self.navigationController pushViewController:childView animated:YES]; 
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
	
	if (isLoading) return;
	
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 ) {
		
        currentPage++;
        
        if (currentPage <= totalPages) {
            isScroll = YES;
            [self getWebData];
        }
        else
        {
            [self.scrollImage setImage:[UIImage imageNamed:@"finishScroll.png"]];
        }
    }
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
            self.startDateTfd.text = dateString;
        
        if (currentTag == 2)
            self.endDateTfd.text = dateString;
    }
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}

@end

