//
//  BossDynamicPublicImgCellCollectionViewCell.h
//  JuXianBossComments
//
//  Created by Jam on 16/12/28.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DeleteButtonClickBlock)();

#define KItemLength 86.25f
#define KItemSpace 10

@interface BossDynamicPublicImgCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView * photoView;

@property (nonatomic, strong) UIImage *image;

- (void)deleteButtonClickCompletion:(DeleteButtonClickBlock) deleteButtonClickBlock;

@end
