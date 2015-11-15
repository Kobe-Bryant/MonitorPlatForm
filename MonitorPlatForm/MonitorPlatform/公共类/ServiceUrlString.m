//
//  ServiceUrlString.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ServiceUrlString.h"
#import "LoginedUsrInfo.h"
#import "SettingsInfo.h"
#import "MPAppDelegate.h"

extern MPAppDelegate *g_appDelegate;

@implementation ServiceUrlString
+(NSString*)generateUrlByParameters:(NSDictionary*)params{
    if(params == nil)return @"";
    NSArray *aryKeys = [params allKeys];
    if(aryKeys == nil)return @"";
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    SettingsInfo   *settings = [SettingsInfo sharedInstance];
    
    NSMutableString *paramsStr = [NSMutableString stringWithCapacity:100];
    for(NSString *str in aryKeys){
        [paramsStr appendFormat:@"&%@=%@",str,[params objectForKey:str]];
    }
                                                      
    NSString *strUrl = [NSString stringWithFormat:@"http://%@/ebcmjczd/invoke?version=%@&imei=%@&clientType=IPAD&userid=%@&password=%@%@",g_appDelegate.javaServiceIp, settings.version, settings.uniqueDeviceID, usrInfo.userPinYinName, usrInfo.userPassWord, paramsStr];
    
    CFStringRef     stringRef;
    stringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8);
    NSString *modifiedUrl =  [NSString stringWithString:(NSString*)stringRef];
    CFRelease(stringRef);
    return modifiedUrl;
}


+(NSString*)generateXZCFUrlByParameters:(NSDictionary*)params{
    if(params == nil)return @"";
    NSArray *aryKeys = [params allKeys];
    if(aryKeys == nil)return @"";
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    SettingsInfo   *settings = [SettingsInfo sharedInstance];
    
    NSMutableString *paramsStr = [NSMutableString stringWithCapacity:100];
    for(NSString *str in aryKeys){
        [paramsStr appendFormat:@"&%@=%@",str,[params objectForKey:str]];
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"http://%@/ebcmsz/invoke?version=%@&imei=%@&clientType=IPAD&userid=%@&password=%@%@",g_appDelegate.javaServiceIp, settings.version, settings.uniqueDeviceID, usrInfo.userPinYinName, usrInfo.userPassWord, paramsStr];
    CFStringRef     stringRef;
    stringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8);
    NSString *modifiedUrl =  [NSString stringWithString:(NSString*)stringRef];
    CFRelease(stringRef);
    return modifiedUrl;
}

+(NSString*)generateUrlByParameters:(NSDictionary*)params ignoreClientType:(BOOL)ignore{
    if(params == nil)return @"";
    NSArray *aryKeys = [params allKeys];
    if(aryKeys == nil)return @"";
    //LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    SettingsInfo   *settings = [SettingsInfo sharedInstance];
    
    NSMutableString *paramsStr = [NSMutableString stringWithCapacity:100];
    for(NSString *str in aryKeys){
        [paramsStr appendFormat:@"&%@=%@",str,[params objectForKey:str]];
    }
    if(ignore == NO)
        [paramsStr appendString:@"&clientType=IPAD"];
    
    NSString *strUrl = [NSString stringWithFormat:@"http://%@/invoke?version=%@&imei=%@%@",settings.javaServiceIp, settings.version, settings.uniqueDeviceID, paramsStr];
    
    CFStringRef     stringRef;
    stringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8);
    NSString *modifiedUrl =  [NSString stringWithString:(NSString*)stringRef];
    CFRelease(stringRef);
    return modifiedUrl;
}

+(NSString*)generateUrlByIP:(NSString *)ip Application:(NSString *)appName Parameters:(NSDictionary *)params
{
    if(params == nil)return @"";
    NSArray *aryKeys = [params allKeys];
    if(aryKeys == nil)return @"";
    LoginedUsrInfo *usrInfo = [LoginedUsrInfo sharedInstance];
    SettingsInfo   *settings = [SettingsInfo sharedInstance];
    
    NSMutableString *paramsStr = [NSMutableString stringWithCapacity:100];
    for(NSString *str in aryKeys){
        [paramsStr appendFormat:@"&%@=%@",str,[params objectForKey:str]];
    }
    
    NSString *strUrl = [NSString stringWithFormat:@"http://%@/%@/invoke?version=%@&imei=%@&clientType=IPAD&userid=%@&password=%@%@",ip,appName, settings.version, @"1", usrInfo.userCNName, usrInfo.userPassWord, paramsStr];
    
    CFStringRef     stringRef;
    stringRef = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)strUrl, nil, nil,kCFStringEncodingUTF8);
    NSString *modifiedUrl =  [NSString stringWithString:(NSString*)stringRef];
    CFRelease(stringRef);
    return modifiedUrl;
}

@end
