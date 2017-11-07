using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    public class PaymentResult : Payment
    {
        /// <summary>
        /// 
        /// </summary>
        public bool Success { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public String PaidDetail { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string TargetBizTradeCode { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public String ErrorCode { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public String ErrorMessage { get; set; }
    }
}
