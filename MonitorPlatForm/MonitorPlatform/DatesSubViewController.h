//
//  DatesSubViewController.h
//  MonitorPlatform
//
//  Created by zhang on 12-9-3.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "WebServiceHelper.h"
@interface DatesSubViewController : UIViewController
<NSURLConnHelperDelegate,NSXMLParserDelegate>
@property(nonatomic,retain)IBOutlet UITableView *listTableView;
@property(nonatomic,copy) NSString *theDateStr;

@end
