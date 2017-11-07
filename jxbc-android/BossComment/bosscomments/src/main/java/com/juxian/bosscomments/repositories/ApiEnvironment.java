package com.juxian.bosscomments.repositories;

import net.juxian.appgenome.LogManager;

/**
 * @author 付晓龙
 * @ClassName: ApiEnvironment
 * @说明:
 * @date 2016-4-12 下午5:00:24
 */

public class ApiEnvironment {
    public static final String TAG = LogManager.Default_Tag + ":WebApi";

    //     线下环境
    public static final String API_HOST_WEB = "http://bc.jux360.cn:8000";
    public static final String API_HOST_MOBILE = String.format("%s/m", API_HOST_WEB);

    public static final String API_HOST_API = "http://bc-api.jux360.cn:8120/v-test";
    public static final String API_HOST_API_AppBase = String.format("%s/appbase", API_HOST_API);
    public static final String API_HOST_API_Workplace = String.format("%s/workplace", API_HOST_API);
    public static final String API_HOST_API_Opinion = String.format("%s/opinion", API_HOST_API);
    public static final String API_HOST_API_Page = String.format("%s/apppage", API_HOST_API);

    // http://api.laobandianping.com:8120/v1

    // 线上环境
//    public static final String API_HOST_WEB = "http://www.laobandianping.com";
//    public static final String API_HOST_MOBILE = String.format("%s/m",API_HOST_WEB);

//    public static final String API_HOST_API = "http://api.laobandianping.com:8120/v-test";
//    public static final String API_HOST_API = "http://api.laobandianping.com:8120/v1";
//    public static final String API_HOST_API_AppBase = String.format("%s/appbase",API_HOST_API);
//    public static final String API_HOST_API_Workplace = String.format("%s/workplace",API_HOST_API);
//    public static final String API_HOST_API_Opinion = String.format("%s/opinion", API_HOST_API);
//    public static final String API_HOST_API_Page = String.format("%s/apppage",API_HOST_API);

    public static final String HOST_SITE = "http://ling-web.juxian.com";
    public static final String Upgrade_GetLastVersion_Endpoint = HOST_SITE
            + "/app/LastVersion";
    public static final String TokenKey = "JX-TOKEN";
    public static final String DeviceKey = "JX-DEVICE";
    public static final int OnceLoadItemCount = 10;

    public static final String ApiTest_Timeout_Endpoint = API_HOST_API_AppBase + "/ApiTest/timeout?seconds=%s";

    // 支付部分
    public static final String Payment_CreateTrade_Endpoint = API_HOST_API_AppBase
            + "/payment/CreateTrade";
    public static final String Payment_PaymentCompleted_Endpoint = API_HOST_API_AppBase
            + "/payment/PaymentCompleted";
    public static final String Wallet_Pay_Endpoint = API_HOST_API_AppBase
            + "/Wallet/Pay?ownerId=%s&tradeCode=%s";

    public static final String Account_CreateNew_Endpoint = API_HOST_API_AppBase
            + "/account/createNew";
    public static final String Account_SignInByToken_Endpoint = API_HOST_API_AppBase
            + "/account/signInByToken";
    public static final String Account_SignUp_Endpoint = API_HOST_API_AppBase
            + "/Account/SignUp";
    public static final String Account_SignIn_Endpoint = API_HOST_API_AppBase
            + "/account/signIn";
    public static final String Account_SignOut_Endpoint = API_HOST_API_AppBase
            + "/Account/SignOut";
    public static final String Account_BindThirdPassport_Endpoint = API_HOST_API_AppBase
            + "/account/bindThirdPassport";
    public static final String Account_ExistsMobilePhone_Endpoint = API_HOST_API_AppBase
            + "/account/existsMobilePhone?phone=%s";
    public static final String Account_ResetPwd_Endpoint = API_HOST_API_AppBase
            + "/account/ResetPassword";
    public static final String Account_OpenAccount_Endpoint = API_HOST_API_AppBase
            + "/Account/OpenAccount";
    // 快速登录
    public static final String Account_ShortcutSignIn_Endpoint = API_HOST_API_AppBase + "/Account/ShortcutSignIn";
    public static final String Account_SendValidationCode_Endpoint = API_HOST_API_AppBase
            + "/Account/SendValidationCode?phone=%s";

    public static final String User_ChangeCurrentToUserProfile_Endpoint = API_HOST_API_AppBase + "/User/ChangeCurrentToUserProfile";
    public static final String User_ChangeCurrentToOrganizationProfile_Endpoint = API_HOST_API_AppBase + "/User/ChangeCurrentToOrganizationProfile";

    // 用户部分
    public static final String User_ChangeProfile_Endpoint = API_HOST_API_AppBase + "/user/ChangeProfile";
    public static final String User_ChangePassword_Endpoint = API_HOST_API_AppBase + "/User/ChangePassword";
    public static final String User_ChangeAvatar_Endpoint = API_HOST_API_AppBase
            + "/User/ChangeAvatar";
    public static final String User_Summary_Endpoint = API_HOST_API_AppBase
            + "/user/Summary";
    public static final String User_MyLastContract_Endpoint = API_HOST_API_AppBase
            + "/User/MyLastContract";

    // BossComment
    public static final String BossComment_Post_Endpoint = API_HOST_API_AppBase + "/BossComment/Post";
    public static final String BossComment_Search_Endpoint = API_HOST_API_AppBase + "/BossComment/Search?idCard=%s&name=%s&company=%s&page=%s&size=%s";

    // 公司名是否存在接口
    public static final String User_ExistsCompany_Endpoint = API_HOST_API_Workplace + "/User/existsCompany?CompanyName=%s";
    public static final String User_CreateNewCompany_Endpoint = API_HOST_API_Workplace + "/User/createNewCompany";
    //版本是否升级
    public static final String User_ExistsVersion_Endpoint = API_HOST_API_Workplace + "/User/existsVersion?VersionCode=%s&AppType=%s";

    // 字典接口
    public static final String Dictionary_Dictionaries_Endpoint = API_HOST_API_Workplace + "/BizDict/getBizByCode";

    // CompanyMember部分
    public static final String CompanyMember_MyRoles_Endpoint = API_HOST_API_Workplace + "/User/myRoles";
    public static final String CompanyMember_Add_Endpoint = API_HOST_API_Workplace + "/CompanyMember/add";
    public static final String CompanyMember_Update_Endpoint = API_HOST_API_Workplace + "/CompanyMember/update";
    public static final String CompanyMember_Delete_Endpoint = API_HOST_API_Workplace + "/CompanyMember/delete";
    public static final String CompanyMember_CompanyMemberListByCompany_Endpoint = API_HOST_API_Workplace + "/CompanyMember/CompanyMemberListByCompany?CompanyId=%s";


    // 公司部分
    public static final String Company_RequestCompanyAudit_Endpoint = API_HOST_API_Workplace + "/Company/RequestCompanyAudit";
    public static final String Company_Summary_Endpoint = API_HOST_API_Workplace + "/Company/summary?CompanyId=%s";
    public static final String Company_Mine_Endpoint = API_HOST_API_Workplace + "/Company/mine?CompanyId=%s";
    public static final String Company_Update_Endpoint = API_HOST_API_Workplace + "/Company/update";
    public static final String Company_MyAuditInfo_Endpoint = API_HOST_API_Workplace + "/Company/myAuditInfo?CompanyId=%s";
    public static final String Company_InviteRegister_Endpoint = API_HOST_API_Workplace + "/Company/InviteRegister?CompanyId=%s";

    // 档案部分
    public static final String EmployeArchive_Add_Endpoint = API_HOST_API_Workplace + "/EmployeArchive/add";
    public static final String EmployeArchive_EmployeList_Endpoint = API_HOST_API_Workplace + "/EmployeArchive/EmployeList?CompanyId=%s";
    public static final String EmployeArchive_ExistsIDCard_Endpoint = API_HOST_API_Workplace + "/EmployeArchive/existsIDCard?CompanyId=%s&IDCard=%s";
    public static final String EmployeArchive_ArchiveDetail_Endpoint = API_HOST_API_Workplace + "/EmployeArchive/Detail?CompanyId=%s&ArchiveId=%s";
    public static final String EmployeArchive_Update_Endpoint = API_HOST_API_Workplace + "/EmployeArchive/update";
    public static final String EmployeArchive_Search_Endpoint = API_HOST_API_Workplace + "/EmployeArchive/Search?CompanyId=%s&RealName=%s&Page=%s&Size=%s";


    // 阶段评价和离任报告部分
    public static final String ArchiveComment_Add_Endpoint = API_HOST_API_Workplace + "/ArchiveComment/add";
    public static final String ArchiveComment_MyCommentList_Endpoint = API_HOST_API_Workplace + "/ArchiveComment/MyListByAudit?CompanyId=%s&AuditStatus=%s&Page=%s&Size=%s";
    public static final String ArchiveComment_AuditPass_Endpoint = API_HOST_API_Workplace + "/ArchiveComment/AuditPass?CompanyId=%s&CommentId=%s&IsSendSms=%s";
    public static final String ArchiveComment_AuditReject_Endpoint = API_HOST_API_Workplace + "/ArchiveComment/AuditReject";
    public static final String ArchiveComment_Search_Endpoint = API_HOST_API_Workplace + "/ArchiveComment/Search?CompanyId=%s&CommentType=%s&RealName=%s&Page=%s&Size=%s";
    public static final String ArchiveComment_Detail_Endpoint = API_HOST_API_Workplace + "/ArchiveComment/Detail?CompanyId=%s&CommentId=%s";
    public static final String ArchiveComment_Update_Endpoint = API_HOST_API_Workplace + "/ArchiveComment/update";
    public static final String ArchiveComment_Summary_Endpoint = API_HOST_API_Workplace + "/ArchiveComment/Summary?CompanyId=%s&CommentId=%s";
    public static final String ArchiveComment_All_Endpoint = API_HOST_API_Workplace + "/ArchiveComment/All?CompanyId=%s&ArchiveId=%s";
    public static final String ArchiveComment_ExistsStageSection_Endpoint = API_HOST_API_Workplace + "/ArchiveComment/existsStageSection?CompanyId=%s&ArchiveId=%s";
    public static final String ArchiveComment_Loglist_Endpoint = API_HOST_API_Workplace + "/ArchiveComment/loglist?CompanyId=%s&CommentId=%s";

    public static final String DrawMoneyRequest_add_Endpoint = API_HOST_API_Workplace + "/DrawMoneyRequest/add";
    public static final String DrawMoneyRequest_BankCardList_Endpoint = API_HOST_API_Workplace + "/DrawMoneyRequest/BankCardList?CompanyId=%s";

    //boss circle
    public static final String BossDynamic_home_Endpoint = API_HOST_API_Workplace + "/BossDynamic/home?CompanyId=%s&Size=%s&Page=%s";
    public static final String BossDynamic_myDynamic_Endpoint = API_HOST_API_Workplace + "/BossDynamic/myDynamic?CompanyId=%s&Size=%s&Page=%s";
    public static final String BossDynamic_add_Endpoint = API_HOST_API_Workplace + "/BossDynamic/add";
    public static final String BossDynamic_del_Endpoint = API_HOST_API_Workplace + "/BossDynamic/del?CompanyId=%s&DynamicId=%s";
    public static final String BossDynamic_comment_Endpoint = API_HOST_API_Workplace + "/BossDynamic/comment";
    public static final String BossDynamic_liked_Endpoint = API_HOST_API_Workplace + "/BossDynamic/liked?CompanyId=%s&DynamicId=%s";


    // wallet
    public static final String Wallet_OrganizationTradeHistory_Endpoint = API_HOST_API_Workplace + "/CompanyWallet/TradeHistory?companyId=%s&mode=%s&page=%s&size=%s";
    public static final String CompanyWallet_Wallet_Endpoint = API_HOST_API_Workplace + "/CompanyWallet/Wallet?CompanyId=%s";

    //消息
    public static final String Message_GetAppMsg_Endpoint = API_HOST_API_Workplace + "/Message/getAppMsg?Size=%s&Page=%s";
    public static final String Message_GetList_Endpoint = API_HOST_API_Workplace + "/Message/getList?Size=%s&Page=%s&MessageType=%s";
    public static final String Message_readMsg_Endpoint = API_HOST_API_Workplace + "/Message/readMsg?MessageId=%s";
    public static final String Message_Unread_Endpoint = API_HOST_API_Workplace + "/Message/unread?MessageType=%s";

    // 部门
    public static final String Department_Add_Endpoint = API_HOST_API_Workplace + "/Department/add";
    public static final String Department_DepartmentListByCompany_Endpoint = API_HOST_API_Workplace + "/Department/all?CompanyId=%s";
    public static final String Department_Delete_Endpoint = API_HOST_API_Workplace + "/Department/delete";
    public static final String Department_Update_Endpoint = API_HOST_API_Workplace + "/Department/update";

    // 招聘与求职
    public static final String Job_JobList_Endpoint = API_HOST_API_Workplace + "/Job/JobList?CompanyId=%s&Page=%s&Size=%s";
    public static final String Job_Add_Endpoint = API_HOST_API_Workplace + "/Job/add";
    public static final String Job_update_Endpoint = API_HOST_API_Workplace + "/Job/update";
    public static final String Job_CloseJob_Endpoint = API_HOST_API_Workplace + "/Job/CloseJob?CompanyId=%s&JobId=%s";
    public static final String Job_OpenJob_Endpoint = API_HOST_API_Workplace + "/Job/OpenJob?CompanyId=%s&JobId=%s";
    public static final String Job_Detail_Endpoint = API_HOST_API_Workplace + "/Job/Detail?CompanyId=%s&JobId=%s";
    public static final String Job_Delete_Endpoint = API_HOST_API_Workplace + "/Job/DeleteJob?CompanyId=%s&JobId=%s";

    public static final String JobQuery_Search_Endpoint = API_HOST_API_Workplace + "/JobQuery/Search?JobName=%s&JobCity=%s&Industry=%s&SalaryRange=%s&Page=%s&Size=%s";
    public static final String JobQuery_Detail_Endpoint = API_HOST_API_Workplace + "/JobQuery/Detail?JobId=%s";

    // 个人端
    public static final String Privateness_Summary_Endpoint = API_HOST_API_Workplace + "/Privateness/Summary";
    public static final String Privateness_ArchiveSummary_Endpoint = API_HOST_API_Workplace + "/Privateness/ArchiveSummary";
    public static final String Privateness_BindingIDCard_Endpoint = API_HOST_API_Workplace + "/Privateness/BindingIDCard?IDCard=%s";
    public static final String Privateness_MyArchives_Endpoint = API_HOST_API_Workplace + "/Privateness/myArchives";
    public static final String Privateness_MyMsg_Endpoint = API_HOST_API_Workplace + "/Privateness/myMsg";
    public static final String Priveteness_InviteRegister_Endpoint = API_HOST_API_Workplace + "/Privateness/InviteRegister";

    public static final String PrivatenessWallet_Wallet_Endpoint = API_HOST_API_Workplace + "/PrivatenessWallet/Wallet";
    public static final String Privateness_DrawMoneyRequest_Endpoint = API_HOST_API_Workplace + "/Privateness/DrawMoneyRequest";
    public static final String Privateness_BankCardList_Endpoint = API_HOST_API_Workplace + "/Privateness/BankCardList";
    public static final String PrivatenessWallet_TradeHistory_Endpoint = API_HOST_API_Workplace + "/PrivatenessWallet/TradeHistory?mode=%s&page=%s&size=%s";

    // 开通服务活动优惠
    public static final String PriceStrategy_CurrentActivity_Endpoint = API_HOST_API_Workplace + "/PriceStrategy/CurrentActivity?ActivityType=%s&Version=%s";

    // 意见反馈
    public static final String Feedback_Frequency_Endpoint = API_HOST_API_Workplace + "/Feedback/frequency";
    public static final String Feedback_Add_Endpoint = API_HOST_API_Workplace + "/Feedback/add";

    // 口碑相关
    public static final String Opinion_Index_Endpoint = API_HOST_API_Opinion + "/Opinion/index?Page=%s&Size=%s";
    public static final String Opinion_Mine_Endpoint = API_HOST_API_Opinion + "/Opinion/mine?Page=%s&Size=%s";
    public static final String Topic_Index_Endpoint = API_HOST_API_Opinion + "/Topic/index";
    public static final String Opinion_Create_Endpoint = API_HOST_API_Opinion + "/Opinion/create";
    public static final String Reply_Create_Endpoint = API_HOST_API_Opinion + "/Reply/create";
    public static final String Opinion_Detail_Endpoint = API_HOST_API_Opinion + "/Opinion/detail?OpinionId=%s";
    public static final String Opinion_Liked_Endpoint = API_HOST_API_Opinion + "/Opinion/liked?OpinionId=%s";
    public static final String Concerned_Mine_Endpoint = API_HOST_API_Opinion + "/Concerned/mine?Page=%s&Size=%s";
    public static final String Company_Detail_Endpoint = API_HOST_API_Opinion + "/Company/detail?CompanyId=%s&Page=%s&Size=%s";
    public static final String Concerned_Attention_Endpoint = API_HOST_API_Opinion + "/Concerned/attention?CompanyId=%s";
    public static final String Topic_Detail_Endpoint = API_HOST_API_Opinion + "/Topic/detail?TopicId=%s&Page=%s&Size=%s";
    public static final String Company_Search_Endpoint = API_HOST_API_Opinion + "/Company/search?Keyword=%s";
    public static final String Console_Index_Endpoint = API_HOST_API_Opinion + "/Console/index";
    public static final String Enterprise_Claim_Endpoint = API_HOST_API_Opinion + "/Enterprise/claim?CompanyId=%s";
    public static final String Enterprise_Opinions_Endpoint = API_HOST_API_Opinion + "/Enterprise/opinions?CompanyId=%s&OpinionCompanyId=%s&AuditStatus=%s&Page=%s&Size=%s";
    public static final String Enterprise_HideOpinions_Endpoint = API_HOST_API_Opinion + "/Enterprise/hideOpinions";
    public static final String Enterprise_RestoreOpinions_Endpoint = API_HOST_API_Opinion + "/Enterprise/restoreOpinions";
    public static final String Enterprise_Settings_Endpoint = API_HOST_API_Opinion + "/Enterprise/settings?CompanyId=%s&OpinionCompanyId=%s&IsCloseComment=%s";
    public static final String Enterprise_Labels_Endpoint = API_HOST_API_Opinion + "/Enterprise/labels";
    public static final String Enterprise_Reply_Endpoint = API_HOST_API_Opinion + "/Enterprise/reply";


    public static final String EmployeArchive_Archive_Endpoint = API_HOST_API_Page + "/EmployeArchive/Archive?CompanyId=%s&ArchiveId=%s";//档案详情
    public static final String EmployeArchive_Comment_Endpoint = API_HOST_API_Page + "/EmployeArchive/Comment?CompanyId=%s&oid=%s";//评价评价详情
    public static final String EmployeArchive_Report_Endpoint = API_HOST_API_Page + "/EmployeArchive/Report?CompanyId=%s&oid=%s";//离任报告详情

    public static final String BackgroundSurvey_List_Endpoint = API_HOST_API_Page + "/BackgroundSurvey/BoughtPurchased?CompanyId=%s";
    public static final String BackgroundSurvey_Search_Endpoint = API_HOST_API_Page + "/BackgroundSurvey/BoughtPurchased?CompanyId=%s&Search=%s";
    public static final String BackgroundSurvey_Personal_Detail_Endpoint = API_HOST_API_Page + "/BackgroundSurvey/personal?ArchiveId=%s";
    public static final String BackgroundSurvey_BoughtDetail_Endpoint = API_HOST_API_Page + "/BackgroundSurvey/BoughtDetail?CompanyId=%s&RecordId=%s";

    public static final String Job_HtmlDetail_Endpoint = API_HOST_API_Page + "/JobDetail/Detail?CompanyId=%s&JobId=%s&isPersonal=%s";

    public static final String Company_RenewalEnterpriseService_Endpoint = API_HOST_API_Page + "/Company/RenewalEnterpriseService?CompanyId=%s&os=android&Version=%s";

    public static final String Register_Agreement_One_Endpoint = API_HOST_MOBILE + "/BossComments/CompanyAgreementAndPrivacy";
    public static final String Register_Agreement_Two_Endpoint = API_HOST_MOBILE + "/BossComments/CompanyPrivacy";
    public static final String Register_Agreement_Three_Endpoint = API_HOST_MOBILE + "/BossComments/UserAgreementAndPrivacy";
    public static final String Register_Agreement_Four_Endpoint = API_HOST_MOBILE + "/BossComments/UserPrivacy";

    public static final String About_Us_Endpoint = API_HOST_MOBILE + "/BossComments/AboutUs";
    public static final String Contact_Us_Endpoint = API_HOST_MOBILE + "/BossComments/ContactUs";
    public static final String company_Transfer_Endpoint = API_HOST_MOBILE + "/BossComments/companyTransfer";
    public static final String Common_Problem_Endpoint = API_HOST_MOBILE + "/BossComments/problem";
    public static final String Role_Permission_Illustrate_Endpoint = API_HOST_MOBILE + "/BossComments/RolePermission";
    public static final String Gold_Explain_Endpoint = API_HOST_MOBILE + "/BossComments/GoldDescription";


    public static final String Opinion_OpinionDetail_Endpoint = API_HOST_API_Page + "/opinion/opinionDetail?OpinionId=%s";
    public static final String Opinion_CreatePage_Endpoint = API_HOST_API_Page + "/Opinion/create?CompanyId=%s";
    public static final String Opinion_ClaimCompany_Endpoint = API_HOST_API_Page + "/Opinion/claimCompany?CompanyId=%s&CompanyName=%s";

}
