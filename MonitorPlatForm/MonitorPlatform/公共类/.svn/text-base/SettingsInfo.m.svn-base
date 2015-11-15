//
//  SettingsInfo.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-6-21.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "SettingsInfo.h"
#import "UIDevice+IdentifierAddition.h"

@implementation SettingsInfo

@synthesize uniqueDeviceID,oaServiceIp,javaServiceIp,xxcxServiceIP,version;

static SettingsInfo *_sharedSingleton = nil;

+ (SettingsInfo *) sharedInstance
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

NSString *koaServiceIpKey			= @"oaip_prefer";
NSString *kjavaServiceIpKey			= @"javaip_prefer";
NSString *kxxcxServiceKey			= @"xxcxip_prefer";

// 获取默认设置
- (void)readPreference
{
    NSString *testValue = [[NSUserDefaults standardUserDefaults] stringForKey:kxxcxServiceKey];
	if (testValue == nil)
	{
		// no default values have been set, create them here based on what's in our Settings bundle info
		//
		NSString *pathStr = [[NSBundle mainBundle] bundlePath];
		NSString *settingsBundlePath = [pathStr stringByAppendingPathComponent:@"Settings.bundle"];
		NSString *finalPath = [settingsBundlePath stringByAppendingPathComponent:@"Root.plist"];
        
		NSDictionary *settingsDict = [NSDictionary dictionaryWithContentsOfFile:finalPath];
		NSArray *prefSpecifierArray = [settingsDict objectForKey:@"PreferenceSpecifiers"];
        
		NSString *oaipDefault = nil;
		NSString *javaipDefault = nil;
		NSString *xxcxipDefault = nil;
		
		NSDictionary *prefItem;
		for (prefItem in prefSpecifierArray)
		{
			NSString *keyValueStr = [prefItem objectForKey:@"Key"];
			id defaultValue = [prefItem objectForKey:@"DefaultValue"];
			
			if ([keyValueStr isEqualToString:koaServiceIpKey])
			{
				oaipDefault = defaultValue;
			}
			else if ([keyValueStr isEqualToString:kjavaServiceIpKey])
			{
				javaipDefault = defaultValue;
			}
			else if ([keyValueStr isEqualToString:kxxcxServiceKey])
			{
				xxcxipDefault = defaultValue;
			}
		}
        
		// since no default values have been set (i.e. no preferences file created), create it here
		NSDictionary *appDefaults = [NSDictionary dictionaryWithObjectsAndKeys:
                                     oaipDefault, koaServiceIpKey,
                                     javaipDefault, kjavaServiceIpKey,
                                     xxcxipDefault, kxxcxServiceKey,
                                     nil];
        
		[[NSUserDefaults standardUserDefaults] registerDefaults:appDefaults];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	
	// we're ready to go, so lastly set the key preference values
	self.oaServiceIp = [[NSUserDefaults standardUserDefaults] stringForKey:@"oaip_prefer"];
    self.javaServiceIp = [[NSUserDefaults standardUserDefaults] stringForKey:@"javaip_prefer"];
    self.xxcxServiceIP = [[NSUserDefaults standardUserDefaults] stringForKey:kxxcxServiceKey];
}


-(void)readSettings{
    [self readPreference];
    self.version = @"1.0";
    self.uniqueDeviceID = [[UIDevice currentDevice] macaddress];
}

@end


