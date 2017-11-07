using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using JXBC.TradeSystem;
using JXBC.TradeSystem.Handlers;

namespace JXBC.Workplace.PaymentExtension
{
    /// <summary>
    /// 
    /// </summary>
    public static class PaymentSources
    {
        /// <summary>
        /// 
        /// </summary>
        public static void Initialize()
        {
            PaymentEngine.RegisterType<IPaymentHandler, OpenEnterpriseServiceHandler>("Handler");
        }

        /// <summary>
        /// 开通个人服务
        /// </summary>
        public static readonly string OpenPersonalService = "OpenPersonalService";

        /// <summary>
        /// 开通企业服务
        /// </summary>
        public static readonly string OpenEnterpriseService = "OpenEnterpriseService";

        /// <summary>
        /// 企业服务续费（含开户）
        /// </summary>
        public static readonly string RenewalEnterpriseService = "RenewalEnterpriseService";

        /// <summary>
        /// 【分成】开通企业服务
        /// </summary>
        public static readonly string ShareIncomeForOpenEnterpriseService = "ShareIncomeForOpenEnterpriseService";

        /// <summary>
        /// 购买背景调查(评价、离职报告)
        /// </summary>

        public static readonly string BuyBackgroundSurvey = "BuyBackgroundSurvey";


        /// <summary>
        /// 销售背景调查(评价、离职报告)【分成】
        /// </summary>
        public static readonly string SellBackgroundSurvey = "SellBackgroundSurvey";

    }
}
