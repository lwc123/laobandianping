//
//  CompanyDetailCell.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "CompanyDetailCell.h"
#import "CompanyReputationListCell.h"

const CGFloat TopMargin = 15.0f;
const CGFloat iconImageViewWith = 50.0f;
const CGFloat scoreTextSize = 14.0f;

const CGFloat LikedCountWith = 40.0f;

@interface CompanyDetailCell()

@property (nonatomic, strong) UIView *imageBgView;
@property (nonatomic, strong) UIImageView *iconImageView;//头像
@property (nonatomic, strong) UILabel * nameLabel;//公司名称
@property (nonatomic, strong) UILabel * scoreLabel;//分数
@property (strong ,nonatomic) TggStarEvaluationView *tggStarEvaView;//星星
@property (nonatomic, strong) UILabel * title;//title
@property (nonatomic, strong) UILabel * contentLabel;

@property (nonatomic, strong) UIView * oneLineView ;
@property (nonatomic, strong) JCTagListView *tagListView;//标签
@property (nonatomic, strong) JCCollectionViewTagFlowLayout *layout;
@property (nonatomic, assign) CGFloat contentHeight;
//下面的View
@property (nonatomic, strong) UIView * bottomView ;
//员工详情
@property (nonatomic, strong) UILabel * startDetailLabel;
//点赞数
@property (nonatomic, strong) UILabel * LikedCountLabel;
//点赞按钮
@property (nonatomic, strong) UIButton * likeBtn;
@property (nonatomic, strong) UILabel * readCount;
@property (nonatomic, strong) UIView * twoLineView ;
//中间的View
@property (nonatomic, strong) UIView * contenView ;



@end

@implementation CompanyDetailCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{

    _imageBgView = [[UIView alloc] init];
    [self.contentView addSubview:_imageBgView];

    //头像
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.layer.masksToBounds = YES;
    _iconImageView.layer.cornerRadius = iconImageViewWith * 0.5;
    [_imageBgView addSubview:_iconImageView];

    //名称
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.text = @"匿名用户";
    [_imageBgView addSubview:_nameLabel];

    //分数
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.font = [UIFont systemFontOfSize:scoreTextSize];
    _scoreLabel.textColor = [PublicUseMethod setColor:KColor_RedColor];
    _scoreLabel.text = @"4分";
    [_imageBgView addSubview:_scoreLabel];
    //星星
    _tggStarEvaView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
        
    }];
    _tggStarEvaView.spacing = 0.1;
    _tggStarEvaView.userInteractionEnabled = NO;
    _tggStarEvaView.norImage = [UIImage imageNamed:@"灰星"];
    _tggStarEvaView.selImage = [UIImage imageNamed:@"黄星"];
    [_imageBgView  addSubview:_tggStarEvaView];
    
    //线
    _oneLineView = [[UIView alloc] init];
    _oneLineView.alpha = 0.2;
    _oneLineView.backgroundColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    [_imageBgView addSubview:_oneLineView];
    
    _contenView = [[UIView alloc] init];
    [self.contentView addSubview:_contenView];
    
    //标签
    _tagListView = [[JCTagListView alloc]init];
    [self.contentView addSubview:_tagListView];
    _tagListView.tagTextColor = [PublicUseMethod setColor:KColor_Add_BlckBlueColor];
    _tagListView.tagTextFont = [UIFont systemFontOfSize:12.0];
    _tagListView.borderWidth = 1;
    _tagListView.borderColor = [PublicUseMethod setColor:KColor_Add_BlckBlueColor];
    _tagListView.cellTitleBackgroudColor = [UIColor whiteColor];
    _tagListView.tagCornerRadius = 4;
    
    //标题  高度不确定
    _title = [[UILabel alloc] init];
    _title.text = @"我是标题";
    _title.font = [UIFont systemFontOfSize:TopMargin];
    _title.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    [_contenView addSubview:_title];
    
    //内容 高度不确定
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:12];
    _contentLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    _contentLabel.text = @"4分";
    _contentLabel.numberOfLines = 0;
    [_contenView addSubview:_contentLabel];
    
    //第二个线
    _twoLineView = [[UIView alloc] init];
    _twoLineView.alpha = 0.2;
    _twoLineView.backgroundColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    [_contenView addSubview:_twoLineView];
    
    _bottomView = [[UIView alloc] init];
    [self.contentView addSubview:_bottomView];
    
    _startDetailLabel = [[UILabel alloc] init];
    _startDetailLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    _startDetailLabel.text = @"我是员工详情";
    _startDetailLabel.font = [UIFont systemFontOfSize:12];
    [_bottomView addSubview:_startDetailLabel];
    
    _LikedCountLabel = [[UILabel alloc] init];
    _LikedCountLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    _LikedCountLabel.text = @"2222";
    _LikedCountLabel.font = [UIFont systemFontOfSize:12];
    [_bottomView addSubview:_LikedCountLabel];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_bottomView addSubview:_likeBtn];
    
    _readCount = [[UILabel alloc] init];
    _readCount.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    _readCount.text = @"阅读 2222";
    _readCount.font = [UIFont systemFontOfSize:12];
    [_bottomView addSubview:_readCount];
    
}

/*
- (void)layoutSubviews{

    [super layoutSubviews];
    
    self.imageBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    self.iconImageView.frame =CGRectMake(TopMargin, TopMargin - 5, iconImageViewWith, iconImageViewWith);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + TopMargin, (70 - TopMargin) * 0.5, SCREEN_WIDTH - self.iconImageView.width - TopMargin * 2, TopMargin);
    
  
    
  
    //星星
    self.tggStarEvaView.frame = CGRectMake(SCREEN_WIDTH - TopMargin - 100, (70 - 18) * 0.5, 100, 18);
    //分数
    self.scoreLabel.frame = CGRectMake(SCREEN_WIDTH - TopMargin - 100 - 10 - 30,(70 - 14) * 0.5, 30, 14);
    
    
    //标签
    [self.tagListView.tags addObjectsFromArray:self.opinionEntity.Labels];
    self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
    self.tagCellHeight = [self.layout calculateContentHeight:self.opinionEntity.Labels];
    
    self.tagListView.frame = CGRectMake(TopMargin, CGRectGetMaxY(self.imageBgView.frame), SCREEN_WIDTH - TopMargin, self.tagCellHeight);
    self.tagListView.backgroundColor = [UIColor redColor];
    
    //标题
    self.title.frame = CGRectMake(TopMargin, 10, SCREEN_WIDTH - TopMargin * 2, [CompanyReputationListCell getTitleTextHeightWithText:self.opinionEntity.Title]);
    
    //内容 我们节选前200个字
    if (self.opinionEntity.Content.length <= 200) {
        self.contentHeight = [CompanyReputationListCell getTitleTextHeightWithText:self.opinionEntity.Content];
    }else{//大于200个字
        NSString * subString = [self.opinionEntity.Content substringToIndex:200];
        self.contentHeight = [CompanyReputationListCell getTitleTextHeightWithText:subString];
    }
    
    self.contentLabel.frame =CGRectMake(TopMargin, CGRectGetMaxY(self.title.frame) + 10, SCREEN_WIDTH - TopMargin * 2, self.contentHeight);
    self.twoLineView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame), SCREEN_WIDTH, 0.5);
    
    //中间的View
    self.contenView.frame = CGRectMake(0, CGRectGetMaxY(self.tagListView.frame), SCREEN_WIDTH, (self.tagCellHeight + 10 + [CompanyReputationListCell getTitleTextHeightWithText:self.opinionEntity.Title] + self.contentHeight + 1));

    
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.contenView.frame), SCREEN_WIDTH, 40);
    self.startDetailLabel.frame = CGRectMake(TopMargin, 10, 200, 12);
    
    
    self.LikedCountLabel.frame = CGRectMake(SCREEN_WIDTH - LikedCountWith - TopMargin, self.startDetailLabel.origin.y, 40, 12);
    
    self.likeBtn.frame = CGRectMake(SCREEN_WIDTH - self.LikedCountLabel.size.width - TopMargin - TopMargin - TopMargin, self.startDetailLabel.origin.y - 2, TopMargin, TopMargin);
    self.readCount.frame = CGRectMake(self.likeBtn.origin.x - 20 - 80, self.startDetailLabel.origin.y, 80, 12);

}
*/
- (void)setOpinionEntity:(OpinionEntity *)opinionEntity{

    _opinionEntity = opinionEntity;

    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:opinionEntity.Avatar] placeholderImage:UserImage];
    self.scoreLabel.text = [NSString stringWithFormat:@"%1.f分",opinionEntity.Scoring];
    self.tggStarEvaView.starCount = opinionEntity.Scoring;
    self.title.text = opinionEntity.Title;
    //内容
    if (opinionEntity.Content.length < 200) {
        self.contentLabel.text = opinionEntity.Content;
    }else{
        self.contentLabel.text = [opinionEntity.Content substringToIndex:200];
    }
    
    _readCount.text = [NSString stringWithFormat:@"阅读 %ld",opinionEntity.ReadCount];
    //员工
    _startDetailLabel.text = [NSString stringWithFormat:@"员工-%@年-%@",opinionEntity.WorkingYears,opinionEntity.Region];
    // 点赞按钮
    self.likeBtn.selected = opinionEntity.IsLiked ? YES : NO;
    
    if (self.likeBtn.selected == NO) {
        [self.likeBtn setImage:[UIImage imageNamed:@"ic_good"] forState:UIControlStateNormal];
    }else{
        
    }
    
    //点赞数
    if (opinionEntity.LikedCount >= 1000) {
        _LikedCountLabel.text = @"999+";
    }else{
        _LikedCountLabel.text = [NSString stringWithFormat:@"%ld",opinionEntity.LikedCount];
    }

    //设置frame
    self.imageBgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 70);
    self.iconImageView.frame =CGRectMake(TopMargin, TopMargin - 5, iconImageViewWith, iconImageViewWith);
    self.nameLabel.frame = CGRectMake(CGRectGetMaxX(self.iconImageView.frame) + TopMargin, (70 - TopMargin) * 0.5, SCREEN_WIDTH - self.iconImageView.width - TopMargin * 2, TopMargin);
    
    //星星
    self.tggStarEvaView.frame = CGRectMake(SCREEN_WIDTH - TopMargin - 100, (70 - 18) * 0.5, 100, 18);
    //分数
    self.scoreLabel.frame = CGRectMake(SCREEN_WIDTH - TopMargin - 100 - 10 - 30,(70 - 14) * 0.5, 30, 14);
    
    
    //标签
    [self.tagListView.tags addObjectsFromArray:self.opinionEntity.Labels];
    self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
    self.tagCellHeight = [self.layout calculateContentHeight:self.opinionEntity.Labels];
    self.tagListView.frame = CGRectMake(TopMargin - 10, CGRectGetMaxY(self.imageBgView.frame), SCREEN_WIDTH - TopMargin, self.tagCellHeight);
    
    //标题
    self.title.frame = CGRectMake(TopMargin, 10, SCREEN_WIDTH - TopMargin * 2, [CompanyReputationListCell getTitleTextHeightWithText:self.opinionEntity.Title]);
    
    //内容 我们节选前200个字
    if (self.opinionEntity.Content.length <= 200) {
        self.contentHeight = [CompanyReputationListCell getTitleTextHeightWithText:self.opinionEntity.Content];
    }else{//大于200个字
        NSString * subString = [self.opinionEntity.Content substringToIndex:200];
        self.contentHeight = [CompanyReputationListCell getTitleTextHeightWithText:subString];
    }
    
    self.contentLabel.frame =CGRectMake(TopMargin, CGRectGetMaxY(self.title.frame) + 10, SCREEN_WIDTH - TopMargin * 2, self.contentHeight);
    self.twoLineView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame), SCREEN_WIDTH, 0.5);
    
    //中间的View
    self.contenView.frame = CGRectMake(0, CGRectGetMaxY(self.tagListView.frame), SCREEN_WIDTH, (10 + [CompanyReputationListCell getTitleTextHeightWithText:self.opinionEntity.Title] + self.contentHeight + 1 + 10 + 2));
    
    
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.contenView.frame), SCREEN_WIDTH, 40);
    self.startDetailLabel.frame = CGRectMake(TopMargin, 10, 200, 12);
    
    
    self.LikedCountLabel.frame = CGRectMake(SCREEN_WIDTH - LikedCountWith - TopMargin, self.startDetailLabel.origin.y, 40, 12);
    
    self.likeBtn.frame = CGRectMake(SCREEN_WIDTH - self.LikedCountLabel.size.width - TopMargin - TopMargin - TopMargin, self.startDetailLabel.origin.y - 2, TopMargin, TopMargin);
    self.readCount.frame = CGRectMake(self.likeBtn.origin.x - 20 - 80, self.startDetailLabel.origin.y, 80, 12);
    
    
    //上面的View  + 中间的VIew  + 标签+下面的View
    self.cellHeight = 70 + self.contenView.frame.size.height + self.tagCellHeight + 40;
    
    
    
    
    
    
    
    
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
