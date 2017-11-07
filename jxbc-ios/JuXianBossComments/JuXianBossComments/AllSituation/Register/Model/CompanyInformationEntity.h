//
//  CompanyInformationEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/7.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

//企业信息
@interface CompanyInformationEntity : JSONModel

@property (nonatomic,assign)long CompanyId;
@property (nonatomic,assign)long PassportId;
@property (nonatomic,copy)NSString<Optional>* CompanyName;
//公司简称
@property (nonatomic,copy)NSString<Optional>* CompanyAbbr;
//法人姓名
@property (nonatomic,copy)NSString<Optional>* LegalName;
//省市城市code
@property (nonatomic,copy)NSString<Optional>* Region;
//name
@property (nonatomic,copy)NSString<Optional>* RegionText;


//企业规模 code
@property (nonatomic,copy)NSString<Optional>* CompanySize;
//name
@property (nonatomic,copy)NSString<Optional>* CompanySizeText;


//所属行业
@property (nonatomic,copy)NSString<Optional>* Industry;
//企业LOGO
@property (nonatomic,copy)NSString<Optional>* CompanyLogo;
@property (nonatomic,assign)long AuditStatus;
//合同状态
@property (nonatomic,assign)long ContractStatus;
@property (nonatomic,strong)NSDate* CreatedTime;
@property (nonatomic,strong)NSDate* ModifiedTime;

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
 ModifiedTime (string, optional):
 */
