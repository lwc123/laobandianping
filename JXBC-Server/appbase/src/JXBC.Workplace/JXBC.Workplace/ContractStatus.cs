using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.Workplace
{
    /// <summary>
    /// 
    /// </summary>
    public enum ContractStatus
    {
        /// <summary>
        /// 
        /// </summary>
        All = 0,
        
        /// <summary>
        /// 已支付
        /// </summary>
        Paid = -1,

        /// <summary>
        /// 服务中
        /// </summary>
        Servicing = 1,

        /// <summary>
        /// 服务结束
        /// </summary>
        ServiceEnd = 2,

        /// <summary>
        /// 评价完成
        /// </summary>
        RateCompleted = 3,
        
        /// <summary>
        /// 拒绝服务
        /// </summary>
        Rejected = 99
    }
}
