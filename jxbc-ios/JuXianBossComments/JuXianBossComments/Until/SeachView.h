//
//  SeachView.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/6.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SeachView;

@protocol SeachViewDelegate <NSObject>

- (void)seachViewDidClickedSeachBtn:(SeachView *)seachView;

@end


@interface SeachView : UIView
@property (weak, nonatomic) IBOutlet UIButton *searchImage;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;
@property (weak, nonatomic) IBOutlet UITextField *placehoderText;
@property (nonatomic,weak) id<SeachViewDelegate> delegate;

+ (instancetype)seachView;
@end
