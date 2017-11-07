//
//  ConsoleEntity.h
//  JuXianBossComments
//
//  Created by juxian on 2017/4/22.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ConsoleEntity : JSONModel
//我的点评总数
@property (nonatomic,assign)long OpinionTotal;
// 我的关注企业总数 
@property (nonatomic,assign)long ConcernedTotal;
//是否显示红点
@property (nonatomic,assign)BOOL IsRedDot;

@end
/*
 OpinionTotal (integer, optional): 我的点评总数 ,
 ConcernedTotal (string, optional): 我的关注企业总数 ,
 IsRedDot (boolean, optional): 是否显示红点
 
 */
