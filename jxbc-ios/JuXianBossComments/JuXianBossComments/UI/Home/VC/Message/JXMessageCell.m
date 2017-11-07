//
//  JXMessageCell.m
//  JuXianBossComments
//
//  Created by CZX on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXMessageCell.h"
@interface JXMessageCell()

@property (weak, nonatomic) IBOutlet UILabel *ContentLabel;

@property (weak, nonatomic) IBOutlet UILabel *CreatedTimeLabel;


@end
@implementation JXMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setMessageModel:(messageEntity *)messageModel
{
    _messageModel = messageModel;
    if (messageModel.Content == nil) {
        self.ContentLabel.text = @"这是空数据";
    }else{
        
        self.ContentLabel.text = messageModel.Content;
    }
    
    
    //用于格式化NSDate对象
    NSDateFormatter*dateFormatter=[[NSDateFormatter alloc]init];
    //设置格式：zzz表示时区
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //NSDate转NSString
    NSString *currentDateString = [dateFormatter stringFromDate:messageModel.CreatedTime];
    //输出currentDateString
    self.CreatedTimeLabel.text = currentDateString;
    
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
