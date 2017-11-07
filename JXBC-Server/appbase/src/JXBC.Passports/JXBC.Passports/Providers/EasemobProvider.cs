using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Newtonsoft.Json;
using M2SA.AppGenome.Configuration;
using M2SA.AppGenome.Logging;

namespace JXBC.Passports.Providers
{
    /// <summary>
    /// 
    /// </summary>
    public class EasemobProvider : ResolveObjectBase, IIMProvider
    {
        private static readonly string LoadAccessTokenApi = "https://a1.easemob.com/{0}/{1}/token";
        private static readonly string CreateAccountApi = "https://a1.easemob.com/{0}/{1}/users";
        private static readonly string ChangeAccountApi = "https://a1.easemob.com/{0}/{1}/users/{2}";
        private static readonly string SendMessageApi = "https://a1.easemob.com/{0}/{1}/messages";

        #region josn & request &  response

        private static T ConvertEntity<T>(HttpDecorator.HttpResponseResult responseResult)
        {
            responseResult.AssertNotNull("responseResult");

            var entity = JsonConvert.DeserializeObject<T>(responseResult.Content);

            return entity;
        }

        private static bool IsErrorResult(string json)
        {
            var isError = string.IsNullOrEmpty(json) || json.Contains("error");
            return isError;
        }

        private class LoadAccessTokenParams
        {
            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "grant_type")]
            public string GrantType { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "client_id")]
            public string ClientId { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "client_secret")]
            public string ClientSecret { get; set; }

        }

        private class AccessTokenResult
        {
            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "access_token")]
            public string AccessToken { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "expires_in")]
            public int ExpiresIn { get; set; }


            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "application")]
            public string Application { get; set; }

        }

        private class CreateAccountParams
        {
            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "username")]
            public string Username { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "password")]
            public string Password { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "nickname")]
            public string Nickname { get; set; }

        }

        private class SendMessageParams
        {
            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "target_type")]
            public string TargetType { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "target")]
            public string[] Target { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "msg")]
            public SendMessageParams_Message Message { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "from")]
            public string From { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "ext")]
            public IDictionary<string,object> ExtParams { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public class SendMessageParams_Message
            {
                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "type")]
                public string Type { get; set; }
                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "msg")]
                public string Msg { get; set; }
            }
        }

        #endregion // josn request &  response

        #region Instance Properties
        /// <summary>
        /// 
        /// </summary>
        public string OrgName { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string AppName { get; set; }
        
        /// <summary>
        /// 
        /// </summary>
        public string ClientId { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string ClientSecret { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string AccessToken { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public DateTime Expires { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public bool IsEffectived
        {
            get { return false == string.IsNullOrEmpty(this.AccessToken) && DateTime.Now < this.Expires; }
        }

        #endregion //Instance Properties
       

        /// <summary>
        /// 
        /// </summary>
        /// <param name="imAccount"></param>
        /// <returns></returns>
        public bool CreateAccount(ThirdIMAccount imAccount)
        {
            if (false == this.LoadAccessToken())
                return false;
            
            var createAccountUrl = string.Format(CreateAccountApi, this.OrgName, this.AppName);
            var data = new CreateAccountParams()
            {
                Username = imAccount.PlatformAccountId,
                Password = imAccount.PlatformAccountPassword,
                Nickname = imAccount.Nickname
            };

            var tokenResponse = HttpJson(HttpDecorator.HttpMethod.POST, createAccountUrl, data);
            if (IsErrorResult(tokenResponse.Content))
            {
                LogManager.GetLogger().Error("Easemob-Error(CreateAccount): {0}[{1},{2}] => {3}", createAccountUrl, this.AccessToken, imAccount.PlatformAccountId, tokenResponse.Content);
                return false;
            }
            else
            {
                LogManager.GetLogger().Info("Easemob-Result(CreateAccount): {0}[{1},{2}] => {3}",  createAccountUrl, this.AccessToken, imAccount.PlatformAccountId, tokenResponse.Content);
                return true;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="imAccount"></param>
        /// <returns></returns>
        public bool ChangeNickname(ThirdIMAccount imAccount)
        {
            if (false == this.LoadAccessToken())
                return false;

            var changeAccountUrl = string.Format(ChangeAccountApi, this.OrgName, this.AppName, imAccount.PlatformAccountId);
            var data = new CreateAccountParams()
            {
                Nickname = imAccount.Nickname
            };

            var tokenResponse = HttpJson(HttpDecorator.HttpMethod.PUT, changeAccountUrl, data);
            if (IsErrorResult(tokenResponse.Content))
            {
                LogManager.GetLogger().Error("Easemob-Error(ChangeNickname): {0}[{1},{2}] => {3}", changeAccountUrl, this.AccessToken, imAccount.PlatformAccountId, tokenResponse.Content);
                return false;
            }
            else
            {
                LogManager.GetLogger().Info("Easemob-Result(ChangeNickname): {0}[{1},{2}] => {3}", changeAccountUrl, this.AccessToken, imAccount.PlatformAccountId, tokenResponse.Content);
                return true;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="toAccount"></param>
        /// <param name="fromAccount"></param>
        /// <param name="messageType"></param>
        /// <param name="message"></param>
        /// <param name="extParams"></param>
        /// <returns></returns>
        public bool SendMessage(string toAccount, string fromAccount, string messageType, string message, IDictionary<string, object> extParams)
        {
            if (false == this.LoadAccessToken())
                return false;
            
            var sendMessageUrl = string.Format(SendMessageApi, this.OrgName, this.AppName);
            var data = new SendMessageParams()
            {
                TargetType = "users",   //给用户发消息
                Target = new string[] { toAccount },
                From = fromAccount,
                ExtParams = extParams,
                Message = new SendMessageParams.SendMessageParams_Message()
                {
                    Type = messageType,
                    Msg = message
                }
            };

            var tokenResponse = HttpJson(HttpDecorator.HttpMethod.POST, sendMessageUrl, data);
            if (IsErrorResult(tokenResponse.Content))
            {
                LogManager.GetLogger().Error("Easemob-Error(SendMessage): {0}[{1},{2}] => {3}", sendMessageUrl, this.AccessToken, fromAccount, JsonConvert.SerializeObject(data));
                return false;
            }
            else
            {
                LogManager.GetLogger().Info("Easemob-Result(SendMessage): {0}[{1},{2}] => {3}", sendMessageUrl, this.AccessToken, fromAccount, JsonConvert.SerializeObject(data));
                return true;
            }
        }


        private bool LoadAccessToken()
        {
            if (this.IsEffectived) return true;

            var loadAccessTokenUrl = string.Format(LoadAccessTokenApi, this.OrgName, this.AppName);
            var data = new LoadAccessTokenParams()
            {
                GrantType = "client_credentials",
                ClientId = this.ClientId,
                ClientSecret = this.ClientSecret
            };
            var tokenResponse = HttpJson(HttpDecorator.HttpMethod.POST, loadAccessTokenUrl, data);

            AccessTokenResult tokenResult = null;
            if (IsErrorResult(tokenResponse.Content))
            {
                LogManager.GetLogger().Error("Easemob-Error(LoadAccessToken): {0}", tokenResponse.Content);
                return false;
            }
            else
            {
                tokenResult = JsonConvert.DeserializeObject<AccessTokenResult>(tokenResponse.Content);
                this.AccessToken = tokenResult.AccessToken;
                this.Expires = DateTime.Now.AddSeconds(tokenResult.ExpiresIn - 60);
                return true;
            }
        }

        private HttpDecorator.HttpResponseResult HttpJson(HttpDecorator.HttpMethod httpMethod, string url, object data)
        {
            var tokenHeaders = new Dictionary<string, string>(2);
            if (this.IsEffectived)
                tokenHeaders.Add("Authorization", string.Concat("Bearer ", this.AccessToken));
            var result = new HttpDecorator().HttpJson(httpMethod, url, JsonConvert.SerializeObject(data), tokenHeaders);
            if(result.StatusCode != System.Net.HttpStatusCode.OK)
            {
                LogManager.GetLogger().Error("Easemob-API: {0} <= {1}", (int)result.StatusCode, url);
            }
            return result;
        }
    }
}
