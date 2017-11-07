//
//  BuyReportVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/20.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"
#import "PayModel.h"
#import "JXAPIS.h"
#import "CareerAdviceEntity.h"
#import "PaymentEntity.h"

//购买背景调查
@interface BuyReportVC : JXTableViewController
@property (nonatomic,strong)CareerServiceEntity *serviceModel;

@property (nonatomic,strong)PayModel *payModel;//保证外部访问
@property (nonatomic,strong)PaymentEntity *entity;
@property (nonatomic,copy)NSString * explainStr;
@property (nonatomic,strong)UITableView *myTableView;
@property (nonatomic,copy)NSString * companyName;

@end
