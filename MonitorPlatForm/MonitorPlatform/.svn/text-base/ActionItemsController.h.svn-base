//
//  ActionItemsController.h
//  EvePad
//
//  Created by chen on 11-7-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol HandleActionDelegate
- (void)doneAndBack;
@end
#import "ActionItem.h"
#import "NSURLConnHelperDelegate.h"
@class WebServiceHelper;

@interface ActionItemsController : UITableViewController<NSXMLParserDelegate,NSURLConnHelperDelegate> {

	NSMutableArray* actionAry;
	NSString *baseInfoXML; //基本信息中需要返回的xml
	id<HandleActionDelegate> delegate;
    int nParserStatus;
    int nParserStatusFather;
    ActionItem *tmpActionItem;
    
}
@property(nonatomic,retain)NSMutableArray* actionAry;
@property(nonatomic,copy)NSString *baseInfoXML;
@property(nonatomic,copy)NSString *gwGUID;
@property(nonatomic, retain) NSMutableString *currentParsedData;
@property(nonatomic, assign)id<HandleActionDelegate> delegate;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@end
