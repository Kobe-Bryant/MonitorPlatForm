//
//  PunishOpinionController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-23.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AttachesListController.h"
#import "PopupDateViewController.h"
#import "NSURLConnHelper.h"

@interface PunishOpinionController : UIViewController <NSURLConnHelperDelegate,UITableViewDataSource,UITableViewDelegate,ReturnSelectedRowDelegate,NSXMLParserDelegate,PopupDateDelegate>

@property (nonatomic,strong) IBOutlet UITableView *infoTableView;
@property (nonatomic,strong) IBOutlet UITextView *opinionTextView;
@property (nonatomic,strong) IBOutlet UITextField *nameTextField;
@property (nonatomic,strong) IBOutlet UITextField *dateTextField;
@property (nonatomic,strong) IBOutlet UILabel *qpyjLabel;
@property (nonatomic,strong) IBOutlet UILabel *qprLabel;
@property (nonatomic,strong) IBOutlet UILabel *qprqLabel;
@property (nonatomic,strong) IBOutlet UIButton *saveBtn;

@property (nonatomic,strong) NSURLConnHelper *webservice;
@property (nonatomic,copy) NSString *userid;
@property (nonatomic,copy) NSString *itemID;
@property (nonatomic,strong) NSDictionary *infoDic;
@property (nonatomic,strong) NSArray *processArray;
@property (nonatomic,strong) NSArray *attachArray;
@property (nonatomic,assign) CGRect currentRect;

@property (nonatomic,strong) NSArray *titleArr;
@property (nonatomic,strong) NSArray *valueArr;
@property (nonatomic,strong) NSArray *titleArr2;
@property (nonatomic,strong) NSArray *valueArr2;

@property (nonatomic, retain) UIPopoverController *popController;
@property (nonatomic, retain) PopupDateViewController *dateController;

@property (nonatomic,strong) NSMutableArray *trueProof;
@property (nonatomic,strong) NSMutableArray *programProof;
@property (nonatomic,strong) NSMutableArray *cellHeightAry;

@property (nonatomic,assign) int nParserStatus;
@property (nonatomic,strong) NSMutableString *currentString;
@property (nonatomic,assign) BOOL bCommit;

@property (nonatomic,assign) int nDataType;

- (IBAction)saveButtonPressed:(id)sender;

@end
