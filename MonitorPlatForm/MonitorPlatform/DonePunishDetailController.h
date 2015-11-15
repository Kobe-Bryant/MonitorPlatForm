//
//  DonePunishDetailController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-7.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttachesListController.h"
#import "NSURLConnHelper.h"

@interface DonePunishDetailController : UITableViewController <NSURLConnHelperDelegate,ReturnSelectedRowDelegate>

@property (nonatomic,copy) NSString *itemID;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,strong) NSArray *processArray;
@property (nonatomic,strong) NSArray *attachArray;
@property (nonatomic,assign) CGRect currentRect;

@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *valueArr;
@property (nonatomic,strong) NSArray *titleArr2;
@property (nonatomic,strong) NSArray *valueArr2;
@property (nonatomic,strong) NSMutableArray *trueProof;
@property (nonatomic,strong) NSMutableArray *programProof;
@property (nonatomic,strong) NSMutableArray *cellHeightAry;

@property (nonatomic,strong) NSURLConnHelper *webservice;

@property (nonatomic,assign) int nParserStatus;
@property (nonatomic,strong) NSMutableString *currentString;

@property (nonatomic,assign) int nDataType;
@end
