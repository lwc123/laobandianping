//
//  PrivatenessSummaryEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/26.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "PrivatenessServiceContract.h"
@interface PrivatenessSummaryEntity : JSONModel


@property (nonatomic,assign)long UnreadMessageNum;
@property (nonatomic,strong)PrivatenessServiceContract<Optional> * PrivatenessServiceContract;
@property (nonatomic,assign)BOOL ExistBankCard;
@property (nonatomic,assign) int myCompanys;

@end
/*
 UnreadMessageNum (integer, optional): 未读消息个数 ,
 PrivatenessServiceContract (PrivatenessServiceContract, optional): 个人开通服务合同信息
 */
