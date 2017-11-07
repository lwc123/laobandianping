using System;
using System.Configuration;
using M2SA.AppGenome.Reflection;
using System.Collections.Generic;

namespace JXBC.Workplace
{
    /// <summary>
    /// 
    /// </summary>
    public static class ModuleEnvironment
    {
        /// <summary>
        /// 
        /// </summary>
        public static readonly string ModuleName = "workplace";

        /// <summary>
        /// 
        /// </summary>
        public static readonly string SMSCacheName = "workplace:sms";

        /// <summary>
        /// 
        /// </summary>
        public static readonly string SMSSecurityStrategyCache = "workplace:sms-strategy";

        /// <summary>
        /// 
        /// </summary>
        public static readonly string[] SMSRejectUserAgents = null;

        /// <summary>
        /// 
        /// </summary>
        public static readonly string[] SMSRejectIPs = null;

        /// <summary>
        /// 
        /// </summary>
        public static readonly int SMSSecurityMobilePhoneLimit = 10;

        /// <summary>
        /// 
        /// </summary>
        public static readonly int SMSSecurityTokenLimit = 10;

        /// <summary>
        /// 
        /// </summary>
        public static readonly int SMSSecurityPassportLimit = 10;

        /// <summary>
        /// 
        /// </summary>
        public static readonly int SMSSecurityIPLimit = 50;

        static ModuleEnvironment()
        {
            SMSSecurityMobilePhoneLimit = GetValueFromConfig("SMS:SecurityMobilePhoneLimit", SMSSecurityMobilePhoneLimit);
            SMSSecurityTokenLimit = GetValueFromConfig("SMS:SecurityTokenLimit", SMSSecurityTokenLimit);
            SMSSecurityPassportLimit = GetValueFromConfig("SMS:SecurityPassportLimit", SMSSecurityPassportLimit);            
            SMSSecurityIPLimit = GetValueFromConfig("SMS:SecurityIPLimit", SMSSecurityIPLimit);

            var rejectUserAgents = GetValueFromConfig("SMS:RejectUserAgents", (string)null);
            if (false == string.IsNullOrEmpty(rejectUserAgents))
            {
                var items = rejectUserAgents.Split(new char[] { '\r', '\n', '\t' }, StringSplitOptions.RemoveEmptyEntries);
                var list = new List<string>(items.Length);
                foreach (var item in items)
                {
                    var value = item.Trim();
                    if (false == string.IsNullOrWhiteSpace(value))
                        list.Add(value.ToLower());
                }
                SMSRejectUserAgents = list.ToArray();
            }

            var rejecIPs = GetValueFromConfig("SMS:RejectIPs", (string)null);
            if (false == string.IsNullOrEmpty(rejecIPs))
            {
                var items = rejecIPs.Split(new char[] { ';' }, StringSplitOptions.RemoveEmptyEntries);
                var list = new List<string>(items.Length);
                foreach (var item in items)
                {
                    var value = item.Trim();
                    if (false == string.IsNullOrWhiteSpace(value))
                    {
                        if (value.Contains(".*"))
                            list.Add(value.ToLower().Replace(".*", "") + ".");
                        else
                            list.Add(value.ToLower());
                    }
                }
                SMSRejectIPs = list.ToArray();
            }
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
