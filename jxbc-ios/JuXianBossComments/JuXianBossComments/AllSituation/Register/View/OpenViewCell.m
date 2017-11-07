//
//  OpenViewCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/4.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "OpenViewCell.h"

@implementation OpenViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.openFierLabel.text = @"开户费：";
    self.openLabel.text = @"开通老板点评服务";
}

- (void)setPriceEntity:(PriceStrategyEntity *)priceEntity{
    _priceEntity = priceEntity;
    
    if (priceEntity.IosOriginalPrice == 0) {
        self.lineView.hidden = YES;
    }else{
        self.lineView.hidden = NO;
        self.yuanMoney.text = [NSString stringWithFormat:@"%1.f元",priceEntity.IosOriginalPrice];
    }
    if (priceEntity.IsActivity) {//如果有活动
        self.springLabel.text = [NSString stringWithFormat:@"%@:",priceEntity.ActivityName];
        self.moneyLabel.text = [NSString stringWithFormat:@"%1.f元",priceEntity.IosPreferentialPrice];
        self.discountLabel.hidden= NO;

        self.discountLabel.text = priceEntity.IosActivityDescription;
        self.lineView.hidden = NO;
        self.discountImage.hidden = NO;
        self.lineView.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        self.lineView.font = [UIFont systemFontOfSize:17];
        [self.discountImage sd_setImageWithURL:[NSURL URLWithString:priceEntity.ActivityIcon] placeholderImage:[UIImage imageNamed:@"denglong"]];
        self.springLabel.hidden= NO;
        self.moneyLabel.hidden = NO;
        self.realyLineView.hidden = NO;
    }else{//没有活动
        self.realyLineView.hidden = YES;
        self.lineView.hidden = NO;
        self.lineView.textColor = [PublicUseMethod setColor:KColor_RedColor];
        self.lineView.font = [UIFont systemFontOfSize:24];
        self.discountImage.hidden = YES;
        self.springLabel.hidden= NO;
        self.springLabel.text = priceEntity.IosActivityDescription;
        self.springLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
        self.springLabel.font = [UIFont systemFontOfSize:13.0];
        self.moneyLabel.hidden = YES;
//        self.moneyLabel.text = @"5000元";
        self.discountLabel.hidden= YES;
    }
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
