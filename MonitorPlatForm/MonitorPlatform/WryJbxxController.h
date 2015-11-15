//
//  WryJbxxController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-22.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelperDelegate.h"
#import "PollutionSelectedController.h"

#import "LightMenuBar.h"
#import "LightMenuBarDelegate.h"
@class  JbxxDataModel;
@class WryXmspModel;
@class XkzDataModel;
@class ZfrwDataModel;
@class PwsfDataModel;
@class CftzDataModel;
@class SolidLinkageDataModel;


@interface WryJbxxController : UIViewController <LightMenuBarDelegate>
@property (nonatomic,copy) NSString* wrybh;//污染源编号 440301200600568
@property (nonatomic,copy) NSString *wrymc;
@property (nonatomic,copy) NSString *wryjc;

@property(nonatomic, strong) NSMutableString *curParsedData;
@property(nonatomic, assign) BOOL isGotJsonString;
@property(nonatomic,strong) NSDictionary *dicJbxx;//基本信息
@property(nonatomic,strong) NSDictionary *dicWryjs;//污染源介绍
@property(nonatomic,strong) NSArray *aryKeys;
@property(nonatomic,strong) JbxxDataModel* jbxxModel;
@property(nonatomic,strong) WryXmspModel* wryXmspModel;
@property(nonatomic,strong) XkzDataModel* xkzModel;
@property(nonatomic,strong) ZfrwDataModel* zfrwModel;
@property(nonatomic,strong) PwsfDataModel* pwsfModel;
@property(nonatomic,strong) CftzDataModel* cftzModel;
@property(nonatomic,strong) SolidLinkageDataModel *linkageModel;
@property (nonatomic,strong) UIButton *btnTitleView;

@property (nonatomic,strong) IBOutlet UITableView *resTableView;
@property (nonatomic,strong) IBOutlet UIImageView *scrollImage;
@property (nonatomic,strong) UIImageView *emptyView;

@property (nonatomic,strong) LightMenuBar *_lightMenuBar;
@property (nonatomic,strong) NSArray *itemAry;
@property (nonatomic,strong) NSArray *zxjcAry;

@end
