//
//  UserCommentCompanyVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/10.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "UserCommentCompanyVC.h"
#import "UserCommentDetailVC.h"
#import "JXSupportView.h"
#import "JHMoreTagsVC.h"
#import "JHTextNumberView.h"
#import "TggStarEvaluationView.h"
#import "YLTagsChooser.h"
#import "NSArray+YLBoundsCheck.h"
#import "JHWaterFlowLayout.h"
#import "YLTagsCollectionViewCell.h"
#import "OpinionCompanyDetailVC.h"


@interface UserCommentCompanyVC ()<JXFooterViewDelegate,SupportViewDelegate,JHWaterFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) JXSupportView *supportView;

@property (nonatomic, strong) UILabel *tagLabel;
@property (nonatomic, strong) UIButton *moreTagsBtn;
@property (nonatomic, strong) JHTextNumberView *myTextView;
@property (strong ,nonatomic) TggStarEvaluationView *tggStarEvaView;
@property (nonatomic, strong) JXFooterView * footerView;
@property (nonatomic,strong) NSMutableArray    *selectedTags;
@property (nonatomic, strong) UIScrollView *myscrollView;
@property (nonatomic, strong) JHWaterFlowLayout *layout;
@property (nonatomic, assign) NSInteger tagCellHeight;
@property (nonatomic, strong) YLTagsChooser *tagsView;

@end

@implementation UserCommentCompanyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"添加点评";
    
    _selectedTags = [NSMutableArray array];
    [self isShowLeftButton:YES];
    [self initUI];
    
}


-(void)initUI{

    _orignalTags = [NSMutableArray array];

    [self.view addSubview:self.myscrollView];
    
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, SCREEN_WIDTH, 17)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [PublicUseMethod setColor:KColor_Text_BlackColor];
    label.text = @"公司名称";
    
     //星星
    // 注意weakSelf
    __weak __typeof(self)weakSelf = self;
    // 初始化
    self.tggStarEvaView = [TggStarEvaluationView evaluationViewWithChooseStarBlock:^(NSUInteger count) {
        
        [UIView animateWithDuration:.3 animations:^{
            weakSelf.supportView.hidden = NO;
            weakSelf.tagLabel.y = CGRectGetMaxY(weakSelf.supportView.frame) + 13;
            weakSelf.myCollectionView.y = CGRectGetMaxY(weakSelf.tagLabel.frame) +5;
            weakSelf.moreTagsBtn.y =  CGRectGetMaxY(weakSelf.myCollectionView.frame) + 10;

            weakSelf.myTextView.y = CGRectGetMaxY(weakSelf.moreTagsBtn.frame) + 20;
            weakSelf.footerView.y = CGRectGetMaxY(weakSelf.myTextView.frame)+ 25;

        }];
    }];
   
    self.tggStarEvaView.frame = CGRectMake((self.myscrollView.frame.size.width - 95) / 2, CGRectGetMaxY(label.frame) + 30, 95, 18);
    // 星星之间的间距，默认0.5
     self.tggStarEvaView.spacing = 0.1;
     self.tggStarEvaView.userInteractionEnabled = YES;
     self.tggStarEvaView.norImage = [UIImage imageNamed:@"commentgraystar"];
     self.tggStarEvaView.selImage = [UIImage imageNamed:@"commentewwlostar"];
    
    //标签
//    self.layout = [[JHWaterFlowLayout alloc]init];
//    self.layout.rowHeight = 28.f;
//    self.layout.delegate = self;
//    self.tagCellHeight = [self.layout jhcalculateContentHeight:self.orignalTags.copy];
//    self.tagsView = [[YLTagsChooser alloc] initWithBottomHeight:80 maxSelectCount:5 delegate:self];
//    self.tagsView.frame = CGRectMake(10, CGRectGetMaxY(self.tagLabel.frame) +5, SCREEN_WIDTH - 20, self.tagCellHeight);
//    
    
    [self.myscrollView addSubview:label];
    [self.myscrollView addSubview:self.tggStarEvaView];
    [self.myscrollView addSubview:self.supportView];
    [self.myscrollView addSubview:self.tagLabel];
    
    [self.myscrollView addSubview:self.myCollectionView];
    [self.myscrollView addSubview:self.moreTagsBtn];
    [self.myscrollView addSubview:self.myTextView];
    [self.myscrollView addSubview:self.footerView];
    

    _orignalTags = [@[@"羽毛球羽毛球",
                      @"弹球弹球弹球",
                      @"门球羽毛球球",
                      @"弹球弹球弹球",
                      @"弹球弹球弹球",
                      ]mutableCopy];
    [self.myCollectionView reloadData];

}


#pragma mark---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _orignalTags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"YLTagsCollectionViewCell";
    
    YLTagsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier
                                                                               forIndexPath:indexPath];
    NSString *str = [_orignalTags yl_objectAtIndex:indexPath.row];
    [cell.btn setTitle:str forState:UIControlStateNormal];
    cell.selected = [self.selectedTags containsObject:str];
    
    return cell;
}
#pragma mark---YLWaterFlowLayoutDelegate
- (CGFloat)waterFlowLayout:(JHWaterFlowLayout *)layout widthAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *str = [_orignalTags yl_objectAtIndex:indexPath.row];
    CGSize size = CGSizeMake(SCREEN_WIDTH - 20,CGFLOAT_MAX);
    
    CGRect textRect = [str
                       boundingRectWithSize:size
                       options:NSStringDrawingUsesLineFragmentOrigin
                       attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]}
                       context:nil];
    CGFloat width = textRect.size.width + 15;
    return width;
}

#pragma mark---UICollectionViewDelegate
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *title = _orignalTags[indexPath.row];
    
    if(![_selectedTags containsObject:title]){
        if(_selectedTags.count >= 5){
            //提示用户
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:[NSString stringWithFormat:@"最多选择%li个",(long)5]
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil, nil];
            [alert show];
        }else{
            [_selectedTags addObject:title];
        }
    }else{
        [_selectedTags removeObject:title];
    }
    [collectionView reloadData];
}



- (JHTextNumberView *)myTextView{
    
    if (_myTextView == nil) {
        _myTextView = [[JHTextNumberView alloc] initWithplacehoder:@"说说您对这家公司的评价吧，10个字以上" numbertaxt:@"500" textViewHeight:170];
        _myTextView.backgroundColor = [UIColor whiteColor];
        _myTextView.frame = CGRectMake(10, CGRectGetMaxY(self.moreTagsBtn.frame) + 21, SCREEN_WIDTH- 20, 190);
        _myTextView.layer.borderColor = [PublicUseMethod setColor:KColor_Text_ListColor].CGColor;
        _myTextView.layer.borderWidth = 0.2;
    }
    return _myTextView;
}

- (UIScrollView *)myscrollView{
    
    if (_myscrollView == nil) {
        _myscrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];;
        _myscrollView.scrollEnabled = YES;
        _myscrollView.userInteractionEnabled = YES;
        _myscrollView.contentSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT + 100);
        
    }
    return _myscrollView;
}

- (UILabel *)tagLabel{
    
    if (_tagLabel == nil) {
        _tagLabel = [UILabel labelWithFrame:CGRectMake(10, CGRectGetMaxY(self.tggStarEvaView.frame) + 17, SCREEN_WIDTH - 10, 14) title:@"请选择标签" titleColor:[PublicUseMethod setColor:KColor_Text_BlackColor] fontSize:14.0 numberOfLines:1];
        
    }
    return _tagLabel;
}

- (UIButton *)moreTagsBtn{
    
    if (_moreTagsBtn == nil) {
        _moreTagsBtn = [UIButton buttonWithFrame:CGRectMake(SCREEN_WIDTH - 10 - 80, CGRectGetMaxY(self.myCollectionView.frame) - 15, 80, 20) title:@"更多标签" fontSize:14.0 titleColor:[PublicUseMethod setColor:KColor_Text_BlueColor] imageName:nil bgImageName:nil];
        _moreTagsBtn.titleLabel.textAlignment = NSTextAlignmentRight;
        [_moreTagsBtn addTarget:self action:@selector(moreTagsBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _moreTagsBtn.backgroundColor = [UIColor yellowColor];
    }
    return _moreTagsBtn;
}

- (JXSupportView *)supportView{
    if (_supportView == nil) {
        _supportView = [JXSupportView supportView];
        _supportView.frame = CGRectMake(0, CGRectGetMaxY(_tggStarEvaView.frame)+ 10, SCREEN_WIDTH, 120);
        _supportView.delegate = self;
        _supportView.hidden = YES;
    }
    return _supportView;
}

-(UICollectionView *)myCollectionView
{
    if(!_myCollectionView){
        
        self.layout = [[JHWaterFlowLayout alloc]init];
        self.layout.rowHeight = 28.f;
        self.layout.delegate = self;
        self.tagCellHeight = [self.layout jhcalculateContentHeight:self.orignalTags.copy];

        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tagLabel.frame), SCREEN_WIDTH - 20, self.tagCellHeight + 10)
                                              collectionViewLayout:_layout];
        _myCollectionView.backgroundColor = [UIColor whiteColor];
        [_myCollectionView registerClass:[YLTagsCollectionViewCell class] forCellWithReuseIdentifier:@"YLTagsCollectionViewCell"];
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
    }
    return _myCollectionView;
}


- (JXFooterView *)footerView{

    if (_footerView == nil) {
        _footerView = [JXFooterView footerView];
        _footerView.frame = CGRectMake(10, CGRectGetMaxY(self.myTextView.frame)+ 25, SCREEN_WIDTH - 20, 44);
        _footerView.backgroundColor = [UIColor whiteColor];
        _footerView.delegate = self;
        _footerView.nextLabel.text = @"匿名点评";
    }
    return _footerView;
}


#pragma mark -- 是否推荐朋友 根据tag 值
- (void)supportViewDelegateRecommend:(JXSupportView *)supportView click:(UIButton *)button{

}
//支持
- (void)supportViewDelegateSupport:(JXSupportView *)supportView click:(UIButton *)button{

}
//看好
- (void)supportViewDelegateGood:(JXSupportView *)supportView click:(UIButton *)button{

}

#pragma mark -- 点评
- (void)jxFooterViewDidClickedNextBtn:(JXFooterView *)jxFooterView{

    [PublicUseMethod showAlertView:@"评价不能小于10个字"];

    if (self.myTextView.myTextView.text.length < 10) {
        [self alertWithTitle:@"温馨提示" String:@"评价不能小于10个字"];
        
        return;
    }
    
    if (self.myTextView.myTextView.text.length > 500) {
        [self alertWithTitle:@"温馨提示" String:@"评价不能大于500个字"];

        return;
    }
    
    
    
}

- (void)alertWithTitle:(NSString*)title String:(NSString*)string{
    
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title message:string preferredStyle:UIAlertControllerStyleAlert];
    NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:title];
    
    [hogan addAttribute:NSFontAttributeName
                  value:[UIFont systemFontOfSize:16]
                  range:[title rangeOfString:title]];
    [alert setValue:hogan forKey:@"attributedTitle"];
    [self presentViewController:alert animated:YES completion:nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [alert dismissViewControllerAnimated:YES completion:nil];
    });
}

#pragma mark -- 更多标签
- (void)moreTagsBtnClick{
    JHMoreTagsVC * moreTags = [[JHMoreTagsVC alloc] init];
    [self.navigationController pushViewController:moreTags animated:YES];
}

- (void)leftButtonAction:(UIButton *)button{
    
    if ([self.secondVC isKindOfClass:[UserCommentDetailVC class]] || [self.secondVC isKindOfClass:[OpinionCompanyDetailVC class]]) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
    
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
