using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.TradeSystem.Providers
{
    /// <summary>
    /// 
    /// </summary>
    public interface IPaymentProvider
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        /// <returns></returns>
        string GenerateSignedParams(TradeJournal tradeJournal);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeSource"></param>
        /// <param name="paymentResult"></param>
        /// <returns></returns>
        IDictionary<string, string> ParsePaymentResult(TradeJournal tradeSource, string paymentResult);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeSource"></param>
        /// <param name="paymentDetail"></param>
        /// <returns></returns>
        Tuple<bool, IDictionary<string, string>> VerifyPaymentResult(TradeJournal tradeSource, IDictionary<string, string> paymentDetail);


        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeSource"></param>
        /// <param name="paymentDetail"></param>
        /// <returns></returns>
        PaymentCredential BuildPaymentCredential(TradeJournal tradeSource, IDictionary<string, string> paymentDetail);


        /// <summary>
        /// 
        /// </summary>
        /// <param name="source"></param>
        /// <returns></returns>
        Tuple<bool, string> Refund(TradeJournal source);
    }
}
