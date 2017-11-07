//
//  JXMessageCellThird.m
//  JuXianBossComments
//
//  Created by CZX on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXMessageCellThird.h"
#import "JXNoticeMessageVC.h"
@interface JXMessageCellThird()


@end

@implementation JXMessageCellThird

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.dateImage.layer.cornerRadius = 4;
    self.dateImage.layer.masksToBounds = YES;
    self.ContentLabel.numberOfLines = 2;
}

-(void)setMessageModel:(JXMessageEntity *)messageModel
{
    _messageModel = messageModel;
    [self.dateImage sd_setImageWithURL:[NSURL URLWithString:messageModel.Picture] placeholderImage:LOADing_Image];
    self.ContentLabel.text = messageModel.Content;
    
    if (messageModel.IsRead == 0) {
        self.ContentLabel.font = [UIFont boldSystemFontOfSize:15.0];
    }else if (messageModel.IsRead == 1){//已读
        self.ContentLabel.font = [UIFont systemFontOfSize:15.0];
    }
    self.CreatedTimeLabel.text = [JXJhDate jhDateChangeWith:messageModel.CreatedTime];
    self.ExtendParamsLabel.hidden = YES;
    
}

+ (CGFloat)sizeWithMessageModel:(JXMessageEntity *)messageModel{
    
    if (messageModel.Content.length > 40) {
        
        return 92;
    }else{
        return [self sizeWithText:messageModel.Content font:[UIFont systemFontOfSize:15] maxSize:CGSizeMake(ScreenWidth - 20, CGFLOAT_MAX)].height + 53.5;
    }    
}

//计算高度
+ (CGSize)sizeWithText:(NSString *)text font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

@end
