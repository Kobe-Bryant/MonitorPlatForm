//
//  SearchWryController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-23.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommenWordsViewController.h"

@interface SearchWryController : UIViewController<UITableViewDataSource,UITableViewDelegate,NSXMLParserDelegate,WordsDelegate>
@property(nonatomic,strong) IBOutlet UITextField *nameField;
@property(nonatomic,strong) IBOutlet UITextField *addressField;
@property(nonatomic,strong) IBOutlet UITextField *areaField;
@property(nonatomic,strong) IBOutlet UITextField *streetField;
@property(nonatomic, assign) BOOL isGotJsonString;
@property(nonatomic, strong) NSMutableString *curParsedData;
@property(nonatomic,strong) IBOutlet UITableView *resTableView;
@property(nonatomic,strong) NSArray *aryParsedItem;
@property (nonatomic,strong) CommenWordsViewController *wordsSelectViewController;
@property (nonatomic,strong) UIPopoverController *wordsPopoverController;
-(IBAction)searchBtnPressed:(id)sender;
-(IBAction)areaFieldPressed:(id)sender;
@end
