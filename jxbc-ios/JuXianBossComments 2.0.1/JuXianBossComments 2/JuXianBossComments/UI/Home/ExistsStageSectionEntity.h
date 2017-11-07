//
//  ExistsStageSectionEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ExistsStageSectionEntity : JSONModel

@property (nonatomic,copy)NSString<Optional> * StageYear;
@property (nonatomic,strong)NSArray<Optional> * StageSection;


@end

/*
 StageYear (string): 评价年份 ,
 StageSection (string, optional): 年份区间
 */
