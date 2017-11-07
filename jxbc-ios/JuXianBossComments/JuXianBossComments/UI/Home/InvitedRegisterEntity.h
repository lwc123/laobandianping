//
//  InvitedRegisterEntity.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/30.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface InvitedRegisterEntity : JSONModel
/*
@property (nonatomic,strong)NSNumber<Optional> *InvitedId;
@property (nonatomic,strong)NSNumber<Optional> * CompanyId;
@property (nonatomic,strong)NSNumber<Optional> * PassportId;
*/
@property (nonatomic,assign)long  InvitedId;
@property (nonatomic,assign)long  CompanyId;
@property (nonatomic,assign)long  PassportId;


@property (nonatomic,copy)NSString<Optional>* InviterCode;
@property (nonatomic,copy)NSString<Optional>* InviteRegisterQrcode;

@property (nonatomic,copy)NSString<Optional>* InvitePremium;
@property (nonatomic,copy)NSString<Optional>* InviteRegisterUrl;
@property (nonatomic,strong)NSDate<Optional>* CreatedTime;
@property (nonatomic,strong)NSDate<Optional>* ModifiedTime;
@property (nonatomic,strong)NSDate<Optional>* ExpirationTime;

@end
/*
 InvitedRegister {
 InvitedId (integer, optional): ,
 CompanyId (integer, optional): 公司ID，个人不传 ,
 PassportId (integer): 用户ID ,
 InviterCode (string, optional): 邀请码 ,
 InviteRegisterQrcode (string, optional): 邀请二维码图片地址 ,
 InvitePremium (string, optional): 邀请企业奖金 ,
 InviteRegisterUrl (string, optional): 邀请链接URL ,
 ExpirationTime (string, optional): 过期时间 ,
 CreatedTime (string, optional): 添加时间 ,
 ModifiedTime (string, optional): 修改时间
 }
 */
