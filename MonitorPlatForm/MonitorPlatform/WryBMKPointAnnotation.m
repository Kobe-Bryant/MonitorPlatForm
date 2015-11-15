//
//  WryBMKPointAnnotation.m
//  HNYDZF
//
//  Created by 张 仁松 on 12-7-17.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "WryBMKPointAnnotation.h"

@implementation WryBMKPointAnnotation
@synthesize wrybh,wrymc;

-(void)dealloc{
    
    [wrybh release];
    [wrymc release];
    [super dealloc];
}
@end
