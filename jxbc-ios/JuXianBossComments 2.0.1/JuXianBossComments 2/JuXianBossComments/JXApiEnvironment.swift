//
//  JXApiEnvironment.swift
//  JuXianBossComments
//
//  Created by juxian on 16/10/11.
//  Copyright © 2016年 jinghan. All rights reserved.

import Foundation
class JXApiEnvironment : NSObject {
    
    
    //* / ************  本地配置 ************
    static let API_HOST_API = "http://bc-api.jux360.cn:8120/v-test";
    static let API_HOST_WEB = "http://bc.jux360.cn:8000";
    static let API_HOST_MOBILE = API_HOST_WEB + "/m";
    // */
    
     /* / ************  线上配置 ************
     static let API_HOST_API = "http://api.laobandianping.com:8120/v-test";
     static let API_HOST_WEB = "http://www.laobandianping.com";
     static let API_HOST_MOBILE = API_HOST_WEB + "/m";
     // */
    
     /* / ************  线上V1 配置 ************
     static let API_HOST_API = "http://api.laobandianping.com:8120/v1";
     static let API_HOST_WEB = "http://www.laobandianping.com";
     static let API_HOST_MOBILE = API_HOST_WEB + "/m";
     // */
    
    static let API_HOST_API_Appbase = API_HOST_API + "/appbase";
    static let API_HOST_API_Workplace = API_HOST_API + "/workplace"
    static let API_HOST_API_Apppage = API_HOST_API + "/apppage"
    
    
    static let TokenKey = "JX-TOKEN";
    static let DeviceKey = "JX-DEVICE";
    static let OnceLoadItemCount = 10;
    
    
    /************** 账号 **************/
    static let Account_CreateNew_Endpoint = API_HOST_API_Appbase + "/account/createNew";
    static let Account_SignInByToken_Endpoint = API_HOST_API_Appbase + "/account/signInByToken";
    static let Account_SignUp_Endpoint = API_HOST_API_Appbase + "/account/signUp";
    static let Account_SignIn_Endpoint = API_HOST_API_Appbase + "/account/signIn";
    static let Account_SignOut_Endpoint = API_HOST_API_Appbase + "/account/signOut";
    static let Account_BindThirdPassport_Endpoint = API_HOST_API_Appbase + "/account/bindThirdPassport";
    static let Account_ResetPassword_Endpoint = API_HOST_API_Appbase + "/account/ResetPassword";
    static let Account_ExistsMobilePhone_Endpoint = API_HOST_API_Appbase + "/account/existsMobilePhone?phone=%@";
    static let Account_SendValidationCode_Endpoint = API_HOST_API_Appbase + "/account/SendValidationCode?phone=%@";
    
    
    static let HotKeywords_CareerService_Endpoint = API_HOST_API_Appbase
        + "/Search/HotKeywords?biztype=1";
    
    static let Dictionary_Dictionaries_Endpoint = API_HOST_API_Appbase
        + "/dictionary/Dictionaries?codes=%@";
    
    /************** 充值记录 & 支付 **************/
    static let UserWallet_TradeHistory_Endpoint = API_HOST_API_Appbase + "/userWallet/TradeHistory?page=%d&size=%d";
    
    static let Payment_CreateTrade_Endpoint = API_HOST_API_Appbase + "/payment/CreateTrade";
    
    static let Payment_PaymentCompleted_Endpoint = API_HOST_API_Appbase + "/payment/PaymentCompleted";
    
    
    static let Page_ServiceContract_WithPay_Endpoint = API_HOST_API_Appbase + "/page/service_contract?oid=%@&from=pay";

    /**************  h5 **************/
    static let Page_CareerService_Share_Endpoint = API_HOST_API_Apppage + "/page/career_service?oid=%ld&jxl_from=share";
    
    
    //背景调查购买index
     static let Page_BackgroundSurvey_Endpoint = API_HOST_API_Apppage + "/BackgroundSurvey/BoughtPurchased?CompanyId=%ld&Page=%d&Size=%d";
    //背景调查搜索
    static let Page_BackgroundSearch_Endpoint = API_HOST_API_Apppage + "/BackgroundSurvey/index?CompanyId=%ld&Search=%d";
    
    //购买背景调查详情
    static let Page_BoughtDetailh_Endpoint = API_HOST_API_Apppage + "/BackgroundSurvey/BoughtDetail?CompanyId=%ld&RecordId=%@";

    //续费
    static let Page_RenewalEnterpriseService_Endpoint = API_HOST_API_Apppage + "/Company/RenewalEnterpriseService?CompanyId=%ld&os=%@&Version=%@";

    
    //个人端档案详情
    static let Page_UserSurveyDetail_Endpoint = API_HOST_API_Apppage + "/BackgroundSurvey/personal?ArchiveId=%ld";

    
    /**************修改授权人*************/
    static let CompanyMember_Update = API_HOST_API_Workplace + "/CompanyMember/update";
   //授权人列表
    static let CompanyMember_List = API_HOST_API_Workplace + "/CompanyMember/CompanyMemberListByCompany";
    
    //交易记录
    static let Organization_TradeHistory_Endpoint = API_HOST_API_Workplace + "/CompanyWallet/TradeHistory?CompanyId=%ld&mode=%d&page=%d&size=%d";
    
    //删除
    static let CompanyMember_Delegate_Endpoint = API_HOST_API_Workplace + "/CompanyMember/delete/%@";
    
    //角色说明
    static let Page_Role_Instruction = API_HOST_MOBILE + "/BossComments/RolePermission";


}
