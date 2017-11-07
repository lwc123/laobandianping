//
//  SignInMemberPublic.h
//  JuXianBossComments
//
//  Created by juxian on 16/12/11.
//  Copyright © 2016年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SignInMemberPublic : NSObject
+ (instancetype)sharedInstance;
+ (void)SignInWithCompanyId:(long)companyId;
+ (void)SignInLoginWithAccount:(AnonymousAccount *) account;

+ (NSInteger)isApplePayWithBizSource:(NSString *)bizSource;

@end
