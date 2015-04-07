//
//  MessageCell.h
//  PAL
//
//  Created by 周佳磊 on 15/4/7.
//  Copyright (c) 2015年 &#21608;&#20339;&#30922;. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UILabel *lineOne;
@property (weak, nonatomic) IBOutlet UILabel *lineTwo;
@property (weak, nonatomic) IBOutlet UILabel *numberOfNewMessage;
@property (weak, nonatomic) IBOutlet UIImageView *isNew;

@end
