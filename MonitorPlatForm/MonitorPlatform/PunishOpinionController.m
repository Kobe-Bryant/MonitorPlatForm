//
//  PunishOpinionController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-23.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "PunishOpinionController.h"
#import "ReturnBackViewController.h"
#import "AttachmentViewController.h"
#import "HandlePassViewController.h"
#import "ServiceUrlString.h"
#import <QuartzCore/QuartzCore.h>
#import "UITableViewCell+Custom.h"
#import "MPAppDelegate.h"
#import "JSONKit.h"
#import "ZrsUtils.h"
#import "LoginedUsrInfo.h"
//#import "WebServiceHelper.h"

extern MPAppDelegate *g_appDelegate;

@implementation PunishOpinionController
@synthesize itemID,infoDic,nParserStatus,attachArray,saveBtn,webservice;
@synthesize titleArr,titleArr2,valueArr,valueArr2,currentRect,qprqLabel;
@synthesize trueProof,programProof,processArray,currentString,qprLabel;
@synthesize infoTableView,opinionTextView,nameTextField,dateTextField;
@synthesize popController,dateController,bCommit,nDataType,qpyjLabel,cellHeightAry;

#define nBaseData 1
#define nProcessData 2
#define nTruthAttachData 3
#define nProgramAttachData 4
#define nSaveOpinion 5

#define nDataNormal 1
#define nDataException 2
#define nDataNone 3

#pragma mark - Private methods

- (void)setLandscape
{
    self.opinionTextView.frame = CGRectMake(113, 20, 891, 48);
    self.qprqLabel.frame = CGRectMake(424, 85, 85, 31);
    self.dateTextField.frame = CGRectMake(517, 85, 175, 31);
    self.saveBtn.frame = CGRectMake(860, 80, 108, 42);
}

- (void)setPortrait
{
    self.opinionTextView.frame = CGRectMake(113, 20, 635, 48);
    self.qprqLabel.frame = CGRectMake(346, 85, 85, 31);
    self.dateTextField.frame = CGRectMake(439, 85, 175, 31);
    self.saveBtn.frame = CGRectMake(640, 79, 108, 42);
}

- (void)getWebData
{
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_COMPLAINT_DETAIL" forKey:@"service"];
    [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
    [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
    [param setObject:itemID forKey:@"bwbh"];
    
    NSString *requestString = [ServiceUrlString generateXZCFUrlByParameters:param];
    
    self.nParserStatus = nBaseData;
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
}

- (void)dealingString:(NSString *)string
{
    NSRange midRang = [string rangeOfString:@"####"];
    NSString *trueString = [string substringToIndex:midRang.location];
    NSString *processString = [string substringFromIndex:midRang.location + midRang.length];
    
    // 解析事实证据字符串
    NSRange itemRang = [trueString rangeOfString:@"~~"];
    while (itemRang.location != NSNotFound) {
        NSMutableDictionary *tmpDic = [[NSMutableDictionary alloc] initWithCapacity:4];
        
        NSString *aItem = [trueString substringToIndex:itemRang.location];
        NSRange rang = [aItem rangeOfString:@"##"];
        NSString *zjxx = [aItem substringToIndex:rang.location];
        [tmpDic setObject:zjxx forKey:@"证据信息"];
        aItem = [aItem substringFromIndex:rang.location + rang.length];
        rang = [aItem rangeOfString:@"##"];
        NSString *ywxldm = [aItem substringToIndex:rang.location];
        [tmpDic setObject:ywxldm  forKey:@"YWXLDM"];
        aItem = [aItem substringFromIndex:rang.location + rang.length];
        rang = [aItem rangeOfString:@"##"];
        NSString *userID = [aItem substringToIndex:rang.location];
        [tmpDic setObject:userID  forKey:@"上传人"];
        NSString *bmbh = [aItem substringFromIndex:rang.location + rang.length];
        [tmpDic setObject:bmbh forKey:@"部门编号"];
        
        [self.trueProof addObject:tmpDic];
        [tmpDic release];
        
        
        trueString = [trueString substringFromIndex:itemRang.location + itemRang.length];
        itemRang = [trueString rangeOfString:@"~~"];
    }
   
    // 解析程序证据字符串
    NSRange itemRang1 = [processString rangeOfString:@"~~"];
    while (itemRang1.location != NSNotFound) {
        NSMutableDictionary *tmpDic1 = [[NSMutableDictionary alloc] initWithCapacity:4];
        
        NSString *aItem1 = [processString substringToIndex:itemRang1.location];
        NSRange rang1 = [aItem1 rangeOfString:@"##"];
        NSString *zjxx1 = [aItem1 substringToIndex:rang1.location];
        [tmpDic1 setObject:zjxx1  forKey:@"证据信息"];
        aItem1 = [aItem1 substringFromIndex:rang1.location + rang1.length];
        rang1 = [aItem1 rangeOfString:@"##"];
        NSString *ywxldm1 = [aItem1 substringToIndex:rang1.location];
        [tmpDic1 setObject:ywxldm1  forKey:@"YWXLDM"];
        aItem1 = [aItem1 substringFromIndex:rang1.location + rang1.length];
        rang1 = [aItem1 rangeOfString:@"##"];
        NSString *userID1 = [aItem1 substringToIndex:rang1.location];
        [tmpDic1 setObject:userID1 forKey:@"上传人"];
        NSString *bmbh1 = [aItem1 substringFromIndex:rang1.location + rang1.length];
        [tmpDic1 setObject:bmbh1  forKey:@"部门编号"];
        
        [self.programProof addObject:tmpDic1];
        [tmpDic1 release];
        
        
        processString = [processString substringFromIndex:itemRang1.location + itemRang1.length];
        itemRang1 = [processString rangeOfString:@"~~"];
    }
    
}

- (IBAction)saveButtonPressed:(id)sender
{
    //点击按钮取消键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
    [param setObject:@"GET_COMPLAINT_UPDATE" forKey:@"service"];
    [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
    [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
    [param setObject:itemID forKey:@"bwbh"];
    [param setObject:opinionTextView.text  forKey:@"qpyj"];
    [param setObject:nameTextField.text forKey:@"qpr"];
    [param setObject:dateTextField.text  forKey:@"qpsj"];
    
    NSString *requestString = [ServiceUrlString generateXZCFUrlByParameters:param];
    
    self.nParserStatus = nSaveOpinion;
    self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
}

- (IBAction)HandlePassing:(id)sender 
{
    if (bCommit) {
    
        HandlePassViewController *childView = [[HandlePassViewController alloc] initWithNibName:@"HandlePassViewController" bundle:nil];
    
        [childView setLetterVisitNum:itemID];
        [childView setNLinker:2];
        childView.changeUserID = _userid;
        [self.navigationController pushViewController:childView animated:YES];
        [childView release];
        
    } else {
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"请先输入签批意见并保存"
                              delegate:nil 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

- (IBAction)GetBack:(id)sender 
{
    if (bCommit) {
        ReturnBackViewController *childView = [[ReturnBackViewController alloc] initWithNibName:@"ReturnBackViewController" bundle:nil];
    
        [childView setLetterVisitNum:itemID];
        [childView setNLinker:2];
        childView.changeUserID = _userid;
        [self.navigationController pushViewController:childView animated:YES];
        [childView release];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:@"签批意见尚未保存，请保存签批意见"  
                              delegate:nil 
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(IBAction)touchFromDate:(id)sender{
	UIControl *btn =(UIControl*)sender;
    
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    dateController.myPicker.date = [dateFormatter dateFromString:dateTextField.text];
    
	[popController presentPopoverFromRect:[btn bounds] inView:btn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

- (void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate*)date{ 
	[popController dismissPopoverAnimated:YES];
	if (bSaved) {
		NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
		[dateFormatter setDateFormat:@"yyyy-MM-dd"];
		NSString *dateString = [dateFormatter stringFromDate:date];
		[dateFormatter release];  
		self.dateTextField.text = dateString;
	}
}

#pragma mark - View lifecycle

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"处罚建议签批";
    
    self.cellHeightAry = [NSMutableArray array];
    
    self.bCommit = NO;
    
    self.opinionTextView.layer.borderColor = UIColor.grayColor.CGColor;
    self.opinionTextView.layer.borderWidth = 2;
    
    self.nameTextField.text = g_appDelegate.userCNName;
    NSDateFormatter *dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.dateTextField.text = [dateFormatter stringFromDate:[NSDate date]];
    
    [self.dateTextField addTarget:self action:@selector(touchFromDate:) forControlEvents:UIControlEventTouchDown];
    
    PopupDateViewController *date = [[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate];
	self.dateController = date;
	dateController.delegate = self;
	[date release];
	
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:nav];
	self.popController = popover;
	[popover release];
	[nav release];
    
    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"手工流转" style:UIBarButtonItemStyleBordered target:self action:@selector(HandlePassing:)];
    UIBarButtonItem *aItem2 = [[UIBarButtonItem alloc] initWithTitle:@"退回" style:UIBarButtonItemStyleBordered target:self action:@selector(GetBack:)];
    
    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(600, 0, 160, 44)];
    [tools setTintColor:[self.navigationController.navigationBar tintColor]]; 
	[tools setAlpha:[self.navigationController.navigationBar alpha]]; 
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:8];
    [buttons addObject:aItem];
    [buttons addObject:aItem2];
    [aItem release];
    [aItem2 release];
    [tools setItems:buttons animated:NO];
    [buttons release];
    
    UIBarButtonItem *myBItem = [[UIBarButtonItem alloc] initWithCustomView:tools];
    
	self.navigationItem.rightBarButtonItem = myBItem;
    [myBItem release]; 
	[tools release];
    /*
    UIBarButtonItem *aItem = [[UIBarButtonItem alloc] initWithTitle:@"手工流转" style:UIBarButtonItemStyleBordered target:self action:@selector(HandlePassing:)];
    UIBarButtonItem *aItem2 = [[UIBarButtonItem alloc] initWithTitle:@"退回" style:UIBarButtonItemStyleBordered target:self action:@selector(GetBack:)];
    UIBarButtonItem *fixed = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:self action:nil];
    fixed.width = 20;
    NSArray *rightButtons = [NSArray arrayWithObjects:aItem2, fixed, aItem, nil];
    self.navigationItem.rightBarButtonItems = rightButtons;
    [aItem release];
    [aItem2 release];
    [fixed release];*/
    
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
    [super viewDidAppear:animated];
    UIDeviceOrientation deviceOrientation = [UIDevice currentDevice].orientation;
    if (UIDeviceOrientationIsLandscape(deviceOrientation)) 
        [self setLandscape];
    else 
        [self setPortrait];
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (webservice)
        [webservice cancel];
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation ==UIInterfaceOrientationLandscapeRight) 
        [self setLandscape];
    else 
        [self setPortrait];
    
    [self.opinionTextView resignFirstResponder];
    [self.nameTextField resignFirstResponder];
    
    [self.infoTableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (void)dealloc
{
    [itemID release];
    [infoDic release];
    [processArray release];
    [attachArray release];
    [titleArr release];
    [titleArr2 release];
    [valueArr release];
    [valueArr2 release];
    [trueProof release];
    [programProof release];
    [popController release];
    [dateController release];
    [currentString release];
    [super dealloc];
}

#pragma mark - URL ConnHelper delegate

-(void)processWebData:(NSData*)webData
{
    if ([webData length] <=0 )
        return;
    
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    
    NSString *str =[[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    
    NSString *ctrlChar = [NSString stringWithFormat:@"%c",0x0A];
    NSString *resultJSON =[str stringByReplacingOccurrencesOfString:ctrlChar withString:@""]; 
    
    if (nParserStatus == nBaseData) {
       
        
        self.nDataType = nDataNormal;
        

        NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[resultJSON objectFromJSONString]];

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
        
        if (nDataType == nDataException) {
            
            NSString *msg = [NSString stringWithFormat:@"访问错误,请联系处罚系统维护人员"];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        } 
        if (nDataType == nDataNone) {
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有案件基本信息数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }

        self.infoDic = [resultArray objectAtIndex:0];
        self.trueProof = [NSMutableArray arrayWithCapacity:5];
        self.programProof = [NSMutableArray arrayWithCapacity:5];
        [self dealingString:[infoDic objectForKey:@"证据目录及附件"]];
            
        /*self.titleArr = [NSArray arrayWithObjects:@"处罚对象",@"单位地址",@"法人代表姓名",@"联系人",@"所属行政区",@"案件来源",@"处罚建议部门",@"经办人姓名",@"经办人意见",@"审核日期",@"违法行为简况",@"违反条款",@"处罚依据", nil];
        self.titleArr2 = [NSArray arrayWithObjects:@"被处罚单位",@"所属行业",@"法人代表电话",@"联系人电话",@"邮政编码",@"执法事项",@"执法人员",@"经办日期",@"审核人",@"审核意见", nil];*/
        self.titleArr = [NSArray arrayWithObjects:@"处罚对象:",@"单位地址:",@"法人代表姓名:",@"联系人:",@"所属行政区:",@"案件来源:",@"处罚建议部门:",@"经办人姓名:",@"经办人意见:",@"审核日期:",@"违法行为简况:",@"违反条款:",@"处罚依据:", nil];
        self.titleArr2 = [NSArray arrayWithObjects:@"被处罚单位:",@"所属行业:",@"法人代表电话:",@"联系人电话:",@"邮政编码:",@"执法事项:",@"执法人员:",@"经办日期:",@"审核人:",@"审核意见:", nil];
        
        NSString *shrq = [infoDic objectForKey:@"审核日期"];
        if ([shrq length] > 10)
            shrq = [shrq substringToIndex:10];
        
        self.valueArr = [NSArray arrayWithObjects:[infoDic objectForKey:@"被罚对象"],[infoDic objectForKey:@"单位地址"],[infoDic objectForKey:@"法定代表人姓名"],[infoDic objectForKey:@"联系人"],[infoDic objectForKey:@"行政区划"],[infoDic objectForKey:@"案件来源"],[infoDic objectForKey:@"处罚建议部门"],[infoDic objectForKey:@"经办人姓名"],[infoDic objectForKey:@"经办人意见"],shrq,[infoDic objectForKey:@"违法行为简况"],[infoDic objectForKey:@"违反条款"],[infoDic objectForKey:@"处罚依据"], nil];
        
        NSNumber *yzbm = [infoDic objectForKey:@"邮政编码"];
        
        NSString *jbrq = [infoDic objectForKey:@"经办日期"];
        if ([jbrq length] > 10)
            jbrq = [jbrq substringToIndex:10];
        self.valueArr2 = [NSArray arrayWithObjects:[infoDic objectForKey:@"被罚单位"],[infoDic objectForKey:@"行业内容"],[infoDic objectForKey:@"电话"],[infoDic objectForKey:@"联系电话"],[yzbm stringValue],[infoDic objectForKey:@"执法事项"],[infoDic objectForKey:@"执法人员"],jbrq,[infoDic objectForKey:@"审核人"],[infoDic objectForKey:@"审核意见"], nil];
        
        if ([cellHeightAry count] > 0)
            [cellHeightAry removeAllObjects];
        
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        CGFloat width;
        if (UIDeviceOrientationIsLandscape(orientation))
            width = 1024/10*3-20;
        else
            width = 768/10*3-20;
        
        for (int i = 0;i < [valueArr2 count];i++)
        {
            NSString *valueStr1 = [valueArr objectAtIndex:i];
            CGFloat height1 = [ZrsUtils calculateTextHeight:valueStr1 byFontSize:19 andWidth:width];
            NSString *valueStr2 = [valueArr2 objectAtIndex:i];
            CGFloat height2 = [ZrsUtils calculateTextHeight:valueStr2 byFontSize:19 andWidth:width];
            if (height1 < height2)
                height1 = height2;
            [cellHeightAry addObject:[NSNumber numberWithFloat:height1]];
        }
        
        if (UIDeviceOrientationIsLandscape(orientation))
            width = 1024/10*8-20;
        else
            width = 768/10*8-20;
        
        for (int i = 3;i > 0;i--) {
            NSString *valueStr = [valueArr objectAtIndex:[valueArr count]-i];
            CGFloat height = [ZrsUtils calculateTextHeight:valueStr byFontSize:19 andWidth:width];
            [cellHeightAry addObject:[NSNumber numberWithFloat:height]];
        }
            
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
        [param setObject:@"GET_WORKFLOW_LIST" forKey:@"service"];
        [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
        [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
        [param setObject:itemID forKey:@"bwbh"];
      
        NSString *requestString = [ServiceUrlString generateXZCFUrlByParameters:param];
            
        self.nParserStatus = 2;
        self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
        
    } else if (nParserStatus == nProcessData) {

        //NSString *resultJSON = @"[{\"result\":\"false\",\"exception\":\"访问错误:查询数据时发生异常：ORA-00904: U_POWER.P_GETDATE: invalid identifier \"}]";
        //NSArray *tmpArray = [resultJSON JSONValue];
        self.nDataType = nDataNormal;
        
        //异常或无数据的处理
        NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[resultJSON objectFromJSONString]];
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
        
        if (nDataType == nDataException) {
            NSString *msg = [NSString stringWithFormat:@"访问错误: %@",[resultDic objectForKey:@"exception"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        if (nDataType == nDataNone) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有案件流程信息数据" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        
        [resultArray removeLastObject];
        self.processArray = [NSArray arrayWithArray:resultArray];
        [self.infoTableView reloadData];
        
    
    } else if (nParserStatus == nSaveOpinion) {
        

        NSArray *tmpArray = [resultJSON objectFromJSONString];
        
        NSDictionary *reDic = [tmpArray lastObject];
        NSString *result = [reDic objectForKey:@"result"];
        if ([result isEqualToString:@"true"]) {
            self.bCommit = YES;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
            
    } else {

        NSArray *tmpArray = [resultJSON objectFromJSONString];
        
        self.attachArray = [NSArray arrayWithArray:tmpArray];
        NSMutableArray *fjmcArr = [NSMutableArray arrayWithCapacity:10];
        
        for (NSDictionary *tmpDic in attachArray) {
            NSString *fjmc = [tmpDic objectForKey:@"FJMC"];
            if ([fjmc length] > 0)
                [fjmcArr addObject:fjmc];
        }
        
        UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
        
        AttachesListController *childView = [[AttachesListController alloc] initWithStyle:UITableViewStylePlain];;
        [childView setDelegate:self];
        [childView setAttachesList:fjmcArr];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:childView];
        nav.modalPresentationStyle =  UIModalPresentationFormSheet;
        [self presentModalViewController:nav animated:YES];
        if (statusBarOrientation == UIInterfaceOrientationPortrait)
            nav.view.superview.frame = CGRectMake(368, 624, 400, 400);
        else 
            nav.view.superview.frame = CGRectMake(624, 368, 400, 400);
        [nav release];
        [childView release];
    }
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
    return;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger count;
    if (section == 0) {
        if (titleArr)
            count = [titleArr count];
        else
            count = 1;
    }
    else if (section == 1){
        if (trueProof)
            count = [trueProof count];
        else
            count = 1;
    } else if (section == 2) {
        if (programProof)
            count = [programProof count];
        else
            count = 1;
    } else {
        if (processArray)
            count = [processArray count];
        else
            count = 1;
    }
    
    if (count < 1)
        count = 1;
    
    return count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0)
        return @"处罚案件基本信息";
    else if (section == 1)
        return @"事实证据";
    else if (section == 2)
        return @"程序证据";
    else 
        return @"案件处理流程";
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row%2 == 0 && indexPath.section == 0)
        cell.backgroundColor = LIGHT_BLUE_UICOLOR;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    CGFloat height;
	if (indexPath.section == 0) {
        if ([cellHeightAry count] > 0)
            height = [[cellHeightAry objectAtIndex:indexPath.row] floatValue];
        else
            height = 44;
    }
    else if (indexPath.section == 3)
        
        height = 99;
    
    else if (indexPath.section == 1) {
        if ([trueProof count] > 0) {
            NSDictionary *tmpDic = [trueProof objectAtIndex:indexPath.row];
            NSString *zjxx = [tmpDic objectForKey:@"证据信息"];
            zjxx = [NSString stringWithFormat:@"%d、%@",indexPath.row+1,zjxx];
            
            UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            CGFloat width;
            if (UIDeviceOrientationIsLandscape(orientation))
                width = 1024-50;
            else
                width = 768-50;
            
            height = [ZrsUtils calculateTextHeight:zjxx byFontSize:19 andWidth:width];
        }
        else
        {
            height = 44;
        }
        
    } else {
        if ([programProof count] > 0)
        {
            NSDictionary *tmpDic = [programProof objectAtIndex:indexPath.row];
            NSString *zjxx = [tmpDic objectForKey:@"证据信息"];
            zjxx = [NSString stringWithFormat:@"%d、%@",indexPath.row+1,zjxx];
            
            UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
            CGFloat width;
            if (UIDeviceOrientationIsLandscape(orientation))
                width = 1024-50;
            else
                width = 768-50;
            
            height = [ZrsUtils calculateTextHeight:zjxx byFontSize:19 andWidth:width];
        }
        else
        {
            height = 44;
        }
    }
    
    if (height < 44)
        height = 44;
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!titleArr) {
        static NSString *CellIdentifier = @"Cell";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        }
        
        return cell;
    }
    
    UITableViewCell *cell;
    NSInteger row = [indexPath row];
    NSInteger section = [indexPath section];
    
    if (section == 0) {
        CGFloat cellHeight = [[cellHeightAry objectAtIndex:row] floatValue];
        
        if (row < [titleArr2 count]) {
            NSArray *valueAry = [NSArray arrayWithObjects:[titleArr objectAtIndex:row],[valueArr objectAtIndex:row],[titleArr2 objectAtIndex:row],[valueArr2 objectAtIndex:row], nil];
            
            cell = [UITableViewCell makeCoupleLabelsCell:tableView coupleCount:2 cellHeight:cellHeight valueArray:valueAry];
        }
        else {
            NSArray *valueAry = [NSArray arrayWithObjects:[titleArr objectAtIndex:row],[valueArr objectAtIndex:row], nil];
            
            cell = [UITableViewCell makeCoupleLabelsCell:tableView coupleCount:1 cellHeight:cellHeight valueArray:valueAry];
        }
        
    }
    else if (section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"TrueProof_Cell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TrueProof_Cell"] autorelease];
        }
        
        if ([trueProof count] > 0) {
            NSDictionary *tmpDic = [trueProof objectAtIndex:row];
            NSString *zjxx = [tmpDic objectForKey:@"证据信息"];
            cell.textLabel.text = [NSString stringWithFormat:@"%d、%@",row+1,zjxx];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        } else
            cell.textLabel.text = @"暂无证据信息";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    else if (section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"ProgramProof_Cell"];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ProgramProof_Cell"] autorelease];
        }
        
        if ([programProof count] > 0) {
            NSDictionary *tmpDic = [programProof objectAtIndex:row];
            NSString *zjxx = [tmpDic objectForKey:@"证据信息"];
            cell.textLabel.text = [NSString stringWithFormat:@"%d、%@",row+1,zjxx];
            cell.textLabel.numberOfLines = 0;
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
            cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
        } else
            cell.textLabel.text = @"暂无证据信息";
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    else {
        
        NSDictionary *tmpDic = [processArray objectAtIndex:row];
        NSString *status = [NSString stringWithFormat:@"当前状态：%@",[tmpDic objectForKey:@"DQZT"]];
        NSString *type = [NSString stringWithFormat:@"办理类型：%@",[tmpDic objectForKey:@"SFZB"]];
        NSString *opinion = [NSString stringWithFormat:@"办理意见：%@",[tmpDic objectForKey:@"CLRYJ"]];
        NSString *person = [NSString stringWithFormat:@"办理人：%@",[tmpDic objectForKey:@"YHM"]];
        NSString *date = [NSString stringWithFormat:@"完成时间：%@",[tmpDic objectForKey:@"JSSJ"]];
        
        cell = [UITableViewCell makeSubCell:tableView 
                                      Title:[tmpDic objectForKey:@"BZMC"] 
                                    Opinion:opinion 
                                     Status:status 
                                       Type:type 
                                     Person:person 
                                       Date:date];
        
    }
    
    return cell;
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    
    if (indexPath.section == 1) {
        NSDictionary *tmpDic = [trueProof objectAtIndex:indexPath.row];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
        [param setObject:@"GET_COMPLAINTS_FILE_LIST" forKey:@"service"];
        [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
        [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
        [param setObject:itemID forKey:@"bwbh"];
        [param setObject:@"cfjy" forKey:@"ywlx"];
        [param setObject:@"sszj" forKey:@"ywxl"];
        [param setObject:[tmpDic objectForKey:@"YWXLDM"] forKey:@"ywxldm"];
      
        NSString *requestString = [ServiceUrlString generateXZCFUrlByParameters:param];
        self.nParserStatus = 3;
        
        currentRect = CGRectMake(700, 500, 50, 50);
        self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
    }
    else {
        NSDictionary *tmpDic = [programProof objectAtIndex:indexPath.row];
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:10];
        [param setObject:@"GET_COMPLAINTS_FILE_LIST" forKey:@"service"];
        [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
        [param setObject:usrInfo.userPinYinName forKey:@"yhid"];
        [param setObject:itemID forKey:@"bwbh"];
        [param setObject:@"cfjy" forKey:@"ywlx"];
        [param setObject:@"cxzj" forKey:@"ywxl"];
        [param setObject:[tmpDic objectForKey:@"YWXLDM"] forKey:@"ywxldm"];
        
        NSString *requestString = [ServiceUrlString generateXZCFUrlByParameters:param];
        self.nParserStatus = 4;
        
        currentRect = CGRectMake(700, 500, 50, 50);
        self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
    }
    
}

#pragma mark - Return row delegate

- (void)returnSelectedRow:(NSInteger)row {
    NSDictionary *tmpDic = [attachArray objectAtIndex:row];
    
    AttachmentViewController *childView = [[AttachmentViewController alloc] initWithNibName:@"AttachmentViewController" bundle:nil];
    [childView setCode:[tmpDic objectForKey:@"FJBH"]];
    [childView setAttachmentName:[tmpDic objectForKey:@"FJMC"]];
    [childView setAttachmentType:[tmpDic objectForKey:@"FJLX"]];
    [childView setNLinkerType:2];
    
    [self.navigationController pushViewController:childView animated:YES];
    [childView release];
}

#pragma mark - UITextField delegate
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
        [self.navigationController popViewControllerAnimated:YES];
}

@end
