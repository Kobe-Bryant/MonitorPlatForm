//
//  ProcesserInfoItem.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-2-15.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProcesserInfoItem : NSObject

@property (nonatomic,copy) NSString *stepID;              //步骤id
@property (nonatomic,copy) NSString *nextProcesser;       //下一个处理人，无论是退回还是流转
@property (nonatomic,copy) NSString *stepDesc;            //步骤描述
@property (nonatomic,copy) NSString *stepDept;            //人员部门
@property (nonatomic,retain) NSMutableArray *processers;  //处理人集合
@property (nonatomic,copy) NSString *currentProcesser;    //原处理人
@property (nonatomic,assign) BOOL canSplit;               //可否多处理人
@property (nonatomic,copy) NSString *nextProcesserID;     //下个处理人id

- (ProcesserInfoItem *)init;
@end
