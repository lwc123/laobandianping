//
//  HeaderView.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeaderView : UIView


@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *idLabel;
+ (instancetype)headerView;

@end
