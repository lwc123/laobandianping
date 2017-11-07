//
//  OpenEnterpriseRequest.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/3.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface OpenEnterpriseRequest : JSONModel

@property (nonatomic,copy)NSString *CompanyName;
@property (nonatomic,copy)NSString *RealName;
@property (nonatomic,copy)NSString *JobTitle;
@end
