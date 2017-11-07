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

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width


@interface JCTagListView ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, copy) JCTagListViewBlock selectedBlock;
@property (nonatomic,strong)JCCollectionViewTagFlowLayout *layout;
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
    _tagSelectedBackgroundColor = [UIColor colorWithRed:217/255.0f green:217/255.0f blue:217/255.0f alpha:1];
    _tagLastStrokeColor = [self setColor:@"e96e4d"];
    _tagLastTextColor = [self setColor:@"e96e4d"];
    _tagCornerRadius = 12.5f;
    
    _layout = [[JCCollectionViewTagFlowLayout alloc] init];
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:_layout];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.backgroundColor = [UIColor clearColor];
    [_collectionView registerClass:[JCTagCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self addSubview:_collectionView];
}
-(UIColor *) setColor:( NSString *)hexColor
{
    unsigned int red, green, blue;
    NSRange range;
    range.length = 2 ;
    range.location = 0 ;
    [[NSScanner scannerWithString:[hexColor substringWithRange :range]] scanHexInt :&red];
    
    range.location = 2 ;
    [[ NSScanner scannerWithString :[hexColor substringWithRange :range]] scanHexInt :&green];
    
    range.location = 4 ;
    [[ NSScanner scannerWithString:[hexColor substringWithRange :range]] scanHexInt :&blue];
    //NSLog(@"red  %d   green  %d  blue   %d",red,green,blue);
    return [UIColor colorWithRed :(float)(red/255.0f) green :(float)(green/ 255.0f ) blue:(float)(blue/255.0f ) alpha : 1.0f ];
}

- (void)setCompletionBlockWithSelected:(JCTagListViewBlock)completionBlock
{
    self.selectedBlock = completionBlock;
}

#pragma mark - UICollectionViewDelegate | UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    NSLog(@"%ld",self.tags.count);
    return self.tags.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"%ld",indexPath.row);
    JCCollectionViewTagFlowLayout *layout = (JCCollectionViewTagFlowLayout *)collectionView.collectionViewLayout;
    CGSize maxSize = CGSizeMake(collectionView.frame.size.width - layout.sectionInset.left - layout.sectionInset.right, layout.itemSize.height);
    
    CGRect frame = [self.tags[indexPath.item] boundingRectWithSize:maxSize options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:15.0f]} context:nil];
    
    CGFloat sizeHeight = MIN(frame.size.width + 25.0f+15,ScreenWidth-30);
    return CGSizeMake(sizeHeight, layout.itemSize.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    JCTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.layer.borderWidth = self.tagstrokeWith;
    cell.backgroundColor = self.tagBackgroundColor;
    cell.layer.borderColor = self.tagStrokeColor.CGColor;
    cell.layer.cornerRadius = self.tagCornerRadius;
    cell.titleLabel.text = self.tags[indexPath.item];
    cell.titleLabel.textColor = self.tagTextColor;
    
    [cell setNeedsLayout];
    if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
        cell.backgroundColor = self.tagSelectedBackgroundColor;
    }
    if (self.tags) {
        if (indexPath.item==self.tags.count-1) {
            //最后一个
            cell.titleLabel.textColor = self.tagLastTextColor;
            cell.layer.borderColor = self.tagLastStrokeColor.CGColor;
            if (self.taglastFont) {
               cell.titleLabel.font = self.taglastFont;
            }else
            {
                cell.titleLabel.font = [UIFont systemFontOfSize:15];
            }
            cell.imgView.hidden = YES;
            cell.titleLabel.textAlignment = 1;
        }else{
            cell.imgView.hidden = NO;
            cell.titleLabel.textAlignment = 0;

        }
        
//        for (UIView *view in cell.contentView.subviews) {
//
//            if ([view isKindOfClass:[UIButton class]]) {
//
//                [(UIButton *)view removeFromSuperview];
//            }
//        }
//        if (self.tags.count>1 && indexPath.item!=self.tags.count-1){
//        
//            UIImage *img = [UIImage imageNamed:@"shanchu"];
//            CGRect frame = self.frame;
//            UIButton *bt = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, frame.size.width+img.size.width, frame.size.height)];
//
//            bt.userInteractionEnabled = NO;
//            bt.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
//            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width-img.size.width, 0, img.size.width, img.size.height)];
//            imgView.backgroundColor = [UIColor redColor];
//            imgView.image = img;
//            [bt addSubview:imgView];
//
//            
//            [cell.contentView addSubview:bt];
//        
//        }
    }

    
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.canSelectTags) {
        JCTagCell *cell = (JCTagCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        if ([self.selectedTags containsObject:self.tags[indexPath.item]]) {
            cell.backgroundColor = self.tagBackgroundColor;
            
            [self.selectedTags removeObject:self.tags[indexPath.item]];
        }
        else {
            cell.backgroundColor = self.tagSelectedBackgroundColor;
            
            [self.selectedTags addObject:self.tags[indexPath.item]];
        }
    }

    if (self.selectedBlock) {
        self.selectedBlock(indexPath.item);
    }
    
    
    

    
}

@end
