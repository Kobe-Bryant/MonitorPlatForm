//
//  DoneNoiseAllowVC.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-9.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "DoneNoiseAllowVC.h"
#import "MPAppDelegate.h"
#import "UITableViewCell+Custom.h"
#import "ServiceUrlString.h"
#import "DoneNoiseAllowDetailVC.h"
#import "JSONKit.h"
#import "LoginedUsrInfo.h"
#import "NoiseTastDetailViewController.h"

extern MPAppDelegate *g_appDelegate;

@implementation DoneNoiseAllowVC
@synthesize nDataType,webservice;
@synthesize doneDataAry,completedType,totalPages;
@synthesize isLoading,currentPage,listType;
@synthesize dateController,popController,currentTag,isScroll;

#define nDataNormal 1
#define nDataException 2
#define nDataNone 3

#define nYB 1
#define nTZ 2

#pragma mark - private methods

- (void)getWebData
{
    scrollImage.hidden = YES;
    
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    if (_isTastDone) {
        [param setObject:@"GET_RWCX_LIST" forKey:@"service"];
        [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
        [param setObject:@"44030100006" forKey:@"lclxbh"];
        [param setObject:@"0" forKey:@"sfdqbz"];
        if ([taskInfoField.text length] > 0)
            [param setObject:taskInfoField.text  forKey:@"rwxx"];
        
        if (completedTypeSeg.selectedSegmentIndex == 0)
            [param setObject:@"zcwc" forKey:@"wcqk"];
        else if (completedTypeSeg.selectedSegmentIndex == 1)
            [param setObject:@"cswc" forKey:@"wcqk"];
        
        if ([startDateTfd.text length] > 0)
            [param setObject:startDateTfd.text  forKey:@"startTime"];
        
        if ([endDateTfd.text length] > 0)
            [param setObject:endDateTfd.text forKey:@"endTime"];
      
    }
    else{
        if (listType == nYB)
            [param setObject:@"GET_ZSXK_DONE_LIST" forKey:@"service"];
        else
            [param setObject:@"GET_ZSXK_INFO_LIST" forKey:@"service"];
        
        [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
        [param setObject:@"41389071-3226-4dab-9c01-61eed5c944b4" forKey:@"lclx"];
        
        if ([taskInfoField.text length] > 0)
            [param setObject:taskInfoField.text forKey:@"rwxx"];
        
        if (completedTypeSeg.selectedSegmentIndex == 0)
            [param setObject:@"zcwc" forKey:@"type"];
        else if (completedTypeSeg.selectedSegmentIndex == 1)
            [param setObject:@"cswc" forKey:@"type"];
        
        if ([startDateTfd.text length] > 0)
            [param setObject:startDateTfd.text  forKey:@"kssj"];
        
        if ([endDateTfd.text length] > 0)
            [param setObject:endDateTfd.text  forKey:@"jssj"];
    }
   
    [param setObject:@"50" forKey:@"pageSize"];
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
        startDateTfd.text = @"";    
    else if (currentTag == 2)
        endDateTfd.text = @"";
    
	[self.popController presentPopoverFromRect:[tfd bounds] inView:tfd permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (IBAction)searchBtnPressed:(id)sender
{
    if ([startDateTfd.text length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"起始日期不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    if ([endDateTfd.text length] == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"截止日期不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }
    currentPage = 1;
    totalPages = 0;
    isScroll = NO;
    [scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
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
    [webservice release];
    [completedType release];
    [doneDataAry release];
    [dateController release];
    [popController release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if (listType == nYB)
        self.title = @"已办噪声许可查询列表";
    else if(_isTastDone)
    {
     
        self.title = @"已办噪声许可任务列表";
    }
    else{
        self.title = @"噪声许可台账列表";
        completedLbl.hidden = YES;
        completedTypeSeg.hidden = YES;
    }
        
    
    [startDateTfd addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    [endDateTfd addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    
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
    
    completedTypeSeg.selectedSegmentIndex = 2;
    
    self.doneDataAry = [NSMutableArray array];
    
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
    [scrollImage setImage:[UIImage imageNamed:@"upScroll.png"]];
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
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webservice)
        [webservice cancel];
    
    [super viewWillDisappear:YES];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [listTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
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
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"未获取到相关数据。" 
                              delegate:nil
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
        if (_isTastDone) {
            NSArray *arr = [resultDic objectForKey:@"beans"];
            if (arr.count==0) {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有满足查询条件的已办任务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alert show];
                [alert release];
                [self.doneDataAry removeAllObjects];
                [listTable reloadData];
                return;
            }
            NSDictionary *pageInfoDic = [resultDic objectForKey:@"pageInfo"];
            totalPages = [[pageInfoDic objectForKey:@"pageCount"]intValue];
            if (!isScroll)
                [self.doneDataAry removeAllObjects];
            
            [self.doneDataAry addObjectsFromArray:arr];
            [listTable reloadData];
        }
        else{
            
            NSDictionary *pageInfoDic = [resultArray lastObject];
            currentPage = [[pageInfoDic objectForKey:@"currentPage"] intValue];
            totalPages = [[pageInfoDic objectForKey:@"pageCount"] intValue];
            
            [resultArray removeLastObject];
            
            if (!isScroll)
                [self.doneDataAry removeAllObjects];
            
            [self.doneDataAry addObjectsFromArray:resultArray];
            [listTable reloadData];
           }
       
        
        if ([resultArray count] == 50)
            scrollImage.hidden = NO;
        
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有满足查询条件的已办案件" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
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
	return 80;
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
    return @"查询结果";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (_isTastDone) {
        NSUInteger index = [indexPath row];
        NSDictionary *aItem = [doneDataAry objectAtIndex:index];
        
        NSString *code = [NSString stringWithFormat:@"办理人：%@",[aItem objectForKey:@"YHM"]];
        NSString *phase = [NSString stringWithFormat:@"办理阶段：%@",[aItem objectForKey:@"BZMC"]];
        NSString *reason = @"";
        NSString *timeLimit = [NSString stringWithFormat:@"办理期限：%@",[aItem objectForKey:@"LCQX"]];
        NSArray *dateArr = [timeLimit componentsSeparatedByString:@" "];
        if (dateArr.count>=2) {
            timeLimit = [dateArr objectAtIndex:0];
        }
        NSString *titleStr = [NSString stringWithFormat:@"%@\n%@",[aItem objectForKey:@"B_DWMC"],[aItem objectForKey:@"LCMC"]];
        cell = [UITableViewCell makeSubCell:tableView
                                                   withTitle:titleStr
                                                    caseCode:code
                                               complaintDate:phase
                                                     endDate:timeLimit
                                                        Mode:reason];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        for (UIView *view in cell.contentView.subviews) {
            if (view.tag == 1111) {
                [view removeFromSuperview];
            }
        }
        
        CGRect rect =CGRectMake(0, 3, 40, 72);;
        UILabel *lb = [[UILabel alloc] initWithFrame:rect];
        lb.text = [NSString stringWithFormat:@"%i、",indexPath.row+1];
        lb.tag = 1111;
        lb.textAlignment = UITextAlignmentCenter;
        lb.backgroundColor = [UIColor clearColor];
        [cell.contentView addSubview:lb];
        [lb release];        
    }
    else{
        NSUInteger index = [indexPath row];
        NSDictionary *tmpDic = [doneDataAry objectAtIndex:index];
        NSString *xmmc = [tmpDic objectForKey:@"GDMC"];
        NSString *jsdw = [NSString stringWithFormat:@"建设单位：%@",[tmpDic objectForKey:@"JSDW"]];
        NSString *qpsj = [tmpDic objectForKey:@"QPSJ"];
        if ([qpsj length] > 10)
            qpsj = [qpsj substringToIndex:10];
        
        //cell editing
        CGRect tRect1;
        CGRect tRect2;
        CGRect tRect3;
        NSString *cellIdentifier;
        
        tRect1 = CGRectMake(20, 0, 708, 55);
        tRect2 = CGRectMake(20, 55, 454, 25);
        tRect3 = CGRectMake(474, 55, 254, 25);
        cellIdentifier = @"cell_portraitProjectsList";
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
        }
        
        UILabel* lblTitle = nil;
        UILabel* lblCode = nil;
        UILabel* lblCDate = nil;
        
        if (cell.contentView != nil)
        {
            lblTitle = (UILabel *)[cell.contentView viewWithTag:1];
            lblCode = (UILabel *)[cell.contentView viewWithTag:2];
            lblCDate = (UILabel *)[cell.contentView viewWithTag:3];
        }
        
        
        if (lblTitle == nil) {
            
            lblTitle = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
            [lblTitle setBackgroundColor:[UIColor clearColor]];
            [lblTitle setTextColor:[UIColor blackColor]];
            lblTitle.font = [UIFont fontWithName:@"Helvetica" size:20.0];
            lblTitle.textAlignment = UITextAlignmentLeft;
            lblTitle.numberOfLines = 2;
            lblTitle.tag = 1;
            [cell.contentView addSubview:lblTitle];
            [lblTitle release];
            
            
            lblCode = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
            [lblCode setBackgroundColor:[UIColor clearColor]];
            [lblCode setTextColor:[UIColor grayColor]];
            lblCode.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            lblCode.textAlignment = UITextAlignmentLeft;
            lblCode.tag = 2;
            [cell.contentView addSubview:lblCode];
            [lblCode release];
            
            
            
            lblCDate = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
            [lblCDate setBackgroundColor:[UIColor clearColor]];
            [lblCDate setTextColor:[UIColor grayColor]];
            lblCDate.font = [UIFont fontWithName:@"Helvetica" size:15.0];
            lblCDate.textAlignment = UITextAlignmentLeft;
            lblCDate.tag = 3;
            [cell.contentView addSubview:lblCDate];
            [lblCDate release];
            
            
            
            lblTitle.backgroundColor = [UIColor clearColor];
            lblCode.backgroundColor = [UIColor clearColor];
            lblCDate.backgroundColor = [UIColor clearColor];
        }
        
        if (lblTitle != nil)	[lblTitle setText:xmmc];
        if (lblCode != nil)     [lblCode setText:jsdw];
        if (lblCDate != nil)	[lblCDate setText:[NSString stringWithFormat:@"签批时间：%@",qpsj]];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //cell.selectionStyle = UITableViewCellSelectionStyleGray;

    }
      
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isTastDone) {
        NSDictionary *dic = [doneDataAry objectAtIndex:indexPath.row];
        
        NoiseTastDetailViewController *detail = [[NoiseTastDetailViewController alloc] initWithNibName:@"NoiseTastDetailViewController" bundle:nil];
        detail.yhid = [dic objectForKey:@"YHBH"];
        detail.bwbhnew = [dic objectForKey:@"BH"];
        detail.ywxtbh = [dic objectForKey:@"YWXTBH"];
        detail.SFZB = [dic objectForKey:@"SFZB"];
        detail.BZDYBH  = [dic objectForKey:@"BZDYBH"];
        detail.BZBH = [dic objectForKey:@"BZBH"];
        detail.lclxbh = @"44030100006";
        detail.hasDone = YES;
        [self.navigationController pushViewController:detail animated:YES];
        [detail release];

    }
    else{
        NSUInteger row = [indexPath row];
        NSDictionary *tmpDic = [doneDataAry objectAtIndex:row];
        
        DoneNoiseAllowDetailVC *childView = [[[DoneNoiseAllowDetailVC alloc] initWithNibName:@"DoneNoiseAllowDetailVC" bundle:nil] autorelease];
        
        NSString *complaintNum = [tmpDic objectForKey:@"SQDJBH"];
        childView.complaintNum = complaintNum;
        [self.navigationController pushViewController:childView animated:YES];
    }
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0)
//        [self.navigationController popViewControllerAnimated:YES];
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
            [scrollImage setImage:[UIImage imageNamed:@"finishScroll.png"]];
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
            startDateTfd.text = dateString;
        
        if (currentTag == 2)
            endDateTfd.text = dateString;
    }
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return NO;
}


@end
