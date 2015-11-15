//
//  LoginViewController.m
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "LoginViewController.h"
#import "MainMenuViewController.h"
#import "MPAppDelegate.h"
#import "WebServiceHelper.h"
#import "LoginedUsrInfo.h"
#import "JSONKit.h"
#import "SettingsInfo.h"

extern MPAppDelegate *g_appDelegate;

@implementation LoginViewController
@synthesize usrField,pwdField,savePwdCtrl,bgImagView,loginBtn;
@synthesize currentParsedCharacterData,isGetName,isConnecting,isLoginSuccess,isGetPassword;
@synthesize isGetLoginID;

-(void)infoTipInMainThread:(NSString*)flag{
    if ([flag isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"检测到新版本的移动办公，请更新。"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
        
        
    }
    else{
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"提示"
                              message:@"检测到新版本的移动办公，是否更新？"
                              delegate:self
                              cancelButtonTitle:@"确定"
                              otherButtonTitles:@"取消",nil];
        [alert show];
        [alert release];
        return;
    }
}

- (void)setLandscape
{
    self.usrField.frame = CGRectMake(421, 298, 226, 31);
    self.pwdField.frame = CGRectMake(421, 356, 226, 31);
    self.savePwdCtrl.frame = CGRectMake(477, 413, 79, 27);
    self.loginBtn.frame = CGRectMake(445, 485, 129, 49);
    
    self.bgImagView.image = [UIImage imageNamed:@"login_landscape.jpg"];
}

- (void)setPortrait
{
    self.usrField.frame = CGRectMake(298, 394, 226, 31);
    self.pwdField.frame = CGRectMake(298, 452, 226, 31);
    self.savePwdCtrl.frame = CGRectMake(354, 509, 79, 27);
    self.loginBtn.frame = CGRectMake(322, 582, 129, 49);
    
    self.bgImagView.image = [UIImage imageNamed:@"login_Bg.jpg"];
}

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

-(void)dealloc{
    [usrField release];
    [pwdField release];
    [savePwdCtrl release];
    [currentParsedCharacterData release];
    [super dealloc];
}

#pragma mark - View lifecycle
-(IBAction)btnLoginPressed:(id)sender{
    if (usrField.text == nil || [usrField.text isEqualToString:@""]) {
		NSString *msg = @"用户名不能为空";
		
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
	
	if (pwdField.text == nil|| [pwdField.text isEqualToString:@""]) {
		NSString *msg = @"密码不能为空";
		
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

    if (isConnecting) {
        return;
    }
    
    isConnecting = YES;
    
    SettingsInfo *info = [SettingsInfo sharedInstance];
    info.uniqueDeviceID = @"3C:07:54:04:E2:E5";
    NSString *param = [WebServiceHelper createParametersWithKey:@"loginID" 
                                                          value:usrField.text,
                       @"passWord",pwdField.text,@"MACID",info.uniqueDeviceID, nil];
    
    //读取配置文件 ip
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    g_appDelegate.oaServiceIp = [defaults stringForKey:@"oaip_prefer"];
    
    NSString *URL = [NSString stringWithFormat:OA_URL,g_appDelegate.oaServiceIp];
    
	WebServiceHelper *webservice = [[[WebServiceHelper alloc] initWithUrl:URL
                                                                   method:@"Login" 
                                                                nameSpace:@"http://tempuri.org/"
                                                               parameters:param 
                                                                 delegate:self] autorelease];
	[webservice runAndShowWaitingView:self.view];
    
}

-(void)gotoSafari{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://219.133.105.204:81/MobileLawService_jcpt/ipad/jcptUpdateApp.html"]];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0) {
        [self gotoSafari];
    }
}


-(void)newVertionFound:(NSNotification *)note{
    NSString *flag = [[note userInfo] objectForKey:@"mustUpdate"];
    
    [self performSelectorOnMainThread:@selector(infoTipInMainThread:) withObject:flag waitUntilDone:NO];
    
}

#define kNewVertionFound      @"kNewVertionFound"
-(void)checkVersion{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(newVertionFound:)
                                                 name:kNewVertionFound
                                               object:nil];
    
    NSString *strUrl = @"http://219.133.105.204:81/MobileLawService_jcpt/ipad/version.json";
    NSURL *url = [NSURL URLWithString:strUrl];
    
    NSString *resultJSON = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    NSDictionary *verInfo = [resultJSON objectFromJSONString];
    NSString *serverVer = [verInfo objectForKey:@"version"];
    NSString *mustUpdate = [verInfo objectForKey:@"mustupdate"];
    CGFloat verFromServer = [serverVer floatValue] *100;
    NSString *settingVer = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    CGFloat appVer = [settingVer floatValue] *100;
    if (verFromServer > appVer) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:kNewVertionFound object:nil userInfo:[NSDictionary dictionaryWithObject:mustUpdate forKey:@"mustUpdate"]];
    }
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    isLoginSuccess = NO;
    // Do any additional setup after loading the view from its nib.
    self.currentParsedCharacterData = [NSMutableString stringWithCapacity:20];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	NSString *usr = [defaults objectForKey:kUser];
    NSString *isSave = [defaults objectForKey:kSavePwd];
    NSString *pwd = nil;
    if (isSave != nil) {
        if ([isSave isEqualToString:@"1"]) {
            pwd = [defaults objectForKey:kPwd];
            savePwdCtrl.on = YES;
        }
    }
	if (usr == nil) usr= @"";
	if (pwd == nil) pwd = @"";
	usrField.text = usr;
	pwdField.text  = pwd;

}

- (void)viewDidAppear:(BOOL)animated
{
    //检查是否需要更新
    [NSThread detachNewThreadSelector:@selector(checkVersion) toTarget:self withObject:nil];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
	[super viewDidAppear:animated];
    [self setPortrait];
        
}

- (void)viewWillDisappear:(BOOL)animated
{
    
	[super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
 /*   if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation ==UIInterfaceOrientationLandscapeRight)
        [self setLandscape];
    else 
        [self setPortrait];
    
    [self.usrField resignFirstResponder];
    [self.pwdField resignFirstResponder];*/
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

-(void)processWebData:(NSData*)webData{
    
    NSString *theXML = [[NSString alloc] initWithBytes: [webData bytes] length:[webData length] encoding:NSUTF8StringEncoding];
    NSLog(@"%@",theXML);
    [theXML release];
    
    NSXMLParser *xmlParser = [[[NSXMLParser alloc] initWithData:webData] autorelease];
    [xmlParser setDelegate: self];
    [xmlParser setShouldResolveExternalEntities: YES];
    [xmlParser parse];
}

-(void)processError:(NSError *)error{
    NSString *msg = @"请求数据失败，请检查网络。";
    isConnecting = NO;
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


-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	
	if ([elementName isEqualToString:@"UM_FLAG"])
	{
		isGetName = YES;
	}
    else if ([elementName isEqualToString:@"UM_LOGIN_ID"])
    {
        isGetLoginID = YES;
    }
    else if ([elementName isEqualToString:@"UM_PASSWORD"])
    {
        isGetPassword = YES;
    }
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if( isGetName || isGetLoginID || isGetPassword)
	{
		[currentParsedCharacterData appendString:string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{

	if(isGetName && [elementName isEqualToString:@"UM_FLAG"])
	{
        //汪斌的oa是wb 信访、行政处罚是wangbin对应不对
        g_appDelegate.userPinYinName = currentParsedCharacterData;
            
        NSString *usr = usrField.text;
        NSString *pwd = pwdField.text;
        g_appDelegate.userCNName = usr;
        g_appDelegate.ipadPassWord = pwd;
            
        LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
        if([currentParsedCharacterData isEqualToString:@"wb"])
            usrInfo.userPinYinName = @"wangbin";
        else if([currentParsedCharacterData isEqualToString:@"chensenchao"])
            usrInfo.userPinYinName = @"chenshengchao";
        else if([currentParsedCharacterData isEqualToString:@"duangjian"])
            usrInfo.userPinYinName = @"duanjuan";
        else if([currentParsedCharacterData isEqualToString:@"shenjianqian"])
            usrInfo.userPinYinName = @"shenjianqiang";
        else
            usrInfo.userPinYinName = currentParsedCharacterData;
        

        usrInfo.userCNName = usr;
            
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:usr forKey:kUser];
        if (savePwdCtrl.on) {
            [defaults setObject:pwd forKey:kPwd];
            [defaults setObject:@"1" forKey:kSavePwd];
        }
        else
            [defaults setObject:@"0" forKey:kSavePwd];
        isLoginSuccess = YES;
		
        
        isGetName = NO;
        [currentParsedCharacterData setString:@""];
	}
    else if (isGetLoginID && [elementName isEqualToString:@"UM_LOGIN_ID"])
	{
        g_appDelegate.userLoginID = currentParsedCharacterData ;
        isGetLoginID = NO;
        [currentParsedCharacterData setString:@""];
    }
    
    else if (isGetPassword && [elementName isEqualToString:@"UM_PASSWORD"])
    {
        g_appDelegate.userPassWord = currentParsedCharacterData ;
        LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
        usrInfo.userPassWord =  pwdField.text;
        
        isGetPassword = NO;
        [currentParsedCharacterData setString:@""];
    }
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{
	//NSLog(@"-------------------end--------------");
	isConnecting = NO;
    if(!isLoginSuccess){
        NSString *msg = @"登录失败，用户名、密码错误或使用的设备并未登记在案。";
        
        UIAlertView *alert = [[UIAlertView alloc] 
                              initWithTitle:@"提示" 
                              message:msg 
                              delegate:nil
                              cancelButtonTitle:@"确定" 
                              otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        MainMenuViewController *controller = [[MainMenuViewController alloc] initWithNibName:@"MainMenuViewController" bundle:nil];
        [self.navigationController pushViewController:controller animated:YES];
        [controller release];
    }
}

#pragma mark - UITextField delegate

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    UIInterfaceOrientation statusBarOrientation = [UIApplication sharedApplication].statusBarOrientation;
    if (statusBarOrientation == UIInterfaceOrientationLandscapeRight || statusBarOrientation == UIInterfaceOrientationLandscapeLeft){
    NSTimeInterval animationDuration=0.30f;
	[UIView beginAnimations:@"ResizeForKeyboard" context:nil];
	[UIView setAnimationDuration:animationDuration];
	float width=self.view.frame.size.width;
	float height=self.view.frame.size.height;
	CGRect rect=CGRectMake(0.0f,-200,width,height);//上移，按实际情况设置
	self.view.frame=rect;
	[UIView commitAnimations];
	return ;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
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

@end
