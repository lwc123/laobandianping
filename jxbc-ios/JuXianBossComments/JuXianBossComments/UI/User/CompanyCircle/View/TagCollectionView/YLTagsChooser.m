//
//  YLTagsChooser.m
//  YLTagsChooser
//
//  Created by TK-001289 on 16/6/13.
//  Copyright © 2016年 YL. All rights reserved.
//

#import "YLTagsChooser.h"
#import "NSArray+YLBoundsCheck.h"
#import "JHWaterFlowLayout.h"
#import "YLTagsCollectionViewCell.h"

#define HEXCOLOR(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 屏幕尺寸


static NSTimeInterval const kSheetAnimationDuration = 0.25;
static CGFloat const kBottomBtnHeight = 44.f;
static CGFloat const kBottomGap = 24.f;
static CGFloat const kYGap = 10.f;

@interface YLTagsChooser()<UICollectionViewDelegate,UICollectionViewDataSource,JHWaterFlowLayoutDelegate>
{
    
}
@property (nonatomic,strong) UIView            *bottomView;
@property (nonatomic,strong) UIButton          *ensureBtn;
@property (nonatomic,copy  ) NSArray           *orignalTags;
@property (nonatomic,strong) NSMutableArray    *selectedTags;

@end


@implementation YLTagsChooser
-(instancetype)initWithBottomHeight:(CGFloat)bHeight
                     maxSelectCount:(CGFloat)maxCount
                           delegate:(id<YLTagsChooserDelegate>)aDelegate
{
    if(self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)]){
        _orignalTags = [NSArray array];
        _selectedTags = [NSMutableArray array];
        self.alpha = 0.f;
        self.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:0.5];
        
        self.bottomHeight = bHeight;
        self.maxSelectCount = maxCount;
        self.delegate = aDelegate;
        
        [self.bottomView addSubview:self.ensureBtn];
        [self addSubview:self.bottomView];
        [self addSubview:self.myCollectionView];

    }
    return self;
}

-(void)refreshWithTags:(NSArray *)tags
{
    self.orignalTags = tags;
    [_selectedTags removeAllObjects];
    [self.myCollectionView reloadData];
}

-(UIView *)bottomView
{
    if(!_bottomView){
        _bottomView = [[UIView alloc]init];
        _bottomView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _bottomView.frame = CGRectMake(0, SCREEN_WIDTH, SCREEN_HEIGHT, _bottomHeight);
    }
    return _bottomView;
}

-(UICollectionView *)myCollectionView
{
    if(!_myCollectionView){
        JHWaterFlowLayout *layout = [[JHWaterFlowLayout alloc]init];
        layout.rowHeight = 28.f;
        layout.delegate = self;
        
        _myCollectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kYGap, SCREEN_WIDTH, _bottomHeight - 2 * kYGap - kBottomGap - kBottomBtnHeight)
                                              collectionViewLayout:layout];
        
        _myCollectionView.backgroundColor = [UIColor clearColor];
        [_myCollectionView registerClass:[YLTagsCollectionViewCell class] forCellWithReuseIdentifier:@"YLTagsCollectionViewCell"];
        
        _myCollectionView.delegate = self;
        _myCollectionView.dataSource = self;
    }
    return _myCollectionView;
}

-(UIButton *)ensureBtn
{
    if(!_ensureBtn){
        _ensureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _ensureBtn.backgroundColor = HEXCOLOR(0x25c5b6);
        _ensureBtn.layer.cornerRadius = 5;
        _ensureBtn.layer.masksToBounds = YES;
        _ensureBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        [_ensureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_ensureBtn setTitleColor:[[UIColor whiteColor]colorWithAlphaComponent:0.6] forState:UIControlStateHighlighted];
        [_ensureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [_ensureBtn addTarget:self action:@selector(ensureAction) forControlEvents:UIControlEventTouchUpInside];
        _ensureBtn.frame = CGRectMake(10, _bottomHeight - kBottomGap - kBottomBtnHeight, SCREEN_WIDTH - 20, kBottomBtnHeight);
    }
    return _ensureBtn;
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
    cell.selected = [_selectedTags containsObject:str];
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
        if(_selectedTags.count >= _maxSelectCount){
            //提示用户
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                           message:[NSString stringWithFormat:@"最多选择%li个",(long)_maxSelectCount]
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
    if([_delegate respondsToSelector:@selector(tagsChooser:selectedTags:)]){
        [_delegate tagsChooser:self selectedTags:_selectedTags];
    }
    [collectionView reloadData];
}

#pragma mark---touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    UITouch *lastTouch = [touches anyObject];
    CGPoint point = [lastTouch locationInView:self];
    if(!CGRectContainsPoint(self.bottomView.frame, point)){
        [self dismiss];
    }
}

#pragma mark---animation method
- (void)showInView:(UIView *)view
{
    [view addSubview:self];
    
    CGRect frame = self.bottomView.frame;
    frame.origin.y = SCREEN_HEIGHT - _bottomHeight;
    [UIView animateWithDuration:kSheetAnimationDuration
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bottomView.frame = frame;
                         self.alpha = 1.f;
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)dismiss
{
    CGRect frame = self.bottomView.frame;
    frame.origin.y = SCREEN_WIDTH;
    [UIView animateWithDuration:kSheetAnimationDuration
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.bottomView.frame = frame;
                         self.alpha = 0;
                     } completion:^(BOOL finished) {
                         [self removeFromSuperview];
                     }];
}


#pragma mark---other methods
-(void)ensureAction
{
    if([_delegate respondsToSelector:@selector(tagsChooser:selectedTags:)]){
        [_delegate tagsChooser:self selectedTags:_selectedTags];
    }
    [self dismiss];
}

@end

