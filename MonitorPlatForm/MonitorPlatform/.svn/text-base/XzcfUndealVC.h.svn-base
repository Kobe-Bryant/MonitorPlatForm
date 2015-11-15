//
//  XzcfUndealVC.h
//  MonitorPlatform
//
//  Created by 王哲义 on 12-11-30.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"
#import "WebServiceHelper.h"


#define TYPEXZCF  0
#define TYPEXCZF  1
#define TYPEPWSF  2
#define TYPEYJ    3

@interface XzcfUndealVC : UIViewController <NSURLConnHelperDelegate,UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate>
{
    IBOutlet UITableView *listTable;
}

@property (nonatomic) int type;
@property (nonatomic,copy) NSString *yhid;
@property (nonatomic,copy) NSString *fromStr;
@property (nonatomic,copy) NSString *endStr;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@end
