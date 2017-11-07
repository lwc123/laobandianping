//
//  JXMessageCell.h
//  JuXianBossComments
//
//  Created by CZX on 16/12/16.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "messageEntity.h"
@interface JXMessageCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *clickBtn;

@property(nonatomic,strong)messageEntity *messageModel;

@end
