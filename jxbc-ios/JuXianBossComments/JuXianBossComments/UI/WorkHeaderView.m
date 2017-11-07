//
//  workHeaderView.m
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "WorkHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation WorkHeaderView


- (void)awakeFromNib{
    [super awakeFromNib];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.layer.cornerRadius = 8;
    self.iconImageView.layer.borderWidth = 3;
    self.iconImageView.layer.borderColor = [PublicUseMethod setColor:@"D4BA77"].CGColor;

    self.bgView.layer.cornerRadius= 8;
    self.bgView.layer.shadowOpacity = 0.5;// 阴影透明度
    self.bgView.layer.shadowColor = [PublicUseMethod setColor:KColor_Text_EumeColor].CGColor;// 阴影的颜色
        self.bgView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    self.bgView.layer.shadowOffset  = CGSizeMake(3, 3);// 阴影的范围
}

- (void)setCompanyModel:(CompanySummary *)companyModel{

    self.companyModel = companyModel;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:companyModel.CompanyLogo] placeholderImage:Company_LOGO_Image];

    // 企业简称
    self.companyName.text = companyModel.CompanyAbbr;
    self.LegalName.text = companyModel.LegalName;
    
    self.EmployedNum.text = [NSString stringWithFormat:@"在职员工：%ld",companyModel.EmployedNum];
    self.DimissionNum.text = [NSString stringWithFormat:@"离任员工：%ld",companyModel.DimissionNum];
    // 认证状态
    if (companyModel.AuditStatus == 1) {
        self.auditSatus.text = @"认证审核中";
    }
    if (companyModel.AuditStatus == 2) {
        self.auditSatus.text = @" ";
        self.auditImageView.hidden = NO;
    }

}

+ (instancetype)workHeaderView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"WorkHeaderView" owner:nil options:nil].lastObject;
}

- (IBAction)fixBtnClick:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(workHeaderViewDidClickFixBtn:)]) {
        [self.delegate workHeaderViewDidClickFixBtn:self];
    }
    
}


@end
