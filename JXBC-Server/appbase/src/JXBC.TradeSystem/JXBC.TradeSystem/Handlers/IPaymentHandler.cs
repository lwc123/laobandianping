using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.TradeSystem.Handlers
{
    /// <summary>
    /// 
    /// </summary>
    public interface IPaymentHandler
    {
        /// <summary>
        /// 
        /// </summary>
        string TargetBizSource { get; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paymentParams"></param>
        bool Preprocess(Payment paymentParams);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        BizProcessResult BizProcess(TradeJournal tradeJournal);
    }
}
