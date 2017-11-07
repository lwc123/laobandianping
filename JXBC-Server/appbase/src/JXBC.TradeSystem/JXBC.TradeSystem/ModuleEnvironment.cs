using System;
using System.Configuration;
using System.Collections.Generic;
using System.Linq;
using M2SA.AppGenome.Reflection;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    public static class ModuleEnvironment
    {
        /// <summary>
        /// 数据库单位：分
        /// 1元 = 100分
        /// </summary>
        public static readonly int DBCurrencyUnit = 100;
        /// <summary>
        /// 
        /// </summary>
        public static readonly string ModuleName = "trade";

        /// <summary>
        /// 是否启用测试支付金额(0.01元)
        /// </summary>
        public static readonly bool EnableTestTotalFee = false;


        /// <summary>
        /// 影响可提现金额(真实货币)的交易业务源
        /// </summary>
        public static readonly string RealityMoneyBizSourceScope = "Withdraw,WithdrawRefund,SellBackgroundSurvey,ShareIncomeForOpenEnterpriseService";

        /// <summary>
        /// 系统支付可使用的范围
        /// </summary>
        public static readonly string SystemPayBizSourceScope = "ShareIncomeForOpenEnterpriseService,SellBackgroundSurvey,OpenEnterpriseGift";

        /// <summary>
        /// 
        /// </summary>
        internal static readonly IList<string> RealityMoneyBizSourceScopeList = null;

        /// <summary>
        /// 
        /// </summary>
        internal static readonly IList<string> SystemPayBizSourceScopeList = null;

        static ModuleEnvironment()
        {
            EnableTestTotalFee = GetValueFromConfig(ModuleName + ":EnableTestTotalFee", EnableTestTotalFee);

            RealityMoneyBizSourceScope = GetValueFromConfig(ModuleName + ":RealityMoneyBizSourceScope", RealityMoneyBizSourceScope);
            RealityMoneyBizSourceScopeList = RealityMoneyBizSourceScope.Split(new char[] { ',', ' ' }, StringSplitOptions.RemoveEmptyEntries).ToList();

            SystemPayBizSourceScope = GetValueFromConfig(ModuleName + ":SystemPayBizSourceScope", SystemPayBizSourceScope);
            SystemPayBizSourceScopeList = SystemPayBizSourceScope.Split(new char[] { ',', ' ' }, StringSplitOptions.RemoveEmptyEntries).ToList();
        }

        internal static T GetValueFromConfig<T>(string configKey, T defaultValue)
        {
            var configValue = ConfigurationManager.AppSettings.Get(configKey);
            if (string.IsNullOrEmpty(configValue))
                return defaultValue;

            return configValue.Convert<T>();
        }
    }
}
