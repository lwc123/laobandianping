//
//  ApiEnvironment.h
//  JuXianTalentBank
//
//  Created by 万里 on 16/02/02.
//  Copyright (c) 2015年 Max. All rights reserved.
//
//* / ***********  本地配置  *************
#define API_HOST_WEB @"http://bc.jux360.cn:8000"
//静态
#define API_HOST_MOBILE [NSString stringWithFormat:@"%@/m",API_HOST_WEB]
#define API_HOST_API @"http://bc-api.jux360.cn:8120/v-test"
// */
/* / ***********  线上配置  *************
 #define API_HOST_WEB @"http://www.laobandianping.com"
 #define API_HOST_MOBILE [NSString stringWithFormat:@"%@/m",API_HOST_WEB]
 #define API_HOST_API @"http://api.laobandianping.com:8120/v-test"
 // */

/* /  ******************  线上V1  ***********
 #define API_HOST_WEB @"http://www.laobandianping.com"
 #define API_HOST_MOBILE [NSString stringWithFormat:@"%@/m",API_HOST_WEB]
 #define API_HOST_API @"http://api.laobandianping.com:8120/v1"
 // */
#define API_HOST_API_Appbase    [NSString stringWithFormat:@"%@/appbase",API_HOST_API]
#define API_HOST_API_Workplace  [NSString stringWithFormat:@"%@/workplace",API_HOST_API]
#define API_HOST_API_Opinion  [NSString stringWithFormat:@"%@/opinion",API_HOST_API]


#define API_HOST_API_Apppage    [NSString stringWithFormat:@"%@/apppage",API_HOST_API]

//分享域名
#define Share_HOST @"http://radish-web.juxian.com"//线上分享


//百度地图云存储 猎头位置信息
#define API_Account_CreateHunterLocation @"http://api.map.baidu.com/geodata/v3/poi/create"

//通过云存储的passpordid 去服务器获取相关猎人信息
#define API_Hunter_BMKHunterInfo(passPordId) [NSString stringWithFormat:@"%@/User/Profiles?ids=%@",API_HOST_API_Appbase,passPordId]



//Account
#pragma mark - Account
#define API_Account_CreateNew [NSString stringWithFormat:@"%@/account/Createnew",API_HOST_API_Appbase]//路径拼接@"/account/SignIn"
#define API_Account_SignIn [NSString stringWithFormat:@"%@/account/SignIn",API_HOST_API_Appbase]
#define API_Account_ShortcutSignIn [NSString stringWithFormat:@"%@/account/ShortcutSignIn",API_HOST_API_Appbase]
#define API_Account_SignUp [NSString stringWithFormat:@"%@/account/SignUp",API_HOST_API_Appbase]
//开户
#define API_Account_Open [NSString stringWithFormat:@"%@/account/OpenAccount",API_HOST_API_Appbase]


#define API_Account_BindThirdPassport [NSString stringWithFormat:@"%@/account/BindThirdPassport",API_HOST_API_Appbase]
#define API_Account_SignInByToken [NSString stringWithFormat:@"%@/account/SignInByToken",API_HOST_API_Appbase]
#define API_Account_SignOut [NSString stringWithFormat:@"%@/account/SignOut",API_HOST_API_Appbase]
//检测账号是否存在
#define API_Account_ExistsMobilePhone [NSString stringWithFormat:@"%@/account/ExistsMobilePhone?phone=",API_HOST_API_Appbase]
//修改密码
#define API_ACcount_ChangePassWord [NSString stringWithFormat:@"%@/account/ResetPassword",API_HOST_API_Appbase]
//设置密码
#define API_Account_ResetPassWord [NSString stringWithFormat:@"%@/User/ChangePassword",API_HOST_API_Appbase]
//登录成功之后调用 获取多个公司及信息
#define API_Company_Information [NSString stringWithFormat:@"%@/User/myRoles",API_HOST_API_Workplace]

#define API_CompanyInformation(companyId) [NSString stringWithFormat:@"%@/Company/summary?CompanyId=%ld",API_HOST_API_Workplace,companyId]


//获取所有的字典
#define API_Dictionary_Dictionaries [NSString stringWithFormat:@"%@/BizDict/getBizByCode?Code=salary,city,panicked,period,leaving",API_HOST_API_Workplace]

//获取学历
#define API_Dictionary_Academic [NSString stringWithFormat:@"%@/BizDict/getBizByCode?Code=academic",API_HOST_API_Workplace]

//离任原因 返聘意愿字典
#define API_Dictionary_leaving [NSString stringWithFormat:@"%@/BizDict/getBizByCode?Code=panicked,leaving",API_HOST_API_Workplace]
//规模字典
#define API_Dictionary_Size [NSString stringWithFormat:@"%@/BizDict/getBizByCode?Code=CompanySize",API_HOST_API_Workplace]
//行业字典
#define API_Dictionary_Industry [NSString stringWithFormat:@"%@/BizDict/getBizByCode?Code=industry",API_HOST_API_Workplace]


//获取城市
#define API_Dictionary_City [NSString stringWithFormat:@"%@/BizDict/getBizByCode?Code=city",API_HOST_API_Workplace]


//获取支付宝的支付方式 GET
#define API_Payment_getPaymentMethod @"/Payment/getPaymentMethod"
//———————购买服务—————————
//支付成功后的post请求
#define API_Payment_MobileAlipayPaymentSynNotify(alipayBack) [NSString stringWithFormat:@"/Payment/MobileAlipayPaymentSynNotify?%@",alipayBack]

//支付宝获取支付参数的接口 POST
#define ApI_Payment_GetPaymentParams1 @"/Payment/GetPaymentParams"
#define ApI_Payment_GetPaymentParams(a,b,c,d,e) [NSString stringWithFormat:@"/Payment/GetPaymentParams?PaymentInterfaceCode=%@&productId=%@&number=%@&productType=%@&BizType=%@",a,b,c,d,e]
// --------打赏---------
#define API_Payment_GetpaymentAwardparams(InterfaceCode,PrimaryId,RMB)[NSString stringWithFormat:@"/Payment/GetPaymentParams?PaymentInterfaceCode=%@&PrimaryId=%@&RMB=%@&RecordType=CareerAdvice&bizType=SendGratuity",InterfaceCode,PrimaryId,RMB]



// 唯一的一个:GET
//#define API_Account_BindThirdPassport @"/account/BindThirdPassport"
#define API_Account_ChangeAvatar @"/account/ChangeAvatar"
#define API_Account_UploadAvatar @"/account/UploadAvatar"
#define API_Account_ChangeIdentity @"/account/ChangeIdentity"
#define GET_URL(_url_) [NSString stringWithFormat:@"http://localhost:8080%@",_url_]
#define API_Mobile_Send @"/Mobile/Send"

///清除用户服务器的数据
#define API_Account_ClearUser @"/Account/ClearUser?mobilePhone="

//企业认证
#define API_CompanyAudit [NSString stringWithFormat:@"%@/Company/RequestCompanyAudit",API_HOST_API_Workplace]

//判断公司名是否存在
#define API_Company_Exists(CompanyName) [NSString stringWithFormat:@"%@/User/existsCompany?CompanyName=%@",API_HOST_API_Workplace,CompanyName]

//企业认证信息详情 获取已提交认证信息
#define API_Company_myAuditInfo(CompanyId) [NSString stringWithFormat:@"%@/Company/myAuditInfo?CompanyId=%ld",API_HOST_API_Workplace,CompanyId]

//开户返回的优惠价格
#define API_Price_Strategy(ActivityType,Version) [NSString stringWithFormat:@"%@/PriceStrategy/CurrentActivity?ActivityType=%ld&Version=%@",API_HOST_API_Workplace,ActivityType,Version]

//金库支付POST
#define API_Wallet_pay(CompanyId,tradeCode) [NSString stringWithFormat:@"%@/Wallet/Pay?ownerId=%ld&tradeCode=%@",API_HOST_API_Appbase,CompanyId,tradeCode]


//判断用苹果内购还是第三方支付 -- 线上OpenEnterpriseServic
#define API_Getpayways(bizSource) [NSString stringWithFormat:@"%@/payment/getpayways?os=iOS&bizSource=%@",API_HOST_API_Appbase,bizSource]

//判断用苹果内购还是第三方支付 -- 线下
#define API_Getpayways_Text(bizSource) [NSString stringWithFormat:@"%@/payment/getpayways?os=iOS&bizSource=%@&PayWays=Wechat,Alipay,Offline,AppleIAP",API_HOST_API_Appbase,bizSource]

//获取指定业务的苹果内购产品信息
#define API_GetIAPProduct(bizSource) [NSString stringWithFormat:@"%@/Payment/getIAPProduct?bizSource=%@",API_HOST_API_Appbase,bizSource]

//创建公司
#define API_CreateNewCompany  [NSString stringWithFormat:@"%@/User/createNewCompany",API_HOST_API_Workplace]

//改变用户头像
#define API_User_ChangeAvatar [NSString stringWithFormat:@"%@/user/ChangeAvatar",API_HOST_API_Appbase]
//改变用户信息/user/ChangeProfile
#define API_user_ChangeProfile [NSString stringWithFormat:@"%@/user/ChangeProfile",API_HOST_API_Appbase]
//用户信息
#define API_User_Summary [NSString stringWithFormat:@"%@/User/Summary",API_HOST_API_Appbase]


//老板点评
#define API_BossComment [NSString stringWithFormat:@"%@/BossComment/Post",API_HOST_API_Appbase]

//老板查询接口
#define API_BossCheck(idCard,name,company,page,size) [NSString stringWithFormat:@"%@/BossComment/Search?idCard=%@&name=%@&company=%@page=%@&size=%@",API_HOST_API_Appbase,idCard,name,company,page,size]

// 切换用户身份到个人
#define API_Account_ChangeCurrentToUserProfile [NSString stringWithFormat:@"%@/User/ChangeCurrentToUserProfile",API_HOST_API_Appbase]

// 切换用户身份到企业用户
#define API_Account_ChangeCurrentToOrganizationProfile [NSString stringWithFormat:@"%@/User/ChangeCurrentToOrganizationProfile",API_HOST_API_Appbase]

//*****************************工作台
#pragma mark - 工作台
#define API_CompanyInformation(companyId) [NSString stringWithFormat:@"%@/Company/summary?CompanyId=%ld",API_HOST_API_Workplace,companyId]


//******************添加员工档案
#define API_AddEmployeArchive [NSString stringWithFormat:@"%@/EmployeArchive/add",API_HOST_API_Workplace]
//修改员工档案
#define API_UpDate_EmployeArchive [NSString stringWithFormat:@"%@/EmployeArchive/update",API_HOST_API_Workplace]
//******************员工档案列表
#define API_EmployeArchiveList(companyId) [NSString stringWithFormat:@"%@/EmployeArchive/EmployeList?CompanyId=%ld",API_HOST_API_Workplace,companyId]
//校验身份证
#define API_Exists_IDCar(companyId,idCard) [NSString stringWithFormat:@"%@/EmployeArchive/existsIDCard?CompanyId=%ld&IDCard=%@",API_HOST_API_Workplace,companyId,idCard]

//*****************添加评价
#define API_ArchiveComment [NSString stringWithFormat:@"%@/ArchiveComment/add",API_HOST_API_Workplace]
//档案详情获取model
#define API_ArchiveDetail(CompanyId,ArchiveId) [NSString stringWithFormat:@"%@/EmployeArchive/Detail?CompanyId=%ld&ArchiveId=%ld",API_HOST_API_Workplace,CompanyId,ArchiveId]
//档案详情h5
#define API_Web_ArchiveDetail(CompanyId,ArchiveId) [NSString stringWithFormat:@"%@/EmployeArchive/Archive?CompanyId=%ld&ArchiveId=%ld",API_HOST_API_Apppage,CompanyId,ArchiveId]

//阶段评价h5
#define API_Web_CommentDetail(CompanyId,commentId) [NSString stringWithFormat:@"%@/EmployeArchive/Comment?CompanyId=%ld&oid=%ld",API_HOST_API_Apppage,CompanyId,commentId]
//离任详情h5
#define API_Web_ReportDetail(CompanyId,commentId) [NSString stringWithFormat:@"%@/EmployeArchive/Report?CompanyId=%ld&oid=%ld",API_HOST_API_Apppage,CompanyId,commentId]

//离任评价 阶段评价详情
#define API_Comment_Detail(CompanyId,CommentId) [NSString stringWithFormat:@"%@/ArchiveComment/Detail?CompanyId=%ld&CommentId=%ld",API_HOST_API_Workplace,CompanyId,CommentId]

//评价列表
#define API_CommentSeach_List(companyId,commentType,realName,page,size) [NSString stringWithFormat:@"%@/ArchiveComment/Search?CompanyId=%ld&CommentType=%d&RealName=%@&Page=%d&Size=%d",API_HOST_API_Workplace,companyId,commentType,realName,page,size]
//修改评价
#define API_Comment_Update [NSString stringWithFormat:@"%@/ArchiveComment/update",API_HOST_API_Workplace]

//h5档案详情进入修改离任阶段评价
#define API_AllComment_List(CommentId,ArchiveId) [NSString stringWithFormat:@"%@/ArchiveComment/All?CompanyId=%ld&ArchiveId=%ld",API_HOST_API_Workplace,CommentId,ArchiveId]

//背景调查---> 公司钱包
#define API_Company_Wallet(CompanyId) [NSString stringWithFormat:@"%@/CompanyWallet/Wallet?CompanyId=%ld",API_HOST_API_Workplace,CompanyId]

//档案搜索结果列表
#define API_ArchiveSeach_List(companyId,realName,page,size) [NSString stringWithFormat:@"%@/EmployeArchive/Search?CompanyId=%ld&RealName=%@&Page=%d&Size=%d",API_HOST_API_Workplace,companyId,realName,page,size]


//查看此档案已添加的年份区间评价
#define API_Exists_StageSection(CompanyId,ArchiveId) [NSString stringWithFormat:@"%@/ArchiveComment/existsStageSection?CompanyId=%ld&ArchiveId=%ld",API_HOST_API_Workplace,CompanyId,ArchiveId]
//邀请注册InviteRegister
#define API_InviteRegister(CompanyId) [NSString stringWithFormat:@"%@/Company/InviteRegister?CompanyId=%ld",API_HOST_API_Workplace,CompanyId]

// 检测是否有新版本
#define API_ExistsVersion(Version) [NSString stringWithFormat:@"%@/User/existsVersion?VersionCode=%@&AppType=ios",API_HOST_API_Workplace,Version]

//获取消息列表红点逻辑
#define API_MessageUnread(messagetype) [NSString stringWithFormat:@"%@/Message/unread?MessageType=%d",API_HOST_API_Workplace,messagetype]



//****************************我的
#pragma mark - 我的
//添加授权人
#define API_Add_CompanyMember [NSString stringWithFormat:@"%@/CompanyMember/add",API_HOST_API_Workplace]

//授权人列表
#define API_CompanyMember_List(companyId)[NSString stringWithFormat:@"%@/CompanyMember/CompanyMemberListByCompany?CompanyId=%ld",API_HOST_API_Workplace,companyId]
//修改授权人
#define API_Update_CompanyMember [NSString stringWithFormat:@"%@/CompanyMember/update",API_HOST_API_Workplace]
//删除
#define API_Delegate_CompanyMember [NSString stringWithFormat:@"%@/CompanyMember/delete",API_HOST_API_Workplace]

//我提交的（要我审核）列表
#define API_ArchiveComment_MyListByAudit(companyId,AuditStatus,page,size)[NSString stringWithFormat:@"%@/ArchiveComment/MyListByAudit?CompanyId=%ld&AuditStatus=%ld&Page=%ld&Size=%ld",API_HOST_API_Workplace,companyId,AuditStatus,page,size]

//进入H5页面重新请求数据，查看状态以及数据的改变
#define API_ArchiveComment_Summary(CompanyId,CommentId)[NSString stringWithFormat:@"%@/ArchiveComment/Summary?CompanyId=%ld&CommentId=%ld",API_HOST_API_Workplace,CompanyId,CommentId]
//我的
#define API_Company_Mine(CompanyId) [NSString stringWithFormat:@"%@/Company/mine?CompanyId=%ld",API_HOST_API_Workplace,CompanyId]

#pragma mark - 消息
// 获取消息
#define API_getAppMsg(size,page) [NSString stringWithFormat:@"%@/Message/getAppMsg?Size=%d&Page=%d",API_HOST_API_Workplace,size,page]

//1.1.2
#define API_getMsgList(messageType,size,page) [NSString stringWithFormat:@"%@/Message/getlist?MessageType=%d&Size=%d&Page=%d",API_HOST_API_Workplace,messageType,size,page]

// 标记消息为已读状态
#define API_getReadMsg(messageId) [NSString stringWithFormat:@"%@/Message/readMsg?MessageId=%ld",API_HOST_API_Workplace,messageId]
// 获取未读消息数量
#define API_getUnreadMsgNum(companyId) [NSString stringWithFormat:@"%@/Message/getAppMsg?&CompanyId=%ld",API_HOST_API_Workplace,companyId]

//修改记录
#define API_getLogList(companyId,commentId) [NSString stringWithFormat:@"%@/ArchiveComment/loglist?CompanyId=%ld&CommentId=%ld",API_HOST_API_Workplace,companyId,commentId]



#pragma mark -
//交易
#define API_TradeHistory_Wallet(companyId,mode,page,size)[NSString stringWithFormat:@"%@/CompanyWallet/TradeHistory?CompanyId=%ld&mode=%d&page=%d&size=%d",API_HOST_API_Workplace,companyId,mode,page,size]

//拒绝
#define API_PostArchiveComment_AuditReject(CompanyId) [NSString stringWithFormat:@"%@/ArchiveComment/AuditReject?CompanyId=%ld",API_HOST_API_Workplace,CompanyId]

//通过审核
#define API_PostArchiveCommentAuditPass(CompanyId,CommentId,IsSendSms) [NSString stringWithFormat:@"%@/ArchiveComment/AuditPass?CompanyId=%ld&CommentId=%ld&IsSendSms=%d",API_HOST_API_Workplace,CompanyId,CommentId,IsSendSms]

//修改企业信息
#define API_Company_Update [NSString stringWithFormat:@"%@/Company/update",API_HOST_API_Workplace]

//部门添加
#define API_Department_Add [NSString stringWithFormat:@"%@/Department/add",API_HOST_API_Workplace]

//部门修改
#define API_Department_Update [NSString stringWithFormat:@"%@/Department/update",API_HOST_API_Workplace]

//部门删除
#define API_Department_Delegate [NSString stringWithFormat:@"%@/Department/delete",API_HOST_API_Workplace]

//部门列表
#define API_Department_List(CompanyId) [NSString stringWithFormat:@"%@/Department/all?CompanyId=%ld",API_HOST_API_Workplace,CompanyId]

//提现  获取银行卡的列表
//获取消息
#define API_getDrawMoneyRequest_BankCardList(CompanyId) [NSString stringWithFormat:@"%@/DrawMoneyRequest/BankCardList?CompanyId=%ld",API_HOST_API_Workplace,CompanyId]

//提现申请
#define API_PostDrawMoneyRequest_add [NSString stringWithFormat:@"%@/DrawMoneyRequest/add",API_HOST_API_Workplace]


//**************************************个人工作台
#pragma mark - 个人工作台
//个人工作台
#define API_UserSummary [NSString stringWithFormat:@"%@/Privateness/Summary",API_HOST_API_Workplace]

//我的档案没有绑定身份证号  GET /Privateness/ArchiveSummary
#define API_ArchiveSummary [NSString stringWithFormat:@"%@/Privateness/ArchiveSummary",API_HOST_API_Workplace]
//绑定身份证号
#define API_Binding_IDCard(IDCard) [NSString stringWithFormat:@"%@/Privateness/BindingIDCard?IDCard=%@",API_HOST_API_Workplace,IDCard]

//我的档案列表
#define API_myArchive_List [NSString stringWithFormat:@"%@/Privateness/myArchives",API_HOST_API_Workplace]

#pragma mark -
#pragma mark 个人钱包
// 个人钱包WalletEntity
#define API_User_Wallet [NSString stringWithFormat:@"%@/PrivatenessWallet/Wallet",API_HOST_API_Workplace]
// 个人钱包交易记录
#define API_User_TradeHistory(mode,size,page) [NSString stringWithFormat:@"%@/PrivatenessWallet/TradeHistory?mode=%d&size=%d&page=%d",API_HOST_API_Workplace,mode,size,page]

//个人银行卡列表 GET /Privateness/BankCardList
#define API_User_BankCardList [NSString stringWithFormat:@"%@/Privateness/BankCardList",API_HOST_API_Workplace]

//个人提现
#define API_User_SubmitMoney [NSString stringWithFormat:@"%@/Privateness/DrawMoneyRequest",API_HOST_API_Workplace]

#pragma mark -
//个人消息
#define API_User_Meaage(size,page) [NSString stringWithFormat:@"%@/Privateness/myMsg?Size=%d&Page=%d",API_HOST_API_Workplace,size,page]
//个人分享邀请
#define API_User_Share [NSString stringWithFormat:@"%@/Privateness/InviteRegister",API_HOST_API_Workplace]

//个人求职列表
#define API_JobQuery_List(JobName,JobCity,Industry,SalaryRange,Page,Size) [NSString stringWithFormat:@"%@/JobQuery/Search?JobName=%@&JobCity=%@&Industry=%@&SalaryRange=%@&Page=%d&Size=%d",API_HOST_API_Workplace,JobName,JobCity,Industry,SalaryRange,Page,Size]

//公司圈
//主题轮播图
#define API_Company_Topic [NSString stringWithFormat:@"%@/Topic/index",API_HOST_API_Opinion]
//公司口碑列表
#define API_Company_ReputationList(page,size) [NSString stringWithFormat:@"%@/Opinion/index?Page=%d&Size=%d",API_HOST_API_Opinion,page,size]
//个人点赞
#define API_Opinion_Praise(opinionId) [NSString stringWithFormat:@"%@/Opinion/liked?OpinionId=%ld",API_HOST_API_Opinion,opinionId]

//我的点评列表
#define API_CommentList_Mine(page,size) [NSString stringWithFormat:@"%@/Opinion/mine?Page=%d&Size=%d",API_HOST_API_Opinion,page,size]

//个人统计 红点GET /opinion/Console/index
#define API_Console_Index [NSString stringWithFormat:@"%@/Console/index",API_HOST_API_Opinion]


//我关注的公司
#define API_Concerned_MineList(page,size) [NSString stringWithFormat:@"%@/Concerned/mine?Page=%d&Size=%d",API_HOST_API_Opinion,page,size]

//关注POST /opinion/Concerned/attention
#define API_Opinion_Attention(companyId) [NSString stringWithFormat:@"%@/Concerned/attention?CompanyId=%ld",API_HOST_API_Opinion,companyId]

//公司详情GET /opinion/Company/detail
#define API_Company_Detail(companyId,page,size) [NSString stringWithFormat:@"%@/Company/detail?CompanyId=%ld&Page=%d&Size=%d",API_HOST_API_Opinion,companyId,page,size]

//专题详情
#define API_Topic_Detail(topicId,page,size) [NSString stringWithFormat:@"%@/Topic/detail?TopicId=%ld&Page=%d&Size=%d",API_HOST_API_Opinion,topicId,page,size]

//搜索
#define API_Company_Search(keyword) [NSString stringWithFormat:@"%@/Company/search?Keyword=%@",API_HOST_API_Opinion,keyword]

//评论
#define API_Reply_Create [NSString stringWithFormat:@"%@/Reply/create",API_HOST_API_Opinion]


//***************** 老板圈
#pragma mark - 老板圈
// 获取老板圈动态列表
#define API_getBossCircle_list(CompanyId,Size,Page) [NSString stringWithFormat:@"%@/BossDynamic/home?CompanyId=%ld&Size=%d&Page=%d",API_HOST_API_Workplace,CompanyId,Size,Page]

// 获取某个老板动态
#define API_getMyDynamic_list(CompanyId,Size,Page) [NSString stringWithFormat:@"%@/BossDynamic/myDynamic?CompanyId=%ld&Size=%d&Page=%d",API_HOST_API_Workplace,CompanyId,Size,Page]

// 发布动态
#define API_postPublicDynamic_add [NSString stringWithFormat:@"%@/BossDynamic/add",API_HOST_API_Workplace]

// 删除动态
#define API_postDeleteDynamic_del(CompanyId,PassportId,DynamicId) [NSString stringWithFormat:@"%@/BossDynamic/del?CompanyId=%ld&PassportId=%ld&DynamicId=%ld",API_HOST_API_Workplace,CompanyId,PassportId,DynamicId]

// 评论动态
#define API_postCommentDynamic_comment [NSString stringWithFormat:@"%@/BossDynamic/comment",API_HOST_API_Workplace]

// 点赞动态

#define API_postLikedDynamic_comment(CompanyId,Dynamic) [NSString stringWithFormat:@"%@/BossDynamic/liked?CompanyId=%ld&DynamicId=%ld",API_HOST_API_Workplace,CompanyId,Dynamic]

//****************** 招聘
#pragma mark - 招聘
#pragma mark - 企业
//----企业----
// 公司所发布的职位列表
#define API_getJob_jobList(CompanyId,Size,Page) [NSString stringWithFormat:@"%@/Job/JobList?CompanyId=%ld&Size=%d&Page=%d",API_HOST_API_Workplace,CompanyId,Size,Page]

// 企业发布职位
#define API_postJob_add [NSString stringWithFormat:@"%@/Job/add",API_HOST_API_Workplace]

// 编辑职位
#define API_postJob_update [NSString stringWithFormat:@"%@/Job/update",API_HOST_API_Workplace]

// 职位详情
#define API_getJob_detail(CompanyId,JobId) [NSString stringWithFormat:@"%@/Job/Detail?CompanyId=%ld&JobId=%ld",API_HOST_API_Workplace,CompanyId,JobId]

// 企业职位详情H5 个人isPersonal = 1 企业isPersonal = 0
#define API_getJob_detailHtml(CompanyId,JobId) [NSString stringWithFormat:@"%@/JobDetail/Detail?CompanyId=%ld&JobId=%ld&isPersonal=0",API_HOST_API_Apppage,CompanyId,JobId]

#define API_getJobQuery_detailHtml(CompanyId,JobId) [NSString stringWithFormat:@"%@/JobDetail/Detail?CompanyId=%ld&JobId=%ld&isPersonal=1",API_HOST_API_Apppage,CompanyId,JobId]

// 关闭职位
#define API_postJob_closeJob(CompanyId,JobId) [NSString stringWithFormat:@"%@/Job/CloseJob?CompanyId=%ld&JobId=%ld",API_HOST_API_Workplace,CompanyId,JobId]

// 开启职位
#define API_postJob_openJob(CompanyId,JobId) [NSString stringWithFormat:@"%@/Job/OpenJob?CompanyId=%ld&JobId=%ld",API_HOST_API_Workplace,CompanyId,JobId]

// 删除职位
#define API_getJob_deleteJob(CompanyId,JobId) [NSString stringWithFormat:@"%@/Job/DeleteJob?CompanyId=%ld&JobId=%ld",API_HOST_API_Workplace,CompanyId,JobId]

#pragma mark - 个人招聘
// 搜索职位列表
#define API_getJobQuery_search(JobName,JobCity,Industry,SalaryRange,Page,Size) [NSString stringWithFormat:@"%@/JobQuery/Search?JobName=%@,JobCity=%@,Industry=%@,SalaryRange=%@,Page=%d,Size=%d",API_HOST_API_Workplace,JobName,JobCity,Industry,SalaryRange,Page,Size]
// 职位详情
#define API_getJobQuery_Detail(JobId) [NSString stringWithFormat:@"%@/JobQuery/Detail?&JobId=%ld",API_HOST_API_Workplace,JobId]

//----设置-----意见反馈
// 查看用户当天提交的反馈次数
#define API_FeedbackFrequency [NSString stringWithFormat:@"%@/Feedback/frequency",API_HOST_API_Workplace]

// 提交反馈意见
#define API_FeedbackAdd [NSString stringWithFormat:@"%@/Feedback/add",API_HOST_API_Workplace]

