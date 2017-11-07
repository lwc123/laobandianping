

//
//  PaymentEngine.swift
//  JuXianBossComments
//
//  Created by juxian on 16/10/24.
//  Copyright © 2016年 jinghan. All rights reserved.
//

import Foundation



enum TradeMode : NSInteger {
    case Unknown = 0,Payoff,Payout
}

enum PayWay : NSInteger {
    case Unknown,Wallet,Alipay,Wechat
}

enum BizSource : NSInteger {
    case Unknown,BuyCareerService,SendGratuity,Wechat
}

typealias paymentCompletedEmptyCallback = (PaymentResult?) -> Void;

class PaymentEngine : NSObject {
    
    static let TradeMode_All = 0;
    static let TradeMode_Payoff = 1;
    static let TradeMode_Payout = 2;
    static let TradeMode_Action_Buy = 21;//消费记录
    static let TradeMode_Action_Withdraw = 22;//提现/提现退款

    
    static let TradeType_PersonalToPersonal = 1;
    static let TradeType_PersonalToOrganization = 2;
    static let TradeType_OrganizationToPersonal = 3;
    static let TradeType_OrganizationToOrganization = 4;

    
    static let PayWays_Wallet = "Wallet";
    static let PayWays_Alipay = "Alipay";
    static let PayWays_Wechat = "Wechat";
    static let PayWays_System = "System";
    static let PayWays_AppleIAP = "AppleIAP";

    
    //开通企业服务
    static let BizSources_OpenEnterpriseService = "OpenEnterpriseService";
    //查看雇员档案（评价 离职报告）
    static let BizSources_ReadEmployeArchive = "ReadEmployeArchive";
    //充值
    static let BizSources_Deposit = "Deposit";
    //个人开通服务
    static let BizSources_OpenPersonalService = "OpenPersonalService";
    //续费
    static let BizSources_RenewalEnterpriseService = "RenewalEnterpriseService";

    
    static var lastPaymentEntity : PaymentEntity? = nil;
    
    static var callback : paymentCompletedEmptyCallback = PaymentEngine.paymentCompletedEmptyAction;
    
    class func paymentCompletedEmptyAction(result:PaymentResult?) { }
    
    class func onPaymentCompletedCallback(result:PaymentResult?, paymentCompletedEmptyCallback: (PaymentResult?) -> Void) {
        paymentCompletedEmptyCallback(result);
    }

}
