//
//  NSString+MD5Addition.h
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITableViewCell (Custom)

+ (UITableViewCell *)makeSubCell:(UITableView *)tableView
                    withSubvalue:(NSString *)aValue
                    andSubvalue1:(NSString *)aValue1 andNum:(int)aNum;

+(UITableViewCell*)makeSubCell:(UITableView *)tableView
					 withTitle:(NSString *)aTitle
						 value:(NSString *)aValue
                        height:(NSInteger)aHeight;



//oa公文列表编辑方法
+(UITableViewCell*)makeSubCell:(UITableView *)tableView 
                     withTitle:(NSString *)title
                        sender:(NSString *)aSender 
                      withDate:(NSString*) aDate;


//信访列表表栏编辑方法
+ (UITableViewCell *)makeSubCell:(UITableView *)tableView 
                       withTitle:(NSString *)aTitle
                        caseCode:(NSString *)aCode 
                   complaintDate:(NSString *)aCDate 
                         endDate:(NSString *)aEDate
                            Mode:(NSString *)aMode;


//信访流程表栏编辑方法
+ (UITableViewCell *)makeSubCell:(UITableView *)tableView
                           Title:(NSString *)aTitle
                         Opinion:(NSString *)aOpinion
                       Signature:(NSString *)aSignature;

//处罚流程表栏编辑棒法
+ (UITableViewCell *)makeSubCell:(UITableView *)tableView 
                           Title:(NSString *)aTitle 
                         Opinion:(NSString *)aOpinion 
                          Status:(NSString *)aStatus 
                            Type:(NSString *)aType 
                          Person:(NSString *)aPerson 
                            Date:(NSString *)aDate;


+(UITableViewCell*)makeMultiLabelsCell:(UITableView *)tableView
                             withTexts:(NSArray *)valueAry
                             andHeight:(CGFloat)height
                              andWidth:(CGFloat)totalWidth
                         andIdentifier:(NSString *)identifier;

+ (UITableViewCell*)makeSubCell:(UITableView *)tableView
                     withValue1:(NSString *)aTitle
                         value2:(NSString *)aTitle2
                         value3:(NSString *)aValue
                         value4:(NSString *)aValue2
                         height:(NSInteger)aHeight;

//标签对表栏编辑方法
+(UITableViewCell *)makeCoupleLabelsCell:(UITableView *)tableView
                             coupleCount:(NSInteger)count
                              cellHeight:(CGFloat)height 
                              valueArray:(NSArray *)valueAry;

//联单表头编辑方法
+(UIView *)makeHeaderViewForTableView:(UITableView *)tableView
                         valueArray:(NSArray *)valueAry
                       headerHeight:(CGFloat)height;

//数量统计表栏编辑方法
+(UITableViewCell *)makeTDCellForTableView:(UITableView *)tableView
                                valueArray:(NSArray *)valueAry
                              statisticNum:(NSString *)numString
                                cellHeight:(CGFloat)height
                                 andWidths:(NSArray*)widthAry;

//台账列表表栏编辑方法
+ (UITableViewCell *)makeSubCell:(UITableView *)tableView
                       withTitle:(NSString *)aTitle
                    andSubvalue1:(NSString *)aCode
                    andSubvalue2:(NSString *)aCDate
                    andSubvalue3:(NSString *)aEDate
                    andSubvalue4:(NSString *)aMode
                    andNoteCount:(NSInteger)num;

//多列表头编辑方法
+(UIView *)makeHeaderViewForTableView:(UITableView *)tableView
                           valueArray:(NSArray *)valueAry
                           widthArray:(NSArray *)widthAry
                         headerHeight:(CGFloat)height;
//多列表格编辑方法
+ (UITableViewCell*)makeMultiLabelsCell:(UITableView *)tableView
                              withTexts:(NSArray *)valueAry
                              andWidths:(NSArray*)widthAry
                              andHeight:(CGFloat)height
                          andIdentifier:(NSString *)identifier;

+(UITableViewCell*)makeMultiLabelsCell:(UITableView *)tableView
                             withTexts:(NSArray *)valueAry
                             andWidths:(NSArray*)widthAry
                             andHeight:(CGFloat)height
                         andIdentifier:(NSString *)identifier
                            firstAlign:(NSTextAlignment)align;

//建筑工程项目列表编辑方法
+ (UITableViewCell *)makeSubCell:(UITableView *)tableView 
                       withTitle:(NSString *)aTitle
                          andOne:(NSString *)aCode 
                          andTwo:(NSString *)aCDate 
                        andThree:(NSString *)aEDate
                         andFour:(NSString *)aMode;

@end
