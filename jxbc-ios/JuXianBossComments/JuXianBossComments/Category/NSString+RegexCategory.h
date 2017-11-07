//
//  NSString+RegexCategory.h
//  JuXianBossComments
//
//  Created by Jam on 17/1/19.
//  Copyright © 2017年 jinghan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (RegexCategory)

//手机号分服务商
- (BOOL)isMobileNumberClassification;
//手机号有效性
- (BOOL)isMobileNumber;
//邮箱
- (BOOL)isEmailAddress;
//身份证号
- (BOOL) simpleVerifyIdentityCardNum;
//车牌
- (BOOL)isCarNumber;
//mac地址
- (BOOL)isMacAddress;
//url
- (BOOL)isValidUrl;
//汉字
- (BOOL)isValidChinese;
//邮编
- (BOOL)isValidPostalcode;
//税号
- (BOOL)isValidTaxNo;

// 最小长度
// 最大长度
// 是否包含汉字
// 首位不能是数字
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;
// 最小长度
// 最大长度
// 是否包含汉字
// 是否包含数字
// 是否包含字母
// 需要包含的字符
// 首位不能是数字
- (BOOL)isValidWithMinLenth:(NSInteger)minLenth
                   maxLenth:(NSInteger)maxLenth
             containChinese:(BOOL)containChinese
              containDigtal:(BOOL)containDigtal
              containLetter:(BOOL)containLetter
      containOtherCharacter:(NSString *)containOtherCharacter
        firstCannotBeDigtal:(BOOL)firstCannotBeDigtal;

#pragma mark - 算法相关
//精确的身份证号码有效性检测
+ (BOOL)accurateVerifyIDCardNumber:(NSString *)value;

/** 银行卡号有效性问题Luhn算法
 *  现行 16 位银联卡现行卡号开头 6 位是 622126～622925 之间的，7 到 15 位是银行自定义的，
 *  可能是发卡分行，发卡网点，发卡序号，第 16 位是校验码。
 *  16 位卡号校验位采用 Luhm 校验方法计算：
 *  1，将未带校验位的 15 位卡号从右依次编号 1 到 15，位于奇数位号上的数字乘以 2
 *  2，将奇位乘积的个十位全部相加，再加上所有偶数位上的数字
 *  3，将加法和加上校验位能被 10 整除。
 */
- (BOOL)bankCardluhmCheck;

//ip地址
- (BOOL)isIPAddress;

#pragma mark - 是否包含emoji表情
- (BOOL)isContainsEmoji;

@end
