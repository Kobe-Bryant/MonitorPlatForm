//
//  ChangePasswordVC.m
//  MonitorPlatform
//
//  Created by 王哲义 on 12-11-27.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "MPAppDelegate.h"
#import "ZrsUtils.h"

extern MPAppDelegate *g_appDelegate;

@interface ChangePasswordVC ()
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,assign) BOOL isResult;
@property (nonatomic,assign) BOOL isSuccess;
@property (nonatomic,strong) NSMutableString *currentStr;
@end

@implementation ChangePasswordVC
@synthesize webHelper,isResult,currentStr,isSuccess;


#pragma mark - Private methods

- (IBAction)completedBtnPress:(id)sender
{
    if (![oldPassword.text isEqualToString:g_appDelegate.ipadPassWord])
    {
        [ZrsUtils showAlertMsg:@"当前密码输入错误，请输入正确的当前密码。" andDelegate:nil];
        oldPassword.text = @"";
    }
    else
    {
        if (![surePassword.text isEqualToString:newPassword.text])
        {
            [ZrsUtils showAlertMsg:@"两次输入密码不一致，请重新输入" andDelegate:nil];
            newPassword.text = @"";
            surePassword.text = @"";
        }
        else
        {
            NSString *param = [WebServiceHelper createParametersWithKey:@"loginID" value:g_appDelegate.userLoginID,@"passWord",newPassword.text, nil];
            NSString *URL = [NSString stringWithFormat:OA_URL,g_appDelegate.oaServiceIp];
            
            self.webHelper = [[[WebServiceHelper alloc] initWithUrl:URL method:@"UpdatePassWord" nameSpace:@"http://tempuri.org/" parameters:param delegate:self] autorelease];
            [webHelper runAndShowWaitingView:self.view];
        }
    }
}

#pragma mark - View Lifecycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [super dealloc];
}

#pragma mark - URLConnHelper delegate

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

#pragma mark - XML parser delegate

- (void)parserDidStartDocument:(NSXMLParser *)parser{
    currentStr = [NSMutableString string];
    isResult = NO;
    isSuccess = NO;
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *) namespaceURI qualifiedName:(NSString *)qName
   attributes: (NSDictionary *)attributeDict
{
	if ([elementName isEqualToString:@"UpdatePassWordResult"])
	{
		isResult = YES;
	}
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
	if(isResult)
	{
		[currentStr appendString:string];
	}
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    
	if(isResult && [elementName isEqualToString:@"UpdatePassWordResult"])
	{
        if ([currentStr isEqualToString:@"1"])
            isSuccess = YES;
	}
}

- (void)parserDidEndDocument:(NSXMLParser *)parser{

    if(isSuccess){
        [ZrsUtils showAlertMsg:@"修改成功" andDelegate:self];
    }
    else
    {
        [ZrsUtils showAlertMsg:@"修改失败" andDelegate:nil];
    }
}


#pragma mark - AlertView delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
