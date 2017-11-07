//
//  ResultEntity.h
//  JuXianBossComments
//
//  Created by juxian on 17/1/3.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface ResultEntity : JSONModel

@property (nonatomic,strong)NSString<Optional> *BizId;
@property (nonatomic,strong)NSString<Optional> *ErrorCode;
@property (nonatomic,strong)NSString<Optional> *ErrorMessage;
@property (nonatomic,strong)NSString<Optional> *JsonModel;
@property (nonatomic,assign)BOOL Success;

@end
