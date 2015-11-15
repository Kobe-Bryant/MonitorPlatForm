//
//  SearchDonePunishController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-7.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "SearchDonePunishController.h"
#import "DonePunishDetailController.h"
#import "MPAppDelegate.h"
#import "ServiceUrlString.h"
#import "UITableViewCell+Custom.h"
#import "JSONKit.h"
#import "LoginedUsrInfo.h"

extern MPAppDelegate *g_appDelegate;

@implementation SearchDonePunishController
@synthesize punishArray,nDataType,totalPages,isScroll,isLoading;
@synthesize doneTable,caseInfoLbl,startDateLbl,endDateLbl,scrollImage;
@synthesize caseInfoTfd,startDateTfd,endDateTfd,searchBtn,webservice;
@synthesize dateController,popController,currentTag,currentPage,listType;
@synthesize totalDataCount;

#define nDataNormal 1
#define nDataException 2
#define nDataNone 3

#define nYB 1
#define nTZ 2

#pragma mark - private methods

- (void)setLandscape
{
    self.caseInfoLbl.frame = CGRectMake(127, 20, 85, 31);
    self.caseInfoTfd.frame = CGRectMake(220, 20, 566, 31);
    self.startDateLbl.frame = CGRectMake(127, 61, 85, 31);
    self.startDateTfd.frame = CGRectMake(220, 61, 215, 31);
    self.endDateLbl.frame = CGRectMake(478, 61, 85, 31);
    self.endDateTfd.frame = CGRectMake(571, 61, 215, 31);
    self.searchBtn.frame = CGRectMake(845, 20, 50, 72);
}

- (void)setPortrait
{
    self.caseInfoLbl.frame = CGRectMake(20, 20, 85, 31);
    self.caseInfoTfd.frame = CGRectMake(113, 20, 566, 31);
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
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    
    if (listType == nYB)
    {
        [param setObject:@"GET_WORKFLOW_DOLIST" forKey:@"service"];
        [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
        [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
    }
    else
    {
        [param setObject:@"GET_XZCF_INFO_LIST" forKey:@"service"];
        [param setObject:@"440301201210353" forKey:@"lcslbh"];
    }
    
    [param setObject:@"50" forKey:@"pageSize"];
    
    if ([caseInfoTfd.text length] > 0)
    {
        if (listType == nYB)
            [param setObject:caseInfoTfd.text  forKey:@"BLNR"];
        else
            [param setObject:caseInfoTfd.text forKey:@"blnr"];
    }
    if ([startDateTfd.text length] > 0)
    {
        if (listType == nYB)
            [param setObject:startDateTfd.text forKey:@"KSSJ"];
        else
            [param setObject:startDateTfd.text  forKey:@"kssj"];
    }
    if ([endDateTfd.text length] > 0)
    {
        if (listType == nYB)
            [param setObject:endDateTfd.text forKey:@"JSSJ"];
        else
            [param setObject:endDateTfd.text  forKey:@"jssj"];
    }
    if (currentPage > 0)
        [param setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"currentPage"];

    NSString *requestString = nil;
    if (listType == nYB)
        requestString = [ServiceUrlString generateXZCFUrlByParameters:param];
    else
        requestString = [ServiceUrlString generateUrlByParameters:param];
    
    isLoading = YES;
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
    //NSLog(@"%@", requestString);
}

- (IBAction)searchBtnPressed:(id)sender
{
    if ([startDateTfd.text length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"起始日期不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    if ([endDateTfd.text length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"截止日期不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
        return;
    }
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    currentPage = 1;
    totalPages = 0;
    isScroll = NO;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    [self getWebData];
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
    
    if (listType == nYB)
        self.title = @"已办处罚案件列表";
    else
        self.title = @"行政处罚台账列表";

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
    
    self.punishArray = [NSMutableArray array];
    
    NSDateFormatter *formatter = [[[NSDateFormatter alloc] init] autorelease];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endDateStr = [formatter stringFromDate:[NSDate date]];
    NSArray *dateAry = [endDateStr componentsSeparatedByString:@"-"];
    NSString *fromDateStr = [NSString stringWithFormat:@"%@-01-01",[dateAry objectAtIndex:0]];
    startDateTfd.text = fromDateStr;
    endDateTfd.text = endDateStr;
    
    currentPage = 1;
    totalPages = 0;
    isScroll = NO;
    [self.scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
    [self getWebData];
     //[self setPortrait];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webservice)
        [webservice cancel];
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:YES]; 
}


- (void)dealloc
{
    [punishArray release];
    [super dealloc];
}

#pragma mark - URL connhelper delegate

-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0)
    {
        return;
    }
    isLoading = NO;
    //解析JSON格式数据
    NSString *resultJSON =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x09];
    NSString *str =[resultJSON stringByReplacingOccurrencesOfString:ctrlChar withString:@""];

    NSMutableArray *resultArray = [[NSMutableArray alloc] initWithArray:[str objectFromJSONString]];
    if(resultArray == nil || resultArray.count == 0)
    {
        return;
    }
    //NSLog(@"%@", resultJSON);
    //{"result":"failed","exception":"访问错误:参数【kssj: jssj: 】，不能为空"}
    self.nDataType = nDataNormal;
    NSDictionary *resultDic = [resultArray objectAtIndex:0];
    NSArray *keys = [resultDic allKeys];
    for (NSString *key in keys)
    {
        if ([key isEqualToString:@"COUNT"])
        {
            self.nDataType = nDataNone;
            break;
        }
        if ([key isEqualToString:@"exception"])
        {
            self.nDataType = nDataException;
            break;
        }
    }
    
    if(self.nDataType == nDataNormal)
    {
        NSDictionary *statusDict = [resultArray lastObject];
        if([[statusDict objectForKey:@"pageAmount"] intValue] > 0)
        {
            currentPage = [[statusDict objectForKey:@"currentPage"] intValue];
            totalPages = [[statusDict objectForKey:@"pageCount"] intValue];
            totalDataCount = [[statusDict objectForKey:@"pageAmount"] intValue];
            [resultArray removeObject:statusDict];
            
            //如果是在业务办理的已办处罚中，数据多了一个{"result":"true"}
            if([[[resultArray lastObject] allKeys] containsObject:@"result"])
            {
                [resultArray removeLastObject];
            }
            
            if(totalDataCount == 0)
            {
                currentPage = 0;
                totalPages = 0;
                totalDataCount = 0;
                [self.punishArray removeAllObjects];
                [self.doneTable reloadData];
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有满足查询条件的已办案件。" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                return;
            }
            
            if (!isScroll)
                [self.punishArray removeAllObjects];
            
            [self.punishArray addObjectsFromArray:resultArray];
            
            [self.doneTable reloadData];
            
            if ([resultArray count] == 50)
                self.scrollImage.hidden = NO;
            [resultArray release];
        }
    }
    else if(self.nDataType == nDataNone || self.nDataType == nDataException)
    {
        currentPage = 0;
        totalPages = 0;
        totalDataCount = 0;
        [self.punishArray removeAllObjects];
        [self.doneTable reloadData];
        
        // [{"COUNT":0},{"result":"true"},{"pageAmount":0,"pageSize":50,"currentPage":1,"pageCount":1}]
        //[{"result":"failed","exception":"访问错误:根据指定的参数,未获取到该任务信息"}]
        NSString *msg = [[resultArray objectAtIndex:0] objectForKey:@"exception"];
        if(msg == nil)
            msg = @"暂无数据";
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
    }
    

    
    
    
    
    /*NSArray *aryJson = [str objectFromJSONString];
    if(aryJson == nil)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"  message:@"查无数据"  delegate:nil
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
    
    
    {
        
        
        
        [resultArray removeLastObject];
        
        
        
    }  */
}


- (void)processError:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] 
                          initWithTitle:@"提示" 
                          message:@"请求数据失败,请检查网络连接并重试。" 
                          delegate:nil
                          cancelButtonTitle:@"确定" 
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    return;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [punishArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger index = [indexPath row];
    NSDictionary *aItem = [punishArray objectAtIndex:index];
    
    NSString *dwmc = listType == nYB ? [aItem objectForKey:@"B_DWMC"]:[aItem objectForKey:@"DWMC"];
    NSString *name = listType == nYB ? [NSString stringWithFormat:@"流程名称：%@",[aItem objectForKey:@"LCMC"]]:[NSString stringWithFormat:@"单位地址：%@",[aItem objectForKey:@"DWDZ"]];
    NSString *phase = listType == nYB ? [NSString stringWithFormat:@"办理阶段：%@",[aItem objectForKey:@"BZMC"]]:@"";
    //NSString *reason = [NSString stringWithFormat:@"执法事项：%@",[aItem objectForKey:@"ZFSX"]];
    NSString *jssj = listType == nYB ? [NSString stringWithFormat:@"步骤结束时间：%@",[[aItem objectForKey:@"JSSJ"] substringToIndex:10]]:[NSString stringWithFormat:@"案件性质：%@",[aItem objectForKey:@"AJXZMC"]];
    NSString *kssj = listType == nYB ? [NSString stringWithFormat:@"步骤开始时间：%@",[[aItem objectForKey:@"KSSJ"] substringToIndex:10]]:[NSString stringWithFormat:@"立案信息：%@",[aItem objectForKey:@"SFYLA"]];
    
    UITableViewCell *cell = [UITableViewCell makeSubCell:tableView withTitle:dwmc andSubvalue1:name andSubvalue2:jssj andSubvalue3:kssj andSubvalue4:phase andNoteCount:indexPath.row];
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    int count = 50*currentPage > totalDataCount ? totalDataCount : 50*currentPage;
    NSString *str = [NSString stringWithFormat:@"当前显示%d条，总共查到数据%d条",count,totalDataCount];
    return str;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{   
    NSDictionary *tmpDic = [punishArray objectAtIndex:indexPath.row];
    
    DonePunishDetailController *childView = [[[DonePunishDetailController alloc] initWithNibName:@"DonePunishDetailController" bundle:nil] autorelease];

    if (listType == nYB)
        [childView setItemID:[tmpDic objectForKey:@"BH"]];
    else
        childView.itemID = [tmpDic objectForKey:@"BWBH"];

    [self.navigationController pushViewController:childView animated:YES];
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
            [self.scrollImage setImage:[UIImage imageNamed:@"finishScroll.png"]];
		
    }
}

@end
