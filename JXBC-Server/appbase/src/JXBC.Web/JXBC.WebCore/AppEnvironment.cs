using System;
using System.Collections.Generic;
using System.Configuration;
using M2SA.AppGenome.Reflection;

namespace JXBC.WebCore
{
    /// <summary>
    /// 
    /// </summary>
    public static class AppEnvironment
    {
        /// <summary>
        /// 
        /// </summary>
        public static readonly string ModuleName = "web";

        /// <summary>
        /// 
        /// </summary>
        internal static readonly string EncryptSalt = "j<yA{k";

        /// <summary>
        /// 
        /// </summary>
        public static readonly string ResourcesSiteRoot = "";

        /// <summary>
        /// 
        /// </summary>
        public static readonly string ResourcesPhysicalRoot = "";

        /// <summary>
        /// 
        /// </summary>
        public static readonly string TestValidationCode = "FRUIT1204";

        /// <summary>
        /// 
        /// </summary>

        public static bool Test = false;

        static AppEnvironment()
        {
            EncryptSalt = GetValueFromConfig("passports:Security.EncryptSalt", EncryptSalt);
            ResourcesSiteRoot = GetValueFromConfig("Resources:SiteRoot", ResourcesSiteRoot);
            ResourcesPhysicalRoot = GetValueFromConfig("Resources:PhysicalRoot", ResourcesPhysicalRoot);

            Test = GetValueFromConfig("application:test", Test);
            TestValidationCode = GetValueFromConfig("app:TestValidationCode", TestValidationCode);
        }

        public static T GetValueFromConfig<T>(string configKey, T defaultValue)
        {
            var configValue = ConfigurationManager.AppSettings.Get(configKey);
            if (string.IsNullOrEmpty(configValue))
                return defaultValue;

            return configValue.Convert<T>();
        }
    }
}