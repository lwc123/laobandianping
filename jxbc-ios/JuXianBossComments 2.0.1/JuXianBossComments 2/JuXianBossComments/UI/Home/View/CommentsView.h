//
//  CommentsView.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWTextView.h"

@interface CommentsView : UIView<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UITextView *iwTextView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (nonatomic,strong)IWTextView * myTextView;
@property (nonatomic,strong)UIButton * voiceImage;
@property (nonatomic,strong)UIButton * deleteVoiceBtn;
@property (nonatomic,strong)UILabel * lenthLabel;


+ (instancetype)commentsView;

@end
