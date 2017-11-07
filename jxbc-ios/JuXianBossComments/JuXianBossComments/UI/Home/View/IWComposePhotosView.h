//
//  IWComposePhotosView.h
//  WeiBo
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 icsast. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IWComposePhotoView.h"

@interface IWComposePhotosView : UIView

/**
 *  可以设置多张。也可以通过调用这个photos的get方法返回当前IWComposePhotosView里面显示的image
 */
@property (nonatomic, strong) NSArray *photos;

/**
 *  向里面添加一张photo
 *
 *  @param photo
 */
- (void)addPhoto:(UIImage *)photo;
- (void)addPhoto:(UIImage *)photo imageUrl:(NSString *)imageUrl;


//SC.XJH.12.4
@property (nonatomic, strong) IWComposePhotoView *imageView;

@end
