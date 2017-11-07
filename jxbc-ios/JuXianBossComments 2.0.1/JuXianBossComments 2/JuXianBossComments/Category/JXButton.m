//
//  JXButton.m
//  JuXianTalentBank
//
//  Created by 万里 on 16/2/29.
//  Copyright © 2016年 Max. All rights reserved.
//

#import "JXButton.h"

@implementation JXButton
//对内部label的调整
- (CGRect)titleRectForContentRect:(CGRect)contentRect;
{
    
    if (self.imageLeft==YES) {
        CGFloat titleX = self.imageSize.width+self.leftGrap+5;
        CGFloat titleHeight = contentRect.size.height-self.top*2.0;
//        CGFloat titleY = self.topGrap+4;
        CGFloat titleY = (contentRect.size.height- titleHeight-1)/2;

        CGFloat titleWidth = self.size.width;
        return CGRectMake(titleX, titleY, titleWidth, titleHeight);
    }
    return [super titleRectForContentRect:contentRect];
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect;
{
    if (self.imageLeft==YES) {
        CGFloat imageX = self.leftGrap;
        CGFloat imageY = self.topGrap;
        CGFloat imageHeight = self.imageSize.height;
        CGFloat imageWidth  = self.imageSize.width;
        return CGRectMake(imageX, imageY, imageWidth, imageHeight);
    }
    return [super titleRectForContentRect:contentRect];
}



@end
