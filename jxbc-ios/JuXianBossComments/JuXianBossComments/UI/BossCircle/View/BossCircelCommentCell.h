//
//  BossCircelCommentCell.h
//  JuXianBossComments
//
//  Created by Jam on 16/12/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BossDynamicCommentEntity;

@interface BossCircelCommentCell : UITableViewCell

//@property (nonatomic, strong) BossDynamicCommentEntity *comment;

- (void)setName:(NSString*) name andComment:(NSString*)comment;

@end
