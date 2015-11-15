//
//  LoginedUsrInfo.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "LoginedUsrInfo.h"

@implementation LoginedUsrInfo
@synthesize userCNName;
@synthesize userPassWord;
@synthesize userPinYinName;

@synthesize aryMenus;

static LoginedUsrInfo *_sharedSingleton = nil;
+ (LoginedUsrInfo *) sharedInstance
{
    @synchronized(self)
    {
        if(_sharedSingleton == nil)
        {
            _sharedSingleton = [NSAllocateObject([self class], 0, NULL) init];
        }
    }
    
    return _sharedSingleton;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [[self sharedInstance] retain];
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (NSUInteger) retainCount
{
    return NSUIntegerMax; // denotes an object that cannot be released
}

- (oneway void) release
{
    // do nothing
}

- (id) autorelease
{
    return self;
}

@end

