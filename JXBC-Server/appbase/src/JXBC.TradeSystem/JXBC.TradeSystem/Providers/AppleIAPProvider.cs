using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Reflection;
using M2SA.AppGenome.Logging;
using Newtonsoft.Json;

namespace JXBC.TradeSystem.Providers
{
    /// <summary>
    /// 
    /// </summary>
    public class AppleIAPProvider : IPaymentProvider
    {
        #region AppleIAPP Entities

        /// <summary>
        /// 
        /// </summary>
        public class Product
        {
            /// <summary>
            /// 
            /// </summary>
            public string Name { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string ProductCode { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public decimal Price { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public decimal GoldCoins { get; set; }
        }

        /// <summary>
        /// 
        /// </summary>
        public class VerifyResult
        {
            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "status")]
            public string Status { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "exception")]
            public string Exception { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "receipt")]
            public object Receipt { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "environment")]
            public string Environment { get; set; }
        }

        #endregion //Alipay Entities

        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public string ProductVerifyApi { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string SandboxVerifyApi { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string VerifyPassword { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public IDictionary<string, Product> Products { get; set; }

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizSource"></param>
        /// <returns></returns>
        public Product GetProductJson(string bizSource)
        {
            bizSource.AssertNotNull(bizSource);

            if (false == this.Products.ContainsKey(bizSource))
                throw new ArgumentOutOfRangeException("bizSource", string.Format("AppleIAP Not support the bizSource : {0}", bizSource));

            return this.Products[bizSource];
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        /// <returns></returns>
        public string GenerateSignedParams(TradeJournal tradeJournal)
        {
            tradeJournal.AssertNotNull("tradeJournal");
            return this.GetProductJson(tradeJournal.BizSource).ToJson();
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

            var result = new Dictionary<string, string>();
            result["PaymentResult"] = paymentResult;
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeSource"></param>
        /// <param name="paymentDetail"></param>
        /// <returns></returns>
        public Tuple<bool, IDictionary<string, string>> VerifyPaymentResult(TradeJournal tradeSource, IDictionary<string, string> paymentDetail)
        {
            if(null == paymentDetail || false == paymentDetail.ContainsKey("PaymentResult"))
                return Tuple.Create(false, paymentDetail);

            var orderParams = new Dictionary<string, string>();
            orderParams.Add("receipt-data",paymentDetail["PaymentResult"]);
            if(false == string.IsNullOrEmpty(this.VerifyPassword))
                orderParams.Add("password", this.VerifyPassword);

            var verifyResponse = new HttpDecorator().HttpPostJson(this.ProductVerifyApi, orderParams.ToJson(), null);
            var verifyJson = verifyResponse.Content;
            if (string.IsNullOrEmpty(verifyJson) && null != verifyResponse.Stream && verifyResponse.Stream.Length > 0)
            {
                verifyJson = Encoding.UTF8.GetString(verifyResponse.Stream);
            }            

            var verifyResult = verifyJson.ConvertEntity<VerifyResult>();
            if (null != verifyResult && verifyResult.Status == "21007")
            {
                //测试环境下，请求沙盒验证
                paymentDetail["Sandbox"] = "true";
                verifyResponse = new HttpDecorator().HttpPostJson(this.SandboxVerifyApi, orderParams.ToJson(), null);
                verifyJson = verifyResponse.Content;
                if (string.IsNullOrEmpty(verifyJson) && null != verifyResponse.Stream && verifyResponse.Stream.Length > 0)
                {
                    verifyJson = Encoding.UTF8.GetString(verifyResponse.Stream);
                }
                verifyResult = verifyJson.ConvertEntity<VerifyResult>();
            }

            paymentDetail.Clear();
            var verifySuccess = false;
            if (null != verifyResult)
            {
                verifySuccess = verifyResult.Status == "0";
                var verifyDetail = verifyResult.GetPropertyValues();
                foreach(var item in verifyDetail)
                {
                    if(null != item.Value)
                        paymentDetail.Add(item.Key, item.Value.ToString());
                }
            }
            LogManager.GetLogger().Info("==>verifyResult: {0}", verifyJson);

            return Tuple.Create(verifySuccess, paymentDetail);
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
            credential.TotalFee = tradeSource.TotalFee;
            if (paymentDetail.ContainsKey("Sandbox"))
            {
                credential.TotalFee = 0;
            }
            return credential; 
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        /// <returns></returns>
        public Tuple<bool, string> Refund(TradeJournal tradeJournal)
        {
            throw new NotSupportedException("The provider not supported method [Refund]");
        }
    }
}
