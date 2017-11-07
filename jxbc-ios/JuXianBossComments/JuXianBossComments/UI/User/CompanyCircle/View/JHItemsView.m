//
//  JHItemsView.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/7.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHItemsView.h"

@interface JHItemsView(){

    UIView *_underLine;

}
@property (nonatomic, assign) NSInteger index;
@end

@implementation JHItemsView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    
    if (self) {
        [self createNilView];
    }
    return self;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        [self createNilView];
    }
    
    return self;
}

- (void)createNilView{

    NSArray *titleArray = @[@"待处理事项",@"通 知"];
    float width = SCREEN_WIDTH/2;
    
    for (int i = 0; i < titleArray.count; i ++) {
        messageButton *button = [[messageButton alloc]initWithFrame:CGRectMake(width*i, 0, width, 36)];
        button.backgroundColor = [UIColor whiteColor];
        button.tag = 10+i;
        
        [button setTitle:titleArray[i] forState:UIControlStateNormal];
        [button setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
        
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        [button addTarget:self action:@selector(selectAction:) forControlEvents:UIControlEventTouchUpInside];
        if (button.tag ==10) {
            [button setTitleColor:[PublicUseMethod setColor:KColor_RedColor] forState:UIControlStateNormal];
            _index = 10;
            button.showRedPoint = NO;
        }
        [self addSubview:button];
    }
    _underLine = [[UIView alloc]initWithFrame:CGRectMake(0, 35, width, 1)];
    _underLine.backgroundColor = [PublicUseMethod setColor:KColor_RedColor];
    [self addSubview:_underLine];

}

- (void)selectAction:(messageButton *)button{

    UIButton *button1 = (UIButton*)[self viewWithTag:_index];
    
    //变黑色
    [button1 setTitleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] forState:UIControlStateNormal];
    //变红色
    [button setTitleColor:[PublicUseMethod setColor:KColor_RedColor] forState:UIControlStateNormal];
    
    
    _index = button.tag;
    
    [UIView animateWithDuration:.35 animations:^{
        _underLine.x = (SCREEN_WIDTH/2)*(_index -10);
//        CGPoint point = CGPointMake((_index-10)*SCREEN_WIDTH, 0);
//        _scrollView.contentOffset = point;
    }];
    
    if ([self.delegate respondsToSelector:@selector(jhItemsViewDelegateWithButton:ItemsView:)]) {
        [self.delegate jhItemsViewDelegateWithButton:button ItemsView:self];
    }
    

}


@end
