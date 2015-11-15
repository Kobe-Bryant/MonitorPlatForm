//
//  OpinionViewController.h
//  EvePad
//
//  Created by chen on 11-7-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"
#import "QQSectionHeaderView.h"
#import "UsualOpinionVC.h"

@class WebServiceHelper;

@protocol ModifiedWordsDelegate
- (void)returnModifiedWords:(NSString *)words;
@end



@interface OpinionViewController : UIViewController
<UITableViewDelegate,UITableViewDataSource, WordsDelegate,QQSectionHeaderViewDelegate,NSXMLParserDelegate,UITextViewDelegate,UsualOpinionDelegate> {

	IBOutlet UITextView	*opinion;
	NSString   *origOpinion;
    IBOutlet UIButton *load;
	IBOutlet UITextField *signature;
    
	UIPopoverController *wordsPopoverController;
	CommenWordsViewController* wordsSelectViewController;
	id<ModifiedWordsDelegate> delegate;
	
	NSMutableArray *lists;
	
	IBOutlet UITableView *myTableView;
	
	NSMutableString *currentParsedData;
	int nParserStatus;
	NSString *curDepartID;   //部门id
	NSString *curPersonName;  //人名
	NSString *curDepartName; //部门名称
	
	NSMutableDictionary *departDic; //key是部门名称  value是部门人员数组
	NSMutableArray *departNameAry;  //因为dictionary会自动排序 所以用departNameAry来存储xml部门的顺序
    
    BOOL hasSave;
}
-(IBAction)jingYongYuBtnPressed:(id)sender;    //敬用语
-(IBAction)changYongYiJianBtnPressed:(id)sender;//常用意见
-(IBAction)lianJieCiBtnPressed:(id)sender;//联接词
-(IBAction)zhiWuMingChenBtnPressed:(id)sender;//职务名称

-(IBAction)clearOpinionText:(id)sender;//清空重写
-(IBAction)saveAndGoBack:(id)sender;//保存返回
-(IBAction)cancelAndGoBack:(id)sender;//取消
-(IBAction)saveTemplate:(id)sender;//保存模板
-(IBAction)refreshPersonLists:(id)sender; //更新人员列表


-(IBAction)backgroundTap:(id)sender;

@property (nonatomic, retain) UITextView* opinion;
@property (nonatomic, retain) NSString *origOpinion;
@property (nonatomic, assign) id <ModifiedWordsDelegate> delegate;

@property (nonatomic, retain) UIPopoverController* wordsPopoverController;
@property (nonatomic, retain) CommenWordsViewController* wordsSelectViewController;

@property (nonatomic, retain) UIPopoverController *opinionPopover;
@property (nonatomic, retain) UsualOpinionVC *opinionSelectVC;

@property (nonatomic, retain) UITableView *myTableView;
@property (nonatomic, strong) IBOutlet UIButton *jyyBtn;
@property (nonatomic, strong) IBOutlet UIButton *cyyjBtn;
@property (nonatomic, strong) IBOutlet UIButton *ljcBtn;
@property (nonatomic, strong) IBOutlet UIButton *zwmcBtn;
@property (nonatomic, strong) IBOutlet UIButton *bcmbBtn;
@property (nonatomic, strong) IBOutlet UIButton *cleanBtn;
@property (nonatomic, strong) IBOutlet UIButton *saveBtn;
@property (nonatomic, strong) IBOutlet UIButton *cancelBtn;
@property (nonatomic, strong) IBOutlet UIImageView *backgrandView;

@property (nonatomic, retain) NSMutableString *currentParsedData;
@property (nonatomic, retain) NSMutableDictionary *departDic;
@property (nonatomic, retain) NSMutableArray *departNameAry;
@property (nonatomic, copy) NSString *curDepartID;   //部门id
@property (nonatomic, copy) NSString *curPersonName;  //人名
@property (nonatomic, copy) NSString *curDepartName; //部门名称
@property (nonatomic, retain) UIButton *load;
@property (nonatomic,strong) WebServiceHelper *webHelper;

@end
