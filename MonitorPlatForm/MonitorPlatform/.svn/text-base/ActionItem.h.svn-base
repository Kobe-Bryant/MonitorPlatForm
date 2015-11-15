//
//  ActionItem.h
//  EvePad
//
//  Created by chen on 11-5-31.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AttachFileItem : NSObject 
@property(nonatomic,retain)NSString *fileName;
@property(nonatomic,retain)NSString *fileID;
@property(nonatomic,assign)BOOL isTif; //NO 表明是正文.doc
@property(nonatomic) BOOL isJPG;
@end

@interface ActionItem : NSObject {

	NSString *Name;//
	NSString *ActionType; //指明在选择接人收时，是多选(1)还是单选(0)
	NSString *ActionID;
	NSString *Type;
	NSString *ToTaskID;
	BOOL handled;////如果执行此操作，handled为true
	NSMutableArray *UserIDAry;
	NSMutableArray *UserNameAry;
	NSMutableArray *UserDepartmentNameAry;
	
	NSMutableArray *selectedUsersAry;//存放选择的UserID
	
}

@property(nonatomic,copy) NSString *Name;//
@property(nonatomic,copy)NSString * ActionType; //指明在选择接人收时，是多选(1)还是单选(0)
@property(nonatomic,copy)NSString * ActionID;
@property(nonatomic,copy)NSString * Type;
@property(nonatomic,copy)NSString * ToTaskID;
@property(nonatomic,assign)BOOL handled;
@property(nonatomic,retain) NSMutableArray *UserIDAry;
@property(nonatomic,retain) NSMutableArray *UserNameAry;
@property(nonatomic,retain) NSMutableArray *UserDepartmentNameAry;
@property(nonatomic,retain) NSMutableArray *selectedUsersAry;
@end
