//
//  QueryBuildingProjectVC.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-9-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "QueryBuildingProjectVC.h"
#import "JSONKit.h"
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "BuildingProjectDetailVC.h"
#import "ServiceUrlString.h"
#import "NSDateUtil.h"

extern MPAppDelegate *g_appDelegate;

@implementation QueryBuildingProjectVC
@synthesize resultAry,dmzAry,webservice;
@synthesize gxgsValue,wordsPopover,wordSelectCtrl;
@synthesize dateController,popController,currentTag;
@synthesize isLoading,isScroll,currentPage,totalPages;

#pragma mark - Private methods

- (void)requestData
{
    scrollImage.hidden = YES;
    isLoading = YES;
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
    [param setObject:@"QUERY_GCXM_INFO_LIST" forKey:@"service"];
    [param setObject:@"20" forKey:@"pageSize"];
    [param setObject:[NSString stringWithFormat:@"%d",currentPage] forKey:@"currentPage"];
    
    if ([gxgsFie.text length] > 0)
        [param setObject:gxgsValue forKey:@"gxgs"];

    if ([gcxxFie.text length] > 0)
        [param setObject:gcxxFie.text  forKey:@"gcxx"];
        
    if ([kssjFie.text length] > 0)
        [param setObject:kssjFie.text forKey:@"kssj"];
    
    if ([jssjFie.text length] > 0)
        [param setObject:jssjFie.text  forKey:@"jssj"];
    
    NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
}

- (IBAction)searchBtnPressed:(id)sender
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    currentPage = 1;
    isScroll = NO;
    [self requestData];
}

- (void)selectWord:(id)sender
{
    if (wordsPopover)
        [wordsPopover dismissPopoverAnimated:YES];
    
    UITextField *fie = (UITextField *)sender;
    fie.text = @"";
    
    wordSelectCtrl.wordsAry = [NSArray arrayWithObjects:@"深圳市人居环境委员会",@"深圳市水源保护区办公室",@"福田区环保局",@"罗湖区环保局",@"南山区环保局",@"盐田区环保局",@"宝安区环保局",@"龙岗区环保局",@"光明新区城建局",@"坪山新区环保局", nil];
    
    [wordSelectCtrl.tableView reloadData];
    [wordsPopover presentPopoverFromRect:[fie bounds] inView:fie permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)touchFromDate:(id)sender
{
    UITextField *tfd =(UITextField*)sender;
    currentTag = tfd.tag;
    
    if (currentTag == 1)
        kssjFie.text = @"";
    
    if (currentTag == 2)
        jssjFie.text = @"";
    
	[self.popController presentPopoverFromRect:[tfd bounds] inView:tfd permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

#pragma mark - View lifecycle

- (void)dealloc
{
    [resultAry release];
    [dmzAry release];
    [webservice release];
    [gxgsValue release];
    [popController release];
    [dateController release];
    [wordsPopover release];
    [wordSelectCtrl release];
    
    [super dealloc];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dmzAry = [NSArray arrayWithObjects:@"440301",@"440309",@"440304",@"440303",@"440305",@"440308",@"440306",@"440307",@"440302",@"440310", nil];
        self.resultAry = [NSMutableArray array];
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
    
    self.title = @"建筑工程项目查询";
    
    //日期选择功能初始化
    [kssjFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    [jssjFie addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    
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
    
    //管辖归属可选功能初始化
    [gxgsFie addTarget:self action:@selector(selectWord:) forControlEvents:UIControlEventTouchDown];
    CommenWordsViewController *wordCtrl = [[CommenWordsViewController alloc] initWithStyle:UITableViewStylePlain];
    [wordCtrl setContentSizeForViewInPopover:CGSizeMake(320, 400)];
    self.wordSelectCtrl = wordCtrl;
    wordSelectCtrl.delegate = self;
    UIPopoverController *popCtrl = [[UIPopoverController alloc] initWithContentViewController:wordSelectCtrl];
    self.wordsPopover = popCtrl;
    [wordCtrl release];
    [popCtrl release];
    
    //获取默认数据
    NSDate *nowDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *endDateStr = [dateFormatter stringFromDate:nowDate];
    
    [dateFormatter release];
    kssjFie.text = [NSDateUtil firstDateThisYear];
    jssjFie.text = endDateStr;
    
    gxgsFie.text = @"深圳市人居环境委员会";
    self.gxgsValue = @"440301";
    
    currentPage = 1;
    isScroll = NO;
    [self requestData];
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
    
    if (wordsPopover)
        [wordsPopover dismissPopoverAnimated:YES];
    
    if (popController)
        [popController dismissPopoverAnimated:YES];
    
    [super viewWillDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [listTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
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
            kssjFie.text = dateString;
        
        if (currentTag == 2)
            jssjFie.text = dateString;
    }
}

#pragma mark - Words Delegate

- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    gxgsFie.text = words;
    self.gxgsValue = [dmzAry objectAtIndex:row];
    
    [wordsPopover dismissPopoverAnimated:YES];
}

#pragma mark - URL connhelper delegate 

-(void)processWebData:(NSData*)webData 
{
    isLoading = NO;
    if([webData length] <=0 )  
        return;    
    NSString *resultJSON =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];  
    NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x09];   
    NSString *str =[resultJSON stringByReplacingOccurrencesOfString:ctrlChar withString:@""];    
    NSArray *oneAry = [str objectFromJSONString];
    NSMutableArray *tmpAry = [NSMutableArray arrayWithArray:oneAry]; 
    
    NSDictionary *tmpDic = [tmpAry objectAtIndex:0];
    NSArray *keyAry = [tmpDic allKeys];
    BOOL bSuccess = YES;   
    for (NSString *key in keyAry)   
    {         
        if ([key isEqualToString:@"result"])   
        {
            NSString *msg = [tmpDic objectForKey:@"exception"];
            if (msg == nil) {
                msg = @"查无数据";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];    
            [alert release];   
            bSuccess = NO;     
            break;        
        }  
    }          
    if (bSuccess)   
    {         
        NSDictionary *pageDic = [tmpAry lastObject];
        
        currentPage = [[pageDic objectForKey:@"currentPage"] intValue];
        totalPages = [[pageDic objectForKey:@"pageCount"] intValue]; 
        
        [tmpAry removeLastObject];
        
        if (!isScroll)
            [resultAry removeAllObjects];
        
        if ([gcxxFie.text length]!= 0)
        {
            for (NSDictionary* dic in tmpAry)
            {
                NSString* str = [dic objectForKey:@"GCXMMC"];
                NSInteger count = 0;
                NSLog(@"%d",[str length]);
                for (int i=0,j=0;i<[str length] ; i++)
                {
                    int k = 0;
                    NSString* strGC = [str substringWithRange:NSMakeRange(i, 1)];
                    while (j<[gcxxFie.text length]&&k<[gcxxFie.text length])
                    {
                        NSString* strFie = [gcxxFie.text substringWithRange:NSMakeRange(j, 1)];
                        if ([strGC isEqualToString:strFie]) {
                            count++;
                            j++;
                            break;
                        }
                        k++;
                    }
                }
                if (count == [gcxxFie.text length])
                {
                    [resultAry addObject:dic];
                }
            }
        }else
        {
            [resultAry addObjectsFromArray:tmpAry];
        }
        
        
        if ([tmpAry count] == 20)
            scrollImage.hidden = NO;
        
        [listTable reloadData];
    }
    else
    {
        currentPage = 0;
        totalPages = 0;
        [resultAry removeAllObjects];
        [listTable reloadData];
    }
}

- (void)processError:(NSError *)error
{    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                    message:@"请求数据失败,请检查网络连接并重试。" 
                                                   delegate:self 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:nil]; 
    [alert show];   
    [alert release]; 
    return; 
} 

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
	if (isLoading)
    {
       return; 
    }
    if (scrollView.contentSize.height - scrollView.contentOffset.y <= 850 )
    {
        currentPage++;
        if (currentPage <= totalPages)
        {
            isScroll = YES;
            [self requestData];
        }
        else
        {
            [scrollImage setImage:[UIImage imageNamed:@"finishScroll.png"]];
        }
    }
}

#pragma mark - UITextField delegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
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
    return [resultAry count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"查询结果";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSUInteger index = [indexPath row];
    NSDictionary *tmpDic = [resultAry objectAtIndex:index];
    NSString *gcxmmc = [tmpDic objectForKey:@"GCXMMC"];
    NSString *jsdw = [NSString stringWithFormat:@"建设单位：%@",[tmpDic objectForKey:@"JSDW"]];
    NSString *sgdw = [NSString stringWithFormat:@"施工单位：%@",[tmpDic objectForKey:@"SGDW"]];
    
    //cell editing
    CGRect tRect1;
    CGRect tRect2;
    CGRect tRect3;
    NSString *cellIdentifier;
    
    tRect1 = CGRectMake(20, 0, 708, 55);
    tRect2 = CGRectMake(20, 55, 354, 25);
    tRect3 = CGRectMake(374, 55, 354, 25);
    cellIdentifier = @"cell_portraitProjectsList";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
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
	
	if (lblTitle != nil)	[lblTitle setText:gcxmmc];
	if (lblCode != nil)     [lblCode setText:jsdw];
	if (lblCDate != nil)	[lblCDate setText:sgdw];

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleGray;
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *tmpDic = [resultAry objectAtIndex:indexPath.row];
    BuildingProjectDetailVC *childVC = [[[BuildingProjectDetailVC alloc] initWithNibName:@"BuildingProjectDetailVC" bundle:nil] autorelease];
    childVC.sbdjbh = [tmpDic objectForKey:@"GCXMSBDJH"];
    childVC.wrybh = [tmpDic objectForKey:@"WRYBH"];
    [self.navigationController pushViewController:childVC animated:YES];
}

@end
