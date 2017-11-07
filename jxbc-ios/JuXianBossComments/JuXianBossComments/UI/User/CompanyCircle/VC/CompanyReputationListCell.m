//
//  CompanyReputationListCell.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/18.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "CompanyReputationListCell.h"
#import "TggStarEvaluationView.h"
#import "JCTagListView.h"
#import "JCCollectionViewTagFlowLayout.h"
// 间距
const CGFloat ListMargin = 15.0;
const CGFloat TopUpMargin = 10.0;

// 头像高度
const CGFloat length = 50.0f;
const CGFloat likeBtnMargin = 5.0f;
//点赞数的宽度
const CGFloat LikedCountLabel_Width = 40.0f;
//点赞btn的宽度 公司名称的高度
const CGFloat LikedBtn_Width = 15.0f;
// 字体型号
const CGFloat scoreFontSize = 14.0f;
const CGFloat contentSize = 12.0f;

//公司名称所在View的高度
const CGFloat bgViewHeight = 66.0f;
const CGFloat bottowVIewHeight = 30.0f;


//const CGFloat contentFontSize = 14.0f;

@interface CompanyReputationListCell()

@property (nonatomic, strong) UIImageView *logoImageView;//头像
@property (nonatomic, strong) UIView * bgView ;//头像和公司名的背景View
@property (nonatomic, strong) UILabel * companyLabel;//公司名称
@property (nonatomic, strong) UILabel * scoreLabel;//分数
@property (nonatomic, strong) UILabel * title;//title
//内容
@property (nonatomic, strong) UILabel * contentLabel;
//下面的View
@property (nonatomic, strong) UIView * bottomView ;
//员工详情
@property (nonatomic, strong) UILabel * startDetailLabel;
//点赞数
@property (nonatomic, strong) UILabel * LikedCountLabel;
//点赞按钮
@property (nonatomic, strong) UIButton * likeBtn;
@property (nonatomic, strong) UILabel * readCount;
@property (nonatomic, strong) UIView * oneLineView ;
@property (nonatomic, strong) UIView * twoLineView ;
@property (nonatomic, strong) UIView * twoBgView ;

@property (strong ,nonatomic) TggStarEvaluationView *tggStarEvaView;
@property (nonatomic, strong) JCTagListView *tagListView;//标签
@property (nonatomic, strong) JCCollectionViewTagFlowLayout *layout;
@property (nonatomic, assign) CGFloat contentHeight;


@end


@implementation CompanyReputationListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUp];
    }
    return self;
}

- (void)setUp{

    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = [UIColor yellowColor];
    
    _bgView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [_bgView addGestureRecognizer:tap];
    [self.contentView addSubview:_bgView];
    //公司logo
    _logoImageView = [[UIImageView alloc] init];
    _logoImageView.layer.masksToBounds = YES;
    _logoImageView.layer.cornerRadius = 4;
    [_bgView addSubview:_logoImageView];
    
    //公司名称
    _companyLabel = [[UILabel alloc] init];
    _companyLabel.text = @"我是公司";
    _companyLabel.font = [UIFont systemFontOfSize:15.0];
    _companyLabel.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    [_bgView addSubview:_companyLabel];
    
    //线
    _oneLineView = [[UIView alloc] init];
    _oneLineView.alpha = 0.2;
    _oneLineView.backgroundColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    [self.contentView addSubview:_oneLineView];
    //标签
    self.tagListView = [[JCTagListView alloc]init];
    [self.contentView addSubview:self.tagListView];
    self.tagListView.tagSelectedTextColor = [UIColor blackColor];
    self.tagListView.tagCornerRadius = 5.0f;
    
    //中间的一个大View //可以暂时不写
    
    
    //分数
    _scoreLabel = [[UILabel alloc] init];
    _scoreLabel.font = [UIFont systemFontOfSize:LikedBtn_Width];
    _scoreLabel.textColor = [PublicUseMethod setColor:KColor_RedColor];
    _scoreLabel.text = @"4分";
    [self.contentView addSubview:_scoreLabel];
  //星星
    _tggStarEvaView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
        
    }];
    _tggStarEvaView.spacing = 0.1;
    _tggStarEvaView.userInteractionEnabled = NO;
    _tggStarEvaView.norImage = [UIImage imageNamed:@"灰星"];
    _tggStarEvaView.selImage = [UIImage imageNamed:@"黄星"];
    [self.contentView  addSubview:_tggStarEvaView];

    //标题  高度不确定
    _title = [[UILabel alloc] init];
    _title.text = @"我是标题";
    _title.font = [UIFont boldSystemFontOfSize:scoreFontSize];
    _title.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    [self.contentView addSubview:_title];
    
    
    //内容 高度不确定
    _contentLabel = [[UILabel alloc] init];
    
    _contentLabel.font = [UIFont systemFontOfSize:contentSize];
    _contentLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    _contentLabel.text = @"4分";
    _contentLabel.numberOfLines = 0;
    _contentLabel.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:_contentLabel];
    
    //第二个线
    _twoLineView = [[UIView alloc] init];
    _twoLineView.alpha = 0.2;
    _twoLineView.backgroundColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    [self.contentView addSubview:_twoLineView];
    
    _bottomView = [[UIView alloc] init];
    _bottomView.userInteractionEnabled = YES;
    UITapGestureRecognizer * tapp = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(taptemp)];
    [_bottomView addGestureRecognizer:tapp];
    
    [self.contentView addSubview:_bottomView];
    
    
    
    _startDetailLabel = [[UILabel alloc] init];
    _startDetailLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    _startDetailLabel.text = @"我是员工详情";
    _startDetailLabel.font = [UIFont systemFontOfSize:11];
    [_bottomView addSubview:_startDetailLabel];
    
    _LikedCountLabel = [[UILabel alloc] init];
    _LikedCountLabel.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    _LikedCountLabel.text = @"2222";
    _LikedCountLabel.font = [UIFont systemFontOfSize:12];
    
    [_bottomView addSubview:_LikedCountLabel];
    
    _likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_likeBtn addTarget:self action:@selector(likeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_likeBtn setImage:[UIImage imageNamed:@"wuzan"] forState:UIControlStateNormal];

    [_bottomView addSubview:_likeBtn];
    
    _readCount = [[UILabel alloc] init];
    _readCount.textColor = [PublicUseMethod setColor:KColor_Text_EumeColor];
    _readCount.text = @"阅读 2222";
    _readCount.font = [UIFont systemFontOfSize:12];
    
    
    [_bottomView addSubview:_readCount];
    
}

- (void)taptemp{

}

/*
- (void)layoutSubviews{

    [super layoutSubviews];

    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, bgViewHeight);
    self.logoImageView.frame =CGRectMake(ListMargin, ListMargin - 7, length, length);
    self.companyLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + TopUpMargin, (bgViewHeight - LikedBtn_Width) * 0.5, SCREEN_WIDTH - self.logoImageView.width - ListMargin * 2, LikedBtn_Width);
    
    //线
    self.oneLineView.frame = CGRectMake(0, CGRectGetMaxY(self.bgView.frame), SCREEN_WIDTH, 1);
    
    //标签
    [self.tagListView.tags addObjectsFromArray:self.opinionModel.Labels];
    self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
    self.tagCellHeight = [self.layout calculateContentHeight:self.opinionModel.Labels];
    
    self.tagListView.frame = CGRectMake(ListMargin, CGRectGetMaxY(self.oneLineView.frame), SCREEN_WIDTH - ListMargin, self.tagCellHeight);
    self.tagListView.backgroundColor = [UIColor redColor];
    
    //分数
    self.scoreLabel.frame = CGRectMake(ListMargin, CGRectGetMaxY(self.tagListView.frame) + 3, 28, LikedBtn_Width);
    //星星
    self.tggStarEvaView.frame = CGRectMake(CGRectGetMaxX(self.scoreLabel.frame) + 8, CGRectGetMaxY(self.tagListView.frame), 100, 18);
    
    //标题
    self.title.frame = CGRectMake(ListMargin, CGRectGetMaxY(self.scoreLabel.frame) + 10, SCREEN_WIDTH - ListMargin * 2, [CompanyReputationListCell getTitleTextHeightWithText:self.opinionModel.Title]);
    
    //内容 我们节选前200个字
    if (self.opinionModel.Content.length <= 200) {
        
        self.contentHeight = [CompanyReputationListCell getTitleTextHeightWithText:self.opinionModel.Content];
    }else{//大于200个字
//        [string substringToIndex:7];//截取掉下标7之后的字符串
//        [string substringFromIndex:2];//截取掉下标2之前的字符串
        NSString * subString = [self.opinionModel.Content substringToIndex:200];
        self.contentHeight = [CompanyReputationListCell getTitleTextHeightWithText:subString];
    }
    
    self.contentLabel.frame =CGRectMake(ListMargin, CGRectGetMaxY(self.title.frame) + TopUpMargin, SCREEN_WIDTH - ListMargin * 2, self.contentHeight);
    self.twoLineView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame), SCREEN_WIDTH, 0.5);
    
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.twoLineView.frame), SCREEN_WIDTH, bottowVIewHeight);
    
    self.startDetailLabel.frame = CGRectMake(9.5, 10, 200, 11);
    
    self.LikedCountLabel.frame = CGRectMake(SCREEN_WIDTH - LikedCountLabel_Width - ListMargin, self.startDetailLabel.origin.y, LikedCountLabel_Width, 12);
    
    self.likeBtn.frame = CGRectMake(SCREEN_WIDTH - self.LikedCountLabel.size.width - LikedBtn_Width - ListMargin - likeBtnMargin, self.startDetailLabel.origin.y - 2, LikedBtn_Width, LikedBtn_Width);
    
    self.readCount.frame = CGRectMake(self.likeBtn.origin.x - 20 - 80, self.startDetailLabel.origin.y, 80, 12);
    // 上面的View  + 标签 + 星星 + 上下的空隙 + title + 空隙 + 内容 + 下面的View的高度 + 两个线的高度
//    self.cellHeight = bgViewHeight + self.tagCellHeight + 18 + 6 + 10 + [CompanyReputationListCell getTitleTextHeightWithText:self.opinionModel.Title] + 10 + self.contentHeight + 40 + 2;
}
*/
// 计算文字行高
+ (CGFloat)getTitleTextHeightWithText:(NSString *)text {
    if (!text || !text.length)
        return 0;
    return [SETextView frameRectWithAttributtedString:[[NSAttributedString alloc] initWithString:text] constraintSize:CGSizeMake(SCREEN_WIDTH - ListMargin * 2, CGFLOAT_MAX) lineSpacing:0 font:[UIFont systemFontOfSize:contentSize]].size.height;
}

#pragma mark -- 公司的点击
- (void)tapGesture{

    if ([self.delegate respondsToSelector:@selector(ReputationListCellCompanydetail:indexPath:)]) {
        
        [self.delegate ReputationListCellCompanydetail:self indexPath:self.indexPath];
    }

}

#pragma mark -- 点赞
- (void)likeBtnClick:(UIButton *)button{

    
    MJWeakSelf
    [UserOpinionRequest postOpinionPraiseWithOpinionId:self.opinionModel.OpinionId success:^(BOOL result) {
        weakSelf.opinionModel.IsLiked = !weakSelf.opinionModel.IsLiked;
        if (weakSelf.opinionModel.IsLiked == YES) {
            weakSelf.opinionModel.LikedCount++;
        }else{
            weakSelf.opinionModel.LikedCount--;
        }
    } fail:^(NSError *error) {
        
    }];
    button.selected = !button.selected;

    int num = [self.LikedCountLabel.text intValue];

    if (button.selected) {
        
        self.LikedCountLabel.text = [NSString stringWithFormat:@"%d",num + 1];
        [button setImage:[UIImage imageNamed:@"ic_xjhgood"] forState:UIControlStateNormal];

    }else{
        self.LikedCountLabel.text = [NSString stringWithFormat:@"%d",num - 1];
        [button setImage:[UIImage imageNamed:@"wuzan"] forState:UIControlStateNormal];
    }

}

- (void)setOpinionModel:(OpinionEntity *)opinionModel{

    _opinionModel = opinionModel;
    _companyLabel.text = opinionModel.Company.CompanyName;
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:opinionModel.Company.CompanyLogo] placeholderImage:LOGO_Image];

    [self.tagListView setCompletionBlockWithSelected:^(NSInteger index) {
        NSLog(@"______%ld______", (long)index);
    }];
    
    //分数
    _scoreLabel.text = [NSString stringWithFormat:@"%1.f分",opinionModel.Scoring];
    //星星
    _tggStarEvaView.starCount = [_scoreLabel.text integerValue];
    
    //标题
    _title.text = opinionModel.Title;
    
    //内容
    if (opinionModel.Content.length < 200) {
        _contentLabel.text = opinionModel.Content;
    }else{
        _contentLabel.text = [opinionModel.Content substringToIndex:200];
    }
    _readCount.text = [NSString stringWithFormat:@"阅读 %ld",opinionModel.ReadCount];
    
    //员工
    _startDetailLabel.text = [NSString stringWithFormat:@"员工-%@年-%@",opinionModel.WorkingYears,opinionModel.Region];
     // 点赞按钮
    self.likeBtn.selected = opinionModel.IsLiked ? YES : NO;
    
    if (self.likeBtn.selected == NO) {
        [_likeBtn setImage:[UIImage imageNamed:@"wuzan"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"ic_xjhgood"] forState:UIControlStateNormal];

    }
    
    //点赞数
    if (opinionModel.LikedCount >= 1000) {
        _LikedCountLabel.text = @"999+";
    }else{
        _LikedCountLabel.text = [NSString stringWithFormat:@"%ld",opinionModel.LikedCount];
    }

    
    
    
    self.bgView.frame = CGRectMake(0, 0, SCREEN_WIDTH, bgViewHeight);
    self.logoImageView.frame =CGRectMake(ListMargin, ListMargin - 7, length, length);
    self.companyLabel.frame = CGRectMake(CGRectGetMaxX(self.logoImageView.frame) + TopUpMargin, (bgViewHeight - LikedBtn_Width) * 0.5, SCREEN_WIDTH - self.logoImageView.width - ListMargin * 2, LikedBtn_Width);
    
    //线
    self.oneLineView.frame = CGRectMake(0, CGRectGetMaxY(self.bgView.frame), SCREEN_WIDTH, 1);
    
    //标签
    [self.tagListView.tags addObjectsFromArray:self.opinionModel.Labels];
    self.layout = [[JCCollectionViewTagFlowLayout alloc] init];
    self.tagCellHeight = [self.layout calculateContentHeight:self.opinionModel.Labels];
    
    self.tagListView.frame = CGRectMake(ListMargin, CGRectGetMaxY(self.oneLineView.frame), SCREEN_WIDTH - ListMargin, self.tagCellHeight);
    self.tagListView.backgroundColor = [UIColor redColor];
    
    //分数
    self.scoreLabel.frame = CGRectMake(ListMargin, CGRectGetMaxY(self.tagListView.frame) + 3, 28, LikedBtn_Width);
    //星星
    self.tggStarEvaView.frame = CGRectMake(CGRectGetMaxX(self.scoreLabel.frame) + 8, CGRectGetMaxY(self.tagListView.frame), 100, 18);
    
    //标题
    self.title.frame = CGRectMake(ListMargin, CGRectGetMaxY(self.scoreLabel.frame) + 10, SCREEN_WIDTH - ListMargin * 2, [CompanyReputationListCell getTitleTextHeightWithText:self.opinionModel.Title]);
    
    //内容 我们节选前200个字
    if (self.opinionModel.Content.length <= 200) {
        
        self.contentHeight = [CompanyReputationListCell getTitleTextHeightWithText:self.opinionModel.Content];
    }else{//大于200个字
        //        [string substringToIndex:7];//截取掉下标7之后的字符串
        //        [string substringFromIndex:2];//截取掉下标2之前的字符串
        NSString * subString = [self.opinionModel.Content substringToIndex:200];
        self.contentHeight = [CompanyReputationListCell getTitleTextHeightWithText:subString];
    }
    
    self.contentLabel.frame =CGRectMake(ListMargin, CGRectGetMaxY(self.title.frame) + TopUpMargin, SCREEN_WIDTH - ListMargin * 2, self.contentHeight);
    self.twoLineView.frame = CGRectMake(0, CGRectGetMaxY(self.contentLabel.frame), SCREEN_WIDTH, 0.5);
    
    self.bottomView.frame = CGRectMake(0, CGRectGetMaxY(self.twoLineView.frame), SCREEN_WIDTH, bottowVIewHeight);
    
    self.startDetailLabel.frame = CGRectMake(9.5, 10, 200, 11);
    
    self.LikedCountLabel.frame = CGRectMake(SCREEN_WIDTH - LikedCountLabel_Width - ListMargin, self.startDetailLabel.origin.y, LikedCountLabel_Width, 12);
    
    self.likeBtn.frame = CGRectMake(SCREEN_WIDTH - self.LikedCountLabel.size.width - LikedBtn_Width - ListMargin - likeBtnMargin, self.startDetailLabel.origin.y - 2, LikedBtn_Width, LikedBtn_Width);
    
    self.readCount.frame = CGRectMake(self.likeBtn.origin.x - 20 - 80, self.startDetailLabel.origin.y, 80, 12);
    
    self.cellHeight = bgViewHeight + self.tagCellHeight + 18 + 6 + 10 + [CompanyReputationListCell getTitleTextHeightWithText:self.opinionModel.Title] + 10 + self.contentHeight + 40 + 2;
}



//- (void)awakeFromNib {
//    [super awakeFromNib];
//    // Initialization code
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
