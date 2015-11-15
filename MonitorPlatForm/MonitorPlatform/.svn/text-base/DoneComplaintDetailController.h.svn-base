//
//  DoneComplaintDetailController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-9.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NSURLConnHelper.h"

@interface DoneComplaintDetailController : UITableViewController <NSURLConnHelperDelegate,UITableViewDelegate,UITableViewDataSource,UIAlertViewDelegate>

@property (nonatomic,assign) int nParserStatus;
@property (nonatomic,assign) BOOL bHave;

@property (nonatomic,strong) NSMutableArray *attachments;
@property (nonatomic,strong) NSMutableArray *caseProcessAry;
@property (nonatomic,strong) NSMutableArray *cellHeightAry;

@property (nonatomic,copy) NSString *complaintNum,*orgid,*processCode;
@property (nonatomic,strong) NSMutableArray *title1,*title2,*value1,*value2;
@property (nonatomic,strong) NSURLConnHelper *webservice;

@property (nonatomic,assign) int nDataType;
@end
