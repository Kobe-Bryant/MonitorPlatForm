//
//  ToDoOADetailController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-10.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDoOAItem.h"
#import "ActionItem.h"

#import "CommenWordsViewController.h"
#import "OpinionViewController.h"
#import "PersonSelectViewController.h"
#import "ActionItemsController.h"
#import "AttachmentFilesController.h"
#import "NSURLConnHelperDelegate.h"
@class WebServiceHelper;

@interface ToDoOADetailController : UITableViewController <ModifiedWordsDelegate,OpenFileDelegate,HandleActionDelegate,NSXMLParserDelegate,NSURLConnHelperDelegate>{

    NSMutableString *currentParsedData;
    
    int nParserStatus;
    int nParserStatusFather;

    NSMutableArray* attachFileAry;

    NSMutableArray* formcontentNodeAry;
    NSMutableArray* formcontentValueAry;
    NSMutableArray* canWriteAry;
    NSMutableArray* formcontentPinyinNameAry;


    int currentPopRow;

    UIPopoverController *handleActionPopoverController;
    ActionItemsController* actionController;

    UIPopoverController *filesPopoverController;
    AttachmentFilesController* filesController;
    AttachFileItem *tmpFileItem;
    

}
@property(nonatomic,retain)ToDoOAItem *aItem;
@property (nonatomic,assign) BOOL isDone;
@property (nonatomic, retain)NSArray *formalAry;
@property(nonatomic, retain) NSMutableString *currentParsedData;

@property(nonatomic, retain) NSMutableArray* attachFileAry;
@property(nonatomic, retain) NSMutableArray* formcontentNodeAry;
@property(nonatomic, retain) NSMutableArray* formcontentValueAry;
@property(nonatomic, retain) NSMutableArray* canWriteAry;
@property(nonatomic, retain) NSMutableArray* formcontentPinyinNameAry;
@property(nonatomic, retain) NSMutableArray *cellHeightAry;

@property(nonatomic, retain) UIPopoverController *handleActionPopoverController;
@property(nonatomic, retain) ActionItemsController* actionController;
@property (nonatomic,strong) WebServiceHelper *webHelper;
@property(nonatomic, retain) UIPopoverController *filesPopoverController;
@property(nonatomic, retain) AttachmentFilesController* filesController;
- (void)getDetail:(NSString*)guid;
@end
