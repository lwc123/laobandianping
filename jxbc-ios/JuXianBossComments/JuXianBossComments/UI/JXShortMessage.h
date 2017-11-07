//
//  JXShortMessage.h
//  JuXianBossComments
//
//  Created by juxian on 2017/3/2.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JXShortMessage;
@protocol JXShortMessageDelagate <NSObject>

- (void)shortMessageDidClickedWith:(UIButton *)button shortMessage:(JXShortMessage *)shortMessage;

@end

@interface JXShortMessage : UIView

@property (weak, nonatomic) IBOutlet UIButton *imageBtn;
@property (weak, nonatomic) IBOutlet UIButton *clinkBtn;

@property (nonatomic,weak) id<JXShortMessageDelagate> delegate;

+ (instancetype)shortMessage;


@end
