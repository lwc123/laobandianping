//
//  IWComposePhotoView.h
//  WeiBo
//
//  Created by apple on 15/7/20.
//  Copyright (c) 2015年 icsast. All rights reserved.
//

#import <UIKit/UIKit.h>

//SC.XJH.12.4设置图片X号的点击代理
@protocol IWComposePhotoViewDelegate;
@interface IWComposePhotoView : UIImageView
@property (weak, nonatomic) id<IWComposePhotoViewDelegate> delegate;
@end
@protocol IWComposePhotoViewDelegate <NSObject>
@optional
- (void)deleteImage;
@end
