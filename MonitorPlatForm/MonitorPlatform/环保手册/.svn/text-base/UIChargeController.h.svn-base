//
//  UIChargeController.h
//  EPad
//
//  Created by chen on 11-6-15.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

#define PAGE_TYPE_NONE  0 //不是首页(ROOT)
#define PAGE_TYPE_FLFG  1 //@"法律法规"
#define PAGE_TYPE_ZYZDS 2 //@"作业指导书"
#define PAGE_TYPE_NBZD  3 //@"内部管理制度"
#define PAGE_TYPE_HBBZ  4 //@"环保标准"
#define PAGE_TYPE_YJZN  5 //@"应急指南"

@interface UIChargeController : UIViewController <UITableViewDelegate,UITableViewDataSource,UISearchBarDelegate>{
    UISearchBar *_searchBar;
	IBOutlet UITableView *myTableView;
    NSMutableArray *dataFGBH;
	NSMutableArray *dataFGMC;
	NSMutableArray *dataWJMC;
	NSMutableArray *dataSFML;
	NSMutableArray *dataFGDH;
    NSMutableArray *dataDLDM;
    
    BOOL isExisSelect;
    BOOL isSelect;
    NSString *viewTitle;
    sqlite3 *data_db;
}
@property(nonatomic,retain)UITableView *myTableView;
@property(nonatomic,retain) NSMutableArray *dataFGBH;
@property(nonatomic,retain) NSMutableArray *dataFGMC;
@property(nonatomic,retain) NSMutableArray *dataWJMC;
@property(nonatomic,retain) NSMutableArray *dataSFML;
@property(nonatomic,retain) NSMutableArray *dataFGDH;
@property(nonatomic,retain) NSMutableArray *dataDLDM;


@property(nonatomic,strong) UISearchBar *_searchBar; 
@property(nonatomic,strong) NSMutableArray *saveFGMC;
@property(nonatomic,strong) NSMutableArray *allInfo;
@property(nonatomic,strong) NSString *viewTitle;
@property(nonatomic,assign) BOOL isSelect;
@property(nonatomic,assign) BOOL isExisSelect;
@property(nonatomic,assign) NSInteger firstPageType; //首页显示的类型
//-(void)searchByFIDH:(id)strFIDH;
-(void)searchByFIDH:(id)strFIDH root:(id)rootMl;

@end
