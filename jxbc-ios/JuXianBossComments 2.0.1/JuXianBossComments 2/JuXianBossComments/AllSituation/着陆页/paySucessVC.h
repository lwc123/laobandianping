//
//  paySucessVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"

//支付成功
@interface paySucessVC : JXBasedViewController

@property (nonatomic,assign)long companyId;
@property (nonatomic,copy)NSString * companyName;
@property (nonatomic,strong)UIViewController * secondVC;
@end
