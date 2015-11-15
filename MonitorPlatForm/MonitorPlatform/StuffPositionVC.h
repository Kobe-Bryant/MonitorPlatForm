//
//  StuffPositionVC.h
//  MonitorPlatform
//
//  Created by zhang on 12-8-31.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "BMapKit.h"
#import "PersonsViewController.h"
@interface StuffPositionVC : UIViewController
<NSURLConnHelperDelegate,BMKGeneralDelegate,BMKMapViewDelegate,NSXMLParserDelegate,PersonPositonDelegate>

@end
