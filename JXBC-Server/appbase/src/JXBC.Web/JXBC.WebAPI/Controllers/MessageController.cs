using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web.Http;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using JXBC.Passports;
using JXBC.Passports.Providers;
using JXBC.Workplace;
using JXBC.WebCore;
using JXBC.WebCore.ViewModels;

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 消息相关API
    /// </summary>
    [Authorize]
    public class MessageController : AuthenticatedApiController
    {
        /// <summary>
        /// 用户给猎头发送"发个简历"消息
        /// </summary>
        /// <param name="consultantPassportId">指定发送的猎头账号Id</param>
        /// <returns></returns>
        [HttpPost]
        public bool SendResumeRequest(long consultantPassportId)
        {
            if (consultantPassportId < 0) return false;
            var passport = UserPassport.FindById(consultantPassportId);
            if (null == passport || passport.ProfileType == ProfileType.UserProfile) return false;

            var message = string.Format("您可以将简历发送到我的邮箱：{0}", passport.Profile.Email);
            var toAccount = ThirdIMAccount.FindByPlatformAccountId(Passports.ModuleEnvironment.IMProviderName, ThirdIMAccount.BuildAccountName(MvcContext.Current.PassportId, ProfileType.UserProfile));
            var fromAccount = ThirdIMAccount.FindByPlatformAccountId(Passports.ModuleEnvironment.IMProviderName, ThirdIMAccount.BuildAccountName(consultantPassportId, ProfileType.OrganizationProfile));
            var isSent = ObjectIOCFactory.GetSingleton<IIMProvider>(Passports.ModuleEnvironment.IMProviderName)
                .SendMessage(toAccount.PlatformAccountId, fromAccount.PlatformAccountId, "txt", message, null);
            return isSent;
        }

        /// <summary>
        /// 发送"交换电话"请求
        /// #返回值：请求消息的Id
        /// </summary>
        /// <param name="toPassportId">指定发送的账号Id</param>
        /// <param name="toProfileType">指定发送的身份类型，[1:(UserProfile)向用户发送；2:(OrganizationProfile)向猎头发送]</param>
        /// <returns></returns>
        [HttpPost]
        public long BuildPhoneRequest(long toPassportId, int toProfileType)
        {
            if (toPassportId < 0) return -1;

            var message = new Message();
            message.MessageType = Message.PhoneType;
            message.Subject = "交换电话";            
            message.ToPassportId = toPassportId;
            message.FromPassportId = MvcContext.Current.PassportId;
            message.SentTime = DateTime.Now;

            if ((ProfileType)toProfileType == ProfileType.OrganizationProfile)
            {
                message.ToProfileType = ProfileType.OrganizationProfile;
                message.Content = string.Format("您好，交换个电话，聊聊工作呗？我的电话：{0}", MvcContext.Current.UserPassport.MobilePhone);
            }
            else
            {
                message.ToProfileType = ProfileType.UserProfile;
                message.Content = string.Format("您好，我是{0}，目前正在看新的工作机会，请问您有合适的工作机会推荐么？", MvcContext.Current.UserPassport.Profile.Nickname);
            }
            var saved = Message.AddNewMessage(message);
            return saved ? message.MessageId : 0;
        }

        /// <summary>
        /// 更新"交换电话"请求的状态
        /// </summary>
        /// <param name="messageId">(服务端返回的)请求消息的Id</param>
        /// <param name="agree">同意交换，还是拒绝</param>
        /// <returns></returns>
        [HttpPost]
        public bool UpdatePhoneRequest(long messageId, bool agree)
        {
            if (messageId < 0) return false;
            var message = Message.FindById(messageId);
            if(null != message && message.ToPassportId == MvcContext.Current.PassportId)
            {
                var extendParams = new Dictionary<string, object>();
                extendParams.Add("agree", agree ? "true":"false");
                message.ExtendParams = extendParams.ToJson();
                return message.Save();
            }

            return false;
        }

        /// <summary>
        /// 检查"交换电话"请求的状态
        /// #返回值：[-99：非正常请求API; -1:用户尚未处理；0:用户拒绝交换；1:用户同意交换]
        /// </summary>
        /// <param name="messageId">(服务端返回的)请求消息的Id</param>
        /// <returns></returns>
        [HttpGet]
        public int CheckPhoneRequest(long messageId)
        {
            if (messageId < 0) return -99;
            var message = Message.FindById(messageId);
            if (null != message)
            {
                if (string.IsNullOrEmpty(message.ExtendParams)) return -1; //未处理
                var extendParams = message.ExtendParams.ConvertEntity<Dictionary<string, object>>();
                if (extendParams.ContainsKey("agree") && extendParams["agree"].ToString() == "true")
                    return 1;   //同意
                else
                    return 0;   //拒绝
            }

            return -99;
        }


        /// <summary>
        /// 获得用户(指定身份类型)的系统消息列表
        /// </summary>
        /// <param name="toProfileType">用户的Profile类型；向前兼容：默认值为UserProfile</param>
        /// <param name="page"></param>
        /// <param name="size"></param>
        /// <returns></returns>
        [HttpGet]
        public IList<Message> SystemNotifications(int toProfileType = (int)ProfileType.UserProfile, int page = 1, int size = 10)
        {
            if (page < 1) page = 1;
            if (size < 1) size = 10;
            var pagination = new Pagination() { PageIndex = page, PageSize = size };
            var list = Message.FindSystemNotifications(MvcContext.Current.PassportId, (ProfileType)toProfileType, pagination);
            var result = list.ToEntities();

            //MessageContact.ClearNewMessageCount(MvcContext.Current.PassportId, (ProfileType)toProfileType, Message.SystemNotificationPassportId);

            return result;
        }
    }
}
