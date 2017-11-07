//
//  JXLRefreshHeader.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/4/8.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXLRefreshHeader.h"
@interface JXLRefreshHeader()
@property (nonatomic,strong)NSArray *images;
@property (nonatomic,assign)float timeInterval;
@end
@implementation JXLRefreshHeader
- (UIImageView*)loadImageView
{
    if (!_loadImageView) {
        
        _loadImageView = [[UIImageView alloc]init];
        [self addSubview:_loadImageView];
    }
    return _loadImageView;
}
- (UIImageView*)imageView
{
    if (!_imageView) {
#pragma mark -- 添加下来加载的头图片
        UIImage *image = [UIImage imageNamed:@"用良心点评您 的员工"];
        UIImageView * imageView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:_imageView=imageView];
    }
    return _imageView;
}
- (void)prepare
{
    [super prepare];
}
- (void)placeSubviews
{
    [super placeSubviews];
    
    self.mj_h = 62;
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(14);
        make.centerX.equalTo(self);
        make.height.mas_equalTo(14);
    }];
    
    [self.stateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.imageView.mas_bottom).offset(9);
        make.height.mas_equalTo(11);
    }];
    [self.loadImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.stateLabel);
        make.right.equalTo(self.stateLabel.mas_left).offset(-8);
        make.height.width.mas_equalTo(11);
    }];
    

//    self.mj_h = 80;
//    // mj_w--320
//    CGFloat loadCenterX = self.mj_w * 0.5+10;
//    CGFloat imageCenterX= self.mj_w * 0.5;
//    if (!self.stateLabel.hidden) {
//        loadCenterX -= 95;
//       
//    }
//    CGFloat imageCenterY = self.mj_h*0.25;
//    CGFloat loadCenterY = self.mj_h * 0.75;//刷新图片的y
//    CGPoint loadCenter = CGPointMake(loadCenterX, loadCenterY);
//    CGPoint imageCenter = CGPointMake(imageCenterX, imageCenterY);
//    if (self.imageView.constraints.count==0) {
//        self.imageView.size = self.imageView.image.size;
//        self.imageView.center = imageCenter;
//    }
//    // 加载视图视图设置旋转
//    if (self.loadImageView.constraints.count == 0) {
//        self.loadImageView.size = CGSizeMake(11, 11);
//        self.loadImageView.center = loadCenter;
//        
//    }
//    if (self.gifView.constraints.count) return;
//    
//    self.gifView.frame = self.bounds;
//    if (self.stateLabel.hidden && self.lastUpdatedTimeLabel.hidden) {
//        self.gifView.contentMode = UIViewContentModeCenter;
//    } else {
//        self.gifView.contentMode = UIViewContentModeRight;
//        self.gifView.mj_w = self.mj_w * 0.5 - 90;
//    }
    self.lastUpdatedTimeLabel.mj_h = 0;

}
#pragma mark - 公共方法
- (void)setImages:(NSArray *)images duration:(NSTimeInterval)duration forState:(MJRefreshState)state
{
    if (images == nil) return;
    self.images  = images;
    self.timeInterval = duration;
//    self.stateImages[@(state)] = images;
//    self.stateDurations[@(state)] = @(duration);
//
    /* 根据图片设置控件的高度 */
    UIImage *image = [images firstObject];
    if (image.size.height > self.mj_h) {
        self.mj_h = image.size.height;
    }
}

- (void)setImages:(NSArray *)images forState:(MJRefreshState)state
{
    [self setImages:images duration:images.count * 0.1 forState:state];
}

#pragma mark - 实现父类的方法
- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    NSArray *images = self.images;
    if (self.state != MJRefreshStateIdle || images.count == 0) return;
    // 停止动画
    [self.loadImageView stopAnimating];
    // 设置当前需要显示的图片
    NSUInteger index =  images.count * pullingPercent;
    if (index >= images.count) index = images.count - 1;
    self.loadImageView.image = images[0];
}

- (void)setState:(MJRefreshState)state
{
    MJRefreshCheckState
    
    // 根据状态做事情
    // 根据状态做事情
    if (state == MJRefreshStatePulling || state == MJRefreshStateRefreshing) {
        NSArray *images = self.images;
        if (images.count == 0) return;
        
        [self.loadImageView stopAnimating];
        if (images.count == 1) { // 单张图片
            self.loadImageView.image = [images lastObject];
        } else { // 多张图片
            
            self.loadImageView.animationImages = images;
            self.loadImageView.animationDuration =  self.timeInterval;
            [self.loadImageView startAnimating];
        }
    } else if (state == MJRefreshStateIdle) {
        [self.loadImageView stopAnimating];
    }
}

@end
