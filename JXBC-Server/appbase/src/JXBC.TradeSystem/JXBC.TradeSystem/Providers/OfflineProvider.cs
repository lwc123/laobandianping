using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Reflection;
using Newtonsoft.Json;
using JXBC.Passports.Security;

namespace JXBC.TradeSystem.Providers
{
    /// <summary>
    /// 
    /// </summary>
    public class OfflineProvider : IPaymentProvider
    {
        #region Offline Entities

        /// <summary>
        /// 
        /// </summary>
        public class PaymentOrder : Payment
        {
            /// <summary>
            /// 
            /// </summary>
            public string Nonce { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string Sign { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string ThirdTradeCode { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "Transfer-BankName")]
            public string TransferBankName { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "Transfer-AccountName")]
            public string TransferAccountName { get; set; }

            /// <summary>
            /// 
            /// </summary>
            [JsonProperty(PropertyName = "Transfer-BankCard")]
            public string TransferBankCard { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string OrderExtension { get; set; }
            
        }

        #endregion //Alipay Entities

        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public string OfflineSecret { get; set; }


        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        /// <returns></returns>
        public string GenerateSignedParams(TradeJournal tradeJournal)
        {
            tradeJournal.AssertNotNull("tradeJournal");
            
            var paymentParams = new Dictionary<string, string>();
            paymentParams["TradeCode"] = tradeJournal.TradeCode;
            paymentParams["Nonce"] = HashHelper.ComputeHash(tradeJournal.ToJson(), HashAlgorithmName.MD5); 

            return paymentParams.ToJson();
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
            var paymentDetail = paymentResult.ConvertEntity<Dictionary<string, string>>();
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
            if(null == paymentDetail || !paymentDetail.ContainsKey("TradeCode") || !paymentDetail.ContainsKey("TotalFee") || paymentDetail.ContainsKey("OfflineSecret"))
                return Tuple.Create(false, paymentDetail);

            var paymentOrder = paymentDetail.ToJson().ConvertEntity<PaymentOrder>();
            if (null != paymentOrder && !string.IsNullOrEmpty(paymentOrder.Nonce) && !string.IsNullOrEmpty(paymentOrder.Sign)
                && !string.IsNullOrEmpty(paymentOrder.TransferBankName) && !string.IsNullOrEmpty(paymentOrder.TransferAccountName))
            {
                paymentDetail.Remove("Sign");
                paymentDetail["OfflineSecret"] = this.OfflineSecret;
                var paramsSign = HashHelper.ComputeHash(paymentDetail.ToJson(), HashAlgorithmName.MD5);
                if (paramsSign.ToUpper() == paymentOrder.Sign.ToUpper())
                {
                    paymentDetail.Remove("OfflineSecret");
                    paymentDetail["Sign"] = paymentOrder.Sign;

                    return Tuple.Create(true, paymentDetail);
                }
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

            var credential = new PaymentCredential();
            credential.TotalFee = paymentDetail["TotalFee"].Convert<decimal>();
            credential.ThirdTradeCode = paymentDetail.ContainsKey("ThirdTradeCode") ? paymentDetail["ThirdTradeCode"] : paymentDetail["TradeCode"];
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

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paymentDetail"></param>
        /// <returns></returns>
        internal IDictionary<string, string> SignPaymentDetail(IDictionary<string, string> paymentDetail)
        {
            paymentDetail["OfflineSecret"] = this.OfflineSecret;
            var paramsSign = HashHelper.ComputeHash(paymentDetail.ToJson(), HashAlgorithmName.MD5);
            paymentDetail["Sign"] = paramsSign;
            paymentDetail.Remove("OfflineSecret");
            return paymentDetail;

        }
    }
}
