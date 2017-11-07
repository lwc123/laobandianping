//
//  HotTopicCell.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/17.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "HotTopicCell.h"

@implementation HotTopicCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _tagListView.tagTextColor = [PublicUseMethod setColor:KColor_Add_BlckBlueColor];
    _tagListView.tagTextFont = [UIFont systemFontOfSize:12.0];
    _tagListView.borderWidth = 1;
    _tagListView.borderColor = [PublicUseMethod setColor:KColor_Add_BlckBlueColor];
    _tagListView.cellTitleBackgroudColor = [UIColor whiteColor];
    _tagListView.tagCornerRadius = 4;
    
    self.starView = [[WQLStarView alloc] initWithFrame:CGRectMake(0, -15, 87, 30) withTotalStar:5 withTotalPoint:5 starSpace:5];
    self.starView.starAliment = StarAlimentCenter;
    [self.starBgView addSubview:self.starView];

}

- (void)setCompanyEntity:(OpinionCompanyEntity *)companyEntity{

    _companyEntity = companyEntity;

    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:companyEntity.CompanyLogo] placeholderImage:Company_LOGO_Image];
    self.companyName.text = companyEntity.CompanyName;
    self.industLabel.text = companyEntity.Industry;
    self.cityLabel.text = companyEntity.Region;
    self.sizeLabel.text = companyEntity.CompanySize;
    
    //标签
    [self.tagListView.tags addObjectsFromArray:self.companyEntity.Labels];
    self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
    self.tagCellHeight = [self.layout calculateContentHeight:self.companyEntity.Labels];
    
    self.tagListView.height = self.tagCellHeight;
    
    self.countLabel.text = [NSString stringWithFormat:@"总阅读 %ld    共%ld条点评     来自%ld位员工",companyEntity.ReadCount,companyEntity.CommentCount,companyEntity.StaffCount];
    
    NSString * ss = [NSString stringWithFormat:@"%.1f",companyEntity.Score];
    
    self.starView.commentPoint = 3.9 * 2;

    self.cellHeight = self.tagCellHeight + 15 + 10 * 4 + 15 + 12 * 4 + 10;

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
