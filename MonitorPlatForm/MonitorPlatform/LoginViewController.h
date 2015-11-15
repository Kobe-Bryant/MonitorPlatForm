//
//  LoginViewController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"

@interface LoginViewController : UIViewController<NSURLConnHelperDelegate,NSXMLParserDelegate,UITextFieldDelegate>
@property (nonatomic,strong) IBOutlet UITextField *usrField;
@property (nonatomic,strong) IBOutlet UITextField *pwdField;
@property (nonatomic,strong) IBOutlet UISwitch *savePwdCtrl;
@property (nonatomic,strong) IBOutlet UIImageView *bgImagView;
@property (nonatomic,strong) IBOutlet UIButton *loginBtn;
@property (nonatomic,assign) BOOL isGetName;
@property (nonatomic,assign) BOOL isGetLoginID;
@property (nonatomic,assign) BOOL isGetPassword;
@property (nonatomic,assign) BOOL isConnecting;
@property (nonatomic,assign) BOOL isLoginSuccess;
@property (nonatomic,strong) NSMutableString *currentParsedCharacterData;

-(IBAction)btnLoginPressed:(id)sender;
@end
