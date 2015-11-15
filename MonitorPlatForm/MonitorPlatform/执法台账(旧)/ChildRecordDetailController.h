//
//  ChildRecordDetailController.h
//  MonitorPlatform
//
//  Created by 张仁松 on 13-6-4.
//  Copyright (c) 2013年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RecordItem.h"
#import "NSURLConnHelperDelegate.h"

@interface ChildRecordDetailController : UIViewController<NSURLConnHelperDelegate,NSXMLParserDelegate>
@property(nonatomic,retain)RecordItem *theItem;
@end
