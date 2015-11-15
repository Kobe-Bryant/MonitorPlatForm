//
//  ToDoOAController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-10.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoOAItem.h"
#import "NSURLConnHelperDelegate.h"
@class WebServiceHelper;

@interface ToDoOAController : UITableViewController <UIScrollViewDelegate,NSURLConnHelperDelegate,NSXMLParserDelegate> {
	
	NSMutableArray *aryItems;	
	NSMutableString *curParsedData;
    ToDoOAItem *tmpTodoItem;
    
	int currentPageIndex;	
	BOOL isLoading;	
	int totalPage;//所有页数
	int totalRow; //所有条目
	int nParserStatus;
	BOOL bUpdateFlag;
    BOOL isNone;
    
    UIImageView *emptyView;
}


@property (nonatomic, retain) NSMutableArray *aryItems;
@property(nonatomic, retain) NSMutableString *curParsedData;
@property (nonatomic,strong) WebServiceHelper *webHelper;

-(void)getInitialItemsList;
- (void)getDaiBan;
@end
