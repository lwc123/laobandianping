//
//  JXBecomeHunterView.m
//  JuXianTalentBank
//
//  Created by juxian on 16/8/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXBecomeHunterView.h"
#import "ApplyAccountFourVC.h"

#import "ProveTwoViewController.h"


@interface JXBecomeHunterView()
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;

@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@property (weak, nonatomic) IBOutlet UIView *fourView;
@property (weak, nonatomic) IBOutlet UIView *twoLineView;
@property (weak, nonatomic) IBOutlet UIView *threeLineView;


@end

@implementation JXBecomeHunterView


+(instancetype)becomeHunterView{

    return [[NSBundle mainBundle] loadNibNamed:@"JXBecomeHunterView" owner:nil options:nil].lastObject;

}

- (void)awakeFromNib{
    [super awakeFromNib];
//    self.oneView.backgroundColor = [PublicUseMethod setColor:KColor_MainColor];
//    self.oneView.layer.borderColor = [UIColor whiteColor].CGColor;
    
//    self.twoView.layer.borderColor = [PublicUseMethod setColor:KColor_Text_ListColor].CGColor;
//    
//    self.threeView.layer.borderColor = [PublicUseMethod setColor:KColor_Text_ListColor].CGColor;
}

- (void)layoutSubviews{

    [super layoutSubviews];

    if ([self.viewController isKindOfClass:[ProveTwoViewController class]]) {
        
//        self.oneView.backgroundColor = [PublicUseMethod setColor:KColor_BackgroundColor];
//        self.oneView.layer.borderColor = [UIColor grayColor].CGColor;
//        self.oneLabel.textColor = [PublicUseMethod setColor:KColor_Text_ListColor];
        
        
        self.twoView.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
//        self.twoView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.twoLabel.textColor = [PublicUseMethod setColor:KColor_GoldColor];
    }
    if ([self.viewController isKindOfClass:[ApplyAccountFourVC class]]) {
        
        
        self.twoView.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
        self.twoLabel.textColor = [PublicUseMethod setColor:KColor_GoldColor];
        self.twoLineView.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
        self.threeView.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
        //        self.twoView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.threeLabel.textColor = [PublicUseMethod setColor:KColor_GoldColor];
    }
    if ([self.viewController isKindOfClass:[ApplyAccountFourVC class]]) {
        
        self.twoView.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
        self.twoLabel.textColor = [PublicUseMethod setColor:KColor_GoldColor];
        self.twoLineView.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
        self.threeView.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
        //        self.twoView.layer.borderColor = [UIColor whiteColor].CGColor;
        self.threeLabel.textColor = [PublicUseMethod setColor:KColor_GoldColor];
        self.threeLineView.backgroundColor = [PublicUseMethod setColor:KColor_GoldColor];
    }
    
    
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


@end
