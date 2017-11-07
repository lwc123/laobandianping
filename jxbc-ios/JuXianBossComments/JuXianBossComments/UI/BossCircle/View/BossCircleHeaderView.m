//
//  BossCircleHeaderView.m
//  JuXianBossComments
//
//  Created by Jam on 16/12/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossCircleHeaderView.h"
#import <UIButton+WebCache.h>


//CGFloat const  cornerRadius = 10.f;
//
//CGFloat const iconLength = 80.f;
//
//CGFloat const iconInsert = 20.f;


@interface BossCircleHeaderView()

// 背景图片
@property (nonatomic,strong) UIImageView * backgroundView;

// 头像
@property (nonatomic,strong) UIButton * iconView;

// 头像背景
@property (nonatomic,strong) UIView * iconBackgroundView;


// 企业名
@property (nonatomic,copy) UILabel * companyNameLable;

// 回调
@property (nonatomic, copy) IconButtonClickBlock iconButtonClickBlock;

@end

@implementation BossCircleHeaderView

- (instancetype)init
{
    self = [super initWithFrame:CGRectMake(0, 64, ScreenWidth, 194)];
    if (self) {
        
        [self setupUI];
        
    }
    return self;
}

- (void)setupUI{

    // 背景图片
    _backgroundView = [[UIImageView alloc]initWithFrame:self.bounds];
    _backgroundView.image = [UIImage imageNamed:@"iosgerenzhongxinbj"];
    [self addSubview:_backgroundView];
    
    // 头像背景
    _iconBackgroundView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _iconBackgroundView.backgroundColor = [UIColor whiteColor];
    _iconBackgroundView.alpha = 0.2;
    _iconBackgroundView.layer.cornerRadius = 10;
    [self addSubview:_iconBackgroundView];
    
    // 头像
    _iconView = [[UIButton alloc]initWithFrame:CGRectZero];
//    _iconView.backgroundColor = [UIColor cyanColor];
    _iconView.layer.cornerRadius = 10;
    _iconView.clipsToBounds = YES;
    [_iconView setImage:[UIImage imageNamed:@"企业默认logo"] forState:UIControlStateNormal];
    [_iconView addTarget:self action:@selector(iconButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_iconView];
    
    // 企业名
    
    // 获取公司id
    CompanyMembeEntity * companyEntity= [UserAuthentication GetBossInformation];
    
    
    // 获取公司信息
    [MineRequest getCompanyMineWithCompanyId:companyEntity.CompanyId success:^(CompanySummary *companySummary) {
        
        // 公司名称
        _companyNameLable.text = companySummary.CompanyName;
        
        // logo
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:companySummary.CompanyLogo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"企业默认logo"]];

        
    } fail:^(NSError *error) {

        NSLog(@"#getCompanyMineWithCompanyId error===%@",error);
    }];
    
    _companyNameLable = [[UILabel alloc]initWithFrame:CGRectZero];
    _companyNameLable.textAlignment = NSTextAlignmentCenter;
    _companyNameLable.text = companyEntity.RealName;
    _companyNameLable.textColor = [UIColor whiteColor];
    [self addSubview:_companyNameLable];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [_iconBackgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self).offset(33);
        make.height.width.mas_equalTo(100);
    }];

    [_iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.centerY.equalTo(_iconBackgroundView);
        make.width.height.mas_equalTo(80);
    }];
    
    [_companyNameLable mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self);
        make.top.equalTo(_iconBackgroundView.mas_bottom).offset(10);
        make.height.mas_equalTo(24);
    }];
    
}

- (void)iconButtonClick{
    
    Log(@"头像按钮点击");
    if (self.iconButtonClickBlock) {
        self.iconButtonClickBlock();
    }

}

- (void)iconButtonClickBlockComplete:(IconButtonClickBlock)iconButtonClickBlock{

    self.iconButtonClickBlock = iconButtonClickBlock;
  
}

- (void)updateIconAndCompanyName{
    
    // 获取公司id
    CompanyMembeEntity * companyEntity= [UserAuthentication GetBossInformation];

    // 获取公司信息
    [MineRequest getCompanyMineWithCompanyId:companyEntity.CompanyId success:^(CompanySummary *companySummary) {
        
        // 公司名称
        _companyNameLable.text = companySummary.CompanyName;
        
        // logo
        [self.iconView sd_setImageWithURL:[NSURL URLWithString:companySummary.CompanyLogo] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"企业默认logo"]];
        
    } fail:^(NSError *error) {
        
        NSLog(@"#getCompanyMineWithCompanyId error===%@",error);
    }];
    
}



@end
