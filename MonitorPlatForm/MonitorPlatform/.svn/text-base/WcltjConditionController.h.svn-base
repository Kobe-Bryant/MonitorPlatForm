//
//  WcltjConditionController.h
//  MonitorPlatform
//
//  Created by 王 哲义 on 12-4-25.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WcltjConditionDelegate
-(void)getFromDate:(NSDate*)fromDate andEndDate:(NSDate*)endDate andWaste:(NSString *)category;
-(void)cancelInputCondition;
@end

@interface WcltjConditionController : UIViewController
{
    UIDatePicker *myPicker;
}
@property (nonatomic, assign) id<WcltjConditionDelegate> delegate;
@property (nonatomic, retain) UIDatePicker *fromPicker;
@property (nonatomic, retain) UIDatePicker *endPicker;
@property (nonatomic, retain) UITextField *categoryField;
@property (nonatomic) UIDatePickerMode datePickerMode;


-(id)initWithPickerMode:(UIDatePickerMode) mode;
@end
