//
//  AssignmentViewController.m
//  MonitorPlatform
//
//  Created by PowerData on 14-2-13.
//  Copyright (c) 2014年 博安达. All rights reserved.
//

#import "AssignmentViewController.h"
#import "CommenWordsViewController.h"
#import "PopupDateViewController.h"
#import "ServiceUrlString.h"
#import "NSURLConnHelper.h"
#import "JSONKit.h"
#import "UsersHelper.h"
#import "UISearchSitesController.h"
#import "PersonChooseVC.h"
#import "LoginedUsrInfo.h"
#import "RIButtonItem.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD.h"
#import "DataSyncManagerEx.h"

#define kTtypeSceneTag 1
#define kTtypeGeneralTag 2
#define kPollutionNameTag 3
#define kWebRWBHTag 4
#define kWebRWZPTag 5

@interface AssignmentViewController ()<UITextFieldDelegate,UITextViewDelegate,NSURLConnHelperDelegate,WordsDelegate,SelectSitesDelegate,PopupDateDelegate,PersonChooseResult>
@property (nonatomic, strong) UIPopoverController *popController;
@property (nonatomic, strong) NSURLConnHelper *webHelper;
@property (nonatomic, strong) NSArray *moldArray;
@property (nonatomic, strong) NSArray *typeArray;
@property (nonatomic, strong) NSArray *intArray;
@property (nonatomic, strong) NSArray *slrArray;
@property (nonatomic, strong) MBProgressHUD *HUD;
@property (nonatomic, strong) NSDate *selectDate;
@property (nonatomic, strong) NSString *rwlx;
@property (nonatomic, strong) NSString *zflxxl;
@property (nonatomic, strong) NSString *wrybh;
@property (nonatomic, strong) NSString *rwbh;
@property (nonatomic, assign) NSInteger saveTag;
@property (nonatomic, assign) NSInteger webTag;
@end

@implementation AssignmentViewController
@synthesize isTastDone,HUD;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillDisappear:(BOOL)animated{
    if (self.webHelper)
    {
        [self.webHelper cancel];
    }
    
    //加上这句话在跳转回主界面的时候不会在屏幕最上面出现一个白条
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"任务指派";
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]initWithTitle:@"指派" style:UIBarButtonItemStylePlain target:self action:@selector(barButtonPress:)];
    self.navigationItem.rightBarButtonItem = barButton;
    [barButton release];

    self.pollutionAddress.delegate = self;
    self.representative.delegate = self;
    self.phoneNumber.delegate = self;
    
    self.taskDescription.layer.borderColor = [UIColor grayColor].CGColor;
    self.taskDescription.layer.borderWidth =1.0;
    self.taskDescription.layer.cornerRadius =5.0;
  
    [self.sceneTextField addTarget:self action:@selector(textFieldTouchDon:) forControlEvents:UIControlEventTouchDown];
    self.sceneTextField.tag = kTtypeSceneTag;
    self.sceneTextField.delegate = self;
    
    [self.generalTextField addTarget:self action:@selector(textFieldTouchDon:) forControlEvents:UIControlEventTouchDown];
    self.generalTextField.tag = kTtypeGeneralTag;
    self.generalTextField.delegate = self;
    
    [self.pollutionName addTarget:self action:@selector(textFieldTouchDon:) forControlEvents:UIControlEventTouchDown];
    self.pollutionName.tag = kPollutionNameTag;
    self.pollutionName.delegate = self;
    
    [self.missionTime addTarget:self action:@selector(timeTextFiledSelect:) forControlEvents:UIControlEventTouchDown];
    self.missionTime.delegate = self;
    
    [self.addPerson addTarget:self action:@selector(addPersonPress:) forControlEvents:UIControlEventTouchDown];
    self.addPerson.delegate = self;
    
    self.moldArray = [NSArray arrayWithObjects:@"现场执法任务",@"现场执法类",@"排污收费类",@"信访投诉",@"建设项目审批",@"污染源关停",@"预警类", nil];
    
    DataSyncManagerEx *syncManager = [[DataSyncManagerEx alloc] init];
    NSString *settingVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *saveVersion =[[NSUserDefaults standardUserDefaults] stringForKey:kLastVersion];
    //如果发布了新版本 那么就要同步所有数据
    HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    
    HUD.labelText = @"正在同步数据，请稍候...";
    [HUD show:YES];
    if([saveVersion isEqualToString:settingVer]){
        BOOL ret = [syncManager syncAllTables:NO];
        if(ret == NO){
            if(HUD)  [HUD hide:YES];
            [HUD removeFromSuperview];
        }
    }else{
    
        [syncManager syncAllTables:YES];
        [[NSUserDefaults standardUserDefaults] setObject:settingVer forKey:kLastVersion];
    }

    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSyncFinished:) name:kNotifyDataSyncFininshed object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataSyncFailed:) name:kNotifyDataSyncFailed object:nil];
    
    self.saveTag = kTtypeSceneTag;
    [self returnSelectedWords:[self.moldArray objectAtIndex:0] andRow:0];
    
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy"];
    NSString *year = [matter stringFromDate:[NSDate date]];
    [matter release];
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithCapacity:5];
    [params setObject:@"ASSIGN_TASK_BH" forKey:@"service"];
    [params setObject:[NSString stringWithFormat:@"m440301%@______",year] forKey:@"BH"];
    
    self.webTag = kWebRWBHTag;
    NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8899/"  Application:@"ahydzforacle" Parameters:params];
    self.webHelper = [[[NSURLConnHelper alloc]initWithUrl:strUrl andParentView:nil delegate:self] autorelease];
}

-(void)textFieldTouchDon:(UITextField *)textField{
    
    CommenWordsViewController *wordsViewController = [[[CommenWordsViewController alloc]initWithStyle:UITableViewStylePlain] autorelease];
    wordsViewController.contentSizeForViewInPopover = CGSizeMake(200, 350);
    wordsViewController.delegate = self;
    self.saveTag = textField.tag;
    
    if (textField.tag == kTtypeSceneTag) {
        wordsViewController.wordsAry = self.moldArray;
    }
    else if (textField.tag == kTtypeGeneralTag){
        wordsViewController.wordsAry = self.typeArray;
    }
    else if (textField.tag == kPollutionNameTag){
        UISearchSitesController *formViewController = [[[UISearchSitesController alloc] initWithNibName:@"UISearchSitesController" bundle:nil] autorelease];
        [formViewController setDelegate:self];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:formViewController];
        nav.modalPresentationStyle =  UIModalPresentationFormSheet;
        [self presentModalViewController:nav animated:YES];
        nav.view.superview.frame = CGRectMake(60, 100, 640, 800);
        [nav release];
        return;
    }
    self.popController = [[[UIPopoverController alloc]initWithContentViewController:wordsViewController] autorelease];
    [self.popController presentPopoverFromRect:textField.bounds inView:textField permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}

-(void)timeTextFiledSelect:(UITextField *)textField{
    PopupDateViewController *dateController = [[[PopupDateViewController alloc] initWithPickerMode:UIDatePickerModeDate] autorelease];
	dateController.delegate = self;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:dateController];
	self.popController = [[[UIPopoverController alloc] initWithContentViewController:nav] autorelease];
	[self.popController presentPopoverFromRect:[textField bounds] inView:textField permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [nav release];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

-(void)addPersonPress:(UITextField *)textField{
    PersonChooseVC *controller = [[[PersonChooseVC alloc] initWithStyle:UITableViewStyleGrouped] autorelease];
    controller.delegate = self;
    controller.multiUsers = YES;
    controller.refresh = YES;
	UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
	self.popController = [[UIPopoverController alloc] initWithContentViewController:nav];
	[self.popController presentPopoverFromRect:textField.bounds inView:textField permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    [nav release];
}

-(void)returnSelectedWords:(NSString *)words andRow:(NSInteger)row{
    if (self.saveTag == kTtypeSceneTag) {
        self.sceneTextField.text = words;
        switch (row) {
            case 0:
                self.intArray = [NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5", nil];
                self.typeArray = [NSArray arrayWithObjects:@"常规现场执法",@"三同时现场执法", @"吊证现场执法",@"限期治理现场执法",@"其它",nil];
                break;
            case 1:
                self.intArray = [NSArray arrayWithObjects:@"318",@"351",@"407",@"411",@"430", nil];
                self.typeArray = [NSArray arrayWithObjects:@"行政处罚跟踪管理",@"限期治理验收",@"行政处罚",@"限期整改通知",@"限期整改跟踪任务", nil];
                break;
            case 2:
                self.intArray = [NSArray arrayWithObjects:@"417",@"435", nil];
                self.typeArray = [NSArray arrayWithObjects:@"排污费催缴提醒",@"排污费核定", nil];
                break;
            case 3:
                self.intArray = [NSArray arrayWithObjects:@"402", nil];
                self.typeArray = [NSArray arrayWithObjects:@"信访投诉", nil];
                break;
            case 4:
                self.intArray = [NSArray arrayWithObjects:@"220",@"222",@"223",@"224",@"225",@"226", nil];
                self.typeArray = [NSArray arrayWithObjects:@"建设项目审批",@"建设项目续办",@"投入试运行审批",@"环保设施验收",@"项目审批报告表",@"项目审批报告书", nil];
                break;
            case 5:
                self.intArray = [NSArray arrayWithObjects:@"319", nil];
                self.typeArray = [NSArray arrayWithObjects:@"污染源关停", nil];
                break;
            case 6:
                self.intArray = [NSArray arrayWithObjects:@"771",@"712",@"713",@"714",@"715",@"716",@"717",@"718", nil];
                self.typeArray = [NSArray arrayWithObjects:@"监测浓度超标",@"建设项目审批批复超期预警",@"试生产超期报罚预警",@"排污许可证超期预警",@"排污许可证年检超期预警",@"限期整改超期预警",@"限期治理超期预警",@"在线监测超标报警", nil];
                break;
        }
        self.saveTag = kTtypeGeneralTag;
        [self.popController dismissPopoverAnimated:YES];
        [self returnSelectedWords:[self.typeArray objectAtIndex:0] andRow:0];
    }
    else{
        self.generalTextField.text = words;
        if ([self.sceneTextField.text isEqualToString:@"现场执法任务"]) {
            self.rwlx = @"410";
            self.zflxxl = [self.intArray objectAtIndex:row];
        }
        else{
            self.zflxxl = nil;
            self.rwlx = [self.intArray objectAtIndex:row];
        }
        [self.popController dismissPopoverAnimated:YES];
    }
}

-(void)returnSites:(NSDictionary *)values outsideComp:(BOOL)bOutside{
    self.pollutionName.text = [values objectForKey:@"WRYMC"];
    if (bOutside) {
        self.wrybh = @"";
    }
    else{
        self.wrybh = [values objectForKey:@"WRYBH"];
        self.pollutionAddress.text = [values objectForKey:@"DWDZ"];
        self.phoneNumber.text = [values objectForKey:@"FRDBLXDH"];
        self.representative.text = [values objectForKey:@"FRDB"];
    }
}

-(void)PopupDateController:(PopupDateViewController *)controller Saved:(BOOL)bSaved selectedDate:(NSDate *)date{
    if (bSaved) {
        self.selectDate = [date retain];
        NSTimeInterval selectDate = [date timeIntervalSince1970];
        NSTimeInterval nowDate = [[NSDate date] timeIntervalSince1970];
        
        if (selectDate - nowDate > 0) {
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"yyyy-MM-dd"];
            NSString *dateStr = [matter stringFromDate:date];
            self.missionTime.text = dateStr;
            [matter release];
        }
        else{
            [self showAlertMessage:@"任务期限不能小于当前时间"];
        }
    }
    
    [self.popController dismissPopoverAnimated:YES];
}

-(void)personChoosed:(NSArray *)aryChoosed{
    self.slrArray = aryChoosed;
    NSMutableString *strSLRName = [NSMutableString stringWithCapacity:20];
    NSMutableString *strSLRID = [NSMutableString stringWithCapacity:20];
    NSMutableString *strPhones = [NSMutableString stringWithCapacity:20];
    for(NSDictionary *dicPerson in self.slrArray)
    {
        if([strSLRName length] == 0)
        {
            [strSLRName appendString:[dicPerson objectForKey:@"YHMC"]];
            [strSLRID appendString:[dicPerson objectForKey:@"YHID"]];
            [strPhones appendString:[dicPerson objectForKey:@"YHSJ"]];
        }
        else
        {
            [strSLRName appendFormat:@",%@",[dicPerson objectForKey:@"YHMC"]];
            [strSLRID appendFormat:@",%@",[dicPerson objectForKey:@"YHID"]];
            [strPhones appendFormat:@",%@",[dicPerson objectForKey:@"YHSJ"]];
        }
    }
    self.addPerson.text = strSLRName;
    [self.popController dismissPopoverAnimated:YES];
}

-(void)barButtonPress:(UIBarButtonItem *)barButton{
    
    [self.taskDescription resignFirstResponder];
    
    NSString *tipInfo = nil;
    if (![self.pollutionName.text length]) {
        tipInfo = @"请选择企业";
    }
    else if (![self.missionTime.text length]) {
        tipInfo = @"请选择任务期限";
    }
    else if (![self.addPerson.text length]) {
        tipInfo = @"请选择受理人";
    }
    if (tipInfo) {
        [self showAlertMessage:tipInfo];
        return;
    }
//    if(sendShortMsgSwitch.on){
//        NSArray *aryShouji = [phoneNumsField.text componentsSeparatedByString:@","];
//        for(NSString *phone in aryShouji)
//        {
//            if ([self verifyPhoneNumber:phone] == NO) {
//                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"手机号码无效,请检查将要发送短信的手机号码。" delegate:nil cancelButtonTitle:@"重新输入"otherButtonTitles:nil];
//                [alertView show];
//                return;
//            }
//        }
//        
//    }
    NSDateFormatter *matter = [[NSDateFormatter alloc]init];
    [matter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString *nowTime = [matter stringFromDate:[NSDate date]];
    [matter release];
    
    NSMutableDictionary *infoParams = [NSMutableDictionary dictionaryWithCapacity:5];
    [infoParams setObject:@"ASSIGN_TASK_ACTION" forKey:@"service"];
    [infoParams setObject:self.rwbh forKey:@"RWBH"];
    [infoParams setObject:nowTime forKey:@"RWFQSJ"];
    [infoParams setObject:self.pollutionName.text forKey:@"WRYMC"];
    [infoParams setObject:self.pollutionAddress.text forKey:@"WRYDZ"];
    [infoParams setObject:self.addPerson.text forKey:@"RWJSR"];
    [infoParams setObject:self.missionTime.text forKey:@"RWQX"];
    
    if([self.representative.text length])
        [infoParams setObject:self.representative.text forKey:@"FDDBR"];
    if([self.phoneNumber.text length])
        [infoParams setObject:self.phoneNumber.text forKey:@"FRLXDH"];
    if ([self.taskDescription.text length]) {
        [infoParams setObject:self.taskDescription.text forKey:@"RWMS"];
    }
    
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    [infoParams setObject:usrInfo.userCNName forKey:@"RWFQR"];
    UsersHelper *userHelper = [[UsersHelper alloc]init];
    NSString *userBMBH = [userHelper queryUserBMBHByName:usrInfo.userCNName];
    [infoParams setObject:userBMBH forKey:@"RWFQRBM"];
    [userHelper release];
    
    NSMutableString *slrID = [NSMutableString stringWithCapacity:10];
    NSMutableString *slrBM = [NSMutableString stringWithCapacity:10];
    for (int i=0; i<self.slrArray.count; i++) {
        NSDictionary *dic = [self.slrArray objectAtIndex:i];
        if (i == 0) {
            [slrBM appendFormat:@"%@",[dic objectForKey:@"BMBH"]];
            [slrID appendFormat:@"%@",[dic objectForKey:@"YHID"]] ;
        }
        else{
            [slrBM appendFormat:@",%@;",[dic objectForKey:@"BMBH"]];
            [slrID appendFormat:@",%@",[dic objectForKey:@"YHID"]];
        }
    }
    
    [infoParams setObject:slrID forKey:@"RWJSRBM"];
    [infoParams setObject:slrBM forKey:@"BMBH"];
    
    if (self.zflxxl) {
        [infoParams setObject:self.zflxxl forKey:@"ZFLXXL"];
    }
    [infoParams setObject:self.rwlx forKey:@"RWLX"];
    [infoParams setObject:self.wrybh forKey:@"WRYBH"];

    NSTimeInterval time = [self.selectDate timeIntervalSinceDate:[NSDate date]];
    int days=((int)time)/(3600*24);
    [infoParams setObject:[NSString stringWithFormat:@"%d",days] forKey:@"DAYS"];
    
    self.webTag = kWebRWZPTag;
    NSString *strUrl = [ServiceUrlString generateUrlByIP:@"219.133.105.204:8899/"  Application:@"ahydzforacle" Parameters:infoParams];
   self.webHelper = [[NSURLConnHelper alloc] initWithUrl:strUrl andParentView:self.view delegate:self ];
}

-(void)processWebData:(NSData *)webData{
    if (self.webTag == kWebRWBHTag) {
        NSDictionary *dicBH = [webData objectFromJSONData];
        NSString *strBH = [[[dicBH objectForKey:@"data"]objectAtIndex:0]objectForKey:@"RWBH"];
        if ([strBH length]) {
            int intBH = [[strBH substringFromIndex:10] intValue]+1;
            NSString *rwStr = [[NSString stringWithFormat:@"%d",intBH] substringFromIndex:1];
            self.rwbh = [NSString stringWithFormat:@"%@%@",[strBH substringWithRange:NSMakeRange(0, 11)],rwStr];
        }
        else{
            NSDateFormatter *matter = [[NSDateFormatter alloc]init];
            [matter setDateFormat:@"yyyy"];
            NSString *year = [matter stringFromDate:[NSDate date]];
            self.rwbh = [NSString stringWithFormat:@"m440301%@000001",year];
            [matter release];
        }
    }
    else if (self.webTag == kWebRWZPTag){
        
        NSString *resultJSON = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
        NSRange result = [resultJSON rangeOfString:@"success"];
        if(result.location!= NSNotFound)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                        message:@"指派任务成功！还需要指派其它任务吗？"
                               cancelButtonItem:[RIButtonItem itemWithLabel:@"指派其它任务" action:^{
                self.pollutionName.text = @"";
                self.pollutionAddress.text = @"";
                self.representative.text = @"";
                self.phoneNumber.text = @"";
                self.missionTime.text = @"";
                self.addPerson.text = @"";
                self.taskDescription.text = @"";
                
            }]
                               otherButtonItems:[RIButtonItem itemWithLabel:@"不指派" action:^{
                
                [self.navigationController popViewControllerAnimated:YES];
            }], nil];
            [alertView show];
            [alertView release];
            return;
        }
        else
        {
            NSString *msg = @"发送任务失败！";
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle:@"错误"
                                  message:msg  delegate:nil
                                  cancelButtonTitle:@"确定"
                                  otherButtonTitles:nil];
            [[[alert subviews] objectAtIndex:2] setBackgroundColor:[UIColor colorWithRed:0.5 green:0.0f blue:0.0f alpha:1.0f]];
            [alert show];
            [alert release];
            return;
        }
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.taskDescription resignFirstResponder];
}

-(void)showAlertMessage:(NSString*)msg{
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//#define MOBILE  @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
//#define CM      @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
//#define CU      @"^1(3[0-2]|5[256]|8[56])\\d{8}$"
//#define CT      @"^1((33|53|8[09])[0-9]|349)\\d{7}$"
//
//- (BOOL)verifyPhoneNumber:(NSString *)mobileNum{
//    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",MOBILE];
//    
//    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CM];
//    
//    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CU];
//    
//    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",CT];
//    
//    //        NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",PHS];
//    
//    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
//        || ([regextestcm evaluateWithObject:mobileNum] == YES)
//        || ([regextestct evaluateWithObject:mobileNum] == YES)
//        || ([regextestcu evaluateWithObject:mobileNum] == YES))
//    {
//        return YES;
//    }
//    else
//    {
//        return NO;
//    }
//    
//}

- (void)dataSyncFinished:(NSNotificationCenter *)notification{
    if(HUD)  [HUD hide:YES];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyDataSyncFininshed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyDataSyncFailed object:nil];
    
}

- (void)dataSyncFailed:(NSNotificationCenter *)notification{
    
    if(HUD)  [HUD hide:YES];
    UIAlertView *alert = [[UIAlertView alloc]
                          initWithTitle:@"提示"
                          message:@"同步数据失败！"
                          delegate:self
                          cancelButtonTitle:@"确定"
                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyDataSyncFininshed object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kNotifyDataSyncFailed object:nil];
    
    
}

- (void)dealloc {
    [_sceneTextField release];
    [_generalTextField release];
    [_pollutionName release];
    [_pollutionAddress release];
    [_representative release];
    [_phoneNumber release];
    [_missionTime release];
    [_taskDescription release];
    [_addPerson release];
    [HUD release];
    [super dealloc];
}
- (void)viewDidUnload {
    [self setSceneTextField:nil];
    [self setGeneralTextField:nil];
    [self setPollutionName:nil];
    [self setPollutionAddress:nil];
    [self setRepresentative:nil];
    [self setPhoneNumber:nil];
    [self setMissionTime:nil];
    [self setTaskDescription:nil];
    [self setAddPerson:nil];
    [super viewDidUnload];
}
@end
