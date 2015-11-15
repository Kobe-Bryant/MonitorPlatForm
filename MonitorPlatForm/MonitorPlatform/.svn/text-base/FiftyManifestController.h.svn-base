//
//  FiftyManifestController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-14.
//  Copyright (c) 2012年 博安达. All rights reserved.
// 联单统计前50

#import <UIKit/UIKit.h>
#import "ChooseDateRangeController.h"
@class WebServiceHelper;

#import "NSURLConnHelperDelegate.h"

@interface FiftyManifestController : UIViewController
<NSURLConnHelperDelegate,ChooseDateRangeDelegate,UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate,UISearchBarDelegate>
{
    IBOutlet UILabel *titleLabel;
    UIImageView *emptyView;
}

@property (nonatomic,retain)IBOutlet UITableView *dataTableView;

@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) ChooseDateRangeController *dateController;
@property(nonatomic,retain) NSString *fromDateStr;
@property(nonatomic,retain)NSString* endDateStr;
@property(nonatomic,strong)NSArray *resultDataAry;
@property(nonatomic, strong) NSMutableString *curParsedData;
@property(nonatomic, assign) BOOL isGotJsonString;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property (nonatomic,strong) NSArray *widthAry;
@property (nonatomic,assign) BOOL isLoading;
@property (nonatomic,strong) UISearchBar *mySearchBar;

@property (nonatomic,assign) int entranceFlag;
@property (nonatomic,copy) NSString *cszStr;
@property (nonatomic,copy) NSString *wrymc;
@property (nonatomic,copy) NSString *wrybh;

-(void)requestData;
@end
