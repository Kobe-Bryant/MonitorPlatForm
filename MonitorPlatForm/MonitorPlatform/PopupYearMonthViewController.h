//
//  PopupYearMonthViewController.h
//  EPad
//
//  Created by chen on 11-4-28.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PopupYearMonthViewController;

@protocol PopupYearMonthDelegate

- (void)popupController:(PopupYearMonthViewController *)controller Saved:(BOOL)bSaved selectedYear:(NSInteger)year andMonth:(NSInteger)month;
@end

@interface PopupYearMonthViewController : UIViewController<UIPickerViewDelegate,UIPickerViewDataSource> {

	id<PopupYearMonthDelegate> delegate;
	UIPickerView *myPicker;

}
@property (nonatomic, assign) id<PopupYearMonthDelegate> delegate;
@property (nonatomic, retain) UIPickerView *myPicker;



@end
