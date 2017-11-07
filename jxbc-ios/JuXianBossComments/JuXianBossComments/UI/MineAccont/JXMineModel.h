//
//  JXMineModel.h
//  JuXianTalentBank
//
//  Created by juxian on 16/8/22.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JXMineModel : NSObject

/**
 *  头部标题
 */
@property (nonatomic, copy) NSString *title;

/**
 *  这组的所有的文字
 */
@property (nonatomic, strong) NSArray *cellMessage;


/**
 *  这组的所有图片
 */
@property (nonatomic, strong) NSArray *cellImage;

@end
