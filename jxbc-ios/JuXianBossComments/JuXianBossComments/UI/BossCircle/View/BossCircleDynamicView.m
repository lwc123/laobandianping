//
//  BossCircleDynamicView.m
//  JuXianBossComments
//
//  Created by Jam on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "BossCircleDynamicView.h"
#import "JXPhotoCollectionViewFlowLayout.h"
#import "JXPhotoCollectionViewCell.h"
#import "BossDynamicEntity.h"
#import "XHImageViewer.h"
#import "BossCircleRequest.h"
#import "BossCircelCommentCell.h"
#import "DynamicToolButton.h"
#import <AVFoundation/AVFoundation.h>

// 间距
const CGFloat iconMargin = 15.0;
const CGFloat margin = 12.0f;
// 头像高度
const CGFloat iconLength = 50.0f;

// 公司名高度
const CGFloat companyNameHeight = 14.0f;
// boss名高度
const CGFloat bossNameHeight = 12.f;

// 照片尺寸
const CGFloat PhotoSize = 79.0f;

// 图片间隔
const CGFloat photoMargin = 5.0f;

// 操作条高度
const CGFloat toolBarHeight = 25.0f;

// 字体型号
const CGFloat companyFontSize = 14.0f;
const CGFloat bossNameFontSize = 12.0f;
const CGFloat contentFontSize = 14.0f;

// 单图高度
const CGFloat singleImageHeight = 120;


// 图片九宫格视图
@interface JXPhotoCollectionView : UICollectionView

@end

@implementation JXPhotoCollectionView

@end



@interface BossCircleDynamicView ()<UICollectionViewDelegate, UICollectionViewDataSource,UITableViewDelegate,UITableViewDataSource>

// 头像
@property (nonatomic, strong) UIImageView *iconImageView;
// 公司名称
@property (nonatomic, strong) UILabel *companyNameLabel;
// 老板名称
@property (nonatomic, strong) UILabel *bossNameLable;

// 图片
@property (nonatomic, strong) JXPhotoCollectionView *photoCollectionView;

// 时间
@property (nonatomic, strong) UILabel *timeStampLabel;
// 删除按钮
@property (nonatomic, strong) UIButton *deleteButton;
// 点赞按钮
@property (nonatomic, strong) DynamicToolButton *likeButton;
// 评论按钮
@property (nonatomic, strong) DynamicToolButton *commentButton;

// 分割线
@property (nonatomic, strong) UIView *separateLine;
// 评论列表
@property (nonatomic, strong) UITableView *commentListView;
// 评论数组
@property (nonatomic, strong) NSArray *commentsArray;

// 评论行高
@property (nonatomic, strong) NSMutableArray *cellHeightArray;
//
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation BossCircleDynamicView

static NSString * reuseID = @"DynamicPhoto";


#pragma mark - life Cycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self setup];
    }
    return self;
}

#pragma mark - init
- (void)setup{
    
    // 头像
    _iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(iconMargin, iconMargin, iconLength, iconLength)];
    //    _iconImageView.layer.cornerRadius = 5;
    //    _iconImageView.clipsToBounds = YES;
    [self addSubview:_iconImageView];
    
    // 公司名称
    _companyNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(iconMargin + iconLength + 10, _iconImageView.y + 8, ScreenWidth - 2*iconMargin - iconLength - 10, 14)];
    _companyNameLabel.textColor = ColorWithHex(KColor_GoldColor);
    _companyNameLabel.font = [UIFont systemFontOfSize:companyFontSize];
    [self addSubview:_companyNameLabel];
    
    // 老板名称
    
    _bossNameLable = [[UILabel alloc]initWithFrame:CGRectMake(_companyNameLabel.x, CGRectGetMaxY(_companyNameLabel.frame) + 10, _companyNameLabel.width, 12)];
    _bossNameLable.font = [UIFont systemFontOfSize:bossNameFontSize];
    [self addSubview:_bossNameLable];
    
    // 文字
    _richTextView = [[SETextView alloc]initWithFrame:CGRectMake(_companyNameLabel.x, CGRectGetMaxY(_bossNameLable.frame)+iconMargin, _companyNameLabel.width, 24)];
    _richTextView.backgroundColor = [UIColor whiteColor];
    _richTextView.font = [UIFont systemFontOfSize:contentFontSize];
    [self addSubview:_richTextView];
    
    // 图片
    [self addSubview:self.photoCollectionView];
    self.photoCollectionView.backgroundColor = self.backgroundColor;
    
    
    // 时间
    _timeStampLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    _timeStampLabel.font = [UIFont systemFontOfSize:12];
    _timeStampLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:_timeStampLabel];
    
    
    // 删除按钮
    _deleteButton = [[UIButton alloc]init];
    _deleteButton.hidden = YES;
    [_deleteButton setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteButton setTitle:@"删除" forState:UIControlStateHighlighted];
    [_deleteButton setTitleColor:ColorWithHex(KColor_GoldColor) forState:UIControlStateNormal];
    [_deleteButton setTitleColor:ColorWithHex(KColor_GoldColor) forState:UIControlStateHighlighted];
    [_deleteButton addTarget:self action:@selector(deleteButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    _deleteButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [self addSubview:_deleteButton];
    
    // 点赞按钮
    
    _likeButton = [[DynamicToolButton alloc]init];
    _likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _likeButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_likeButton setImage:[UIImage imageNamed:@"黑赞.png"] forState:UIControlStateNormal];
    [_likeButton setImage:[UIImage imageNamed:@"红赞.png"] forState:UIControlStateSelected];
    [_likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_likeButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
    [_likeButton setTitle:@"0" forState:UIControlStateNormal];
    [_likeButton setTitle:@"0" forState:UIControlStateSelected];
    _likeButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_likeButton addTarget:self action:@selector(likeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_likeButton];
    
    // 评论按钮
    _commentButton = [[DynamicToolButton alloc]init];
    _commentButton.titleLabel.font = [UIFont systemFontOfSize:12];
    _commentButton.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [_commentButton setImage:[UIImage imageNamed:@"通话.png"] forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    [_commentButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    [_commentButton setTitle:@"0" forState:UIControlStateNormal];
    _commentButton.titleLabel.textAlignment = NSTextAlignmentCenter;

    [_commentButton addTarget:self action:@selector(commentButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self addSubview:_commentButton];
    
    // 分割线
    _separateLine = [[UIView alloc]init];
    _separateLine.backgroundColor = [UIColor colorWithRed:240/254.0 green:240/254.0 blue:240/254.0 alpha:1];
    
    
    [self addSubview:_separateLine];
    
    // 评论列表
    
    [self addSubview:self.commentListView];
    
    //    [_commentButton setBackgroundColor:[UIColor redColor]];
    //    [_likeButton setBackgroundColor:[UIColor redColor]];
    //    _timeStampLabel.backgroundColor = [UIColor orangeColor];
    
}

#pragma mark - function

- (void)deleteButtonClick{
    
    // 回调
    if (self.deleteButtonClickBlock) {
        self.deleteButtonClickBlock(self.dynamic);
    }
    
    
}



// 点赞按钮
- (void)likeButtonClick:(UIButton *)sender{
    MJWeakSelf
    // 获取公司id
    CompanyMembeEntity * companyEntity= [UserAuthentication GetBossInformation];
    [BossCircleRequest postLikedDynamicWithCompanyId:companyEntity.CompanyId DynamicId:self.dynamic.DynamicId success:^(BOOL result) {
        
        weakSelf.dynamic.IsLiked = !weakSelf.dynamic.IsLiked;
        if (weakSelf.dynamic.IsLiked == YES) {
            weakSelf.dynamic.LikedNum++;
        }else{
            weakSelf.dynamic.LikedNum--;
        }
        Log(@"点赞");
    } fail:^(NSError *error) {
        Log(@"#postLikedDynamicWithDynamicId error:%@",error.localizedDescription);
    }];
    
    sender.selected = !sender.selected;
    // 取值
    NSString* likedNum = self.likeButton.currentTitle;
    int num = [likedNum intValue];
    
    
    if (sender.selected) {
        
        [self.likeButton setTitle:[NSString stringWithFormat:@"%d",num + 1] forState:UIControlStateSelected];
        [self.likeButton setTitle:[NSString stringWithFormat:@"%d",num + 1] forState:UIControlStateNormal];
    }else{
        [self.likeButton setTitle:[NSString stringWithFormat:@"%d",num - 1] forState:UIControlStateSelected];
        [self.likeButton setTitle:[NSString stringWithFormat:@"%d",num - 1] forState:UIControlStateNormal];
    }
    
}
// 评论按钮
- (void)commentButtonClick:(UIButton *)sender{
    Log(@"评论");
    
    BossDynamicCommentEntity* comment = [[BossDynamicCommentEntity alloc]init];;
    
    // 获取动态id
    comment.DynamicId = self.dynamic.DynamicId;
    comment.CompanyId = self.dynamic.CompanyId;
    
    // 回调
    if (self.commentButtonClickBlock) {
        
        self.commentButtonClickBlock(comment);
    }
    
}

- (void)setBossNameHidden:(BOOL)bossNameHidden{
    
    _bossNameHidden = bossNameHidden;
    
    self.bossNameLable.hidden = bossNameHidden;
}


- (void)setDeleteBtnHidden:(BOOL)deleteBtnHidden{
    
    _deleteBtnHidden = deleteBtnHidden;
    if (_deleteButton) {
        self.deleteButton.hidden = YES;
    }
}


#pragma mark - 布局
- (void)layoutSubviews{
    [super layoutSubviews];
    
    // 文字内容
    self.richTextView.frame = CGRectMake(_companyNameLabel.x, CGRectGetMaxY(_bossNameLable.frame)+margin, _companyNameLabel.width, [BossCircleDynamicView getRichTextHeightWithText:self.dynamic.Content] );
    
    
    // 图片
    if (self.dynamic.Img.count > 0 ) {
        
        if (self.dynamic.Img.count == 1) {
            self.photoCollectionView.frame = CGRectMake(self.companyNameLabel.x, CGRectGetMaxY(self.richTextView.frame) + margin,ScreenWidth*0.5,singleImageHeight);
        }else{
            self.photoCollectionView.frame = CGRectMake(self.companyNameLabel.x, CGRectGetMaxY(self.richTextView.frame) + margin,3 * PhotoSize + 2* photoMargin ,[BossCircleDynamicView getPhotoCollectionViewHeightWithPhotos:_dynamic.Img]);
        }
    }else{
        self.photoCollectionView.frame = CGRectZero;
    }
    
    // 时间
    if (self.dynamic.Img.count > 0) {
        
        //XJH 布局紊乱问题
        self.timeStampLabel.frame = CGRectMake(self.photoCollectionView.x, CGRectGetMaxY(self.photoCollectionView.frame) + 12, 120, 18);
        
        
//        [self.timeStampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.richTextView);
//            make.height.mas_equalTo(18);
//            make.top.equalTo(self.photoCollectionView.mas_bottom).offset(12);
//        }];
    }else{
        //XJH 布局紊乱问题
        self.timeStampLabel.frame = CGRectMake(self.richTextView.x, CGRectGetMaxY(self.richTextView.frame) + 12, 120, 18);
        
//        [self.timeStampLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.equalTo(self.richTextView);
//            make.height.mas_equalTo(18);
//            make.top.equalTo(self.richTextView.mas_bottom).offset(12);
//        }];
    }
    
    
    // 删除按钮
    [self.deleteButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.timeStampLabel);
//        likeButton
         //XJH 布局紊乱问题
//        make.left.equalTo(self.timeStampLabel.mas_right).offset(12);
        make.right.equalTo(self.likeButton.mas_left).offset(-12);

        make.height.mas_equalTo(18);
    }];
    
    
    // 评论按钮
    [self.commentButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.deleteButton);
        make.height.mas_equalTo(18);
        make.right.equalTo(self).offset(-15);
    }];
    //    self.commentButton.frame = CGRectMake(ScreenWidth - 65, self.timeStampLabel.y, 50, 18);
    
    // 点赞按钮
    [self.likeButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.deleteButton);
        make.height.mas_equalTo(18);
        make.right.equalTo(self.commentButton.mas_left).offset(-10);
    }];
    //    self.likeButton.frame = CGRectMake(CGRectGetMaxY(self.commentButton.frame) - 50 , self.timeStampLabel.y, 50, 18);
    
    
    // 分割线
    [self.separateLine mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.timeStampLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(0.5);
    }];
    
    
    if (self.dynamic.CommentCount > 0 && self.dynamic.Comment.count>0) {
        self.commentListView.hidden = NO;
        // 评论
        [self.commentListView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bossNameLable);
            make.right.equalTo(self).offset(-15);
            make.top.equalTo(self.separateLine).offset(15);
            make.bottom.equalTo(self).offset(-15);
        }];
    }else{
        self.commentListView.hidden = YES;
    }
    
}


#pragma mark -  赋值
- (void)setDynamic:(BossDynamicEntity *)dynamic{
    
    if (!dynamic) {
        return;
    }
    
    _dynamic = dynamic;
    [self setNeedsLayout];
    self.commentsArray = dynamic.Comment;
    
    CompanyEntity* company = dynamic.Company;
    
    // 头像
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:company.CompanyLogo] placeholderImage:[UIImage imageNamed:@"默认头像"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        //开始对imageView进行画图
        UIGraphicsBeginImageContextWithOptions(_iconImageView.bounds.size, NO, [UIScreen mainScreen].scale);
        //使用贝塞尔曲线画出一个圆形图
        [[UIBezierPath bezierPathWithRoundedRect:_iconImageView.bounds cornerRadius:10] addClip];
        [_iconImageView drawRect:_iconImageView.bounds];
        
        _iconImageView.image = UIGraphicsGetImageFromCurrentImageContext();
        //结束画图
        UIGraphicsEndImageContext();
    }];
    
    // 公司名
    //    self.companyNameLabel.text = company.CompanyName;
    // 法人代表名称
    //    self.bossNameLable.text = [NSString stringWithFormat:@"法人代表:%@",company.LegalName];
    
    // 1/25更新：反过来了
    // 法人代表名称
    self.companyNameLabel.text = company.LegalName;
    // 公司名
    self.bossNameLable.text = [NSString stringWithFormat:@"%@",company.CompanyName];
    
    
    // 内容
    self.richTextView.attributedText = [[NSAttributedString alloc]initWithString:dynamic.Content];
    
    if (_dynamic.Img.count>0) {
        [self addSubview:self.photoCollectionView];
        // 照片
        JXPhotoCollectionViewFlowLayout* flowlayout = (JXPhotoCollectionViewFlowLayout*)self.photoCollectionView.collectionViewLayout;
        
        if (dynamic.Img.count == 1) {
            //        flowlayout.itemSize = CGSizeMake(3 * PhotoSize + 2* photoMargin,PhotoSize);
            flowlayout.itemSize = CGSizeMake(ScreenWidth*0.5,singleImageHeight);
            
        }else{
            flowlayout.itemSize = CGSizeMake(PhotoSize, PhotoSize);
        }
        [self.photoCollectionView reloadData];
        
    }else{
    
        [self.photoCollectionView removeFromSuperview];
    }
    
    // 时间
    //    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    //    dateFormatter.dateFormat = @"MM月dd日 HH:mm";
    //    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    //
    //    NSString *dateStr =  [dateFormatter stringFromDate:dynamic.CreatedTime];
    //    self.timeStampLabel.text = dateStr;
    self.timeStampLabel.text = [self distanceTimeWithBeforeTime:dynamic.CreatedTime];
    
    CompanyMembeEntity * companyEntity= [UserAuthentication GetMyInformation];
    
    // 删除按钮
    if (dynamic.PassportId == companyEntity.PassportId) {
        self.deleteButton.hidden = NO;
    }else{
        self.deleteButton.hidden = YES;
    }
    
    // 点赞按钮
    self.likeButton.selected = dynamic.IsLiked ? YES : NO;
    
    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",dynamic.LikedNum] forState:UIControlStateSelected] ;
    [self.likeButton setTitle:[NSString stringWithFormat:@"%ld",dynamic.LikedNum] forState:UIControlStateNormal] ;
    
    
    // 评论数
    if (dynamic.CommentCount >= 0) {
        [self.commentButton setTitle:[NSString stringWithFormat:@"%ld",dynamic.CommentCount] forState:UIControlStateNormal];
        [self.commentButton setTitle:[NSString stringWithFormat:@"%ld",dynamic.CommentCount] forState:UIControlStateHighlighted];
        
    }else{
        [self.commentButton setTitle:@"0" forState:UIControlStateNormal];
        [self.commentButton setTitle:@"0" forState:UIControlStateHighlighted];
    }
    
    // 分割线
    if (dynamic.CommentCount == 0 || dynamic.Comment.count == 0) {
        self.separateLine.hidden = YES;
    }else{
        self.separateLine.hidden = NO;
    }
    
    // 评论
    
    if (_dynamic.Comment.count>0 ) {
        [self addSubview:self.commentListView];
        [self.commentListView reloadData];
        
    }else{
        
        [self.commentListView removeFromSuperview];
    }
    
    
}



#pragma mark - collection Delegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self showImageViewerAtIndexPath:indexPath];
}

- (void)showImageViewerAtIndexPath:(NSIndexPath *)indexPath {
    
    //获取选中的cell
    JXPhotoCollectionViewCell *selectedCell = (JXPhotoCollectionViewCell *)[self.photoCollectionView cellForItemAtIndexPath:indexPath];
    
    NSMutableArray* cellPhotos = @[].mutableCopy;
    
    for (NSInteger i = 0;i < self.dynamic.Img.count; i++) {
        
        JXPhotoCollectionViewCell * cell = (JXPhotoCollectionViewCell*)[self.photoCollectionView cellForItemAtIndexPath:[NSIndexPath indexPathForItem:i inSection:0]];
        [cellPhotos addObject:cell.photoImageView];
    }
    
    XHImageViewer *imageViewer = [[XHImageViewer alloc] init];
    
    
    [imageViewer showWithImageViews:cellPhotos selectedView:selectedCell.photoImageView];
    
}

#pragma mark - collection Datasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    // 厉害了
    [self.photoCollectionView.collectionViewLayout invalidateLayout];

    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.dynamic.Img.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    JXPhotoCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseID forIndexPath:indexPath];
    if (self.dynamic.Img[indexPath.item]) {
        cell.photoImageUrl = _dynamic.Img[indexPath.item];
    }

    return cell;
}

#pragma mark - tableview delegate


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary* dict = self.commentsArray[indexPath.row];
    
    NSString * name = dict[@"CompanyAbbr"];
    //    Log(@"%@",name);
    
    NSString * comment = dict[@"Content"];
    //    Log(@"%@",comment);
    
    NSString* cellStr = [name stringByAppendingString:@"："];
    cellStr = [cellStr stringByAppendingString:comment];
    
    CGFloat cellHeight = [BossCircleDynamicView getCommentCellHeightWithText:cellStr];
    return cellHeight;
}


#pragma mark - tableview datasource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return  self.commentsArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * reuseId = @"commentCell";
    
    BossCircelCommentCell * cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    
    if (!cell) {
        cell = [[BossCircelCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
    }
    
    NSDictionary* dict = self.commentsArray[indexPath.row];
    
    NSString * name = dict[@"CompanyAbbr"];
    //    NSLog(@"%@",name);
    
    NSString * comment = dict[@"Content"];
    //    NSLog(@"%@",comment);
    
    NSString* cellStr = [name stringByAppendingString:@"："];
    cellStr = [cellStr stringByAppendingString:comment];
    
    
    [cell setName:name andComment:comment];
    
    //    cell.backgroundColor = [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1];
    
    return cell;
}

#pragma mark - lazy load

-(JXPhotoCollectionView *)photoCollectionView{
    
    if (!_photoCollectionView) {
        
        
        JXPhotoCollectionViewFlowLayout* flowlayout = [[JXPhotoCollectionViewFlowLayout alloc] init];
        
        // 设置图片大小
        flowlayout.itemSize = CGSizeMake(PhotoSize, PhotoSize);
        
        flowlayout.minimumInteritemSpacing = photoMargin;
        flowlayout.minimumLineSpacing = photoMargin;
        
        _photoCollectionView = [[JXPhotoCollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowlayout];
        
        _photoCollectionView.backgroundColor = self.backgroundColor;
        
        [_photoCollectionView registerClass:[JXPhotoCollectionViewCell class] forCellWithReuseIdentifier:reuseID];
        
        [_photoCollectionView setScrollsToTop:NO];
        
        _photoCollectionView.showsVerticalScrollIndicator = NO;
        _photoCollectionView.showsHorizontalScrollIndicator = NO;
        _photoCollectionView.delegate = self;
        _photoCollectionView.dataSource = self;
    }
    return _photoCollectionView;
    
    
}

- (UITableView *)commentListView{
    
    if (_commentListView == nil) {
        _commentListView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        //        _commentListView.backgroundColor = [UIColor orangeColor];
        _commentListView.backgroundColor = self.backgroundColor;
        _commentListView.delegate = self;
        _commentListView.dataSource = self;
        _commentListView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _commentListView.scrollEnabled = NO;
    
    }
    return _commentListView;
    
}

- (NSMutableArray *)cellHeightArray{
    
    if (_cellHeightArray == nil) {
        _cellHeightArray = [[NSMutableArray alloc] init];
    }
    return _cellHeightArray;
    
}

#pragma mark - 计算高度
// 视图总高度
+ (CGFloat)calculateCellHeightWithDynamic:(BossDynamicEntity *)dynamic{
    
    CGFloat viewHeight = 15;
    
    viewHeight += 8;
    
    // 名称
    viewHeight += companyNameHeight + 10 + bossNameHeight;
    viewHeight += 15;
    
    // 文字
    viewHeight += [self getRichTextHeightWithText:dynamic.Content];
    viewHeight += 15;
    
    // 照片
    if (dynamic.Img.count > 0) {
        if (dynamic.Img.count == 1) {
            viewHeight += singleImageHeight;
        }else{
            viewHeight += [self getPhotoCollectionViewHeightWithPhotos:dynamic.Img];
            
        }
        viewHeight += 15;
    }
    
    // 操作条
    viewHeight += 18;
    
    viewHeight += 15;
    
    // 评论
    for (NSDictionary* dict in dynamic.Comment) {
        
        NSString * name = dict[@"CompanyAbbr"];
        //        NSLog(@"%@",name);
        
        NSString * comment = dict[@"Content"];
        //        NSLog(@"%@",comment);
        
        NSString* cellStr = [name stringByAppendingString:@"："];
        cellStr = [cellStr stringByAppendingString:comment];
        
        CGFloat cellHeight = [self getCommentCellHeightWithText:cellStr];
        
        viewHeight += cellHeight;
        
    }
    
    // 底部间距
    if (dynamic.Comment.count>0) {
        viewHeight += 25;
    }else{
        viewHeight +=0;
    }
    
    return viewHeight;
}

// 计算评论cell行号
+ (CGFloat)getCommentCellHeightWithText:(NSString *)text{
    
    if (!text || !text.length)
        return 0;
    return [SETextView frameRectWithAttributtedString:[[NSAttributedString alloc] initWithString:text] constraintSize:CGSizeMake(ScreenWidth - 90, CGFLOAT_MAX) lineSpacing:0 font:[UIFont systemFontOfSize:13]].size.height;
}

// 计算文字行高
+ (CGFloat)getRichTextHeightWithText:(NSString *)text {
    if (!text || !text.length)
        return 0;
    return [SETextView frameRectWithAttributtedString:[[NSAttributedString alloc] initWithString:text] constraintSize:CGSizeMake(ScreenWidth - iconLength - 2 * iconMargin - 10, CGFLOAT_MAX) lineSpacing:0 font:[UIFont systemFontOfSize:contentFontSize]].size.height;
}

// 计算图片高度
+ (CGFloat)getPhotoCollectionViewHeightWithPhotos:(NSArray *)photos {
    // 上下间隔已经在frame上做了
    NSInteger row = (photos.count / 3 + (photos.count % 3 ? 1 : 0));
    return (row * PhotoSize + (row - 1) * photoMargin);
}


// 时间格式化
- (NSString *)distanceTimeWithBeforeTime:(NSDate *)date

{
    NSTimeInterval beTime = [date timeIntervalSince1970];
    
    NSTimeInterval now = [[NSDate date]timeIntervalSince1970];
    
    //    double distanceTime = now - beTime + 60 * 60 *8;
    double distanceTime = now - beTime;
    
    
    NSString * distanceStr;
    
    NSDate * beDate = [NSDate dateWithTimeIntervalSince1970:beTime];
    
    NSDateFormatter * df = self.dateFormatter;
    
    //    [df setDateFormat:@"HH:mm"];
    //
    //    NSString * timeStr = [df stringFromDate:beDate];
    //
    //    [df setDateFormat:@"dd"];
    //
    //    NSString * nowDay = [df stringFromDate:[NSDate date]];
    //
    //    NSString * lastDay = [df stringFromDate:beDate];
    
    if (distanceTime < 60) {//小于一分钟
        
        distanceStr = @"刚刚";
        
    }
    
    else if (distanceTime < 60*60) {//时间小于一个小时
        
        distanceStr = [NSString stringWithFormat:@"%ld分钟前",(long)distanceTime/60];
        
    }
    
    else if(distanceTime < 60*60*24){//时间小于一天
        
        distanceStr = [NSString stringWithFormat:@"%ld小时前",(long)distanceTime/3600];
        
    }
    
    //    else if(distanceTime< 24*60*60*2 && [nowDay integerValue] != [lastDay integerValue]){
    //
    //        if ([nowDay integerValue] - [lastDay integerValue] == 1 || ([lastDay integerValue] - [nowDay integerValue] > 10 && [nowDay integerValue] == 1)) {
    //
    //            distanceStr = [NSString stringWithFormat:@"昨天 %@",timeStr];
    //
    //        }
    //
    //        else{
    //
    //            [df setDateFormat:@"MM-dd HH:mm"];
    //
    //            distanceStr = [df stringFromDate:beDate];
    //
    //        }
    //
    //    }
    //
    //    else if(distanceTime < 24*60*60*365){
    //
    //        [df setDateFormat:@"MM-dd HH:mm"];
    //
    //        distanceStr = [df stringFromDate:beDate];
    //
    //    }
    
    else{
        
        [df setDateFormat:@"yyyy-MM-dd HH:mm"];
        
        distanceStr = [df stringFromDate:beDate];
        
    }
    
    return distanceStr;
    
}

- (NSDateFormatter *)dateFormatter{
    
    if (_dateFormatter == nil) {
        _dateFormatter = [[NSDateFormatter alloc] init];
        //        [_dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
        
    }
    return _dateFormatter;
}


@end
