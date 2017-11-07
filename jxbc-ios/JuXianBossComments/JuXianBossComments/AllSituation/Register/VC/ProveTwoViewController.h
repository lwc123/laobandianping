//
//  ProveTwoViewController.h
//  JuXianBossComments
//
//  Created by juxian on 16/11/18.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import "JXBasedViewController.h"
#import "CompanyAuditEntity.h"

@interface ProveTwoViewController : JXBasedViewController
@property (nonatomic,strong)CompanyAuditEntity * companyAuditEntity;
@property (nonatomic,strong)CompanyInformationEntity * informationEntity
;
@property (nonatomic,copy)NSString * imageStr;
@property (nonatomic,assign)long companyId;
@property (nonatomic,strong)CompanyAuditEntity * fixAudit;

@end
