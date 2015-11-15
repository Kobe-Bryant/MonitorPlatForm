//
//  BaiduMapHelper.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-13.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "BaiduMapHelper.h"

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

@implementation BaiduMapHelper
+(NSString*)bundlePath:(NSString*)filename{
    NSBundle * libBundle = MYBUNDLE ;
	if ( libBundle && filename ){
		NSString * s=[[libBundle resourcePath ] stringByAppendingPathComponent : filename];
		//NSLog ( @"%@" ,s);
		return s;
	}
	return nil ;
}


@end
