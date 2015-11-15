//
//  WryXmspModel.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-1.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WryDataModel.h"

@interface WryXmspModel : WryDataModel<NSURLConnHelperDelegate,NSXMLParserDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) NSArray *xmspArray;
@property (nonatomic,assign) BOOL isLoading;
@end

