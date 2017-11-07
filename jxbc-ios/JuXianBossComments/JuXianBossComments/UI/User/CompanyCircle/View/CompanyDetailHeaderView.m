//
//  CompanyDetailHeaderView.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "CompanyDetailHeaderView.h"

@interface CompanyDetailHeaderView ()
@property (nonatomic, strong) JCCollectionViewTagFlowLayout *layout;

@end

@implementation CompanyDetailHeaderView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    
    self.bigBgView.layer.cornerRadius= 8;
    self.bigBgView.layer.shadowOpacity = 0.5;// 阴影透明度
    self.bigBgView.layer.shadowColor = [PublicUseMethod setColor:KColor_Text_EumeColor].CGColor;// 阴影的颜色
    self.bigBgView.layer.shadowRadius = 3;// 阴影扩散的范围控制
    self.bigBgView.layer.shadowOffset  = CGSizeMake(3, 3);// 阴影的范围
    
    
    self.logoImageView.layer.masksToBounds = YES;
    self.logoImageView.layer.cornerRadius = 4;
    self.logoImageView.layer.borderWidth = 2;
    self.logoImageView.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
    self.attentionBtn.layer.masksToBounds = YES;
    self.attentionBtn.layer.cornerRadius = 8;
    self.attentionBtn.layer.borderWidth = 2;
    self.attentionBtn.layer.borderColor = [PublicUseMethod setColor:KColor_GoldColor].CGColor;
    
    self.tagsView.tagTextColor = [PublicUseMethod setColor:KColor_Add_BlckBlueColor];
    self.tagsView.tagTextFont = [UIFont systemFontOfSize:12.0];
    self.tagsView.borderWidth = 1;
    self.tagsView.borderColor = [PublicUseMethod setColor:KColor_Add_BlckBlueColor];
    self.tagsView.cellTitleBackgroudColor = [UIColor whiteColor];
    self.tagsView.tagCornerRadius = 4;
    
    //星星
    self.starView = [[WQLStarView alloc] initWithFrame:CGRectMake(0, -5, 87, 20) withTotalStar:5 withTotalPoint:5 starSpace:5];
    self.starView.starAliment = StarAlimentCenter;
    [self.starBgView addSubview:self.starView];
    
    //推荐率
    self.recommendView.arcFinishColor = [UIColor cyanColor];
    self.recommendView.arcUnfinishColor = [UIColor cyanColor];
    self.recommendView.arcBackColor = [UIColor redColor];
    self.recommendView.width = 2;
    
    //前景
    self.vistaGoodVIew.arcFinishColor = [UIColor cyanColor];
    self.vistaGoodVIew.arcUnfinishColor = [UIColor cyanColor];
    self.vistaGoodVIew.arcBackColor = [UIColor redColor];
    self.vistaGoodVIew.width = 2;
    
    //支持率
    self.supportView.arcFinishColor = [UIColor cyanColor];
    self.supportView.arcUnfinishColor = [UIColor cyanColor];
    self.supportView.arcBackColor = [UIColor redColor];
    self.supportView.width = 2;
    
}

- (void)setCompanyEntity:(OpinionCompanyEntity *)companyEntity{

    _companyEntity = companyEntity;
//首先判断是否关注
    self.attentionBtn.selected = companyEntity.IsConcerned ? YES : NO;
    if (companyEntity.IsConcerned == YES) {//已经关注了
        [self.attentionBtn setTitle:@"取消关注" forState:UIControlStateNormal];
    }else{
        [self.attentionBtn setTitle:@"关注" forState:UIControlStateNormal];
    }
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:companyEntity.CompanyLogo] placeholderImage:Company_LOGO_Image];
    //公司名称
    self.companyLabel.text = companyEntity.CompanyName;
    //信息
    self.companyInformation.text = [NSString stringWithFormat:@"%@ | %@ | %@",companyEntity.Industry,companyEntity.Region,companyEntity.CompanySize];
    //星星 回去想想 数据类型转换
    self.starView.commentPoint = 2.9;
    
    //标签
    [self.tagsView.tags addObjectsFromArray:companyEntity.Labels];
    self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
    self.cellHeight = [self.layout calculateContentHeight:companyEntity.Labels];
    self.tagsView.height = self.cellHeight;
    self.tagsView.width = SCREEN_WIDTH - 60;
    self.tagsView.x = 30;
    
    
    //推荐率
    self.recommendView.percent = companyEntity.Recommend * 0.01;

    self.recommendView.percent = 0.7;
 
    //前景
    self.vistaGoodVIew.percent = companyEntity.Optimistic * 0.01;

    self.vistaGoodVIew.percent = 0.9;
    
    //支持率
    self.supportView.percent = companyEntity.SupportCEO * 0.01;
    self.supportView.percent = 0.8;

}


#pragma mark -- 关注
- (IBAction)attentionClick:(UIButton *)sender {
     MJWeakSelf
    [UserOpinionRequest postConcernedAttentionCompanyId:self.companyEntity.CompanyId success:^(BOOL result) {
        weakSelf.companyEntity.IsConcerned = !weakSelf.companyEntity.IsConcerned;
        
        if (weakSelf.companyEntity.IsConcerned == YES) {
            
//            weakSelf.opinionModel.LikedCount++;
        }else{
            
//            weakSelf.opinionModel.LikedCount--;
        }
        
        
        
    } fail:^(NSError *error) {
        
    }];
    
    
    sender.selected = !sender.selected;    
    if (sender.selected) {
        [sender setTitle:@"取消关注" forState:UIControlStateNormal];
    }else{
        [sender setTitle:@"关注" forState:UIControlStateNormal];
    }
}

- (IBAction)backCilck:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(companyDetailHeaderViewBack:button:)]) {
        
        [self.delegate companyDetailHeaderViewBack:self button:sender];
    }
    
}

- (IBAction)shareClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(companyDetailHeaderViewShare:button:)]) {
        [self.delegate companyDetailHeaderViewShare:self button:sender];
    }
}




+ (instancetype)companyDetailHeaderView{
    
    return [[NSBundle mainBundle] loadNibNamed:@"CompanyDetailHeaderView" owner:nil options:nil].lastObject;
}

@end
