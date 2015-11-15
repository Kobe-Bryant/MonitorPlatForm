//
//  MPAppDelegate.h
//  MonitorPlatform
//
//  Created by  on 12-2-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LoginViewController;

@interface MPAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) LoginViewController *viewController;
@property (copy, nonatomic) NSString *userCNName;    //正文名字
@property (copy, nonatomic) NSString *userPinYinName;//名字拼音
@property (copy, nonatomic) NSString *userPassWord;  //用户密码
@property (copy, nonatomic) NSString *ipadPassWord;   //平台密码
@property (copy, nonatomic) NSString *userLoginID;   //用户唯一标识
@property (copy, nonatomic) NSString *oaServiceIp;  //oaService ip地址
@property (copy, nonatomic) NSString *javaServiceIp;  //java后台服务 ip地址
@property( copy, nonatomic) NSString *xxcxServiceIP;

@end
