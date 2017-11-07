//
//  XJHMineView.m
//  JuXianTalentBank
//
//  Created by juxian on 16/9/5.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "XJHMineView.h"
//#import "SystemconfigureVC.h"


@implementation XJHMineView

+ (instancetype)jhMineView{


    return [[NSBundle mainBundle] loadNibNamed:@"XJHMineView" owner:nil options:nil].lastObject;

}

- (void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor blueColor];
    
    self.iconImageVIew.layer.masksToBounds = YES;
    self.iconImageVIew.layer.cornerRadius = 4;
    self.bgImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.bgImageView addGestureRecognizer:tap];
    self.twoView.frame = CGRectMake((SCREEN_WIDTH - 200) * 0.5, 55, 200, 200);
    
    self.myInfoBtn.frame = CGRectMake((self.twoView.frame.origin.x + 50), (self.twoView.frame.origin.y + 70), 100, 100);
    
    self.iconImageVIew.frame = CGRectMake((self.myInfoBtn.frame.origin.x + 5), (self.myInfoBtn.frame.origin.y + 5), 80, 80);
    
    self.nameLabel.frame = CGRectMake(self.myInfoBtn.frame.origin.x, CGRectGetMaxY(self.iconImageVIew.frame) + 6, 100, 17);
    
    self.positionLabel.frame = CGRectMake(self.myInfoBtn.frame.origin.x, CGRectGetMaxY(self.nameLabel.frame) + 6, 100, 12);
    
    self.loginLabel.frame = CGRectMake(self.myInfoBtn.frame.origin.x, CGRectGetMaxY(self.iconImageVIew.frame) + 7, 100, 17);
 

}

- (UIViewController*)viewController
{
    UIResponder *next = self;
    do {
        next = next.nextResponder;
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)next;
        }
    } while (next!=nil);
    return nil;
}

- (void)tapAction{

    if ([self.delegate respondsToSelector:@selector(xjhMineViewDidClickUserInfoBtn:)]) {
        [self.delegate xjhMineViewDidClickUserInfoBtn:self];
    }
        
}



- (IBAction)inFoBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(xjhMineViewDidClickUserInfoBtn:)]) {
        
        [self.delegate xjhMineViewDidClickUserInfoBtn:self];
        
    }

}
- (IBAction)systemSetAction:(id)sender {
    

}


@end
