//
//  WryQueryViewController.h
//  BoandaProject
//
//  Created by 曾静 on 13-10-17.
//  Copyright (c) 2013年 szboanda. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "CommenWordsViewController.h"

@interface WryQueryViewController : BaseViewController <UITableViewDataSource, UITableViewDelegate, WordsDelegate, UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITableView *listTableView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UITextField *addressField;
@property (strong, nonatomic) IBOutlet UILabel *dwlxLabel;
@property (strong, nonatomic) IBOutlet UITextField *dwlxField;
@property (strong, nonatomic) IBOutlet UILabel *jgjbLabel;
@property (strong, nonatomic) IBOutlet UITextField *jgjbField;
@property (strong, nonatomic) IBOutlet UIButton *searchButton;

@end
