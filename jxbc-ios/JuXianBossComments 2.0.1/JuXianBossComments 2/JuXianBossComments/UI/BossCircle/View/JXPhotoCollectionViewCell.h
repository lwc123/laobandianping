//
//  JXPhotoCollectionViewCell.h
//  JuXianBossComments
//
//  Created by Jam on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JXPhotoCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *photoImageView;

// 图片地址
@property (nonatomic, strong) NSString *photoImageUrl;

@property (nonatomic, strong) NSIndexPath *indexPath;

@end
