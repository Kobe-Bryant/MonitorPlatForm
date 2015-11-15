//
//  SystemConfigContext.m
//  HBBXXPT
//
//  Created by 张仁松 on 13-6-21.
//  Copyright (c) 2013年 zhang. All rights reserved.
//

#import "SystemConfigContext.h"


//#import "UIDevice+IdentifierAddition.h"

@implementation SystemConfigContext
static NSMutableDictionary *config;
static SystemConfigContext *_sharedSingleton = nil;
+ (SystemConfigContext *) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedSingleton == nil)
        {
            _sharedSingleton = [[SystemConfigContext alloc] init];
            
            NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"config" ofType:@"plist"];
            config = [[NSMutableDictionary alloc] initWithContentsOfFile:plistPath];

            
        }
    }
    
    return _sharedSingleton;
}


-(NSString *)getString:(NSString *)key{
    return [config objectForKey:key];
}

-(NSArray *)getResultItems:(NSString *)key{
    return [config objectForKey:key];
}



-(NSString*)getAppVersion{
     return [NSString stringWithFormat:@"%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]];
}



@end
