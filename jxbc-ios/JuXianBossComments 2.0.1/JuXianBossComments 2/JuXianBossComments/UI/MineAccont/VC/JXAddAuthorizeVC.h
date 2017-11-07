//
//  JXAddAuthorizeVC.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/21.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXTableViewController.h"
typedef void(^authorizBlock)(NSString *authoriStr,NSString * passportId);

//添加新的授权人
@interface JXAddAuthorizeVC : JXTableViewController
@property (nonatomic,copy)NSString * textStr;
@property (nonatomic,copy)authorizBlock block;
@property (nonatomic,strong)UIViewController * secondVC;
@property (nonatomic,strong)CompanyMembeEntity *allreaddyCompany;


@end
