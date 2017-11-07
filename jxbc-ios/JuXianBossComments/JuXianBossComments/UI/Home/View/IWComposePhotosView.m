//
//  IWComposePhotosView.m
//  WeiBo
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 icsast. All rights reserved.
//

//一排最多imageView的数量
#define MAXCOL 4
//每一张图片的间隔
#define MARGIN 10

#import "IWComposePhotosView.h"
#import "IWComposePhotoView.h"
#import "SDPhotoBrowser.h"

@interface IWComposePhotosView ()<SDPhotoBrowserDelegate>

@end

@implementation IWComposePhotosView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    
    return self;
}


- (NSArray *)photos{
    NSMutableArray *array = [self.subviews valueForKeyPath:@"image"];
    
    //    NSMutableArray *array = [NSMutableArray array];
    //    for (int i = 0; i < self.subviews.count; ++i) {
    //        UIImageView *imageView = [self.subviews objectAtIndex:i];
    //        [array addObject:imageView.image];
    //    }
    //SC.XJH.12.6给imageView加tag，供后面点击能获取到拿到的是哪一个图片
    int tag = 0;
    for (int i = 0; i < self.subviews.count; ++i) {
        if ([self.subviews[i] isKindOfClass:NSClassFromString(@"IWComposePhotoView")]) {
            UIView *view = self.subviews[i];
            view.tag = tag++;
        }
    }
    
    return [array copy];
}


//SC.XJH.12.20添加传url设置图片的方法
- (void)addPhoto:(UIImage *)photo imageUrl:(NSString *)imageUrl{
    
    if (imageUrl.length>0) {
        IWComposePhotoView *imageView = [[IWComposePhotoView alloc] init];
        self.imageView = imageView;
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:LOADing_Image];//注意，这地方一定要设置占位图片
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
    }else if (photo){
        IWComposePhotoView *imageView = [[IWComposePhotoView alloc] init];
        self.imageView = imageView;
        imageView.image = photo;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
        [imageView addGestureRecognizer:tap];
        [self addSubview:imageView];
    }
}

- (void)addPhoto:(UIImage *)photo{
    //初始化一个imageView
    IWComposePhotoView *imageView = [[IWComposePhotoView alloc] init];
    //SC.XJH.12.4将imageView用self暴露出去
    self.imageView = imageView;
    imageView.image = photo;
    
    //SC.XJH.12.6添加触摸手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImageView:)];
    [imageView addGestureRecognizer:tap];
    [self addSubview:imageView];
}
//SC.XJH.12.6点击展示图片
- (void)tapImageView:(UITapGestureRecognizer *)tap
{
    UIView *imageView = tap.view;
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    browser.currentImageIndex = imageView.tag;
    browser.sourceImagesContainerView = self;
    browser.imageCount = self.photos.count;
    browser.delegate = self;
    [browser show];
}
//SC.XJH.12.6展示图片代理方法
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    return self.photos[index];
}
- (void)layoutSubviews{
    [super layoutSubviews];
    //在以下代码设置UIImageView的宽高位置
    //计算每一个子控件的宽高
    //    CGFloat childViewWH = (self.width-(MAXCOL-1)*MARGIN)/MAXCOL;
    CGFloat childViewWH = 72;
    for (int i = 0; i < self.subviews.count; ++i) {
        UIView *childView = self.subviews[i];
        childView.size = CGSizeMake(childViewWH, childViewWH);
        
        //计算当前是第几列
        NSInteger col = i % MAXCOL;
        NSInteger row = i / MAXCOL;
        
        CGFloat childViewX = col * (childViewWH + MARGIN) + 0;
        CGFloat childViewY = row * (childViewWH + MARGIN);
        
        if (childView.x==0 && childView.y == 0) {
            childView.x = childViewX+10;
            childView.y = childViewY;
        }else{
            //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1*i * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:0.25 animations:^{
                childView.x = childViewX+10;
                childView.y = childViewY;
            }];
            //            });
        }
    }
}

@end
