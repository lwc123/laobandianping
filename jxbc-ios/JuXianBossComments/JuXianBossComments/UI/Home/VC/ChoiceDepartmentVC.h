//
//  ChoiceDepartmentVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/29.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"
typedef void(^saveBlock)(NSString * informationStr);

//选择部门
@interface ChoiceDepartmentVC : JXBasedViewController

@property (nonatomic,copy)saveBlock block;


@end
