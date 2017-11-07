//
//  ChoiceCompanyCell.m
//  JuXianBossComments
//
//  Created by juxian on 16/12/2.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "ChoiceCompanyCell.h"
#import "PayViewController.h"
#import "ChoiceCompanyVC.h"

@implementation ChoiceCompanyCell

- (void)awakeFromNib {
    [super awakeFromNib];


}

- (void)setInforModel:(CompanyMembeEntity *)membeEntity{

    _membeEntity= membeEntity;
    
    if ([self.viewController isKindOfClass:[PayViewController class]] ) {//选择支付
        
        self.watiBtn.hidden = YES;
        
    }
    if ([self.viewController isKindOfClass:[ChoiceCompanyVC class]] ) {//选则公司
        
        if (membeEntity.UnreadMessageNum == 0) {
            
            self.watiBtn.hidden = YES;
        }else{
            
            NSString * countStr = [NSString stringWithFormat:@"%ld条待审核评价",(long)membeEntity.UnreadMessageNum];
            [self.watiBtn setTitle:countStr forState:UIControlStateNormal];
        }
        //取出公司的名称
        self.companyModel = membeEntity.myCompany;
        self.companyLabel.text = [NSString stringWithFormat:@"%@",self.companyModel.CompanyName];
        
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
