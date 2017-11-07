using JXBC.Passports;
using JXBC.Passports.Providers;
using JXBC.Workplace;
using M2SA.AppGenome;
using M2SA.AppGenome.Cache;
using M2SA.AppGenome.Logging;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Web;

namespace JXBC.Workplace
{
    /// <summary>
    /// 
    /// </summary>
    public static class MessageHelper
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        public static void SendHelloMessage(long passportId)
        {
            var message = new Message();
            message.ToPassportId = passportId;
            message.FromPassportId = Message.SystemNotificationPassportId;
            message.MessageType = Message.ImageType;
            message.ToProfileType = ProfileType.UserProfile;
            message.Subject = ModuleEnvironment.GetValueFromConfig<string>("hello:Subject", string.Empty);
            message.Picture = ModuleEnvironment.GetValueFromConfig<string>("hello:Picture", string.Empty);
            message.Url = "/page/hello";
            message.SentTime = DateTime.Now;
            Message.AddNewMessage(message);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="profile"></param>
        /// <param name="status"></param>
        /// <param name="rejectedReason"></param>
        public static void SendAuthenticateResult(OrganizationProfile profile, Passports.AttestationStatus status, string rejectedReason = null)
        {
            var message = new Message();
            if (status == Passports.AttestationStatus.Passed)
            {
                message.Subject = "身份认证成功通知";
                message.Content = "你好，你的身份认证已经通过审核。";
            }
            else if (status == Passports.AttestationStatus.Rejected)
            {
                message.Subject = "身份认证失败通知";
                message.Content = string.Format("你好，你的身份认证失败，失败原因：{0}；请上传相关资料重新认证。"
                    , rejectedReason);
            }
            else
            {
                return;
            }

            message.ToPassportId = profile.PassportId;
            message.MessageType = Message.TextType;
            message.ToProfileType = ProfileType.OrganizationProfile;
            message.FromPassportId = Message.SystemNotificationPassportId;
            message.SentTime = DateTime.Now;
            Message.AddNewMessage(message);
        }     

        private static readonly int SmsIntervalMinutes = 10;
        private static readonly string SmsAppSign = ConfigurationManager.AppSettings["SMS:AppSign"];
        private static readonly string SmsRegister = ConfigurationManager.AppSettings["SMS:Register"];
        private static readonly string SmsYTX_AccountSId = ConfigurationManager.AppSettings["SMS:YTX-AccountSId"];
        private static readonly string SmsYTX_AccountToken = ConfigurationManager.AppSettings["SMS:YTX-AccountToken"];
        private static readonly string SmsYTX_AppId = ConfigurationManager.AppSettings["SMS:YTX-AppId"];

        private static string GenerateAuthCode(int length)
        {
            string CodeString = "0123456789";
            StringBuilder sb = new StringBuilder();
            Random random = new Random();
            for (int i = 0; i < length; i++)
            {
                Thread.Sleep(1);
                sb.Append(CodeString[random.Next(0, CodeString.Length - 1)].ToString());
            }
            return sb.ToString();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="account"></param>
        /// <param name="clientIP"></param>
        /// <param name="phone"></param>
        /// <returns></returns>
        public static MessageResult SendSMSValidationCode(AnonymousAccount account, string clientIP, string phone)
        {
            var validationCode = GenerateAuthCode(6);
            if (false == CheckSMSSecurityStrategy(account, clientIP, phone))
            {
                return MessageResult.FailedResult("-1","短信发送受限");
            }


            var cache = CacheManager.GetCache(ModuleEnvironment.SMSCacheName);
            cache.Set(phone, validationCode);

            MessageResult result = null;

            if (SmsRegister.Contains("{0}"))
            {
                var smsContent = string.Format(SmsRegister, validationCode);
                result = SendSMS(account.PassportId, phone, smsContent);

                var smsMessage = new SmsMessage() { PassportId = account.PassportId, MobilePhone = phone, Content = smsContent, SendStatus = result.Success ? "Success" : "Failed", FailedReason = null == result.ErrorMessage ? result.ErrorCode : result.ErrorMessage };
                smsMessage.Save();
            }
            else
            {
                result = SendTempleteSMS(phone, SmsRegister, new string[] { validationCode, SmsIntervalMinutes.ToString() });
                var smsMessage = new SmsMessage() { PassportId = account.PassportId, MobilePhone = phone, Content = string.Format("验证码:{0}, 短信模板:{1}", validationCode, SmsRegister), SendStatus = result.Success ? "Success" : "Failed", FailedReason = null == result.ErrorMessage ? result.ErrorCode : result.ErrorMessage };
                smsMessage.Save();
            }

            LogManager.GetLogger().Info("SendSMSValidationCode[{0}] => {1} : {2}", result.Success, phone, validationCode);
            return result;
        }
         
        private static bool CheckSMSSecurityStrategy(AnonymousAccount account, string clientIP, string phone)
        {
            if (null == account || null == account.Token) return false;
            if (string.IsNullOrEmpty(clientIP)) return false;

            if (null != HttpContext.Current)
            {
                if (HttpContext.Current.Request.ServerVariables.AllKeys.Contains("HTTP_USER_AGENT") && null != ModuleEnvironment.SMSRejectUserAgents)
                {
                    var userAgent = HttpContext.Current.Request.ServerVariables["HTTP_USER_AGENT"].ToLower();
                    foreach (var item in ModuleEnvironment.SMSRejectUserAgents)
                    {
                        if (userAgent.Contains(item))
                        {
                            LogManager.GetLogger().Warn("CheckSMSSecurityStrategy[RejectUserAgents] failed! {0} [{1}::{2}::{3}] => {4} ", phone, account.Token.PassportId, clientIP, account.Token.AccessToken, userAgent);
                            return false;
                        }
                    }
                }
                if (null != ModuleEnvironment.SMSRejectIPs)
                {
                    foreach (var item in ModuleEnvironment.SMSRejectIPs)
                    {
                        if (clientIP.StartsWith(item))
                        {
                            LogManager.GetLogger().Warn("CheckSMSSecurityStrategy[RejectIPs] failed! {0} [{1}::{2}::{3}] ", phone, account.Token.PassportId, clientIP, account.Token.AccessToken);
                            return false;
                        }
                    }
                }
            }


            var cache = CacheManager.GetCache(ModuleEnvironment.SMSSecurityStrategyCache);

            // check Phone times
            var phoneTimes = cache.Get<int>(phone);            
            if (phoneTimes >= ModuleEnvironment.SMSSecurityMobilePhoneLimit)
            {
                LogManager.GetLogger().Warn("CheckSMSSecurityStrategy[MobilePhone] failed! {0} [{1}::{2}::{3}] => {4} ", phone, account.Token.PassportId, clientIP, account.Token.AccessToken, phoneTimes);
                return false;
            }

            // check Token times
            var tokenTimes = cache.Get<int>(account.Token.AccessToken);
            if (tokenTimes >= ModuleEnvironment.SMSSecurityTokenLimit)
            {
                LogManager.GetLogger().Warn("CheckSMSSecurityStrategy[AccessToken] failed! {0} [{1}::{2}::{3}] => {4} ", phone, account.Token.PassportId, clientIP, account.Token.AccessToken, tokenTimes);
                return false;
            }

            // check PassportId times
            var passportIdTimes = 0;            
            if (account.Token.PassportId > 0)
            {
                passportIdTimes = cache.Get<int>(account.Token.PassportId);
                if (passportIdTimes >= ModuleEnvironment.SMSSecurityPassportLimit)
                {
                    LogManager.GetLogger().Warn("CheckSMSSecurityStrategy[PassportId] failed! {0} [{1}::{2}::{3}] => {4} ", phone, account.Token.PassportId, clientIP, account.Token.AccessToken, passportIdTimes);
                    return false;
                }
            }

            // check ClientIP times
            var clientIPTimes = cache.Get<int>(clientIP);
            if (clientIPTimes >= ModuleEnvironment.SMSSecurityIPLimit)
            {
                LogManager.GetLogger().Warn("CheckSMSSecurityStrategy[ClientIP] failed! {0} [{1}::{2}::{3}] => {4} ", phone, account.Token.PassportId, clientIP, account.Token.AccessToken, clientIPTimes);
                return false;
            }

            cache.Set(phone, ++phoneTimes);
            cache.Set(account.Token.AccessToken, ++tokenTimes);
            cache.Set(clientIP, ++clientIPTimes);
            if (account.Token.PassportId > 0)
            {
                cache.Set(account.Token.PassportId, ++passportIdTimes);
            }

            LogManager.GetLogger().Info("CheckedSMSSecurityStrategy success! [{0}=>{1}] [{2}=>{3}] [{4}=>{5}] [{6}=>{7}] "
                , phone, phoneTimes
                , account.Token.AccessToken, tokenTimes
                , account.Token.PassportId, passportIdTimes
                , clientIP, clientIPTimes);

            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="phone"></param>
        /// <param name="validationCode"></param>
        /// <returns></returns>
        public static bool CheckSMSValidationCode(string phone, string validationCode)
        {
            if (phone.IsMatchMobilePhone() && false == string.IsNullOrEmpty(validationCode))
            {
                var cache = CacheManager.GetCache(ModuleEnvironment.SMSCacheName);
                var cacheCode = cache.Get<string>(phone);
                if (false == string.IsNullOrEmpty(cacheCode) && cacheCode == validationCode)
                {
                    return true;
                }
            }
            return false;
        }

        public static MessageResult SendTempleteSMS(string phone, string templeteId, string[] arsg)
        {
            phone.AssertNotNull("phone");
            templeteId.AssertNotNull("templeteId");
            arsg.AssertNotNull("arsg");

            if (false == new Regex(@"1\d{10}").IsMatch(phone))
            {
                return MessageResult.FailedResult("-1", "手机号不正确");
            }

            var apiClient = new CCPRestSDK.CCPRestSDK();
            bool isInit = apiClient.init("app.cloopen.com", "8883");
            apiClient.setAccount(SmsYTX_AccountSId, SmsYTX_AccountToken);
            apiClient.setAppId(SmsYTX_AppId);
            try
            {
                if (isInit)
                {
                    Dictionary<string, object> retData = apiClient.SendTemplateSMS(phone, templeteId, arsg);
                    if(null != retData && retData.ContainsKey("statusCode") && retData["statusCode"].ToString()== "000000")
                    {                        
                        return MessageResult.SuccessResult();
                    }
                    else
                    {
                        if (null != retData && retData.ContainsKey("statusCode"))
                        {
                            return MessageResult.FailedResult(retData["statusCode"].ToString(), retData["statusMsg"].ToString());
                        }
                        else
                        {
                            return MessageResult.FailedResult("-9", "发送失败");
                        }
                    }
                }
                else
                {
                    return MessageResult.FailedResult("-1", "初始化失败");
                }
            }
            catch (Exception exc)
            {
                return MessageResult.FailedResult("-"+exc.GetType().Name, exc.Message);                
            }
            finally
            {
                //Response.Write(ret);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizType"></param>
        /// <param name="passportId"></param>
        /// <param name="phone"></param>
        /// <param name="content"></param>
        /// <returns></returns>
        public static MessageResult SendSMS(string bizType, long passportId, string phone, string content)
        {
            if (!content.Contains(SmsAppSign))
                content = SmsAppSign + content;

                var result = SendSMS(passportId, phone, content);
            LogManager.GetLogger().Info("SendSMS[{0}：{1}] => {2} : {3}", result.Success, bizType, phone, content);

            var smsMessage = new SmsMessage() { PassportId = passportId, MobilePhone = phone, Content = content, SendStatus = result.Success ? "Success" : "Failed", FailedReason = null == result.ErrorMessage ? result.ErrorCode : result.ErrorMessage };
            smsMessage.Save();
            return result;
        }

        private static MessageResult SendSMS(long passportId, string phone, string content)
        {
            phone.AssertNotNull("phone");
            content.AssertNotNull("content");

            if (false == new Regex(@"1\d{10}").IsMatch(phone))
            {
                return MessageResult.FailedResult("-1", "手机号不正确");
            }


            const string urlpattern = "http://sdk.entinfo.cn/webservice.asmx/mdSmsSend?sn=SDK-BBX-010-23630&pwd=AF01B559B6B6CD0D1D259CC41B255347&mobile={0}&content={1}&ext=1&stime=&rrid=&msgfmt=";
            var url = string.Format(urlpattern, phone.Trim(), HttpUtility.UrlEncode(content, Encoding.GetEncoding("gb2312")));
            using (var client = new WebClient())
            {
                var stream = client.OpenRead(new Uri(url));
                if (stream != null)
                {
                    var reader = new StreamReader(stream);
                    var readResult = reader.ReadToEnd();
                    var re = new Regex(@"\-?\d{5,32}").Match(readResult).Value;
                    if (!string.IsNullOrEmpty(re) && re.Length > 6)
                    {
                        return MessageResult.SuccessResult();
                    }
                    else
                    {
                        return MessageResult.FailedResult("-9", readResult);
                    }
                }
                return MessageResult.FailedResult("-9");
            }
        }
    }
}
