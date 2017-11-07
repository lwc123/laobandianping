using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    public enum TradeStatus
    {
        /// <summary>
        /// 
        /// </summary>
        All = 0,

        /// <summary>
        /// 
        /// </summary>
        New = 1,

        /// <summary>
        /// 
        /// </summary>
        WaitingPayment = 2,

        /// <summary>
        /// 
        /// </summary>
        Paid = 3,

        /// <summary>
        /// 
        /// </summary>
        BizCompleted = 9
    }
}
