//
//  ShareModel.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/3/9.
//  Copyright © 2016年 Max. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareModel : NSObject
@property (nonatomic,strong)NSString *Brief;
@property (nonatomic,strong)NSString *ImgPath;
@property (nonatomic,strong)NSString *Content;
@property (nonatomic,assign)long shareID;
@property (nonatomic,strong)NSString *shareUrl;
@end
