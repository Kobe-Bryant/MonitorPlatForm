//
//  ButtonViewController.h
//  Eve
//
//  Created by yushang on 10-11-27.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define MAX_BUTTON_COUNT 20
@interface ButtonViewController : UIViewController {
	UILabel* lblTitle;
	UIButton* btn[MAX_BUTTON_COUNT];

	NSInteger page;//第几页
    NSString *pageTitle; //每一页的标题
	UIViewController* parent;
    NSArray *btnNamesAry;
    NSMutableArray *aryBadgeViews;
}

@property (assign) UIViewController* parent;
@property(nonatomic,strong)  NSString *pageTitle;
@property (nonatomic, retain) IBOutlet UILabel *lblTitle;
@property (nonatomic, retain) NSArray *btnNamesAry;
@property(nonatomic,strong)NSMutableArray *aryBadgeViews;

- (id)initWithButtonsAry:(NSArray*)btnsAry 
                andTitle:(NSString*)title
              andPageNum:(NSInteger)pageNum;
-(void)toggleFrom:(id)sender;
-(void)updateBadgesWithOaCount:(NSInteger)oaCount andXfCount:(NSInteger)xfCount andChufaCount:(NSInteger)chufaCount andZaoShengCount:(NSInteger)zaoshengCount;
@end
