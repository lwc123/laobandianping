//
//  AttentionCell.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/20.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "AttentionCell.h"
#import "JCTagListView.h"
#import "JCCollectionViewTagFlowLayout.h"

#define Margin 15
#define BetweenMargin 10
#define LogoImageWith 50
#import "WQLStarView.h"

@interface AttentionCell ()

//logo
@property (nonatomic, strong) UIImageView *logoImageView;
//公司名称
@property (nonatomic, strong) UILabel *nameLabel;
//星星
@property (nonatomic, strong) WQLStarView *starView;
//标签
@property (nonatomic, strong) JCTagListView *tagListView;
//总阅读
@property (nonatomic, strong) UILabel *seeLabel;
@property (nonatomic, strong) JCCollectionViewTagFlowLayout *layout;

//红点
@property (nonatomic, strong) UIView *redView;

@end


@implementation AttentionCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
     
        [self setUp];
    }
    return self;

}

- (void)setUp{
    
     //logo
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 4;
    [self.contentView addSubview:_logoImageView];
    
    //公司名称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"我是公司";
    _nameLabel.font = [UIFont systemFontOfSize:15.0];
    _nameLabel.textColor = [UIColor blackColor];
    [self.contentView addSubview:_nameLabel];
    
    //红点
    _redView = [[UIView alloc] init];
    _redView.backgroundColor = [PublicUseMethod setColor:@"CA001A"];
    _redView.layer.masksToBounds = YES;
    _redView.hidden = YES;
    [self.contentView addSubview:_redView];
    //星星
    
    //标签
    _tagListView = [[JCTagListView alloc] init];
    [self.contentView addSubview:self.tagListView];
    _tagListView.tagTextColor = [PublicUseMethod setColor:KColor_Add_BlckBlueColor];
    _tagListView.tagTextFont = [UIFont systemFontOfSize:12.0];
    _tagListView.borderWidth = 1;
    _tagListView.borderColor = [PublicUseMethod setColor:KColor_Add_BlckBlueColor];
    _tagListView.cellTitleBackgroudColor = [UIColor whiteColor];
    _tagListView.tagCornerRadius = 4;

    
    //公司名称
    _seeLabel = [[UILabel alloc] init];
    _seeLabel.text = @"我是公司";
    _seeLabel.font = [UIFont systemFontOfSize:11.0];
    _seeLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    [self.contentView addSubview:_seeLabel];
    
}

- (void)setCompanyEntity:(OpinionCompanyEntity *)companyEntity{

    _companyEntity = companyEntity;
    [self.logoImageView sd_setImageWithURL:[NSURL URLWithString:companyEntity.CompanyLogo] placeholderImage:Company_LOGO_Image];
    self.nameLabel.text = companyEntity.CompanyName;
    
    //标签
    [self.tagListView.tags addObjectsFromArray:companyEntity.Labels];
    self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
    self.tagCellHeight = [self.layout calculateContentHeight:companyEntity.Labels];
//    [self.tagListView.collectionView reloadData];
    
    //阅读
    self.seeLabel.text = [NSString stringWithFormat:@"总阅读 %ld   共%ld条点评   来自%ld为员工",companyEntity.ReadCount,companyEntity.CommentCount,companyEntity.StaffCount];
    
    //是否显示红点
    self.redView.hidden = companyEntity.IsRedDot;
    
    //设置frame
    self.logoImageView.frame = CGRectMake(Margin, Margin,LogoImageWith, LogoImageWith);
    
    self.starView.frame = CGRectMake(SCREEN_WIDTH - Margin - 100, Margin - 5, 100, 18);
    //红点
    self.redView.frame = CGRectMake(SCREEN_WIDTH - BetweenMargin -8, BetweenMargin, 8, 8);
    self.redView.layer.cornerRadius = 4;
    //星星
    self.starView = [[WQLStarView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH - Margin * 2- 87, Margin - 5, 87, 15) withTotalStar:5 withTotalPoint:5 starSpace:5];
    self.starView.starAliment = StarAlimentCenter;
    [self.contentView addSubview:self.starView];
    self.starView.commentPoint = 2;
    
    //公司名称
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + BetweenMargin, Margin,SCREEN_WIDTH - Margin * 2 - 100 -  BetweenMargin - LogoImageWith, Margin);
    
    //标签
    self.tagListView.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame), CGRectGetMaxY(self.nameLabel.frame), SCREEN_WIDTH - Margin * 2 - BetweenMargin - LogoImageWith, self.tagCellHeight);

    //阅读
    self.seeLabel.frame=CGRectMake(self.nameLabel.frame.origin.x, CGRectGetMaxY(self.tagListView.frame) - 5, self.tagListView.frame.size.width, 25);
    
    self.cellHeight = Margin + Margin + self.tagCellHeight + 25;
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
