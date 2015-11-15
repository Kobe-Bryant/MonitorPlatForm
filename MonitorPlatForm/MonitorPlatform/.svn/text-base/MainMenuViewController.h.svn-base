//
//  MainMenuViewController.h
//  Eve
//
//  Created by yushang on 10-11-21.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "RequestNumberObject.h"

#import "DataSyncManager.h"

@interface MainMenuViewController : UIViewController <UIScrollViewDelegate,UIAlertViewDelegate,RequestNumberDelegate>{

	UIScrollView *scrollView;

    BOOL pageControlIsChangingPage;
	NSMutableArray *aryBadgeViews;
	NSMutableArray *viewControllers;
    
    NSInteger oaCount;
    NSInteger xfCount;
    NSInteger xzcfCount;
    NSInteger zsxkCount;
     DataSyncManager *syncManager;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UIPageControl *pageControl;
@property (nonatomic, retain) IBOutlet UIImageView *bgImageView;
@property (nonatomic, retain) NSMutableArray *viewControllers;
@property (nonatomic, retain) RequestNumberObject *oaRequestNumber;
@property (nonatomic, retain) RequestNumberObject *xfRequestNumber;
@property (nonatomic, retain) RequestNumberObject *xzcfRequestNumber;
@property (nonatomic, retain) RequestNumberObject *zsxkRequestNumber;


- (IBAction)changePage:(id)sender;
- (void)setupPage;
- (void)toggleFromByPage:(NSInteger) nPage ByIndex:(NSInteger) nIndex;
@property(nonatomic,strong)NSMutableArray *aryBadgeViews;
@end
