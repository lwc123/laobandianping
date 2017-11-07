//
//  JXSegmentView.m
//  JuXianBossComments
//
//  Created by Jam on 17/2/8.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXSegmentView.h"

@interface JXSegmentView ()

@property (nonatomic, strong) IBOutlet UIButton *leftButton;
@property (nonatomic, strong) IBOutlet UIButton *rightButton;

@property (nonatomic, strong) IBOutlet UIView *lineView;

// block
@property (nonatomic, copy) ButtonClickBlock leftButtonClickBlock;

@property (nonatomic, copy) ButtonClickBlock rightButtonClickBlock;

@end

@implementation JXSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [JXSegmentView segmentView];
    }
    return self;
}

+ (instancetype)segmentView{

    return [[NSBundle mainBundle] loadNibNamed:@"JXSegmentView" owner:nil options:nil].lastObject;

}
- (void)layoutSubviews{
    [super layoutSubviews];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    self.frame = CGRectMake(0, 0, ScreenWidth, 45);
}

#pragma mark - function

// 左边的按钮点击
- (IBAction)leftButtonClick{
    self.rightButton.selected = NO;
    self.leftButton.selected = YES;

    [UIView animateWithDuration:.3 animations:^{
        self.lineView.x = 0;
    }];
    
    if (self.leftButtonClickBlock) {
        self.leftButtonClickBlock();
    }
}

// 右边的按钮点击
- (IBAction)rightButtonClick{
    self.rightButton.selected = YES;
    self.leftButton.selected = NO;
    [UIView animateWithDuration:.3 animations:^{
        self.lineView.x = ScreenWidth*0.5;
    }];

    if (self.rightButtonClickBlock) {
        self.rightButtonClickBlock();
    }

}

- (void)leftButtonClickCompletHandle:(ButtonClickBlock)buttonClickBlock{
    self.leftButtonClickBlock = buttonClickBlock;

}
- (void)rightButtonClickCompletHandle:(ButtonClickBlock)buttonClickBlock{
    self.rightButtonClickBlock = buttonClickBlock;

}

- (void)setLeftButtonTitle:(NSString *)leftButtonTitle{

    [self.leftButton setTitle:leftButtonTitle forState:UIControlStateNormal];
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle{
    [self.rightButton setTitle:rightButtonTitle forState:UIControlStateNormal];

}




@end
