//
//  MPAppDelegate.m
//  MonitorPlatform
//
//  Created by  on 12-2-8.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import "MPAppDelegate.h"
#import "UIDevice+IdentifierAddition.h"
#import "LoginViewController.h"
#import "DatabaseInstaller.h"
#import "SettingsInfo.h"
MPAppDelegate *g_appDelegate = nil;


@implementation MPAppDelegate

@synthesize window = _window;
@synthesize navigationController = _navigationController;
@synthesize viewController = _viewController;
@synthesize userCNName,userPinYinName,userPassWord,oaServiceIp,javaServiceIp,xxcxServiceIP,userLoginID,ipadPassWord;

- (void)dealloc
{
    [_navigationController release];
    [_viewController release];
    [userCNName release];
    [userPinYinName release];
    [userPassWord release];
    [ipadPassWord release];
    [userLoginID release];
    [oaServiceIp release];
    [javaServiceIp release];
    [xxcxServiceIP release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];

    self.viewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
    self.navigationController = [[[UINavigationController alloc] initWithRootViewController:self.viewController] autorelease];
    
    // Override point for customization after application launch.
    self.window.rootViewController = self.navigationController;
    self.window.backgroundColor = [UIColor whiteColor];
    g_appDelegate =self;
    [self.window makeKeyAndVisible];
    
    [[SettingsInfo sharedInstance] readSettings];
    self.oaServiceIp = [[SettingsInfo sharedInstance] oaServiceIp];
    self.javaServiceIp = [[SettingsInfo sharedInstance] javaServiceIp];
    self.xxcxServiceIP = [[SettingsInfo sharedInstance] xxcxServiceIP];
   
    //保证第一次运行时候将数据库删除
    BOOL DeleteDB = [[[NSUserDefaults standardUserDefaults] objectForKey:@"firstTime"] boolValue];
    if (!DeleteDB)
    {
        [DataBaseInstaller replaceDB];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"firstTime"];
    }
    else
    {
        //每次都检查数据库是否存在
        [DataBaseInstaller Install];
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

@end
