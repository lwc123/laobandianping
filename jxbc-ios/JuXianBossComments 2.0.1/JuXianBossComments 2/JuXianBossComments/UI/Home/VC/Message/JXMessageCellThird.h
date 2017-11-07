//
//  JXMessageCellThird.h
//  JuXianBossComments
//
//  Created by CZX on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface JXMessageCellThird : UITableViewCell
@property(nonatomic,strong)JXMessageEntity *messageModel;

@property (weak, nonatomic) IBOutlet UILabel *ContentLabel;
@property (weak, nonatomic) IBOutlet UILabel *CreatedTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *ExtendParamsLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dateImage;

+ (CGFloat)sizeWithMessageModel:(JXMessageEntity *)messageModel;

@end
