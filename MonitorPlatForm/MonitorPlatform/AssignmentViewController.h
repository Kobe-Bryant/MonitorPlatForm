//
//  AssignmentViewController.h
//  MonitorPlatform
//
//  Created by PowerData on 14-2-13.
//  Copyright (c) 2014年 博安达. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AssignmentViewController : UIViewController
@property (retain, nonatomic) IBOutlet UITextField *sceneTextField;
@property (retain, nonatomic) IBOutlet UITextField *generalTextField;
@property (retain, nonatomic) IBOutlet UITextField *pollutionName;
@property (retain, nonatomic) IBOutlet UITextField *pollutionAddress;
@property (retain, nonatomic) IBOutlet UITextField *representative;
@property (retain, nonatomic) IBOutlet UITextField *phoneNumber;
@property (retain, nonatomic) IBOutlet UITextField *missionTime;
@property (retain, nonatomic) IBOutlet UITextField *addPerson;
@property (retain, nonatomic) IBOutlet UITextView *taskDescription;
@property (nonatomic) BOOL isTastDone;
@end
