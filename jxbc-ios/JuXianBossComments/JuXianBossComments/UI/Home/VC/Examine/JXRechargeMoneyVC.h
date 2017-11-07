//
//  JXRechargeMoneyVC.h
//  JuXianBossComments
//
//  Created by juxian on 2017/2/24.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"
#import <StoreKit/StoreKit.h>

//充值
@interface JXRechargeMoneyVC : JXTableViewController{
    int buyType;
}
@property (nonatomic,strong)PaymentEntity *bhentity;
@property (nonatomic,strong)PaymentEntity *goldMonwyentity;

@property (nonatomic, strong) UIViewController *jhsecond;

@end
