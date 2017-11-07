//
//  CompanyAuditEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/7.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>
#import "CompanyInformationEntity.h"

@interface CompanyAuditEntity : JSONModel


@property (nonatomic,assign)long ApplyId;
@property (nonatomic,assign)long ApplicantId;
@property (nonatomic,assign)long CompanyId;

//驳回理由
@property (nonatomic,copy)NSString<Optional>* RejectReason;
@property (nonatomic,assign)int AuditStatus;
@property (nonatomic,copy)NSString<Optional>* MobilePhone;
//身份证号
@property (nonatomic,copy)NSString<Optional>* iDCard;
//营业执照
@property (nonatomic,copy)NSString<Optional>* Licence;
//验证码
@property (nonatomic,copy)NSString<Optional>* ValidationCode;
//身份证照片
@property (nonatomic,strong)NSArray<Optional>* Images;
@property (nonatomic,strong)CompanyInformationEntity* Company;


@end
/*
 
 
 CompanyName (string): ,
 CompanyId (integer, optional): ,
 PassportId (integer, optional): ,
 CompanyAbbr (string, optional): 公司简称 ,
 LegalName (string, optional): 法人姓名 ,
 Region (string, optional): 省市城市 ,
 CompanySize (string, optional): 企业规模 ,
 Industry (string, optional): 所属行业 ,
 CompanyLogo (string, optional): 企业LOGO ,
  (integer, optional): 认证状态，0未认证，1认证中，2已认证，9被拒绝 ,
 ContractStatus (string, optional): 合同状态 ,
 CreatedTime (string, optional): ,
 ModifiedTime (string, optional): ,
 RejectReason (string, optional):  ,
 (integer, optional): ,
 (integer, optional): ,
  (integer): 法人手机号 ,
 Licence (string):  ,
 Images (string):
 }
 */
