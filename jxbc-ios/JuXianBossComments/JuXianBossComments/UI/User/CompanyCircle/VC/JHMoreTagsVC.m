//
//  JHMoreTagsVC.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHMoreTagsVC.h"
#import "YLTagsChooser.h"
#import "NSArray+YLBoundsCheck.h"
#import "JHWaterFlowLayout.h"
#import "InputmaskView.h"
#import "YLTagsCollectionViewCell.h"

#define Count 5
static CGFloat const kBottomBtnHeight = 44.f;
static CGFloat const kBottomGap = 24.f;
static CGFloat const kYGap = 10.f;
@interface JHMoreTagsVC ()<JHWaterFlowLayoutDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong)  InputmaskView *maskView;
@end

@implementation JHMoreTagsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"请选择标签";
    [self isShowLeftButton:YES];
    [self isShowRightButton:YES with:@"+"];
    [self initUI];

}

- (NSMutableArray *)selectedTags{
    if (_selectedTags == nil) {
        _selectedTags = [@[@"篮球",
                           @"足球",
                           @"羽毛球",
                           @"乒乓球",
                           @"排球",
                           ] mutableCopy];
    }
    return _selectedTags;
}

- (void)rightButtonAction:(UIButton *)button{
    //弹框
    [UIView animateWithDuration:.35 animations:^{
        self.maskView.hidden = NO;
    }];
    
}

-(UICollectionView *)myCollectionView
{
    if(!_myCollectionView){
        
        JHWaterFlowLayout *layout = [[JHWaterFlowLayout alloc]init];
        layout.rowHeight = 28.f;
        layout.delegate = self;
        
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kYGap, SCREEN_WIDTH, 400 - 2 * kYGap - kBottomGap - kBottomBtnHeight)
                                              collectionViewLayout:layout];
        _myCollectionView.backgroundColor = [UIColor clearColor];
        [_myCollectionView registerClass:[YLTagsCollectionViewCell class] forCellWithReuseIdentifier:@"YLTagsCollectionViewCell"];
        
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
    }
    return _myCollectionView;
}


- (InputmaskView *)maskView{

    if (_maskView == nil) {
        _maskView = [[InputmaskView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
        _maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        _maskView.hidden = YES;
    }
    return _maskView;
}





- (void)initUI{
    [self.view addSubview:self.myCollectionView];

    
    _orignalTags = [NSMutableArray array];
    _orignalTags = [@[@"篮球",
                                  @"足球",
                                  @"羽毛球",
                                  @"乒乓球",
                                  @"排球",
                                  @"网球",
                                  @"高尔夫球",
                                  @"冰球",
                                  @"沙滩排球",
                                  @"棒球",
                                  @"垒球",
                                  @"藤球",
                                  @"毽球",
                                  @"台球",
                                  @"鞠蹴",
                                  @"板球",
                                  @"壁球",
                                  @"沙壶",
                                  @"克郎球",
                                  @"橄榄球",
                                  @"曲棍球",
                                  @"水球",
                                  @"马球",
                                  @"保龄球",
                                  @"健身球",
                                  @"门球",
                                  @"弹球",
                                  ]mutableCopy];
    
    
    //    [_selectedTags removeAllObjects];
    [self.myCollectionView reloadData];
    
//    [self refreshWithTags:testTags];
    [self.view addSubview:self.maskView];

}

-(void)refreshWithTags:(NSArray *)tags
{
    self.orignalTags = tags.mutableCopy;
    //    [_selectedTags removeAllObjects];
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
        if(_selectedTags.count >= Count){
            //提示用户
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:[NSString stringWithFormat:@"最多选择%li个",(long)Count]
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
