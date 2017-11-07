//
//  TargetEmploye.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface TargetEmploye : JSONModel

@property (nonatomic,assign)double EmployeId;
@property (nonatomic,copy) NSString<Optional> * realName;
@property (nonatomic,copy) NSString<Optional> * idCard;
@property (nonatomic,strong) NSArray<Optional> * Tags;
@property (nonatomic,strong)NSDate<Optional>* CreatedTime;
@property (nonatomic,strong)NSDate<Optional>* ModifiedTime;
@property (nonatomic,strong) NSArray<Optional> * Comments;


@end
