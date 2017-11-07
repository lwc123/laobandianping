//
//  JXMineView.m
//  JuXianTalentBank
//
//  Created by juxian on 16/9/2.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXMineView.h"

@interface JXMineView ()

@property (weak, nonatomic) IBOutlet UIButton *systemBtn;

@property (weak, nonatomic) IBOutlet UIButton *userInfoBtn;
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@end

@implementation JXMineView
+ (instancetype)mineView{

    return [[NSBundle mainBundle] loadNibNamed:@"JXMineView" owner:nil options:nil].lastObject;

}

@end
