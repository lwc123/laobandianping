using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Reflection;

namespace JXBC.TradeSystem.Providers
{
    /// <summary>
    /// 
    /// </summary>
    public class WalletProvider : IPaymentProvider
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        /// <returns></returns>
        public string GenerateSignedParams(TradeJournal tradeJournal)
        {
            tradeJournal.AssertNotNull("tradeJournal");

            return tradeJournal.TradeCode;
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
            return Tuple.Create(true, paymentDetail);
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
            tradeJournal.AssertNotNull("tradeJournal");
            var result = Wallet.Refund(tradeJournal);
            if (null != result)
            {
                return Tuple.Create<bool, string>(result.Success, result.PaidDetail);
            }
            return Tuple.Create<bool, string>(false, null);
        }
    }
}
