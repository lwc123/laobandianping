//
//  JHWaterFlowLayout.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/12.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JHWaterFlowLayout;
@protocol JHWaterFlowLayoutDelegate <NSObject>

/**通过代理获得每个cell的宽度*/
- (CGFloat)waterFlowLayout:(JHWaterFlowLayout *)layout widthAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface JHWaterFlowLayout : UICollectionViewFlowLayout
@property (nonatomic,assign) id<JHWaterFlowLayoutDelegate> delegate;
@property(nonatomic,assign)CGFloat rowHeight;///< 固定行高

@end
