//
//  HandleActionController.h
//  EvePad
//
//  Created by chen on 11-6-3.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionItem.h"
#import "ToDoOADetailController.h"
@class ActionItemsController;
@class WebServiceHelper;
@interface HandleActionController : UIViewController<UIAlertViewDelegate, UITableViewDelegate,UITableViewDataSource,NSXMLParserDelegate> {
	ActionItem *action;
	UIButton *sendBtn;
	UITableView *myTableView;
	NSMutableArray *tmpSelectedUserIDAry;
	NSString *baseInfoXML; //基本信息中需要返回的xml	
	NSMutableString *commitResult;

    ToDoOADetailController *daibanDetail;
	ActionItemsController* parentController;	
    
}
@property (nonatomic,retain)ActionItem *action;
@property (nonatomic,retain)UIButton *sendBtn;
@property (nonatomic,retain)UITableView *myTableView;
@property (nonatomic,copy)NSMutableArray *tmpSelectedUserIDAry;
@property(nonatomic,copy)NSString *baseInfoXML;
@property (nonatomic,strong) WebServiceHelper *webHelper;

@property(nonatomic, retain) ActionItemsController* parentController;

@end
