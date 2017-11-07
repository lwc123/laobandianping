//
//  SeachCancelView.h
//  JuXianBossComments
//
//  Created by juxian on 2017/3/28.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SeachCancelView;

@protocol SeachCancelViewDelegate <NSObject>

- (void)seachDidClickedSeachBtn:(SeachCancelView *)seachView;

@end


@interface SeachCancelView : UIView

+ (instancetype)seachCancelView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UIButton *searchImage;
@property (nonatomic,weak) id<SeachCancelViewDelegate> delegate;

@end
