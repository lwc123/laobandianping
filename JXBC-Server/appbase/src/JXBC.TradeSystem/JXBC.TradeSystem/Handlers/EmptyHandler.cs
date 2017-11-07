using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.ExceptionHandling;
using M2SA.AppGenome.Logging;

namespace JXBC.TradeSystem.Handlers
{
    /// <summary>
    /// 
    /// </summary>
    public class EmptyHandler : IPaymentHandler
    {
        /// <summary>
        /// 
        /// </summary>
        public string TargetBizSource { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paymentParams"></param>
        /// <returns></returns>
        public bool Preprocess(Payment paymentParams)
        {
            paymentParams.AssertNotNull("paymentParams");
            return true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        public virtual BizProcessResult BizProcess(TradeJournal tradeJournal)
        {
            tradeJournal.AssertNotNull("tradeJournal");
            return BizProcessResult.CreateSuccessResult(tradeJournal.TradeCode);
        }                
    }
}
