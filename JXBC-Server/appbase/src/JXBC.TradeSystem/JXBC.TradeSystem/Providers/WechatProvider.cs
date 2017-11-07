using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Reflection;
using System.Web.Security;
using System.Xml;
using System.IO;
using System.Web;
using System.Net.Security;
using System.Net;
using System.Security.Cryptography.X509Certificates;
using Newtonsoft.Json;
using M2SA.AppGenome;
using M2SA.AppGenome.Configuration;
using M2SA.AppGenome.Logging;
using M2SA.AppGenome.Reflection;
using System.Security.Cryptography;
using JXBC.Passports.Security;

namespace JXBC.TradeSystem.Providers
{
    /// <summary>
    /// 
    /// </summary>
    public class WechatProvider : ResolveObjectBase, IPaymentProvider
    {
        /// <summary>
        /// 
        /// </summary>
        public const string SuccessCallbackResult = "<xml><return_code>SUCCESS</return_code><return_msg>[OK></return_msg></xml>";

        /// <summary>
        /// 
        /// </summary>
        public const string FailCallbackResult = "<xml><return_code>FAIL</return_code></xml>";

        #region Helper Methods

        private string Sign(IDictionary<string, string> requestParams, string key)
        {
            var signedParams = BuildUrlSignParams(requestParams);
            signedParams.AppendFormat("&key={0}", key);

            return HashHelper.ComputeHash(signedParams.ToString(), HashAlgorithmName.MD5);

            var md5 = MD5.Create();
            var bs = md5.ComputeHash(Encoding.UTF8.GetBytes(signedParams.ToString()));
            var sign = new StringBuilder();
            foreach (byte b in bs)
            {
                sign.Append(b.ToString("x2"));
            }
            return sign.ToString().ToUpper();
        }

        private static string GenerateTimeStamp()
        {
            return Convert.ToInt64((DateTime.Now - new DateTime(1970, 1, 1)).TotalSeconds).ToString();
        }
        private static StringBuilder BuildUrlSignParams(IDictionary<string, string> queryParams)
        {
            var keys = queryParams.Keys.ToList();
            keys.Sort();

            StringBuilder query = new StringBuilder();
            foreach (var key in keys)
            {
                var value = queryParams[key];
                if(false == string.IsNullOrEmpty(value))
                    query.Append(key + "=" + queryParams[key] + "&");
            }

            query.Remove(query.Length - 1, 1);

            return query;
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="xmlParams"></param>
        /// <returns></returns>
        public static string ToXmlParams(IDictionary<string, string> xmlParams)
        {
            var xmlBuilder = new StringBuilder();
            xmlBuilder.Append("<xml>");
            foreach (var item in xmlParams)
            {
                if (false == string.IsNullOrEmpty(item.Value))
                    xmlBuilder.AppendFormat("<{0}>{1}</{0}>", item.Key, item.Value);
            }
            xmlBuilder.Append("</xml>");
            return xmlBuilder.ToString();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="xml"></param>
        /// <returns></returns>
        public static IDictionary<string, string> ToDictionary(string xml)
        {
            if (string.IsNullOrEmpty(xml) || false == xml.Contains("<xml>"))
                return null;

            var result = new Dictionary<string, string>();
            var xmlDoc = new XmlDocument();
            xmlDoc.LoadXml(xml);
            var elements = xmlDoc.DocumentElement.ChildNodes;
            foreach(XmlNode node in xmlDoc.DocumentElement.ChildNodes)
            {
                if(node.NodeType == XmlNodeType.Element)
                {
                    result[node.Name] = node.InnerText;
                }
            }
            return result;
        }

        #endregion //helper methods     

        #region Wechat Entities

        /// <summary>
        /// 
        /// </summary>
        public class PayRouteConfig
        {
            /// <summary>
            /// 
            /// </summary>
            public string Name { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string AppId { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public string AppSecret { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public string Partner { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public string PartnerSecret { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public string CertFile { get; set; }
            /// <summary>
            /// 
            /// </summary>
            public string NotifyUrl { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string TradeType { get; set; }
        }

        /// <summary>
        /// 
        /// </summary>
        public class AccessTokenResult
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
        }

        /// <summary>
        /// 
        /// </summary>
        public class AuthorizationRequest
        {
            /// <summary>
            /// 
            /// </summary>
            public string ClientId { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string ResponseType { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string RedirectUri { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string State { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string Scope { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string Display { get; set; }

            /// <summary>
            /// 
            /// </summary>
            /// <returns></returns>
            public override string ToString()
            {
                var paramBuffer = new StringBuilder();
                paramBuffer.AppendFormat("appid={0}", this.ClientId);
                paramBuffer.AppendFormat("&redirect_uri={0}", HttpUtility.UrlEncode(this.RedirectUri));
                paramBuffer.AppendFormat("&response_type={0}", this.ResponseType);
                paramBuffer.AppendFormat("&scope={0}", this.Scope);
                paramBuffer.AppendFormat("&state={0}", string.IsNullOrEmpty(this.State) ? "999" : this.State);
                if (false == string.IsNullOrEmpty(this.Display))
                    paramBuffer.AppendFormat("&display={0}", this.Display);

                return paramBuffer.ToString();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        public class AuthorizationInfo
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
            [JsonProperty(PropertyName = "refresh_token")]
            public string RefreshToken { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "openid")]
            public string OpenId { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "scope")]
            public string scope { get; set; }
        }

        #endregion //Wechat Entities

        private const string API_UnifiedOrder = "https://api.mch.weixin.qq.com/pay/unifiedorder";
        private const string API_QueryOrder = "https://api.mch.weixin.qq.com/pay/orderquery";
        private const string API_Refund = "https://api.mch.weixin.qq.com/secapi/pay/refund";
        private const string API_APPAccessTokenApi = "https://api.weixin.qq.com/cgi-bin/token?grant_type=client_credential&appid={0}&secret={1}";
        private const string API_OAuthAuthorizationURI = "https://open.weixin.qq.com/connect/oauth2/authorize";
        private const string API_OAuthAccessTokenURI = "https://api.weixin.qq.com/sns/oauth2/access_token";

        #region Instance Properties
        /// <summary>
        /// 
        /// </summary>
        public string AppId { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string AppSecret { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string Partner { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string PartnerSecret { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string H5PayUrl { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string AuthRouteUrl { get; set; }        

        /// <summary>
        /// 
        /// </summary>
        public string CertFile { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string NotifyUrl { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public IDictionary<string, PayRouteConfig> PayRoutes { get; set; }

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        /// <param name="config"></param>
        public override void Initialize(IConfigNode config)
        {
            base.Initialize(config);
            if (null == this.PayRoutes || this.PayRoutes.Count < 1)
                return;

            var providerValues = this.GetPropertyValues();
            var routeProperties = typeof(PayRouteConfig).GetPersistProperties();

            foreach (var routeItem in this.PayRoutes)
            {
                var payRoute = routeItem.Value;
                var propValues = payRoute.GetPropertyValues();
                var appendPropValues = new Dictionary<string, object>();

                foreach (var propItem in providerValues)
                {
                    if (routeProperties.ContainsKey(propItem.Key) && (false==propValues.ContainsKey(propItem.Key) || null==propValues[propItem.Key]))
                        appendPropValues.Add(propItem.Key, propItem.Value);
                }

                if (appendPropValues.Count > 0)
                    payRoute.SetPropertyValues(appendPropValues);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        /// <returns></returns>
        public string GenerateSignedParams(TradeJournal tradeJournal)
        {
            tradeJournal.AssertNotNull("tradeJournal");
            if (null == tradeJournal.PayRoute || null == this.PayRoutes || false == this.PayRoutes.ContainsKey(tradeJournal.PayRoute))
                throw new ArgumentOutOfRangeException("payment:PayRoute", string.Format("Not support the PayRoute : {0}-{1}", tradeJournal.PayWay, tradeJournal.PayRoute));

            if (tradeJournal.PayRoute == PayWays.Route_H5)
            {
                var authorizationUrl = this.BuildAuthorizationUrl(tradeJournal);
                return authorizationUrl;                
            }

            var orderParams = UnifiedOrder(tradeJournal);
            if (null == orderParams)
                return null;

            var prepayId = orderParams["prepay_id"];
            if (tradeJournal.PayRoute == PayWays.Route_QRCODE)
            {
                var qrcode = orderParams["code_url"];
                return qrcode;
            }
            else
            {
                var payParams = BuildPayParamsWithAPP(tradeJournal, prepayId);
                return payParams.ToJson();
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="authCode"></param>
        /// <param name="tradeCode"></param>
        /// <returns></returns>
        public string GenerateH5SignedParams(string authCode, string tradeCode)
        {
            authCode.AssertNotNull("openId");
            tradeCode.AssertNotNull("tradeCode");

            var tradeJournal = TradeJournal.FindById(tradeCode);
            if(null == tradeJournal || tradeJournal.TradeStatus != TradeStatus.WaitingPayment)
                return null;
           
            var authInfo = this.LoadAuthorizationInfo(tradeJournal.PayRoute, authCode);
            if (null == authInfo && string.IsNullOrEmpty(authInfo.OpenId))
                return null;

            PaymentEngine.EnableTestTotalFee(tradeJournal);

            var orderParams = UnifiedOrder(tradeJournal, authInfo.OpenId);
            if (null == orderParams)
                return null;
            
            var payParams = BuildPayParamsWithH5(tradeJournal, orderParams["prepay_id"]);
            return payParams.ToJson();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeSource"></param>
        /// <param name="paymentResult"></param>
        /// <returns></returns>
        public IDictionary<string, string> ParsePaymentResult(TradeJournal tradeSource, string paymentResult)
        {
            paymentResult.AssertNotNull("paymentDetail");
            return ToDictionary(paymentResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeSource"></param>
        /// <param name="paymentDetail"></param>
        /// <returns></returns>
        public Tuple<bool, IDictionary<string, string>> VerifyPaymentResult(TradeJournal tradeSource, IDictionary<string, string> paymentDetail)
        {
            paymentDetail.AssertNotNull("paymentDetail");
            if(false == paymentDetail.ContainsKey("out_trade_no"))
                return Tuple.Create(false, paymentDetail);

            var payRoute = this.PayRoutes[tradeSource.PayRoute];

            if (paymentDetail.ContainsKey("sign"))
            {
                var signValue = paymentDetail["sign"];
                paymentDetail.Remove("sign");
                var paymentSign = Sign(paymentDetail, payRoute.PartnerSecret);
                
                if(paymentSign != signValue)
                    return Tuple.Create(false, paymentDetail);
            }

            var paymentResult = QueryOrderResult(tradeSource);

            if(null == paymentResult || false == paymentResult.ContainsKey("sign"))
            {
                LogManager.GetLogger().Warn("QueryOrderResult is null. [{0}]", paymentDetail.ToJson());
                return Tuple.Create(false, paymentDetail);
            }

            var sourceSign = paymentResult["sign"];
            paymentResult.Remove("sign");
            var resultSign = Sign(paymentResult, payRoute.PartnerSecret);
            var isVerified = (resultSign == sourceSign) && paymentResult["return_code"] == "SUCCESS" && paymentResult["result_code"] == "SUCCESS";
            return Tuple.Create(isVerified, paymentResult);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeSource"></param>
        /// <param name="paymentDetail"></param>
        /// <returns></returns>
        public PaymentCredential BuildPaymentCredential(TradeJournal tradeSource, IDictionary<string, string> paymentDetail)
        {
            paymentDetail.AssertNotNull("paymentDetail");
            var credential = new PaymentCredential();
            credential.TotalFee = paymentDetail["total_fee"].Convert<decimal>() / ModuleEnvironment.DBCurrencyUnit;
            return credential;
        }

        private string BuildAuthorizationUrl(TradeJournal tradeJournal)
        {
            var payRoute = this.PayRoutes[tradeJournal.PayRoute];
            var h5PayUrl = this.H5PayUrl + (this.H5PayUrl.Contains("?") ? "&" : "?") + "out_trade_no=" + tradeJournal.TradeCode;
            var authCallbackUrl = this.AuthRouteUrl + (this.AuthRouteUrl.Contains("?") ? "&" : "?") + "redirect_uri=" + HttpUtility.UrlEncode(h5PayUrl);

            var authorizationRequest = new AuthorizationRequest()
            {
                ResponseType = "code",
                Scope = "snsapi_base",
                ClientId = payRoute.AppId,                
                RedirectUri = authCallbackUrl

            };
            var authorizationUrl = string.Format("{0}?{1}#wechat_redirect", API_OAuthAuthorizationURI, authorizationRequest.ToString());
            return authorizationUrl;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="payRouteName"></param>
        /// <param name="authCode"></param>
        /// <returns></returns>
        private AuthorizationInfo LoadAuthorizationInfo(string payRouteName, string authCode)
        {
            var payRoute = this.PayRoutes[payRouteName];
            var tokenParams = new List<KeyValuePair<string, object>>();
            tokenParams.Add("appid", payRoute.AppId);
            tokenParams.Add("secret", payRoute.AppSecret);
            tokenParams.Add("code", authCode);
            tokenParams.Add("grant_type", "authorization_code");

            var httpResult = new HttpDecorator().HttpPost(API_OAuthAccessTokenURI, tokenParams);
            var authInfo = httpResult.Content.ConvertEntity<AuthorizationInfo>();
            return authInfo;
        }

        private IDictionary<string, string> UnifiedOrder(TradeJournal tradeJournal, string openId = null)
        {
            var payRoute = this.PayRoutes[tradeJournal.PayRoute];
            var signParams = new Dictionary<string, string>();
            signParams["appid"] = payRoute.AppId;
            signParams["mch_id"] = payRoute.Partner;
            signParams["notify_url"] = payRoute.NotifyUrl;
            signParams["trade_type"] = payRoute.TradeType;
            signParams["nonce_str"] = Guid.NewGuid().ToString("N");            
            signParams["body"] = tradeJournal.CommoditySubject;
            signParams["out_trade_no"] = tradeJournal.TradeCode;
            signParams["total_fee"] = ((int)(Math.Abs(tradeJournal.TotalFee)*100)).ToString();
            signParams["spbill_create_ip"] = tradeJournal.ClientIP;
            if(tradeJournal.PayRoute == PayWays.Route_H5)
            {
                signParams["device_info"] = "WEB"; 
                signParams["openid"] = openId;
            }
            else if (tradeJournal.PayRoute == PayWays.Route_QRCODE)
            {
                signParams["product_id"] = tradeJournal.TradeCode;
            }

            signParams["sign"] = Sign(signParams, payRoute.PartnerSecret);

            var responseText = new HttpDecorator().HttpPostXml(API_UnifiedOrder, ToXmlParams(signParams), null).Content;
            var orderParams = ToDictionary(responseText);

            if (null == orderParams || false == orderParams.ContainsKey("result_code") || orderParams["result_code"] != "SUCCESS")
                return null;

            if (false == orderParams.ContainsKey("prepay_id"))
                return null;

            return orderParams;
        }

        private IDictionary<string, string> BuildPayParamsWithAPP(TradeJournal tradeJournal, string prepayId)
        {
            var payRoute = this.PayRoutes[tradeJournal.PayRoute];

            var payParams = new Dictionary<string, string>();
            payParams["appid"] = payRoute.AppId;
            payParams["partnerid"] = payRoute.Partner;
            payParams["package"] = "Sign=WXPay";
            payParams["prepayid"] = prepayId;
            payParams["noncestr"] = Guid.NewGuid().ToString("N");
            payParams["timestamp"] = GenerateTimeStamp();
            payParams["sign"] = Sign(payParams, payRoute.PartnerSecret);

            return payParams;
        }

        private IDictionary<string, string> BuildPayParamsWithH5(TradeJournal tradeJournal, string prepayId)
        {
            var payRoute = this.PayRoutes[tradeJournal.PayRoute];

            var payParams = new Dictionary<string, string>();
            payParams["appId"] = payRoute.AppId;
            payParams["timeStamp"] = GenerateTimeStamp();
            payParams["nonceStr"] = Guid.NewGuid().ToString("N");
            payParams["package"] = string.Format("prepay_id={0}", prepayId);
            payParams["signType"] = "MD5";            
            payParams["paySign"] = Sign(payParams, payRoute.PartnerSecret);

            return payParams;
        }

        private IDictionary<string, string> QueryOrderResult(TradeJournal tradeSource)
        {
            var payRoute = this.PayRoutes[tradeSource.PayRoute];

            var orderParams = new Dictionary<string, string>();
            orderParams["appid"] = payRoute.AppId;
            orderParams["mch_id"] = payRoute.Partner;
            orderParams["out_trade_no"] = tradeSource.TradeCode;
            orderParams["nonce_str"] = Guid.NewGuid().ToString("N");
            orderParams["sign"] = Sign(orderParams, payRoute.PartnerSecret);

            var responseText = SendRequestWithCertificate(API_QueryOrder, ToXmlParams(orderParams), payRoute.CertFile, payRoute.Partner);
            var orderResult = ToDictionary(responseText);

            LogManager.GetLogger().Info("==>paymentResult[QueryOrderResult]: {0}=>{1}", API_QueryOrder, responseText);

            return orderResult;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        /// <returns></returns>
        public Tuple<bool, string> Refund(TradeJournal tradeJournal)
        {
            tradeJournal.AssertNotNull("tradeJournal");

            var payRoute = this.PayRoutes[tradeJournal.PayRoute];

            var orderParams = new Dictionary<string, string>();
            orderParams["appid"] = payRoute.AppId;
            orderParams["mch_id"] = payRoute.Partner;            
            orderParams["nonce_str"] = Guid.NewGuid().ToString("N");
            orderParams["op_user_id"] = "system";
            orderParams["out_trade_no"] = tradeJournal.ParentTradeCode;
            orderParams["out_refund_no"] = tradeJournal.TradeCode;
            orderParams["total_fee"] = ((int)(tradeJournal.TotalFee * ModuleEnvironment.DBCurrencyUnit)).ToString();
            orderParams["refund_fee"] = orderParams["total_fee"];
            orderParams["sign"] = Sign(orderParams, payRoute.PartnerSecret);
            
            var responseText = SendRequestWithCertificate(API_Refund, ToXmlParams(orderParams), payRoute.CertFile, payRoute.Partner);
            if(false == string.IsNullOrEmpty(responseText))
            {
                var orderResult = ToDictionary(responseText);
                var isRefunded = orderResult.ContainsKey("return_code") && orderResult["return_code"] == "SUCCESS";
                if(false == isRefunded)
                {
                    LogManager.GetLogger().Info("Refund Trade '{0}' result:{1}", tradeJournal.ParentTradeCode, orderResult);
                }
                return Tuple.Create<bool, string>(isRefunded, orderResult.ToJson());
            }
            return Tuple.Create<bool, string>(false, null);
        }


        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        private string SendRequestWithCertificate(string url, string xmlData, string certFile, string certPassword)
        {
            try
            {
                string cert = FileHelper.GetFullPath(certFile);
                string password = certPassword;

                byte[] buffer = Encoding.UTF8.GetBytes(xmlData);

                LogManager.GetLogger().Warn("Load Certificate [{0}：{1}]", password, cert);
                ServicePointManager.ServerCertificateValidationCallback = (sender, cer, chain, errors) => true;
                X509Certificate certificate = new X509Certificate(cert, password);
                HttpWebRequest httpRequest = (HttpWebRequest)HttpWebRequest.Create(url);
                httpRequest.ClientCertificates.Add(certificate);
                httpRequest.KeepAlive = false;
                httpRequest.Method = "post";
                httpRequest.ContentType = "application/xml";
                httpRequest.ContentLength = buffer.Length;

                using (var postStream = httpRequest.GetRequestStream())
                {
                    postStream.Write(buffer, 0, buffer.Length);
                }

                HttpWebResponse webreponse = (HttpWebResponse)httpRequest.GetResponse();
                Stream stream = webreponse.GetResponseStream();
                string result = string.Empty;
                using (StreamReader reader = new StreamReader(stream))
                {
                    result = reader.ReadToEnd();
                }
                return result;
            }
            catch (Exception ex)
            {
                ex.HandleException();
                return null;
            }
        }
    }
}
