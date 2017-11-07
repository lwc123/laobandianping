//
//  OpenAccountRequest.h
//  JuXianBossComments
//
//  Created by juxian on 16/10/27.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <JSONModel/JSONModel.h>

//此类是 开户申请的model
@interface OpenAccountRequest : JSONModel

/**
密码
 */
@property (nonatomic,copy)NSString<Optional> * Password;
/**
 企业名称
 */
@property (nonatomic,copy)NSString<Optional> * EntName;
/**
 法人代表
 */
@property (nonatomic,copy)NSString<Optional> * LegalRepresentative;
/**
 水印图片
 */
@property (nonatomic,strong)NSArray<Optional> * AttestationImages;



@end
