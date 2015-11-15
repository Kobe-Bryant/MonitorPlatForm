//
//  NSString+MD5Addition.m
//  UIDeviceAddition
//
//  Created by Georg Kitz on 20.08.11.
//  Copyright 2011 Aurora Apps. All rights reserved.
//

#import "UITableViewCell+Custom.h"
#import <CommonCrypto/CommonDigest.h>
#import "TDBadgedCell.h"
#import "NumberUtil.h"

@implementation UITableViewCell (Custom)

//一行四个label
+ (UITableViewCell*)makeSubCell:(UITableView *)tableView
                     withValue1:(NSString *)aTitle
                         value2:(NSString *)aTitle2
                         value3:(NSString *)aValue
                         value4:(NSString *)aValue2
                         height:(NSInteger)aHeight
{
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cellcustom6"];
    if (aCell == nil) {
        aCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellcustom6"];
    }
    
	UILabel* label1 = nil;
    UILabel* label2 = nil;
    UILabel* label3 = nil;
    UILabel* label4 = nil;
    
	if (aCell.contentView != nil)
	{
        label1 = (UILabel *)[aCell.contentView viewWithTag:1];
        label2 = (UILabel *)[aCell.contentView viewWithTag:2];
        label3 = (UILabel *)[aCell.contentView viewWithTag:3];
        label4 = (UILabel *)[aCell.contentView viewWithTag:4];
    }
	
	if (label1 == nil) {
		CGRect tRect = CGRectMake(10, 0, 150, aHeight);
        NSMutableArray *ary = [NSMutableArray arrayWithCapacity:4];
        for(int i=0;i<4;i++){
            UILabel *tLabel = [[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
            [tLabel setBackgroundColor:[UIColor clearColor]];
            
            tLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
            if(i%2 == 0){
                tRect.origin.x += 165;
                tRect.size.width = 205;
                tLabel.textAlignment = UITextAlignmentRight;
                [tLabel setTextColor:[UIColor darkGrayColor]];
            }
            else{
                tRect.size.width = 150;
                tRect.origin.x += 205;
                tLabel.textAlignment = UITextAlignmentLeft;
                [tLabel setTextColor:[UIColor blackColor]];
            }
            
            tLabel.numberOfLines = 3;
            tLabel.tag = i+1;
            [aCell.contentView addSubview:tLabel];
            
            
            [ary addObject:tLabel];
        }
        label1 = [ary objectAtIndex:0];
        label2 = [ary objectAtIndex:1];
        label3 = [ary objectAtIndex:2];
        label4 = [ary objectAtIndex:3];
        
    }
    
    if (aTitle == nil) aTitle = @"";
    if (aValue == nil) aValue = @"";
    if (aTitle2 == nil) aTitle2 = @"";
    if (aValue2 == nil) aValue2 = @"";
    
    if (label1 != nil)  [label1 setText:[NSString stringWithFormat:@"%@",aTitle]];
    if (label2 != nil)  [label2 setText:[NSString stringWithFormat:@"%@",aValue]];
    if (label3 != nil) [label3 setText:[NSString stringWithFormat:@"%@",aTitle2]];
    if (label4 != nil) [label4 setText:[NSString stringWithFormat:@"%@",aValue2]];
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
	return aCell;
}



+(UITableViewCell*)makeSubCell:(UITableView *)tableView
					 withTitle:(NSString *)aTitle
						 value:(NSString *)aValue
                        height:(NSInteger)aHeight;
{
    UILabel* lblTitle = nil;
	UILabel* lblValue = nil;
	UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cellcustom"];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellcustom"] autorelease];
    }
    
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		lblValue = (UILabel *)[aCell.contentView viewWithTag:2];
	}
	
	if (lblTitle == nil) {
		CGRect tRect2 = CGRectMake(5, 0, 160, aHeight);
		lblTitle = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor darkGrayColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		lblTitle.textAlignment = UITextAlignmentRight;
        lblTitle.numberOfLines = 2;
		lblTitle.tag = 1;
		[aCell.contentView addSubview:lblTitle];
		[lblTitle release];
		
		CGRect tRect3 = CGRectMake(180, 0, 520, aHeight);
		lblValue = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lblValue setBackgroundColor:[UIColor clearColor]];
		[lblValue setTextColor:[UIColor blackColor]];
		lblValue.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		lblValue.textAlignment = UITextAlignmentLeft;
        lblValue.numberOfLines = 2;
		lblValue.tag = 2;	
		[aCell.contentView addSubview:lblValue];
		[lblValue release];
	}
	if (aTitle == nil) aTitle = @"";
    if (aValue == nil) aValue = @"";
	if (lblTitle != nil)	[lblTitle setText:aTitle];
	if (lblValue != nil)	[lblValue setText:aValue];
	
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
	return aCell;
}


+(UITableViewCell*)makeSubCell:(UITableView *)tableView 
                     withTitle:(NSString *)title
                        sender:(NSString *)aSender 
                      withDate:(NSString*) aDate
{
    CGRect tRect1;
    CGRect tRect2;
    CGRect tRect3;
    NSString *cellIdentifier;
	
    tRect1 = CGRectMake(60, 3, 700, 54);
    tRect2 = CGRectMake(75, 56, 150, 24);
    tRect3 = CGRectMake(430, 56, 270, 24);
    cellIdentifier = @"cell_portraitOAList";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    UILabel* lblTitle = nil;
	UILabel* lblSender = nil;
	UILabel* lblDate = nil;
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		lblSender = (UILabel *)[aCell.contentView viewWithTag:2];
		lblDate = (UILabel *)[aCell.contentView viewWithTag:3];
	}
    
	if (lblTitle == nil) {
		//CGRect tRect1 = CGRectMake(60, 3, 700, 48);
		lblTitle = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor blackColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:22.0];
		lblTitle.textAlignment = UITextAlignmentLeft;
		lblTitle.numberOfLines = 2;
		lblTitle.tag = 1;
		[aCell.contentView addSubview:lblTitle];
		[lblTitle release];
		
		//CGRect tRect2 = CGRectMake(75, 48, 150, 24);
		lblSender = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblSender setBackgroundColor:[UIColor clearColor]];
		[lblSender setTextColor:[UIColor grayColor]];
		lblSender.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lblSender.textAlignment = UITextAlignmentLeft;
		lblSender.tag = 2;
		[aCell.contentView addSubview:lblSender];
		[lblSender release];
		
		
		//CGRect tRect3 = CGRectMake(430, 48, 270, 24);
		lblDate = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lblDate setBackgroundColor:[UIColor clearColor]];
		[lblDate setTextColor:[UIColor grayColor]];
		lblDate.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lblDate.textAlignment = UITextAlignmentRight;
		lblDate.tag = 3;
		[aCell.contentView addSubview:lblDate];
		[lblDate release];
		
		lblTitle.backgroundColor = [UIColor clearColor];
		lblSender.backgroundColor = [UIColor clearColor];
		lblDate.backgroundColor = [UIColor clearColor];
	}
	
	if (lblTitle != nil)	[lblTitle setText:title];
	if (lblSender != nil)	[lblSender setText:[NSString stringWithFormat:@"发件人:%@", aSender]];
	if (lblDate != nil)	[lblDate setText:[NSString stringWithFormat:@"时间:%@", aDate]];
    
    aCell.accessoryType = UITableViewCellAccessoryNone;
	return aCell;
}

//信访列表表栏编辑方法
+ (UITableViewCell *)makeSubCell:(UITableView *)tableView 
                       withTitle:(NSString *)aTitle
                          caseCode:(NSString *)aCode 
                   complaintDate:(NSString *)aCDate 
                         endDate:(NSString *)aEDate
                            Mode:(NSString *)aMode
{
    CGRect tRect1;
    CGRect tRect2;
    CGRect tRect3;
    CGRect tRect4;
    CGRect tRect5;
    NSString *cellIdentifier;
    
    tRect1 = CGRectMake(60, 3, 440, 48);
    tRect2 = CGRectMake(60, 48, 440, 24);
    tRect3 = CGRectMake(400, 48, 300, 24);
    tRect4 = CGRectMake(500, 25, 200, 24);
    tRect5 = CGRectMake(500, 2, 200, 24);
    cellIdentifier = @"cell_portraitXFList";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
	UILabel* lblTitle = nil;
	UILabel* lblCode = nil;
	UILabel* lblCDate = nil;
    UILabel* lblEDate = nil;
    UILabel* lblMode = nil;
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		lblCode = (UILabel *)[aCell.contentView viewWithTag:2];
		lblCDate = (UILabel *)[aCell.contentView viewWithTag:3];
        lblEDate = (UILabel *)[aCell.contentView viewWithTag:4];
        lblMode = (UILabel *)[aCell.contentView viewWithTag:5];
	}
	
    
	if (lblTitle == nil) {
		
		lblTitle = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor blackColor]];
        lblTitle.highlightedTextColor = [UIColor whiteColor];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:20.0];
		lblTitle.textAlignment = UITextAlignmentLeft;
		lblTitle.numberOfLines = 2;
		lblTitle.tag = 1;
		[aCell.contentView addSubview:lblTitle];
		[lblTitle release];
		
		
		lblCode = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblCode setBackgroundColor:[UIColor clearColor]];
		[lblCode setTextColor:[UIColor grayColor]];
        lblCode.highlightedTextColor = [UIColor whiteColor];
		lblCode.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblCode.textAlignment = UITextAlignmentLeft;
		lblCode.tag = 2;
		[aCell.contentView addSubview:lblCode];
		[lblCode release];
		
		
		
		lblCDate = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lblCDate setBackgroundColor:[UIColor clearColor]];
		[lblCDate setTextColor:[UIColor grayColor]];
        lblCDate.highlightedTextColor = [UIColor whiteColor];
		lblCDate.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblCDate.textAlignment = UITextAlignmentRight;
		lblCDate.tag = 3;
		[aCell.contentView addSubview:lblCDate];
		[lblCDate release];
        
       
		lblEDate = [[UILabel alloc] initWithFrame:tRect4]; //此处使用id定义任何控件对象
		[lblEDate setBackgroundColor:[UIColor clearColor]];
		[lblEDate setTextColor:[UIColor grayColor]];
        lblEDate.highlightedTextColor = [UIColor whiteColor];
		lblEDate.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblEDate.textAlignment = UITextAlignmentRight;
		lblEDate.tag = 4;
		[aCell.contentView addSubview:lblEDate];
		[lblEDate release];
        
        
		lblMode = [[UILabel alloc] initWithFrame:tRect5]; //此处使用id定义任何控件对象
		[lblMode setBackgroundColor:[UIColor clearColor]];
		[lblMode setTextColor:[UIColor grayColor]];
        lblMode.highlightedTextColor = [UIColor whiteColor];
		lblMode.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblMode.textAlignment = UITextAlignmentRight;
		lblMode.tag = 5;
		[aCell.contentView addSubview:lblMode];
		[lblMode release];
        
		
		lblTitle.backgroundColor = [UIColor clearColor];
		lblCode.backgroundColor = [UIColor clearColor];
		lblCDate.backgroundColor = [UIColor clearColor];
        lblEDate.backgroundColor = [UIColor clearColor];
        lblMode.backgroundColor = [UIColor clearColor];
	}
	
	if (lblTitle != nil)	[lblTitle setText:aTitle];
	if (lblCode != nil)     [lblCode setText:aCode];
	if (lblCDate != nil)	[lblCDate setText:aCDate];
    if (lblEDate != nil)	[lblEDate setText:aEDate];
    if (lblMode != nil)     [lblMode setText:aMode];
    
    return aCell;
}

//信访流程表栏编辑方法
+ (UITableViewCell *)makeSubCell:(UITableView *)tableView
                           Title:(NSString *)aTitle
                         Opinion:(NSString *)aOpinion
                       Signature:(NSString *)aSignature
{
    CGRect tRect1;
    CGRect tRect2;
    CGRect tRect3;
    CGRect tRect4;
    NSString *cellIdentifier;
    tRect1 = CGRectMake(0, 0, 162, 44*3);
    tRect2 = CGRectMake(162, 0, 606, 44*2);
    tRect3 = CGRectMake(162, 44*2, 303, 44);
    tRect4 = CGRectMake(465, 44*2, 303, 44);
    cellIdentifier = @"cell_portraitXFProcess";
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    UILabel *titleLabel = nil;
    UITextView *opinionLabel = nil;
    UILabel *spaceLabel = nil;
    UILabel *signatureLabel = nil;
    
    if (aCell.contentView != nil) {
        titleLabel = (UILabel *)[aCell.contentView viewWithTag:1];
        opinionLabel = (UITextView *)[aCell.contentView viewWithTag:2];
        signatureLabel = (UILabel *)[aCell.contentView viewWithTag:4];
    }
    
    
    if (titleLabel == nil) {
        //CGRect tRect1 = CGRectMake(0, 0, 162, 33*2);
		titleLabel = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[titleLabel setBackgroundColor:[UIColor colorWithRed:(0x30/255.0f) green:(0x72/255.0f) blue:(0xa4/255.0f) alpha:1.0]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
		titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.numberOfLines = 2;
		titleLabel.tag = 1;
		[aCell.contentView addSubview:titleLabel];
		[titleLabel release];
        
        //CGRect tRect2 = CGRectMake(162, 0, 606, 33);
		opinionLabel = [[UITextView alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[opinionLabel setBackgroundColor:[UIColor colorWithRed:(0xde/255.0f) green:(0xf0/255.0f) blue:(0xfd/255.0f) alpha:1.0]];
        opinionLabel.text = aOpinion;
		[opinionLabel setTextColor:[UIColor blackColor]];
		opinionLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		opinionLabel.textAlignment = UITextAlignmentLeft;
        opinionLabel.editable = NO;
		opinionLabel.tag = 2;
        opinionLabel.text = aOpinion;
		[aCell.contentView addSubview:opinionLabel];
		[opinionLabel release];
        
        spaceLabel = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[spaceLabel setBackgroundColor:[UIColor colorWithRed:(0xde/255.0f) green:(0xf0/255.0f) blue:(0xfd/255.0f) alpha:1.0]];
		[spaceLabel setTextColor:[UIColor grayColor]];
		spaceLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		spaceLabel.textAlignment = UITextAlignmentRight;
        spaceLabel.numberOfLines = 2;
		spaceLabel.tag = 3;
		[aCell.contentView addSubview:spaceLabel];
		[spaceLabel release];
        
        //CGRect tRect3 = CGRectMake(162, 33, 606, 33);
		signatureLabel = [[UILabel alloc] initWithFrame:tRect4]; //此处使用id定义任何控件对象
		[signatureLabel setBackgroundColor:[UIColor colorWithRed:(0xde/255.0f) green:(0xf0/255.0f) blue:(0xfd/255.0f) alpha:1.0]];
		[signatureLabel setTextColor:[UIColor grayColor]];
		signatureLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		signatureLabel.textAlignment = UITextAlignmentCenter;
        signatureLabel.numberOfLines = 2;
		signatureLabel.tag = 4;
		[aCell.contentView addSubview:signatureLabel];
		[signatureLabel release];
    }
    
    if (titleLabel != nil)     [titleLabel setText:aTitle];
    if (opinionLabel != nil)   opinionLabel.text = aOpinion;
    if (signatureLabel != nil) [signatureLabel setText:aSignature];
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return aCell;
}


//处罚流程表栏编辑方法
+ (UITableViewCell *)makeSubCell:(UITableView *)tableView 
                           Title:(NSString *)aTitle 
                         Opinion:(NSString *)aOpinion 
                          Status:(NSString *)aStatus 
                            Type:(NSString *)aType 
                          Person:(NSString *)aPerson 
                            Date:(NSString *)aDate
{
    CGRect tRect1;
    CGRect tRect2;
    CGRect tRect3;
    CGRect tRect4;
    CGRect tRect5;
    CGRect tRect6;
    NSString *cellIdentifier;
    tRect1 = CGRectMake(0, 0, 162, 33*3);
    tRect2 = CGRectMake(162, 0, 606, 33);
    tRect3 = CGRectMake(162, 34, 303, 33);
    tRect4 = CGRectMake(465, 34, 303, 33);
    tRect5 = CGRectMake(162, 67, 303, 33);
    tRect6 = CGRectMake(465, 67, 303, 33);
    cellIdentifier = @"cell_portraitCFProcess";
    
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    UILabel *titleLabel = nil;
    UILabel *opinionLabel = nil;
    UILabel *statusLabel = nil;
    UILabel *typeLabel = nil;
    UILabel *personLabel = nil;
    UILabel *dateLabel = nil;
    
    if (aCell.contentView != nil) {
        titleLabel = (UILabel *)[aCell.contentView viewWithTag:1];
        opinionLabel = (UILabel *)[aCell.contentView viewWithTag:2];
        statusLabel = (UILabel *)[aCell.contentView viewWithTag:3];
        typeLabel = (UILabel *)[aCell.contentView viewWithTag:4];
        personLabel = (UILabel *)[aCell.contentView viewWithTag:5];
        dateLabel = (UILabel *)[aCell.contentView viewWithTag:6];
    }
    
    
    if (titleLabel == nil) {
        
		titleLabel = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[titleLabel setBackgroundColor:[UIColor colorWithRed:(0x30/255.0f) green:(0x72/255.0f) blue:(0xa4/255.0f) alpha:1.0]];
		[titleLabel setTextColor:[UIColor whiteColor]];
		titleLabel.font = [UIFont fontWithName:@"Helvetica" size:20.0];
		titleLabel.textAlignment = UITextAlignmentCenter;
        titleLabel.numberOfLines = 2;
		titleLabel.tag = 1;
		[aCell.contentView addSubview:titleLabel];
		[titleLabel release];
        
        
		opinionLabel = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[opinionLabel setBackgroundColor:[UIColor colorWithRed:(0xde/255.0f) green:(0xf0/255.0f) blue:(0xfd/255.0f) alpha:1.0]];
		[opinionLabel setTextColor:[UIColor blackColor]];
		opinionLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		opinionLabel.textAlignment = UITextAlignmentCenter;
        opinionLabel.numberOfLines = 2;
		opinionLabel.tag = 2;
		[aCell.contentView addSubview:opinionLabel];
		[opinionLabel release];
        
        
		personLabel = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[personLabel setBackgroundColor:[UIColor colorWithRed:(0xde/255.0f) green:(0xf0/255.0f) blue:(0xfd/255.0f) alpha:1.0]];
		[personLabel setTextColor:[UIColor grayColor]];
		personLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		personLabel.textAlignment = UITextAlignmentCenter;
        personLabel.numberOfLines = 2;
		personLabel.tag = 5;
		[aCell.contentView addSubview:personLabel];
		[personLabel release];
        
        
		dateLabel = [[UILabel alloc] initWithFrame:tRect4]; //此处使用id定义任何控件对象
		[dateLabel setBackgroundColor:[UIColor colorWithRed:(0xde/255.0f) green:(0xf0/255.0f) blue:(0xfd/255.0f) alpha:1.0]];
		[dateLabel setTextColor:[UIColor grayColor]];
		dateLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		dateLabel.textAlignment = UITextAlignmentCenter;
        dateLabel.numberOfLines = 2;
		dateLabel.tag = 6;
		[aCell.contentView addSubview:dateLabel];
		[dateLabel release];
        
        
		statusLabel = [[UILabel alloc] initWithFrame:tRect5]; //此处使用id定义任何控件对象
		[statusLabel setBackgroundColor:[UIColor colorWithRed:(0xde/255.0f) green:(0xf0/255.0f) blue:(0xfd/255.0f) alpha:1.0]];
		[statusLabel setTextColor:[UIColor grayColor]];
		statusLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		statusLabel.textAlignment = UITextAlignmentCenter;
        statusLabel.numberOfLines = 2;
		statusLabel.tag = 3;
		[aCell.contentView addSubview:statusLabel];
		[statusLabel release];
        
        
		typeLabel = [[UILabel alloc] initWithFrame:tRect6]; //此处使用id定义任何控件对象
		[typeLabel setBackgroundColor:[UIColor colorWithRed:(0xde/255.0f) green:(0xf0/255.0f) blue:(0xfd/255.0f) alpha:1.0]];
		[typeLabel setTextColor:[UIColor grayColor]];
		typeLabel.font = [UIFont fontWithName:@"Helvetica" size:19.0];
		typeLabel.textAlignment = UITextAlignmentCenter;
        typeLabel.numberOfLines = 2;
		typeLabel.tag = 4;
		[aCell.contentView addSubview:typeLabel];
		[typeLabel release];
    }
    
    if (titleLabel != nil)     [titleLabel setText:aTitle];
    if (opinionLabel != nil)   [opinionLabel setText:aOpinion];
    if (personLabel != nil)    [personLabel setText:aPerson];
    if (dateLabel != nil)      [dateLabel setText:aDate];
    if (statusLabel != nil)    [statusLabel setText:aStatus];
    if (typeLabel != nil)      [typeLabel setText:aType];
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return aCell;
}

+(UITableViewCell*)makeMultiLabelsCell:(UITableView *)tableView
                             withTexts:(NSArray *)valueAry
                             andHeight:(CGFloat)height
                              andWidth:(CGFloat)totalWidth
                         andIdentifier:(NSString *)identifier
{
    int labelCount = [valueAry count];
    if (labelCount <= 0 || labelCount > 10) {
        return nil;
    }
    UILabel *lblTitle[10];
    UITableViewCell *aCell;
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_Portrait",identifier];
    aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
	
	if (aCell.contentView != nil)
	{
        for (int i =0; i < labelCount; i++)
            lblTitle[i] = (UILabel *)[aCell.contentView viewWithTag:i+1];
        
        
	}
	
	if (lblTitle[0] == nil) {
        int width = totalWidth/labelCount;
        CGRect tRect = CGRectMake(4, 0, width, height);
    
        for (int i =0; i < labelCount; i++) {
            lblTitle[i] = [[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
            [lblTitle[i] setBackgroundColor:[UIColor clearColor]];
            if(i == labelCount -1)
                [lblTitle[i] setTextColor:[UIColor redColor]];
            else
                [lblTitle[i] setTextColor:[UIColor blackColor]];
            [lblTitle[i] setHighlightedTextColor:[UIColor whiteColor]];
            lblTitle[i].font = [UIFont fontWithName:@"Helvetica" size:17.0];
            lblTitle[i].textAlignment = UITextAlignmentCenter;
            lblTitle[i].numberOfLines =2;
            lblTitle[i].tag = i+1;
            [aCell.contentView addSubview:lblTitle[i]];
            [lblTitle[i] release];
            tRect.origin.x += width;
        }
        
	}
    
    for (int i =0; i < labelCount; i++){
        [lblTitle[i] setText:@""];
        
    }
    for (int i =0; i < labelCount; i++){
        NSString *value = [NSString stringWithFormat:@"%@",[valueAry objectAtIndex:i]];
        [lblTitle[i] setText:value];
    }
    
    aCell.accessoryType = UITableViewCellAccessoryNone;
	return aCell;
}


//标签对表栏编辑方法
+(UITableViewCell *)makeCoupleLabelsCell:(UITableView *)tableView 
                             coupleCount:(NSInteger)count 
                              cellHeight:(CGFloat)height 
                              valueArray:(NSArray *)valueAry
{
    if (count > 2 || count < 1) {
        return  nil;
    }
    
    
    CGFloat totalWidth;
    NSString *cellIdentifier;
    
    totalWidth = 768;
    cellIdentifier = [NSString stringWithFormat:@"cell_PortraitCoupleLabels_%d_%.1f",count,height];
        
    UITableViewCell *aCell= [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    UILabel *lblTitle[count*2];
    if (aCell.contentView != nil)
	{
        for (int i =0; i < count*2; i++)
            lblTitle[i] = (UILabel *)[aCell.contentView viewWithTag:i+1];    
	}
    
    if (lblTitle[0] == nil) {
        CGFloat x = 0;
        for (int i =0; i < count*2; i++) {
            CGFloat width;
            UITextAlignment alignment;
            UIColor *textColor;
            
            if (i%2 == 0) {
                width = totalWidth/2/5*2-20;
                textColor = [UIColor grayColor];
                alignment = UITextAlignmentRight;
            } else {
                if (count == 1)
                    width = totalWidth/2/5*8-20;
                else
                    width = totalWidth/2/5*3-20;
                
                textColor = [UIColor blackColor];
                alignment = UITextAlignmentLeft;
            }
            CGRect tRect = CGRectMake(x, 0, width, height);
            lblTitle[i] = [[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
            [lblTitle[i] setBackgroundColor:[UIColor clearColor]];
            [lblTitle[i] setTextColor:textColor];
            lblTitle[i].font = [UIFont fontWithName:@"Helvetica" size:19.0];
            lblTitle[i].textAlignment = alignment;
            lblTitle[i].numberOfLines = 0;
            lblTitle[i].tag = i+1;
            [aCell.contentView addSubview:lblTitle[i]];
            [lblTitle[i] release];
            x += (width+10);
        }
	}
    
    for (int i =0; i < count*2; i++){
        [lblTitle[i] setText:@""];
        
    }
    for (int i =0; i < count*2; i++){
        [lblTitle[i] setText:[valueAry objectAtIndex:i]];
        
    }
    
    aCell.selectionStyle = UITableViewCellSelectionStyleNone;
	return aCell;
}



#pragma mark - Solid Header View Method

+(UIView *)makeHeaderViewForTableView:(UITableView *)tableView
                           valueArray:(NSArray *)valueAry
                         headerHeight:(CGFloat)height
{
    UIView *view;
    CGFloat cellWidth = 728.0;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidth, 45)];
    
    CGFloat width[3] = {cellWidth*0.1,cellWidth*0.6,cellWidth*0.3};
    CGRect tRect = CGRectMake(0, 0, width[0], height);
    
    for (int i =0; i < [valueAry count]; i++) {
        tRect.size.width = width[i];
        UILabel *label =[[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
        label.backgroundColor = [UIColor clearColor];
        [label setTextColor:[UIColor whiteColor]];
        label.font = [UIFont systemFontOfSize:20];
        if (i == 1)
            label.textAlignment = UITextAlignmentLeft;
        else if (i == 2)
            label.textAlignment = UITextAlignmentRight;
        else 
            label.textAlignment = UITextAlignmentCenter;
        tRect.origin.x += width[i];
        
        [label setText:[valueAry objectAtIndex:i]];
        [view addSubview:label];
        [label release];
    }
    
    view.backgroundColor = CELL_HEADER_COLOR;
    return [view autorelease];
}


+ (UITableViewCell *)makeSubCell:(UITableView *)tableView
                       withSubvalue:(NSString *)aValue
                    andSubvalue1:(NSString *)aValue1 andNum:(int)aNum
                    
{
    CGRect tRect0;
    CGRect tRect1;
    CGRect tRect2;
    NSString *cellIdentifier;
    
    tRect0 = CGRectMake(10.0, 8.0, 20.0, 20.0);
    tRect1 = CGRectMake(40, 3, 300, 30);
    tRect2 = CGRectMake(400, 3, 300, 30);
    
    cellIdentifier = @"cell_portraitTZList";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
	UILabel *numLab = nil;
	UILabel *lblCDate = nil;
    UILabel *lblEDate = nil;
	if (aCell.contentView != nil)
	{
		numLab = (UILabel *)[aCell.contentView viewWithTag:12];
		lblCDate = (UILabel *)[aCell.contentView viewWithTag:13];
        lblEDate = (UILabel *)[aCell.contentView viewWithTag:14];
	}
	
    
	if (lblCDate == nil) {
        
        numLab = [[UILabel alloc] initWithFrame:tRect0];
		[numLab setBackgroundColor:[UIColor clearColor]];
		[numLab setTextColor:[UIColor grayColor]];
        numLab.highlightedTextColor = [UIColor whiteColor];
		numLab.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		numLab.textAlignment = NSTextAlignmentRight;
		numLab.tag = 12;
		[aCell.contentView addSubview:numLab];
		[numLab release];
		
		lblCDate = [[UILabel alloc] initWithFrame:tRect1];
		[lblCDate setBackgroundColor:[UIColor clearColor]];
		[lblCDate setTextColor:[UIColor grayColor]];
        lblCDate.highlightedTextColor = [UIColor whiteColor];
		lblCDate.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lblCDate.textAlignment = NSTextAlignmentRight;
		lblCDate.tag = 13;
		[aCell.contentView addSubview:lblCDate];
		[lblCDate release];
        
        
		lblEDate = [[UILabel alloc] initWithFrame:tRect2]; 
		[lblEDate setBackgroundColor:[UIColor clearColor]];
		[lblEDate setTextColor:[UIColor grayColor]];
        lblEDate.highlightedTextColor = [UIColor whiteColor];
		lblEDate.font = [UIFont fontWithName:@"Helvetica" size:18.0];
		lblEDate.textAlignment = NSTextAlignmentRight;
		lblEDate.tag = 14;
		[aCell.contentView addSubview:lblEDate];
		[lblEDate release];
	}
    
	if (numLab != nil)	[numLab setText:[NSString stringWithFormat:@"%i",aNum+1]];
	if (lblCDate != nil)	[lblCDate setText:aValue];
    if (lblEDate != nil)	[lblEDate setText:aValue1];
    return aCell;
}


+ (UITableViewCell *)makeSubCell:(UITableView *)tableView 
                       withTitle:(NSString *)aTitle
                    andSubvalue1:(NSString *)aCode 
                    andSubvalue2:(NSString *)aCDate 
                    andSubvalue3:(NSString *)aEDate
                    andSubvalue4:(NSString *)aMode
                    andNoteCount:(NSInteger)num
{
    CGRect tRect1;
    CGRect tRect2;
    CGRect tRect3;
    CGRect tRect4;
    CGRect tRect5;
    CGRect tRect0;
    NSString *cellIdentifier;
    
    tRect1 = CGRectMake(40, 3, 460, 48);
    tRect2 = CGRectMake(40, 48, 460, 24);
    tRect3 = CGRectMake(400, 48, 300, 24);
    tRect4 = CGRectMake(500, 25, 200, 24);
    tRect5 = CGRectMake(500, 2, 200, 24);
    tRect0 = CGRectMake(0, 3, 40, 72);
    
    cellIdentifier = @"cell_portraitTZList";
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
	UILabel* lblTitle = nil;
	UILabel* lblCode = nil;
	UILabel* lblCDate = nil;
    UILabel* lblEDate = nil;
    UILabel* lblMode = nil;
    UILabel* lblNum = nil;
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:11];
		lblCode = (UILabel *)[aCell.contentView viewWithTag:12];
		lblCDate = (UILabel *)[aCell.contentView viewWithTag:13];
        lblEDate = (UILabel *)[aCell.contentView viewWithTag:14];
        lblMode = (UILabel *)[aCell.contentView viewWithTag:15];
        lblNum = (UILabel *)[aCell.contentView viewWithTag:16];
	}
	
    
	if (lblTitle == nil) {
		
		lblTitle = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor blackColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:20.0];
		lblTitle.textAlignment = UITextAlignmentLeft;
		lblTitle.numberOfLines = 2;
        lblTitle.highlightedTextColor = [UIColor whiteColor];
		lblTitle.tag = 11;
		[aCell.contentView addSubview:lblTitle];
		[lblTitle release];
		
		
		lblCode = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblCode setBackgroundColor:[UIColor clearColor]];
		[lblCode setTextColor:[UIColor grayColor]];
        lblCode.highlightedTextColor = [UIColor whiteColor];
		lblCode.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblCode.textAlignment = UITextAlignmentLeft;
		lblCode.tag = 12;
		[aCell.contentView addSubview:lblCode];
		[lblCode release];
		
		
		
		lblCDate = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lblCDate setBackgroundColor:[UIColor clearColor]];
		[lblCDate setTextColor:[UIColor grayColor]];
        lblCDate.highlightedTextColor = [UIColor whiteColor];
		lblCDate.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblCDate.textAlignment = NSTextAlignmentRight;
		lblCDate.tag = 13;
		[aCell.contentView addSubview:lblCDate];
		[lblCDate release];
        
        
		lblEDate = [[UILabel alloc] initWithFrame:tRect4]; //此处使用id定义任何控件对象
		[lblEDate setBackgroundColor:[UIColor clearColor]];
		[lblEDate setTextColor:[UIColor grayColor]];
        lblEDate.highlightedTextColor = [UIColor whiteColor];
		lblEDate.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblEDate.textAlignment = NSTextAlignmentRight;
		lblEDate.tag = 14;
		[aCell.contentView addSubview:lblEDate];
		[lblEDate release];
        
        
		lblMode = [[UILabel alloc] initWithFrame:tRect5]; //此处使用id定义任何控件对象
		[lblMode setBackgroundColor:[UIColor clearColor]];
		[lblMode setTextColor:[UIColor grayColor]];
        lblMode.highlightedTextColor = [UIColor whiteColor];
		lblMode.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblMode.textAlignment = NSTextAlignmentRight;
		lblMode.tag = 15;
		[aCell.contentView addSubview:lblMode];
		[lblMode release];
        
        lblNum = [[UILabel alloc] initWithFrame:tRect0]; //此处使用id定义任何控件对象
		[lblNum setBackgroundColor:[UIColor clearColor]];
		[lblNum setTextColor:[UIColor blackColor]];
        lblNum.highlightedTextColor = [UIColor whiteColor];
		lblNum.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblNum.textAlignment = NSTextAlignmentCenter;
		lblNum.tag = 16;
		[aCell.contentView addSubview:lblNum];
		[lblNum release];
        
		
		lblTitle.backgroundColor = [UIColor clearColor];
		lblCode.backgroundColor = [UIColor clearColor];
		lblCDate.backgroundColor = [UIColor clearColor];
        lblEDate.backgroundColor = [UIColor clearColor];
        lblMode.backgroundColor = [UIColor clearColor];
        lblNum.backgroundColor = [UIColor clearColor];
	}
	
	if (lblTitle != nil)	[lblTitle setText:aTitle];
	if (lblCode != nil)     [lblCode setText:aCode];
	if (lblCDate != nil)	[lblCDate setText:aCDate];
    if (lblEDate != nil)	[lblEDate setText:aEDate];
    if (lblMode != nil)     [lblMode setText:aMode];
    if (lblNum != nil)      [lblNum setText:[NSString stringWithFormat:@"%d",num+1]];
    
    return aCell;
}

#pragma mark - Building Project List Method

+ (UITableViewCell *)makeSubCell:(UITableView *)tableView 
                       withTitle:(NSString *)aTitle
                          andOne:(NSString *)aCode 
                          andTwo:(NSString *)aCDate 
                        andThree:(NSString *)aEDate
                         andFour:(NSString *)aMode
{
    CGRect tRect1;
    CGRect tRect2;
    CGRect tRect3;
    CGRect tRect4;
    CGRect tRect5;
    NSString *cellIdentifier;
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    if (UIDeviceOrientationIsLandscape(orientation)) {
        tRect1 = CGRectMake(20, 3, 984, 48);
        tRect2 = CGRectMake(20, 48, 984, 24);
        tRect3 = CGRectMake(20, 72, 984, 24);
        tRect4 = CGRectMake(20, 96, 984, 24);
        tRect5 = CGRectMake(20, 120, 984, 24);
        cellIdentifier = @"cell_landscapeGCXMList";
        
    } else {
        tRect1 = CGRectMake(20, 3, 728, 48);
        tRect2 = CGRectMake(20, 48, 728, 24);
        tRect3 = CGRectMake(20, 72, 728, 24);
        tRect4 = CGRectMake(20, 96, 728, 24);
        tRect5 = CGRectMake(20, 120, 728, 24);
        cellIdentifier = @"cell_portraitGCXMList";
    }
    
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
	UILabel* lblTitle = nil;
	UILabel* lblCode = nil;
	UILabel* lblCDate = nil;
    UILabel* lblEDate = nil;
    UILabel* lblMode = nil;
	
	if (aCell.contentView != nil)
	{
		lblTitle = (UILabel *)[aCell.contentView viewWithTag:1];
		lblCode = (UILabel *)[aCell.contentView viewWithTag:2];
		lblCDate = (UILabel *)[aCell.contentView viewWithTag:3];
        lblEDate = (UILabel *)[aCell.contentView viewWithTag:4];
        lblMode = (UILabel *)[aCell.contentView viewWithTag:5];
	}
	
    
	if (lblTitle == nil) {
		
		lblTitle = [[UILabel alloc] initWithFrame:tRect1]; //此处使用id定义任何控件对象
		[lblTitle setBackgroundColor:[UIColor clearColor]];
		[lblTitle setTextColor:[UIColor blackColor]];
		lblTitle.font = [UIFont fontWithName:@"Helvetica" size:20.0];
		lblTitle.textAlignment = UITextAlignmentLeft;
		lblTitle.numberOfLines = 2;
		lblTitle.tag = 1;
		[aCell.contentView addSubview:lblTitle];
		[lblTitle release];
		
		
		lblCode = [[UILabel alloc] initWithFrame:tRect2]; //此处使用id定义任何控件对象
		[lblCode setBackgroundColor:[UIColor clearColor]];
		[lblCode setTextColor:[UIColor grayColor]];
		lblCode.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblCode.textAlignment = UITextAlignmentLeft;
		lblCode.tag = 2;
		[aCell.contentView addSubview:lblCode];
		[lblCode release];
		
		
		
		lblCDate = [[UILabel alloc] initWithFrame:tRect3]; //此处使用id定义任何控件对象
		[lblCDate setBackgroundColor:[UIColor clearColor]];
		[lblCDate setTextColor:[UIColor grayColor]];
		lblCDate.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblCDate.textAlignment = UITextAlignmentLeft;
		lblCDate.tag = 3;
		[aCell.contentView addSubview:lblCDate];
		[lblCDate release];
        
        
		lblEDate = [[UILabel alloc] initWithFrame:tRect4]; //此处使用id定义任何控件对象
		[lblEDate setBackgroundColor:[UIColor clearColor]];
		[lblEDate setTextColor:[UIColor grayColor]];
		lblEDate.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblEDate.textAlignment = UITextAlignmentLeft;
		lblEDate.tag = 4;
		[aCell.contentView addSubview:lblEDate];
		[lblEDate release];
        
        
		lblMode = [[UILabel alloc] initWithFrame:tRect5]; //此处使用id定义任何控件对象
		[lblMode setBackgroundColor:[UIColor clearColor]];
		[lblMode setTextColor:[UIColor grayColor]];
		lblMode.font = [UIFont fontWithName:@"Helvetica" size:15.0];
		lblMode.textAlignment = UITextAlignmentLeft;
		lblMode.tag = 5;
		[aCell.contentView addSubview:lblMode];
		[lblMode release];
        
		
		lblTitle.backgroundColor = [UIColor clearColor];
		lblCode.backgroundColor = [UIColor clearColor];
		lblCDate.backgroundColor = [UIColor clearColor];
        lblEDate.backgroundColor = [UIColor clearColor];
        lblMode.backgroundColor = [UIColor clearColor];
	}
	
	if (lblTitle != nil)	[lblTitle setText:aTitle];
	if (lblCode != nil)     [lblCode setText:aCode];
	if (lblCDate != nil)	[lblCDate setText:aCDate];
    if (lblEDate != nil)	[lblEDate setText:aEDate];
    if (lblMode != nil)     [lblMode setText:aMode];
    
    return aCell;
}

#pragma mark - multiLabelsHead with widthAry

+(UIView *)makeHeaderViewForTableView:(UITableView *)tableView
                           valueArray:(NSArray *)valueAry
                           widthArray:(NSArray *)widthAry
                         headerHeight:(CGFloat)height
{
    UIView *view;
    UILabel *lblTitle[20];
    CGFloat cellWidth = 748.0;
    
    view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 768, 45)];
    
    CGRect tRect = CGRectMake(0, 0, 0, height);
    
    for (int i =0; i < [widthAry count]; i++) {
        CGFloat width = [[widthAry objectAtIndex:i] floatValue] *cellWidth;
        tRect.size.width = width;
        lblTitle[i] = [[UILabel alloc] initWithFrame:tRect];
        [lblTitle[i] setBackgroundColor:[UIColor clearColor]];
        [lblTitle[i] setTextColor:[UIColor whiteColor]];
        lblTitle[i].font = [UIFont systemFontOfSize:20];
        if (i == 0)
            lblTitle[i].textAlignment = NSTextAlignmentCenter;
        else
            lblTitle[i].textAlignment = NSTextAlignmentRight;
        lblTitle[i].numberOfLines =2;
        lblTitle[i].tag = i+1;
        [lblTitle[i] setText:[valueAry objectAtIndex:i]];
        [view addSubview:lblTitle[i]];
        [lblTitle[i] release];
        tRect.origin.x += width;
    
    }
    view.backgroundColor = CELL_HEADER_COLOR;
    return [view autorelease];
}

#pragma mark - multiLabelsCell with widthAry

+(UITableViewCell*)makeMultiLabelsCell:(UITableView *)tableView
                             withTexts:(NSArray *)valueAry
                             andWidths:(NSArray*)widthAry
                             andHeight:(CGFloat)height
                         andIdentifier:(NSString *)identifier
{
    return [UITableViewCell makeMultiLabelsCell:tableView withTexts:valueAry andWidths:widthAry andHeight:height andIdentifier:identifier firstAlign:NSTextAlignmentCenter];
}


+(UITableViewCell*)makeMultiLabelsCell:(UITableView *)tableView
                             withTexts:(NSArray *)valueAry
                             andWidths:(NSArray*)widthAry
                             andHeight:(CGFloat)height
                         andIdentifier:(NSString *)identifier
                            firstAlign:(NSTextAlignment)align
{
    int labelCount = [valueAry count];
    if (labelCount <= 0 || labelCount > 20) {
        return nil;
    }
    UILabel *lblTitle[20];
    
    UITableViewCell *aCell;
    CGFloat cellWidth= 745;
    NSString *cellIdentifier = [NSString stringWithFormat:@"%@_portrait",identifier];
    
    aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
	
	if (aCell.contentView != nil)
	{
        for (int i =0; i < labelCount; i++)
            lblTitle[i] = (UILabel *)[aCell.contentView viewWithTag:i+1];
        
        
	}
	
	if (lblTitle[0] == nil) {
        CGRect tRect = CGRectMake(0, 0, 0, height);
        for (int i =0; i < labelCount; i++) {
            CGFloat width = [[widthAry objectAtIndex:i] floatValue] *cellWidth;
            tRect.size.width = width;
            lblTitle[i] = [[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
            [lblTitle[i] setBackgroundColor:[UIColor clearColor]];
            [lblTitle[i] setTextColor:[UIColor blackColor]];
            [lblTitle[i] setHighlightedTextColor:[UIColor whiteColor]];
            lblTitle[i].font = [UIFont systemFontOfSize:20];
            if (i == 0)
                lblTitle[i].textAlignment = align;
            else
                lblTitle[i].textAlignment = NSTextAlignmentRight;
            lblTitle[i].numberOfLines =2;
            lblTitle[i].tag = i+1;
            [aCell.contentView addSubview:lblTitle[i]];
            [lblTitle[i] release];
            tRect.origin.x += width;
        }
        
	}
    
    for (int i =0; i < labelCount; i++){
        [lblTitle[i] setText:[valueAry objectAtIndex:i]];
        
    }
    
	return aCell;
}


#pragma mark - TDCell Method

+(UITableViewCell *)makeTDCellForTableView:(UITableView *)tableView
                                valueArray:(NSArray *)valueAry
                              statisticNum:(NSString *)numString
                                cellHeight:(CGFloat)height
                                 andWidths:(NSArray*)widthAry
{
    int labelCount = [valueAry count];
    if (labelCount <= 0 || labelCount > 20) {
        return nil;
    }
    UILabel *lblTitle[20];

    CGFloat cellWidth = 768;
    NSString *cellIdentifier = [NSString stringWithFormat:@"cell_portraitTD_%@",[valueAry objectAtIndex:0]];
    TDBadgedCell *aCell;
    
    aCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (aCell == nil) {
        aCell = [[[TDBadgedCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease]; 
    }
	
	if (aCell.contentView != nil)
	{
        for (int i =0; i < labelCount; i++)
            lblTitle[i] = (UILabel *)[aCell.contentView viewWithTag:i+1];
	}
	
	if (lblTitle[0] == nil) {
        
        CGRect tRect = CGRectMake(0, 0, 0, height);
        for (int i =0; i < labelCount; i++) {
            CGFloat width = [[widthAry objectAtIndex:i] floatValue] *cellWidth;
            tRect.size.width = width;
            lblTitle[i] = [[UILabel alloc] initWithFrame:tRect]; //此处使用id定义任何控件对象
            [lblTitle[i] setBackgroundColor:[UIColor clearColor]];
            [lblTitle[i] setTextColor:[UIColor blackColor]];
            [lblTitle[i] setHighlightedTextColor:[UIColor whiteColor]];
            lblTitle[i].font = [UIFont systemFontOfSize:20];
            if (i==1)
                lblTitle[i].textAlignment = UITextAlignmentLeft;
            else
                lblTitle[i].textAlignment = UITextAlignmentCenter;
            lblTitle[i].numberOfLines =2;
            lblTitle[i].tag = i+1;
            [aCell.contentView addSubview:lblTitle[i]];
            [lblTitle[i] release];
            tRect.origin.x += width;
        }
        
	}
    
    for (int i =0; i < labelCount; i++){
        [lblTitle[i] setText:[valueAry objectAtIndex:i]];
        
    }
    
    //aCell.badgeString = [NSString stringWithFormat:@"%@ Kg", [NumberUtil moneyFmtFromFolat:[numString floatValue]]];
    aCell.badgeString = numString;
    aCell.badgeColor = [UIColor colorWithRed:0.792 green:0.197 blue:0.219 alpha:1.000];
    aCell.showShadow = YES;
    aCell.badge.radius = 9;
    
    return aCell;
}


@end
