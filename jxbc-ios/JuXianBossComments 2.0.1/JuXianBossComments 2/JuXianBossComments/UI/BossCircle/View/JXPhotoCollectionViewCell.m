//
//  JXPhotoCollectionViewCell.m
//  JuXianBossComments
//
//  Created by Jam on 16/12/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXPhotoCollectionViewCell.h"

@interface JXPhotoCollectionViewCell ()


@end

@implementation JXPhotoCollectionViewCell

- (void)setPhotoImageUrl:(NSString *)photoImageUrl{
    if (!photoImageUrl) {
        return;
    }
    _photoImageUrl = photoImageUrl;
    _photoImageView.frame = self.bounds;

    [self.photoImageView sd_setImageWithURL:[NSURL URLWithString:_photoImageUrl] placeholderImage:[UIImage imageNamed:@"加载图片"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (self.bounds.size.height != self.bounds.size.width) {
            self.photoImageView.frame = self.bounds;
            CGFloat width = image.size.width*self.bounds.size.height/image.size.height;
            
            if (width>40) {
                _photoImageView.frame = CGRectMake(0, 0, width, self.bounds.size.height);
            }else{
                _photoImageView.frame = CGRectMake(0, 0, 40, self.bounds.size.height);
            }
            
        }
    }];
    
}

#pragma mark - Life Cycle

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self.contentView addSubview:self.photoImageView];
    }
    return self;
}

- (UIImageView *)photoImageView{
    
    if (!_photoImageView) {
        _photoImageView = [[UIImageView alloc]init];
        _photoImageView.width = self.bounds.size.height;
        _photoImageView.height = _photoImageView.width;
        _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
        _photoImageView.clipsToBounds = YES;
        [_photoImageView setContentScaleFactor:[[UIScreen mainScreen] scale]];
        
    }
    
    return _photoImageView;
}

@end
