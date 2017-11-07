//
//  InvitationView.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "InvitationView.h"

@implementation InvitationView

- (void)awakeFromNib{
    [super awakeFromNib];
    
}

#pragma mark -- 复制链接
- (IBAction)copyShareBtn:(id)sender {
    if ([self.delegate respondsToSelector:@selector(invitationViewDidClickedCopyShareBtn:)]) {
        [self.delegate invitationViewDidClickedCopyShareBtn:self];
    }
}

#pragma mark -- 分享
- (IBAction)codeShareBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(invitationViewClickedCodeShareBtn:)]) {
        [self.delegate invitationViewClickedCodeShareBtn:self];
    }
}



+ (instancetype)invitationView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"InvitationView" owner:nil options:nil].lastObject;
}

- (void)layoutSubviews{

    


}


@end
