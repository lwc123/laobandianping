//
//  JHPutVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"
typedef void(^dataBlock)(NSString *dataStr);
@interface JHPutVC : JXBasedViewController
@property (nonatomic,copy)NSString * textStr;
@property (nonatomic,strong)UITextField * jhTextField;
@property (nonatomic,strong)UIViewController * secondVC;
@property (nonatomic,copy)dataBlock block;
//修改部门
@property (nonatomic,strong)DepartmentsEntity * departmentsEntity;

@property (nonatomic,copy)NSString * nameStr;

@end
