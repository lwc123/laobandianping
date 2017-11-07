//
//  JCTagListView.m
//  JCTagListView
//
//  Created by 李京城 on 15/7/3.
//  Copyright (c) 2015年 李京城. All rights reserved.
//

#import "JCTagListView.h"
#import "JCTagCell.h"
#import "JCCollectionViewTagFlowLayout.h"


@interface JCTagListView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) JCTagListViewBlock selectedBlock;

@end

@implementation JCTagListView

static NSString * const reuseIdentifier = @"tagListViewItemId";

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    
    return self;
}

- (instancetype)initWithBorderWidth:(CGFloat)borderWidth {

    
    if (self = [super init]) {
        _borderWidth = borderWidth;
        [self setup];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self setup];
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)setup
{
    _selectedTags = [NSMutableArray array];
    _tags = [NSMutableArray array];
    
    _tagStrokeColor = [UIColor lightGrayColor];
    _tagBackgroundColor = [UIColor clearColor];
    _tagTextColor = [UIColor darkGrayColor];
    _tagSelectedTextColor = [UIColor darkGrayColor];
    //默认
    _cellTitleBackgroudColor = [UIColor colorWithRed:246.0f/255.0f green:243.0f/255.0f blue:234.0f/255.0f alpha:0.1];
    _tagSelectedBackgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
    
    _tagTextFont = [UIFont systemFontOfSize:14.0];
    
    _tagCornerRadius = 10.0f;
    
    JCCollectionViewTagFlowLayout *layout = [[JCCollectionViewTagFlowLayout alloc] init];
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.scrollEnabled = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    
    [_collectionView registerClass:[JCTagCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self addSubview:_collectionView];
}

- (void)setCompletionBlockWithSelected:(JCTagListViewBlock)completionBlock
{
    self.selectedBlock = completionBlock;
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)collectionView.collectionViewLayout;
    
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right + 10, layout.itemSize.height);
    
    CGRect frame = [self.tags[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.tagTextFont} context:nil];
    return CGSizeMake(frame.size.width + 30.0f, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    JCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:243.0f/255.0f blue:234.0f/255.0f alpha:0.1];
    cell.titleLabel.text = self.tags[indexPath.item];
    cell.titleLabel.textColor = self.tagTextColor;
    cell.titleLabel.font = self.tagTextFont;
    cell.titleLabel.layer.borderWidth = self.borderWidth;
    cell.titleLabel.layer.borderColor = self.borderColor.CGColor;
    cell.titleLabel.layer.cornerRadius = self.tagCornerRadius;
    cell.titleLabel.backgroundColor = self.cellTitleBackgroudColor;
//    self.view
    
    if ([cell.titleLabel.text isEqualToString:@"+      "]) {
        cell.titleLabel.textColor =  [UIColor colorWithRed:218.0f/255.0f green:218.0f/255.0f blue:218.0f/255.0f alpha:1];
        cell.titleLabel.backgroundColor = [UIColor whiteColor];
        cell.titleLabel.font = [UIFont systemFontOfSize:19];
    }
    
    if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
        cell.backgroundColor = self.tagSelectedBackgroundColor;
        cell.titleLabel.textColor = self.tagSelectedTextColor;
    }
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (self.canSelectTags) {
        JCTagCell *cell = (JCTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
            
            cell.backgroundColor = self.tagBackgroundColor;
            
            cell.titleLabel.textColor = self.tagTextColor;
            
            [self.selectedTags removeObject:self.tags[indexPath.item]];
        }
        else {
            cell.backgroundColor = self.tagSelectedBackgroundColor;
            cell.titleLabel.textColor = self.tagSelectedTextColor;
            
            [self.selectedTags addObject:self.tags[indexPath.item]];
        }
    }
    
    if (self.selectedBlock) {
        
        self.selectedBlock(indexPath.item);
    }
}
- (UIViewController*)viewController
{
    UIResponder *next = self;
    do {
        next = next.nextResponder;
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController*)next;
        }
    } while (next!=nil);
    return nil;
}
@end
