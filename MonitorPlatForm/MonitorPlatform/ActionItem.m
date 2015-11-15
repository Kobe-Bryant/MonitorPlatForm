//
//  ActionItem.m
//  EvePad
//
//  Created by chen on 11-5-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ActionItem.h"

@implementation AttachFileItem 
@synthesize fileName,fileID,isTif,isJPG;
@end

@implementation ActionItem
@synthesize  Name;//
@synthesize  ActionType; //指明在选择接人收时，是多选(1)还是单选(0)
@synthesize  ActionID;
@synthesize  handled;
@synthesize  Type;
@synthesize  ToTaskID;
@synthesize  UserIDAry;
@synthesize  UserNameAry;
@synthesize  UserDepartmentNameAry,selectedUsersAry;

-(void)dealloc{
    [Name release];
    [ActionID release];
    [Type release];
    [ToTaskID release];
    [UserDepartmentNameAry release];
    [selectedUsersAry release];
    [UserIDAry release];
    [UserNameAry release];
    [ActionType release];
    [super dealloc];
}
@end
