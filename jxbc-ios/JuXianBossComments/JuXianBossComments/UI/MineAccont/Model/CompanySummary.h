//
//  CompanySummary.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/17.
//  Copyright © 2016年 jinghan. All rights reserved.
//

//#import <JSONModel/JSONModel.h>
#import "CompanyModel.h"
#import "CompanyMembeEntity.h"
#import "WalletEntity.h"

@interface CompanySummary : CompanyModel


// 未读消息个数
@property (nonatomic,assign)long UnreadMessageNum;
// 企业审核中提示信息
@property (nonatomic,copy)NSString<Optional>*PromptInfo;

// 企业老板信息
@property (nonatomic,copy)CompanyMembeEntity<Optional>*BossInformation;//NSNull
// 我的身份信息
@property (nonatomic,copy)CompanyMembeEntity<Optional>*MyInformation;
// 钱包
@property (nonatomic,copy)WalletEntity<Optional>* Wallet;

// 城市 code
@property (nonatomic,copy)NSString<Optional>*Region;
//name
@property (nonatomic,copy)NSString<Optional>* RegionText;
// 法人姓名
@property (nonatomic,copy)NSString<Optional>*LegalName;
// 规模 code
@property (nonatomic,copy)NSString<Optional>*CompanySize;
//name
@property (nonatomic,copy)NSString<Optional>* CompanySizeText;
// 行业
@property (nonatomic,copy)NSString<Optional>*Industry;

//有无银行卡
@property (nonatomic,assign)BOOL ExistBankCard;
@property (nonatomic, assign) int myCompanys;

@end
/*
 CompanySummary {
 DimissionNum (int, optional): 离职档案人数 ,
 EmployedNum (int, optional): 在职档案人数 ,
 UnreadMessageNum (int, optional): 未读消息个数 ,
 PromptInfo (string, optional): 企业审核中提示信息 ,
 
 BossInformation (CompanyMember, optional): 企业老板信息 ,
 MyInformation (CompanyMember, optional): 我的身份信息 ,
 
 Wallet (Wallet, optional): 钱包 ,
 CompanyName (string): ,
 CompanyId (integer, optional): ,
 PassportId (integer, optional): ,
 CompanyAbbr (string, optional): 公司简称 
 ,
 LegalName (string, optional): 法人姓名 ,
 Region (string, optional): 省市城市 ,
 CompanySize (string, optional): 企业规模 ,
 
 Industry (string, optional): 所属行业 ,
 CompanyLogo (string, optional): 企业LOGO ,
 AuditStatus (integer, optional): 认证状态，1未认证，2认证中，3被驳回，4已认证 ,
 ContractStatus (string, optional): 合同状态 ,
 CreatedTime (string, optional): ,
 ModifiedTime (string, optional):
 }

 */
