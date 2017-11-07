using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using M2SA.AppGenome.Reflection;
using M2SA.AppGenome.Logging;
using Newtonsoft.Json;
using M2SA.AppGenome;

namespace JXBC.TradeSystem.Providers
{
    /// <summary>
    /// 
    /// </summary>
    public class AlipayProvider : IPaymentProvider
    {
        #region Helper Methods

        private static StringBuilder BuildUrlQuery(IDictionary<string, string> queryParams)
        {
            var keys = queryParams.Keys.ToList();

            StringBuilder query = new StringBuilder();
            foreach (var key in keys)
            {
                var value = queryParams[key];
                if (false == string.IsNullOrEmpty(value))
                    query.Append(key + "=" + HttpUtility.UrlEncode(queryParams[key]) + "&");
            }

            query.Remove(query.Length - 1, 1);

            return query;
        }

        private static StringBuilder BuildSignParams(IDictionary<string, string> queryParams)
        {
            var keys = queryParams.Keys.ToList();
            keys.Sort();

            StringBuilder query = new StringBuilder();
            foreach (var key in keys)
            {
                var value = queryParams[key];
                if (false == string.IsNullOrEmpty(value))
                    query.Append(key + "=" + queryParams[key] + "&");
            }

            query.Remove(query.Length - 1, 1);

            return query;
        }

        private string Sign(IDictionary<string, string> requestParams)
        {
            var signedParams = BuildSignParams(requestParams);
            var sign = RSAProvider.GenerateSignature(this.PrivateKey, signedParams.ToString());
            return sign;
        }

        static string FormatParamName(string name)
        {
            var sb = new StringBuilder(64);
            foreach (var character in name)
            {
                var word = character.ToString();
                if (word.ToUpper() == word)
                {
                    sb.Append("_");
                }
                sb.Append(word.ToLower());
            }

            if (sb[0] == '_') sb.Remove(0, 1);

            return sb.ToString();
        }

        #endregion //helper methods

        #region Alipay Entities

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
            public string Method { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string ProductCode { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string TimeoutExpress { get; set; }
        }

        /// <summary>
        /// 
        /// </summary>
        public class AlipayResult
        {
            /// <summary>
            /// 
            /// </summary>
            public class AlipayResponse
            {
                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "app_id")]
                public string AppId { get; set; }

                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "msg")]
                public string Msg { get; set; }

                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "code")]
                public string Code { get; set; }

                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "trade_status")]
                public string TradeStatus { get; set; }

                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "trade_no")]
                public string TradeNO { get; set; }

                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "out_trade_no")]
                public string OutTradeNO { get; set; }

                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "total_amount")]
                public string TotalAmount { get; set; }

                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "qr_code")]
                public string QRCode { get; set; }

                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "buyer_user_id")]
                public string BuyerUserId { get; set; }

                /// <summary>
                /// 
                /// </summary>
                [JsonProperty(PropertyName = "buyer_logon_id")]
                public string BuyerLogonId { get; set; }
            }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "alipay_trade_app_pay_response")]
            public object TradeAppPayResponse { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "alipay_trade_query_response")]
            public object TradeQueryResponse { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "alipay_trade_precreate_response")]
            public object TradePrecreateResponse { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "sign")]
            public string Sign { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "sign_type")]
            public string SignType { get; set; }
        }

        #endregion //Alipay Entities

        private const string API_URI = "https://openapi.alipay.com/gateway.do";
        private const string API_HttpsVeryfyUrl = "https://mapi.alipay.com/gateway.do?service=notify_verify";
        private const string API_Refund = "alipay.trade.refund";
        private const string API_Query = "alipay.trade.query";
        private const string API_MethodName = "method";
        private const string API_TradePayResult = "alipay_trade_pay_result";
        private const string API_Code_Success = "10000";
        private const string API_MsgStatus_Success = "Success";
        private const string API_TradeStatus_Success = "TRADE_SUCCESS";

        #region Instance Properties
        /// <summary>
        /// 
        /// </summary>
        public string AppId { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string Charset { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Version { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string SignMethod { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Partner { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string SellerId { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string PrivateKey { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string PublicKey { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string H5PayUrl { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string NotifyUrl { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string ReturnUrl { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public IDictionary<string, PayRouteConfig> PayRoutes  { get; set; }

        #endregion //Instance Properties

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

            var signedParams = BuilderSignParams(tradeJournal);

            if(tradeJournal.PayRoute == PayWays.Route_H5)
            {
                tradeJournal.SignedParams = signedParams.ToJson();
                var code = ObjectIOCFactory.GetSingleton<PaymentEngine>().CacheSignedPayment(tradeJournal);
                var payUrl = this.H5PayUrl + "?code=" + code;
                return payUrl;
            }
            else if(tradeJournal.PayRoute == PayWays.Route_QRCODE)
            {
                var qrcode = this.LoadQRCodeContent(tradeJournal, signedParams);
                return qrcode;
            }
            else
            {
                var signedParamsQuery = BuildUrlQuery(signedParams).ToString();
                return signedParamsQuery.ToString();
            }
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

            var paymentDetail = new Dictionary<string, string>();

            var payResponseFirstKeys = new string[] { "{\"alipay_trade_app_pay_response\":", "{\"alipay_trade_query_response\":", "{\"alipay_trade_precreate_response\":" };
            var payResponseEndKey = ",\"sign\":\"";

            if (paymentResult.StartsWith("{") && paymentResult.Contains(payResponseEndKey))
            {
                foreach(var firstKey in payResponseFirstKeys)
                {
                    if (paymentResult.Contains(firstKey))
                    {
                        var alipayResult = paymentResult.ConvertEntity<AlipayProvider.AlipayResult>();
                        if (null == alipayResult.TradeAppPayResponse 
                            && null == alipayResult.TradeQueryResponse
                            && null == alipayResult.TradePrecreateResponse)
                            continue;                        

                        if (null != alipayResult.TradeAppPayResponse)
                        {
                            paymentDetail[API_MethodName] = this.PayRoutes[tradeSource.PayRoute].Method;
                            paymentDetail[API_TradePayResult] = alipayResult.TradeAppPayResponse.ToJson();
                        }
                        else if (null != alipayResult.TradeQueryResponse)
                        {
                            paymentDetail[API_MethodName] = API_Query;
                            paymentDetail[API_TradePayResult] = alipayResult.TradeQueryResponse.ToJson();
                        }
                        else if(null != alipayResult.TradePrecreateResponse)
                        {
                            paymentDetail[API_MethodName] = this.PayRoutes[tradeSource.PayRoute].Method;
                            paymentDetail[API_TradePayResult] = alipayResult.TradePrecreateResponse.ToJson();
                        }

                        paymentDetail["sign"] = alipayResult.Sign;
                        paymentDetail["sign_type"] = alipayResult.SignType;
                        break;
                    }
                }
            }
            else
            {
                var paidParams = paymentResult.Split('&');
                foreach (var item in paidParams)
                {
                    var pair = item.Split('=');
                    if (pair.Length > 1)
                        paymentDetail.Add(pair[0], HttpUtility.UrlDecode(string.Join("=", pair, 1, pair.Length - 1).Replace("\"", "")));
                }
                return paymentDetail;
            }

            return paymentDetail;
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
            var isVerified = this.VerifySignature(tradeSource, paymentDetail);

            if (isVerified)
            {
                return this.QueryPaidStatusFromAlipayGateway(tradeSource, paymentDetail);
            }
            return Tuple.Create(false, paymentDetail);
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

            AlipayResult.AlipayResponse alipayResponse = null;
            if (paymentDetail.ContainsKey(API_TradePayResult))
            {
                alipayResponse = paymentDetail[API_TradePayResult].ConvertEntity<AlipayProvider.AlipayResult.AlipayResponse>();
            }
            else 
            {
                alipayResponse = new AlipayResult.AlipayResponse();
                alipayResponse.TotalAmount = paymentDetail["total_amount"];
            }

            var credential = new PaymentCredential();
            credential.TotalFee = alipayResponse.TotalAmount.Convert<decimal>();
            return credential;
        }

        private IDictionary<string, string> BuilderSignParams(TradeJournal tradeJournal)
        {
            if(null == tradeJournal.PayRoute || null == this.PayRoutes || false == this.PayRoutes.ContainsKey(tradeJournal.PayRoute))
                throw new ArgumentOutOfRangeException("payment:PayRoute", string.Format("Not support the PayRoute : {0}-{1}", tradeJournal.PayWay, tradeJournal.PayRoute));

            var payRoute = this.PayRoutes[tradeJournal.PayRoute];

            var bizParams = new Dictionary<string, string>();
            bizParams["out_trade_no"] = tradeJournal.TradeCode;
            bizParams["total_amount"] = Math.Abs(tradeJournal.TotalFee).ToString("0.00");
            bizParams["subject"] = tradeJournal.CommoditySubject;
            bizParams["partner"] = this.Partner;
            bizParams["seller_id"] = this.SellerId;

            var ignoreParams = new string[] { "Name", "Method", "Sign", "SignType", "PrivateKey", "PublicKey" };
            var values = payRoute.GetPropertyValues();
            foreach (var item in values)
            {
                if (false == ignoreParams.Contains(item.Key) && null != item.Value)
                    bizParams[FormatParamName(item.Key)] = item.Value.ToString();
            }
            
            var signedParams = this.BuilderSignParams(payRoute.Method, bizParams);            

            return signedParams;
        }       

        private IDictionary<string, string> BuilderSignParams(string payMethod, IDictionary<string, string> bizParams)
        {
            var signedParams = new Dictionary<string, string>();
            signedParams["app_id"] = this.AppId;
            signedParams["charset"] = this.Charset;
            signedParams["timestamp"] = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
            signedParams["version"] = this.Version;
            signedParams["sign_type"] = this.SignMethod;
            signedParams["notify_url"] = this.NotifyUrl;
            signedParams["return_url"] = this.ReturnUrl;
            signedParams["method"] = payMethod;
            signedParams["biz_content"] = bizParams.ToJson();
            signedParams["sign"] = Sign(signedParams);

            return signedParams;
        }

        private bool VerifySignature(TradeJournal tradeSource, IDictionary<string, string> paymentDetail)
        {
            string signParams = null;
            if (paymentDetail.ContainsKey(API_TradePayResult))
            {
                signParams = paymentDetail[API_TradePayResult];
                var alipayResponse = paymentDetail[API_TradePayResult].ConvertEntity<AlipayProvider.AlipayResult.AlipayResponse>();
                
                if (alipayResponse.Code != API_Code_Success || alipayResponse.Msg != API_MsgStatus_Success
                    || alipayResponse.OutTradeNO != tradeSource.TradeCode)
                    return false;

                var apiMethod = paymentDetail[API_MethodName];
                if (apiMethod == API_Query)
                {
                    if (alipayResponse.TradeStatus != API_TradeStatus_Success)
                        return false;
                }
                else 
                {
                    if (false == string.IsNullOrEmpty(alipayResponse.AppId) && alipayResponse.AppId != this.AppId)
                        return false;
                    if (false == string.IsNullOrEmpty(alipayResponse.TradeStatus) && alipayResponse.TradeStatus != API_TradeStatus_Success)
                        return false;
                }
            }
            else
            {
                var ignoreParams = new string[] { "sign", "sign_type" };
                var signParamsDic = new Dictionary<string, string>();
                foreach (var item in paymentDetail)
                {
                    if (false == ignoreParams.Contains(item.Key) && null != item.Value)
                        signParamsDic[item.Key] = item.Value.ToString();
                }

                signParams = BuildSignParams(signParamsDic).ToString();
            }

            if (string.IsNullOrEmpty(signParams))
                return false;

            var isVerified = RSAProvider.VerifySignature(signParams, this.PublicKey, paymentDetail["sign"]);

            return isVerified;
        }

        private Tuple<bool, IDictionary<string, string>> QueryPaidStatusFromAlipayGateway(TradeJournal tradeSource, IDictionary<string, string> paymentDetail)
        {
            var bizParams = new Dictionary<string, string>();
            bizParams["out_trade_no"] = tradeSource.TradeCode;

            var signedParams = this.BuilderSignParams(API_Query, bizParams);
            var signedParamsQuery = BuildUrlQuery(signedParams).ToString();
            var requestUrl = string.Format("{0}?{1}", API_URI, signedParamsQuery);
            var responseText = new HttpDecorator().HttpGet(requestUrl, null).Content;
            if (false == string.IsNullOrEmpty(responseText))
            {
                LogManager.GetLogger().Info("==>paymentResult[QueryPaidStatusFromAlipayGateway]: {0}=>{1}", requestUrl, responseText);
                paymentDetail = this.ParsePaymentResult(tradeSource, responseText);
                var isVerified = this.VerifySignature(tradeSource, paymentDetail);
                return Tuple.Create(isVerified, paymentDetail);
            }
            return Tuple.Create(false, paymentDetail);
        }

        private string LoadQRCodeContent(TradeJournal tradeSource, IDictionary<string, string> signedParams)
        {  
            var signedParamsQuery = BuildUrlQuery(signedParams).ToString();
            var requestUrl = string.Format("{0}?{1}", API_URI, signedParamsQuery);
            var responseText = new HttpDecorator().HttpGet(requestUrl, null).Content;
            if (false == string.IsNullOrEmpty(responseText))
            {
                var paymentDetail = this.ParsePaymentResult(tradeSource, responseText);
                if (paymentDetail.ContainsKey(API_TradePayResult))
                {
                    var alipayResponse = paymentDetail[API_TradePayResult].ConvertEntity<AlipayProvider.AlipayResult.AlipayResponse>();
                    return alipayResponse.QRCode;
                }               
            }
            return null;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        /// <returns></returns>
        public Tuple<bool, string> Refund(TradeJournal tradeJournal)
        {
            tradeJournal.AssertNotNull("tradeJournal");

            var bizParams = new Dictionary<string, string>();
            bizParams["out_trade_no"] = tradeJournal.ParentTradeCode;
            bizParams["refund_amount"] = Math.Abs(tradeJournal.TotalFee).ToString("0.00");
            bizParams["operator_id"] = "system";

            var signedParams = this.BuilderSignParams(API_Refund, bizParams);
            var signedParamsQuery = BuildUrlQuery(signedParams).ToString();
            var requestUrl = string.Format("{0}?{1}", API_URI, signedParamsQuery);
            var responseText = new HttpDecorator().HttpGet(requestUrl, null).Content;
            if (false == string.IsNullOrEmpty(responseText))
            {
                LogManager.GetLogger().Info("==>paymentResult[Refund]: {0}=>{1}", requestUrl, responseText);
                var paymentDetail = this.ParsePaymentResult(tradeJournal, responseText);
                var isRefunded = this.VerifySignature(tradeJournal, paymentDetail);
                return Tuple.Create<bool, string>(isRefunded, paymentDetail.ToJson());
            }
            return Tuple.Create<bool, string>(false, null);
        }
    }
}
