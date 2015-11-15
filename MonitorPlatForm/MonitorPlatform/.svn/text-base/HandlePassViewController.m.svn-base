//
//  HandlePassViewController.m
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-2-14.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "HandlePassViewController.h"
#import "PunishController.h"
#import "JSONKit.h"
#import "ProcesserInfoItem.h"
#import "QQList.h"
#import "ServiceUrlString.h"
#import "ComplaintsListViewController.h"
#import "MPAppDelegate.h"
#import "NoiseAllowViewController.h"

extern MPAppDelegate *g_appDelegate;

@implementation HandlePassViewController
@synthesize processTable,usualOpinionBtn,noticeLabel,opinionText,signature;
@synthesize saveForUsual,rewrite,pass,nDataType,backgroundView;
@synthesize letterVisitNum,allInfo,qqListAry,peopleSelected;
@synthesize nAlertStatus,nParseStatus,nLinker,jyyBtn,ljcBtn;
@synthesize wordsSelectViewController,wordsPopoverController,webservice;
@synthesize opinionSelectVC,opinionPopover;
@synthesize isChangeUser,changeUserID;

#define Alert_rewrite 1
#define Alert_pass 2
#define Alert_success 3
#define Alert_fail 4
#define Alert_receive 5
#define Alert_transfer 6

#define receiveData 1
#define transferData 2

#define respect_tag 1
#define linkword_tag 3


#define nComplaint 1
#define nPunish 2
#define nZSXK   3

#define nDataNormal 1
#define nDataException 2
#define nDataNone 3

#pragma mark - Private methods

- (void)setLandscape
{
    self.noticeLabel.frame = CGRectMake(18, 28, 986, 35);
    self.processTable.frame = CGRectMake(25, 109, 265, 500);
    self.opinionText.frame = CGRectMake(402, 146, 550, 208);
    self.signature.frame = CGRectMake(491, 397, 226, 31);
    
    self.usualOpinionBtn.frame = CGRectMake(418, 484, 130, 36);
    self.jyyBtn.frame = CGRectMake(776, 484, 130, 36);
    self.saveForUsual.frame = CGRectMake(592, 527, 130, 36);
    self.ljcBtn.frame = CGRectMake(592, 484, 130, 36);
    self.rewrite.frame = CGRectMake(418, 527, 130, 36);
    self.pass.frame = CGRectMake(776, 527, 130, 36);       
    
    self.backgroundView.image = [UIImage imageNamed:@"allbg_landscape.png"];
}

- (void)setPortrait
{
    self.noticeLabel.frame = CGRectMake(20, 23, 728, 35);
    self.processTable.frame = CGRectMake(27, 121, 218, 540);
    self.opinionText.frame = CGRectMake(343, 141, 346, 208);
    self.signature.frame = CGRectMake(438, 375, 226, 31);
    
    self.usualOpinionBtn.frame = CGRectMake(364, 431, 130, 36);
    self.jyyBtn.frame = CGRectMake(364, 478, 130, 36);
    self.saveForUsual.frame = CGRectMake(364, 527, 130, 36);
    self.ljcBtn.frame = CGRectMake(538, 431, 130, 36);
    self.rewrite.frame = CGRectMake(538, 478, 130, 36);
    self.pass.frame = CGRectMake(538, 528, 130, 36);    
    
    self.backgroundView.image = [UIImage imageNamed:@"allbg.png"];
}

//QQ列表数据处理
- (void)loadQQData
{
    ProcesserInfoItem *aItem;
    
    [qqListAry removeAllObjects];
    int departCount = [allInfo count];
    for (int i=0; i<departCount; i++) 
    {
        aItem = [allInfo objectAtIndex:i];
        QQList *list = [[[QQList alloc] init] autorelease];
        list.m_nID = i; //  分组依据
        list.m_strGroupName = [NSString stringWithString:aItem.stepDesc];
        list.m_arrayPersons = [[[NSMutableArray alloc] init] autorelease];
        ///////////////////////////////////////////////////////////////fix
        list.opened = NO;
        list.indexPaths = [NSMutableArray arrayWithCapacity:10];
        ///////////////////////////////////////////////////////////////fix
            
        int personCount = [aItem.processers count];
            
        NSDictionary *aDic;
        for (int j = 0; j < personCount; j++) 
        {
            aDic = [aItem.processers objectAtIndex:j];
            QQPerson *person = [[[QQPerson alloc] init] autorelease];
            person.m_nListID = j; //  分组依据	
            person.m_strPersonName = [aDic objectForKey:@"cname"];
            person.m_strDept = [aDic objectForKey:@"cdept"];
            [list.m_arrayPersons addObject:person];
            ///////////////////////////////////////////////////////////////fix
            [list.indexPaths addObject:[NSIndexPath indexPathForRow:j inSection:i]];
            ///////////////////////////////////////////////////////////////fix
        }
        [qqListAry addObject:list];
    }
    
    [self.processTable reloadData];
}

//获取页面必要数据
- (void)getNecessaryData
{
    if (nLinker == nComplaint) {
        self.nParseStatus = receiveData;
        self.nAlertStatus = Alert_receive;
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
        [param setObject:@"GET_XFTS_FORWORD_INFO" forKey:@"service"];
        [param setObject:@"41389071-3226-4dab-9c01-61eed5c944b4" forKey:@"lcbh"];
        [param setObject:letterVisitNum forKey:@"xfxh"];
        [param setObject:changeUserID forKey:@"yhid"];
        
        NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
    
        self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
    } 
    
    if (nLinker == nPunish) {
        self.nParseStatus = receiveData;
        self.nAlertStatus = Alert_receive;

        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
        [param setObject:@"GET_WORKFLOW_FORWORD_INFO" forKey:@"service"];
        [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
        [param setObject:changeUserID forKey:@"yhid"];
        [param setObject:letterVisitNum forKey:@"bwbh"];
        
        NSString *requestString = [ServiceUrlString generateXZCFUrlByParameters:param];
        
        self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
    }
    else if (nLinker == nZSXK){
    
        self.nParseStatus = receiveData;
        self.nAlertStatus = Alert_receive;
        
        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:5];
        [param setObject:@"GET_PUBLIC_WORKFLOW_FORWORD_INFO" forKey:@"service"];
        [param setObject:@"44030100006" forKey:@"lcbh"];
        [param setObject:changeUserID forKey:@"yhid"];
        [param setObject:letterVisitNum forKey:@"ywxtbh"];
        
        NSString *requestString = [ServiceUrlString generateUrlByParameters:param];
        self.webservice = [[[NSURLConnHelper alloc] initWithUrl:requestString andParentView:self.view delegate:self] autorelease];
      
    }
}


//常用意见存储路径
- (NSString *)usualOpinionpath
{
	NSString* documentsDirectory  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
	NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"usual_transfer.config"];
	
    return filePath;	
}

//保存为常用意见按钮触发方法
- (IBAction)saveForUsualPressed:(id)sender
{
    //点击按钮取消键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    NSString *filePath = [self usualOpinionpath];
	NSArray *ary =[NSArray arrayWithContentsOfFile:filePath];
    //不存在则初始化
	if (ary == nil || [ary count] == 0) {
		ary =[NSArray arrayWithObjects:@"同意。",@"不同意。",@"已阅。",@"请局领导传阅。",  nil];
		[ary writeToFile:filePath atomically:YES];
	}
	NSMutableArray *newAry = [NSMutableArray arrayWithArray:ary];
    //判断是否为空意见
    if ([opinionText.text length] == 0) {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"意见栏为空，请输入意见再保存模版" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        [alter release];
        
        return;
    }
	//判断本地标准语句是否有重复
	BOOL isEqual = NO;
    for (NSString *oldItem in newAry) 
    {
        if ([opinionText.text isEqualToString:oldItem]) {
            isEqual = YES;
        }
    }
    if (!isEqual) {
        [newAry addObject:opinionText.text];
        [newAry writeToFile:filePath atomically:YES];
        
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"保存意见模版成功，在常用意见弹出窗体中可以找到" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        [alter release];
    } 
    else
    {
        UIAlertView *alter = [[UIAlertView alloc] initWithTitle:@"提示" message:@"意见模版已存在，无需保存" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alter show];
        [alter release];
    }
}

//重写按钮触发方法
- (IBAction)rewritePressed:(id)sender
{
    
    self.nAlertStatus = Alert_rewrite;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                    message:@"确定要重写意见吗？" 
                                                   delegate:self 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
}

//流传按钮触发
- (IBAction)passPressed:(id)sender
{
    //点击按钮取消键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    self.nAlertStatus = Alert_pass;
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" 
                                                    message:@"确定要将本条任务流转出去吗？"
                                                   delegate:self 
                                          cancelButtonTitle:@"确定" 
                                          otherButtonTitles:@"取消", nil];
    [alert show];
    [alert release];
}

- (IBAction)usualOpinionPressed:(id)sender
{
    if (wordsPopoverController != nil) {
        [wordsPopoverController dismissPopoverAnimated:YES];
    }
    UIControl *ctrl = (UIControl*)sender;
    NSString *filePath = [self usualOpinionpath];
	NSArray *ary =[NSArray arrayWithContentsOfFile:filePath];
    //不存在则初始化
	if (ary == nil || [ary count] == 0) {
		ary =[NSArray arrayWithObjects:@"同意。",@"不同意。",@"已阅。",@"请局领导传阅。",  nil];
		[ary writeToFile:filePath atomically:YES];
	}
    
    opinionSelectVC.wordsAry = [NSMutableArray arrayWithArray:ary];
	[opinionSelectVC.tableView reloadData];
	[self.opinionPopover presentPopoverFromRect:ctrl.frame
                                         inView:self.view
                       permittedArrowDirections:UIPopoverArrowDirectionAny
                                       animated:YES];
}

- (IBAction)shortcutButtonPressed:(id)sender
{
    if (wordsPopoverController != nil) {
        [wordsPopoverController dismissPopoverAnimated:YES];
    }
    UIControl *ctrl = (UIControl*)sender;
    
    switch (ctrl.tag) {
        case linkword_tag:
            wordsSelectViewController.wordsAry = [NSArray arrayWithObjects:@"阅处",@"阅办",@"阅示",@"跟进",@"办理",@"妥否",@"请示",@"先提出意见",@"研究",@"会签", nil];
            break;
        
        case respect_tag:
            wordsSelectViewController.wordsAry = [NSArray arrayWithObjects:@"请",@"让",@"至", nil];
            break;

        default:
            break;
    }

	[wordsSelectViewController.tableView reloadData];
	[wordsPopoverController presentPopoverFromRect:ctrl.frame
												 inView:self.view
							   permittedArrowDirections:UIPopoverArrowDirectionAny
											   animated:YES];
}

-(void)goBackAction{
    //点击按钮取消键盘
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    [self.navigationController popViewControllerAnimated:YES];
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
    [super dealloc];
    
    [processTable release];
    [usualOpinionBtn release];
    [noticeLabel release];
    [opinionText release];
    [signature release];
    [saveForUsual release];
    [rewrite release];
    [pass release];
    [letterVisitNum release];
    [allInfo release];
    [qqListAry release];
    [peopleSelected release];
    [wordsSelectViewController release];
    [wordsPopoverController release];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"手工流转";
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy'年'MM'月'dd'日'"];
    NSString *timeStr = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
    [self.signature setText:[NSString stringWithFormat:@"%@%@",g_appDelegate.userCNName,timeStr]];
    
    self.allInfo = [NSMutableArray arrayWithCapacity:10];
    self.qqListAry = [NSMutableArray arrayWithCapacity:10];
    
    CommenWordsViewController *tmpController = [[[CommenWordsViewController alloc] initWithNibName:@"CommenWordsViewController" bundle:nil] autorelease];
	tmpController.contentSizeForViewInPopover = CGSizeMake(220, 300);
	tmpController.delegate = self;
    UIPopoverController *tmppopover = [[[UIPopoverController alloc] initWithContentViewController:tmpController] autorelease];
	self.wordsSelectViewController = tmpController;
    self.wordsPopoverController = tmppopover;
    
    self.opinionSelectVC = [[[UsualOpinionVC alloc] initWithStyle:UITableViewStylePlain] autorelease];
    opinionSelectVC.contentSizeForViewInPopover = CGSizeMake(400, 400);
	opinionSelectVC.delegate = self;
    UINavigationController *nav = [[[UINavigationController alloc] initWithRootViewController:opinionSelectVC] autorelease];
    self.opinionPopover = [[[UIPopoverController alloc] initWithContentViewController:nav] autorelease];
    
    [self getNecessaryData];
    [self setPortrait];
    if(nLinker == nComplaint){
        opinionText.text= @"请人居委信访办审阅。";
    }
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
    
    if (wordsPopoverController)
        [wordsPopoverController dismissPopoverAnimated:YES];
    
    [super viewWillDisappear:YES];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    
    [self.opinionText resignFirstResponder];
    [self.processTable reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

#pragma mark - Alert view delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
    if (alertView.tag==100) {
        if (buttonIndex==0) {
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
    }
    if (buttonIndex == 0) {
        if (nAlertStatus == Alert_rewrite)
            opinionText.text = @"";
        
        else if (nAlertStatus == Alert_receive || nAlertStatus == Alert_fail)
            [self.navigationController popViewControllerAnimated:YES];
        
        else if (nAlertStatus == Alert_transfer)
            return;
        
        else if (nAlertStatus == Alert_success) {
            /*
            if (nLinker == nComplaint) {
                NSArray *controllers = [self.navigationController viewControllers];
                for (UIViewController *controller in controllers)
                    if ([controller isKindOfClass:[ComplaintsListViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                        break;
                    }
            }
            if (nLinker == nZSXK) {
                NSArray *controllers = [self.navigationController viewControllers];
                for (UIViewController *controller in controllers)
                    if ([controller isKindOfClass:[NoiseAllowViewController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                        break;
                    }
            }

            
            if (nLinker == nPunish) {
                NSArray *controllers = [self.navigationController viewControllers];
                for (UIViewController *controller in controllers)
                    if ([controller isKindOfClass:[PunishController class]]) {
                        [self.navigationController popToViewController:controller animated:YES];
                        break;
                    }
            }
             */
             NSArray *controllers = [self.navigationController viewControllers];
            for (UIViewController *controller in controllers)
                if ([controller isKindOfClass:[ComplaintsListViewController class]]||[controller isKindOfClass:[PunishController class]]||[controller isKindOfClass:[NoiseAllowViewController class]]) {
                    [self.navigationController popToViewController:controller animated:YES];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshData" object:nil];
                    break;
                }

        }
        
        else if (nAlertStatus == Alert_pass) {
            if ([opinionText.text length] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"提示" 
                                      message:@"录入意见不能为空"  
                                      delegate:nil 
                                      cancelButtonTitle:@"确定" 
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
        
            if ([peopleSelected count] == 0) {
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"提示" 
                                      message:@"请选择处理人"  
                                      delegate:nil 
                                      cancelButtonTitle:@"确定" 
                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
                return;
            }
        
             
            NSMutableString *str1 = [NSMutableString string];
            NSString *bianhaostr = nil;
           // NSString *buzhoustr = nil;
            
            for (ProcesserInfoItem *aItem in peopleSelected)
            {
                [str1 appendString:[NSString stringWithFormat:@"%@#",aItem.nextProcesserID]];
                bianhaostr = aItem.stepID;
              //  buzhoustr = aItem.stepDesc;
            }
            NSString *str2 = [str1 substringToIndex:[str1 length]-1];
           
            if (nLinker == nComplaint) {
                NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:15];
                [param setObject:@"XFTS_WORKFLOW_FORWORD" forKey:@"service"];
                [param setObject:bianhaostr forKey:@"toStepId"];
                [param setObject:str2 forKey:@"toProcessers"];
                [param setObject:opinionText.text forKey:@"forwordMsg"];
                [param setObject:changeUserID forKey:@"yhid"];
                [param setObject:letterVisitNum forKey:@"xfxh"];
                [param setObject:@"41389071-3226-4dab-9c01-61eed5c944b4" forKey:@"lcbh"];
               
                NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
        
                self.nParseStatus = transferData;
                self.nAlertStatus = Alert_transfer;
                self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
            }
            
            if (nLinker == nPunish) {
                NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:15];
                [param setObject:@"WORKFLOW_FORWORD" forKey:@"service"];
                [param setObject:bianhaostr forKey:@"toStepId"];
                [param setObject:str2 forKey:@"toProcessers"];
                [param setObject:opinionText.text forKey:@"forwordMsg"];
                [param setObject:changeUserID forKey:@"yhid"];
                [param setObject:letterVisitNum forKey:@"bwbh"];
                [param setObject:@"4e033baa-9bab-439f-b483-4ca632bea3dd" forKey:@"lcbh"];
               
                NSString *urlString = [ServiceUrlString generateXZCFUrlByParameters:param];
                
                self.nParseStatus = transferData;
                self.nAlertStatus = Alert_transfer;
                self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
            }
            if (nLinker == nZSXK) {
                
                NSMutableDictionary *param = [NSMutableDictionary dictionaryWithCapacity:15];
                [param setObject:@"PUBLIC_WORKFLOW_FORWORD" forKey:@"service"];
                [param setObject:bianhaostr forKey:@"toStepId"];
                [param setObject:str2 forKey:@"toProcessers"];
                [param setObject:opinionText.text forKey:@"forwordMsg"];
                [param setObject:changeUserID forKey:@"yhid"];
                [param setObject:letterVisitNum forKey:@"ywxtbh"];
                [param setObject:@"44030100006" forKey:@"lcbh"];
                
                NSString *urlString = [ServiceUrlString generateUrlByParameters:param];
                
                self.nParseStatus = transferData;
                self.nAlertStatus = Alert_transfer;
                self.webservice = [[[NSURLConnHelper alloc] initWithUrl:urlString andParentView:self.view delegate:self] autorelease];
            }
        }
    }
}

#pragma mark - NSURLConnhelper delegate
-(void)processWebData:(NSData*)webData
{
    if([webData length] <=0 )
        return;
    NSString *resultJSON = [[[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding] autorelease];
    
    
    
    if (nParseStatus == receiveData) {
        self.nDataType = nDataNormal;
        
        //异常或无数据的处理
        NSMutableArray *resultArray = [NSMutableArray arrayWithArray:[resultJSON objectFromJSONString]];
        if (resultArray.count==0) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"获取不到流转信息" delegate:self cancelButtonTitle:@"确定 " otherButtonTitles:nil, nil];
            alert.tag = 100;
            [alert show];
            [alert release];
            return;
        }
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
            self.nAlertStatus = Alert_fail;
            NSString *msg = [NSString stringWithFormat:@"访问错误: %@",[resultDic objectForKey:@"exception"]];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        if (nDataType == nDataNone){
            self.nAlertStatus = Alert_fail;
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"本案件没有流转目标" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];
            return;
        }
        
        if (nLinker == nPunish)
            [resultArray removeLastObject];
        
        ProcesserInfoItem *aItem;
        NSMutableString *processStr = [NSMutableString string];
        for (NSDictionary *ksDic in resultArray) 
        {   
            aItem = [[ProcesserInfoItem alloc] init];
            aItem.stepID = [ksDic objectForKey:@"childStepId"];
            aItem.stepDesc = [ksDic objectForKey:@"childStepDesc"];
            [processStr appendFormat:@"[%@],",aItem.stepDesc];
            aItem.processers = [ksDic objectForKey:@"processers"];
            if ([[ksDic objectForKey:@"canSplit"] intValue] == 1)
                aItem.canSplit = YES;
            
            [allInfo addObject:aItem];
            [aItem release];
        }
        
        
        self.noticeLabel.text = [NSString stringWithFormat:@"您可以选择%@进行并行处理。",[processStr substringToIndex:[processStr length]-1]];
        
        self.peopleSelected = [NSMutableArray arrayWithCapacity:50];
        [self loadQQData];
    }
    
    if (nParseStatus == transferData) {
        NSArray * resultArray = [resultJSON objectFromJSONString];
        NSDictionary *tmpDic = [resultArray lastObject];
        NSString *transferResult = [tmpDic objectForKey:@"result"];
        
        if ([transferResult isEqualToString:@"success"]) {
            self.nAlertStatus = Alert_success;
            UIAlertView *alert = [[UIAlertView alloc] 
                                  initWithTitle:@"提示" 
                                  message:@"流转成功"  
                                  delegate:self 
                                  cancelButtonTitle:@"确定" 
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] 
                                  initWithTitle:@"提示" 
                                  message:@"流转失败"  
                                  delegate:nil 
                                  cancelButtonTitle:@"确定" 
                                  otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
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

#define HEADER_HEIGHT 59

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return HEADER_HEIGHT;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [qqListAry count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    QQList *persons = [qqListAry objectAtIndex:section];
	if ([persons opened]) {
		return [persons.m_arrayPersons count]; // 人员数
		
	} else {
		return 0;	// 不展开
	}
}

-(UIView*)tableView:(UITableView*)tableView viewForHeaderInSection:(NSInteger)section 
{
	QQList *persons = [qqListAry objectAtIndex:section];
	QQSectionHeaderView *sectionHeadView = [[QQSectionHeaderView alloc] 
                                            initWithFrame:CGRectMake(0.0, 0.0, self.processTable.bounds.size.width, HEADER_HEIGHT) 
                                            title:persons.m_strGroupName 
                                            section:section 
                                            opened:persons.opened
                                            delegate:self];
    [sectionHeadView setBackgroundWithPortrait:@"cellBG_type2.png" andLandscape:@"cellBG_type2_landscape.png"];
	return [sectionHeadView autorelease];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath 
{
	return 56;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"HandlePass_Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    QQList *persons = [qqListAry objectAtIndex:indexPath.section];
    QQPerson *person = [persons.m_arrayPersons objectAtIndex:indexPath.row];
    
	NSString *str = [NSString stringWithFormat:@"%@   (%@)",person.m_strPersonName,person.m_strDept];
    [cell textLabel].text = str;	
	[cell textLabel].font = [UIFont boldSystemFontOfSize:15.0];
	    
    cell.accessoryType = UITableViewCellAccessoryNone;
    for (ProcesserInfoItem *aItem in peopleSelected) {
        if ([person.m_strPersonName isEqualToString:aItem.nextProcesser]&&[persons.m_strGroupName isEqualToString:aItem.stepDesc]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    QQList *persons = [qqListAry objectAtIndex:indexPath.section];
    QQPerson *person = [persons.m_arrayPersons objectAtIndex:indexPath.row];
	UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.accessoryType == UITableViewCellAccessoryCheckmark) {
        for (ProcesserInfoItem *aItem in peopleSelected) 
            if ([person.m_strPersonName isEqualToString:aItem.nextProcesser]) {
                [peopleSelected removeObject:aItem];
                break;
            }  
    }
    else
    {
        ProcesserInfoItem *selectedItem = [[ProcesserInfoItem alloc] init];
        ProcesserInfoItem *aItem = [allInfo objectAtIndex:indexPath.section];
        
        NSDictionary *dic = [aItem.processers objectAtIndex:indexPath.row];
        selectedItem.nextProcesser = [dic objectForKey:@"cname"];
        selectedItem.nextProcesserID = [dic objectForKey:@"cid"];
        selectedItem.stepID = aItem.stepID ;
        selectedItem.stepDesc = aItem.stepDesc;
        selectedItem.processers = aItem.processers;
        selectedItem.canSplit = aItem.canSplit;
        
        if (!aItem.canSplit)
            [peopleSelected removeAllObjects];
        else
        {
            if ([peopleSelected count] > 0)
            {
                NSMutableIndexSet *indexSetTmp = [NSMutableIndexSet indexSet];
                for (int i=0;i<[peopleSelected count];i++)
                {
                    ProcesserInfoItem *removeItem = [peopleSelected objectAtIndex:i];
                    if (![removeItem.stepDesc isEqualToString:aItem.stepDesc])
                    {
                        NSUInteger indexTmp = i;
                        [indexSetTmp addIndex:indexTmp];
                    }
                }
                
                [peopleSelected removeObjectsAtIndexes:indexSetTmp];
            }
        }
        
        [peopleSelected addObject:selectedItem];
        [selectedItem release];
    }
	[self.processTable reloadData];
}

#pragma mark - QQ section header view delegate

-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionClosed:(NSInteger)section
{
	QQList *persons = [qqListAry objectAtIndex:section];
    persons.opened = !persons.opened;
	
	// 收缩+动画 (如果不需要动画直接reloaddata)
	NSInteger countOfRowsToDelete = [processTable numberOfRowsInSection:section];
    if (countOfRowsToDelete > 0) 
    {
        ///////////////////////////////////////////////////////////////fix
		//        persons.indexPaths = [[NSMutableArray alloc] init];
		//        for (NSInteger i = 0; i < countOfRowsToDelete; i++)
		//            [persons.indexPaths addObject:[NSIndexPath indexPathForRow:i inSection:section]];
        ///////////////////////////////////////////////////////////////fix
		
        [self.processTable deleteRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationTop];
    }
}


-(void)sectionHeaderView:(QQSectionHeaderView*)sectionHeaderView sectionOpened:(NSInteger)section
{
	QQList *persons = [qqListAry objectAtIndex:section];
	persons.opened = !persons.opened;
	
	// 展开+动画 (如果不需要动画直接reloaddata)
    ///////////////////////////////////////////////////////////////fix
	//if(persons.indexPaths){
    if ([persons.m_arrayPersons count] > 0)
    {
		[self.processTable insertRowsAtIndexPaths:persons.indexPaths withRowAnimation:UITableViewRowAnimationBottom];
	}
	//persons.indexPaths = nil;
    ///////////////////////////////////////////////////////////////fix
}


#pragma mark - Words delegate
- (void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row
{
    BOOL focus = NO;
	focus = [opinionText isFirstResponder];
	if (!focus) {
		[opinionText becomeFirstResponder];		
	}
    
    NSMutableString *opinionStr = [NSMutableString string];
    [opinionStr appendString:opinionText.text];
    [opinionStr appendString:words];
    [self.opinionText setText:opinionStr];
    
    if (wordsPopoverController != nil) {
        [wordsPopoverController dismissPopoverAnimated:YES];
    }
}

#pragma mark - Text view delegate

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"在此输入意见"])
        [textView setText:@""];
    
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIInterfaceOrientationLandscapeRight || statusBarOrientation == UIInterfaceOrientationLandscapeLeft){
        NSTimeInterval animationDuration=0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width=self.view.frame.size.width;
        float height=self.view.frame.size.height;
        CGRect rect=CGRectMake(0.0f,-140,width,height);//上移，按实际情况设置
        self.view.frame=rect;
        [UIView commitAnimations];
        return ;
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIInterfaceOrientationLandscapeRight || statusBarOrientation == UIInterfaceOrientationLandscapeLeft){
        NSTimeInterval animationDuration=0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        float width=self.view.frame.size.width;
        float height=self.view.frame.size.height;
        CGRect rect=CGRectMake(0.0f,0.0f,width,height);
        self.view.frame=rect;
        [UIView commitAnimations];
    }
}

#pragma mark - UsualOpinion delegate

- (void)returnSelectedOpinion:(NSString *)words
{
    if([opinionText.text length] <= 0)
        opinionText.text = words;
    else{
        //定位光标
        NSRange range = [opinionText selectedRange];
        NSMutableString *top = [[NSMutableString alloc] initWithString:[opinionText text]];
        NSString *addName = [NSString stringWithFormat:@"%@",words];
        [top insertString:addName atIndex:range.location];
        opinionText.text = top;
        [top release];
        int opLoaction = [addName length] + range.location ;
        opinionText.selectedRange = NSMakeRange(opLoaction, 0);
        
    }
    
    if (opinionPopover)
        [opinionPopover dismissPopoverAnimated:YES];
}

- (void)refreshUsualOpinions:(NSArray *)opinionsAry
{
    NSString *filePath = [self usualOpinionpath];
    [opinionsAry writeToFile:filePath atomically:YES];
}
@end
