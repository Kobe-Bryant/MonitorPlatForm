//
//  ChooseDateRangeController.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-3-7.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ChooseDateRangeDelegate
-(void)choosedFromDate:(NSString *)fromDate andEndDate:(NSString *)endDate;
-(void)cancelSelectDateRange;
@end

@interface ChooseDateRangeController : UIViewController

@property (nonatomic, assign) id<ChooseDateRangeDelegate> delegate;
@property (nonatomic, retain) UIDatePicker *fromDatePicker;
@property (nonatomic, retain) UIDatePicker *endDatePicker;

-(id)init;

@end
