//
//  InvitationView.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class InvitationView;
@protocol InvitationViewDelegate <NSObject>
//复制链接
@optional
- (void)invitationViewDidClickedCopyShareBtn:(InvitationView *)jxFooterView;
//二维码分享
- (void)invitationViewClickedCodeShareBtn:(InvitationView *)jxFooterView;


@end

@interface InvitationView : UIView

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet ColorButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIImageView *codeImageView;
@property (weak, nonatomic) IBOutlet UIButton *codeShareBtn;
@property (nonatomic,weak) id<InvitationViewDelegate> delegate;

+(instancetype)invitationView;


@end
