//
//  SystemConfigContext.h
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//
//百度map sdk key 9b07cb34bdefa5c642bc1c98595f5627

#import <Foundation/Foundation.h>

@interface SystemConfigContext : NSObject
{
    //当前用户信息
    NSMutableDictionary *userInfo;

}

+(SystemConfigContext *)sharedInstance;
-(NSString *)getString:(NSString *)key;
-(NSArray *)getResultItems:(NSString *)key;


-(NSString*)getAppVersion;

@end
