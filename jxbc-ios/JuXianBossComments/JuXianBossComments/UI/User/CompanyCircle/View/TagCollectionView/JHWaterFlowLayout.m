//
//  JHWaterFlowLayout.m
//  JuXianBossComments
//
//  Created by juxian on 2017/4/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JHWaterFlowLayout.h"

@interface JHWaterFlowLayout()
@property(nonatomic,strong)NSMutableArray *originxArray;
@property(nonatomic,strong)NSMutableArray *originyArray;
@end

@implementation JHWaterFlowLayout

#pragma mark - 初始化属性
- (instancetype)init {
    self = [super init];
    if (self) {
        [self setupLayout];
        _originxArray = [NSMutableArray array];
        _originyArray = [NSMutableArray array];
    }
    return self;
}

- (void)setupLayout
{
    self.minimumInteritemSpacing = 5;//同一行不同cell间距
    self.minimumLineSpacing = 5;//行间距
//    self.headerReferenceSize = CGSizeMake(0, 50);//设置section header 固定高度，如果需要的话
    self.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    self.scrollDirection = UICollectionViewScrollDirectionVertical;
}

#pragma mark - 重写父类的方法，实现瀑布流布局
#pragma mark - 当尺寸有所变化时，重新刷新
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds {
    return NO;
}

- (void)prepareLayout {
    [super prepareLayout];
}

#pragma mark - 所有cell和view的布局属性
//sectionheader sectionfooter decorationview collectionviewcell的属性都会走这个方法
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    for(UICollectionViewLayoutAttributes *attrs in array){
        //类型判断
        if(attrs.representedElementCategory == UICollectionElementCategoryCell){
            UICollectionViewLayoutAttributes *theAttrs = [self layoutAttributesForItemAtIndexPath:attrs.indexPath];
            attrs.frame = theAttrs.frame;
        }
    }
    return array;
}

#pragma mark - 指定cell的布局属性
- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat x = self.sectionInset.left;
    //如果有sectionheader需要加上sectionheader高度
    CGFloat y = self.headerReferenceSize.height + self.sectionInset.top;
    //判断获得前一个cell的x和y
    NSInteger preRow = indexPath.row - 1;
    if(preRow >= 0){
        if(_originyArray.count > preRow){
            x = [_originxArray[preRow]floatValue];
            y = [_originyArray[preRow]floatValue];
        }
        NSIndexPath *preIndexPath = [NSIndexPath indexPathForItem:preRow inSection:indexPath.section];
        CGFloat preWidth = [self.delegate waterFlowLayout:self widthAtIndexPath:preIndexPath];
        x += preWidth + self.minimumInteritemSpacing;
    }
    
    CGFloat currentWidth = [self.delegate waterFlowLayout:self widthAtIndexPath:indexPath];
    //保证一个cell不超过最大宽度
    currentWidth = MIN(currentWidth, self.collectionView.frame.size.width - self.sectionInset.left - self.sectionInset.right);
    if(x + currentWidth > self.collectionView.frame.size.width - self.sectionInset.right){
        //超出范围，换行
        x = self.sectionInset.left;
        y += _rowHeight + self.minimumLineSpacing;
    }
    // 创建属性
    UICollectionViewLayoutAttributes *attrs = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attrs.frame = CGRectMake(x, y, currentWidth, _rowHeight);
    _originxArray[indexPath.row] = @(x);
    _originyArray[indexPath.row] = @(y);
    return attrs;
}

#pragma mark - CollectionView的滚动范围
- (CGSize)collectionViewContentSize
{
    CGFloat width = self.collectionView.frame.size.width;
    __block CGFloat maxY = 0;
    [_originyArray enumerateObjectsUsingBlock:^(NSNumber *number, NSUInteger idx, BOOL * _Nonnull stop) {
        CGFloat y = [number floatValue];
        if (y > maxY) {
            maxY = y;
        }
    }];
    return CGSizeMake(width, maxY + _rowHeight + self.sectionInset.bottom);
}

- (CGFloat)jhcalculateContentHeight:(NSArray *)tags
{
    CGFloat contentHeight = self.sectionInset.top + self.itemSize.height;
    
    CGFloat originX = self.sectionInset.left;
    CGFloat originY = self.sectionInset.top;
    
    for (NSInteger i = 0; i < tags.count; i++) {
        CGSize maxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width - self.sectionInset.left - self.sectionInset.right, self.itemSize.height);
        
        CGRect frame = [tags[i] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14.0f]} context:nil];
        
        CGSize itemSize = CGSizeMake(frame.size.width + 20.0f, self.itemSize.height);
        
        if ((originX + itemSize.width + self.sectionInset.right/2) > [UIScreen mainScreen].bounds.size.width) {
            originX = self.sectionInset.left;
            originY += itemSize.height + self.minimumLineSpacing;
            
            contentHeight += itemSize.height + self.minimumLineSpacing;
        }
        
        originX += itemSize.width + self.minimumInteritemSpacing;
    }
    
    contentHeight += self.sectionInset.bottom;
    
    return contentHeight;
}

@end
