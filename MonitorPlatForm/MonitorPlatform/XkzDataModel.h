//
//  XkzDataModel.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-1.
//  Copyright (c) 2012年 博安达. All rights reserved.
// 许可证信息

#import <Foundation/Foundation.h>
#import "WryDataModel.h"

@interface XkzDataModel : WryDataModel <NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *webResultAry;
@property (nonatomic,assign) BOOL isLoading;

@end
