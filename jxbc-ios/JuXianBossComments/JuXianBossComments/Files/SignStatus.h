
//定义网络状态的枚举
typedef NS_OPTIONS(NSInteger,SignStatus)
{
    SUCCESS = 1,//正常
    InvalidValidationCode = 2, // 验证码错误 [ 2 ] ,
    ERROR = 9,
    INVALID_EMAIL = 101,//邮箱格式错误
    INVALID_MOBILEPHONE = 102,//手机号格式错误
    INVALID_USERNAME = 103,//用户不符合要求
    INVALID_PASSWORD = 109,//密码不符合要求
    DUPLICATE_MOBILEPHONE = 202,//手机号重复 已经注册
    Duplicate_EntName = 204,//企业名称是否重复
    UserRejected = 999,//拒绝登录 账号被锁定了
    DuplicateUserName = 203//用户名重复，已经注册 [ 203 ] ,
};
//定义消息类型
enum NotificationType
{
    /// 系统消息
    SystemMessage = 1,
    /// 动态消息
    TrendMessage = 2
};
#pragma mark--- 系统通知类型
/// 邀请好友评价
static NSString *InviteFriendsEvaluate = @"InviteFriendsEvaluate";
/// 被好友评价
static NSString *EvaluatedByFriends = @"EvaluatedByFriends";
/// 被PK的信用结果
static NSString *CreditPKResult = @"CreditPKResult";
/// 删除动态
static NSString *DeleteTrend = @"DeleteTrend";
/// 删除评论
static NSString *DeleteComment = @"DeleteComment";
/// 评论变成热评
static NSString *CommentToHot = @"CommentToHot";
/// 信用升级
static NSString *CreditUp = @"CreditUp";
#pragma mark--- 动态消息类型
/// 动态被评论
static NSString *TrendBeComment = @"TrendBeComment";
/// 评论被评论
static NSString *CommentBeComment = @"CommentBeComment";
/// 动态被赞
static NSString *TrendBeLiker = @"TrendBeLiker";
/// 动态被分享
static NSString *TrendBeShare = @"TrendBeShare";
/// 评论被赞
static NSString *CommentBeLiker = @"CommentBeLiker";
