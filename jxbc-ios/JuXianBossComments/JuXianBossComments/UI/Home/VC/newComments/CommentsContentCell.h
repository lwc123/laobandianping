//
//  CommentsContentCell.h
//  JuXianBossComments
//
//  Created by easemob on 2016/12/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWTextView.h"
#import "IWComposePhotosView.h"
#import "CommentsContentModel.h"
#import "ArchiveCommentEntity.h"

@protocol CommentsContentCellDelegate;
@interface CommentsContentCell : UITableViewCell<UITextViewDelegate>
@property (weak, nonatomic) id<CommentsContentCellDelegate> delegate;
@property (nonatomic, strong) CommentsContentModel *model;
@property (nonatomic, strong) ArchiveCommentEntity *detaiComment;//SC.XJH.12.17更换 model类型
@property (strong, nonatomic)  IWTextView *myTextView;
@property (nonatomic, strong) UILabel *lenthLabel;
@property (nonatomic, strong) UIButton *camerBtn;
@property (nonatomic, strong) IWComposePhotosView *photosView;
@property (nonatomic, strong) UIButton *voiceImageBtn;
@property (nonatomic, strong) UIButton *deleteVoiceBtn;
@property (nonatomic, strong) UIButton *voiceBtn;

@property (nonatomic, strong) UILabel *titleLabel;


+ (CGFloat)cellHeightWithModel:(CommentsContentModel *)model;
+ (CGFloat)cellHeightWithArchiveCommentModel:(ArchiveCommentEntity *)detaiComment;//SC.XJH.12.17更换 model类型

@end


@protocol CommentsContentCellDelegate <NSObject>

@optional

- (void)composePicAdd;
- (void)goToRecordVoice;

//- (void)playVoice;
- (void)playVoice:(CommentsContentCell *)cell withVoiceImageBtn:(UIButton *)btn;//SC.XJH.1.6
- (void)deleteVoice;

@end
