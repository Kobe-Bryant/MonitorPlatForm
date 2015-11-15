//
//  TypeStatisticDetailsController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-3-19.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "WebServiceHelper.h"

@interface TypeStatisticDetailsController : UIViewController <UITableViewDataSource,UITableViewDelegate,NSURLConnHelperDelegate,NSXMLParserDelegate>
{
    IBOutlet UILabel *titleLabel;
}
@property (nonatomic,strong) IBOutlet UITableView *dataTableView;
@property (nonatomic,copy) NSString *fromDateStr;
@property (nonatomic,copy) NSString *endDateStr;
@property (nonatomic,copy) NSString *fwbh;
@property (nonatomic,copy) NSString *fwzlmc;
@property (nonatomic,strong) NSArray *resultDataAry;
@property (nonatomic,strong) NSArray *jyDataAry;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSArray *widthAry;
@property (nonatomic, strong) NSMutableString *curParsedData;
@property (nonatomic, assign) BOOL isGotJsonString;
@property (nonatomic, assign) BOOL bLoaded;
@property (nonatomic,assign) int dataType;
@property (nonatomic,copy) NSString *currentMethod;



@end
