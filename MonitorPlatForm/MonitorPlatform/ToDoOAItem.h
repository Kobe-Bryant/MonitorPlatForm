//
//  OAToDoItem.h
//  MonitorPlatform
//
//  Created by 张 仁松 on 12-2-10.
//  Copyright (c) 2012年 博安达. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ToDoOAItem : NSObject
@property(nonatomic,strong)NSString *guid; 
@property(nonatomic,strong)NSString *title; 
@property(nonatomic,strong)NSString *generateDate; 
@property(nonatomic,strong)NSString *fromPerson;
@property(nonatomic,strong)NSString *fileType;       

@end
