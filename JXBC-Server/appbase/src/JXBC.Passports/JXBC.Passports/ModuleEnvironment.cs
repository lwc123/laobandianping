using System;
using System.Collections.Generic;
using System.Configuration;
using System.Diagnostics;
using System.Linq;
using System.Text;
using System.Threading;
using M2SA.AppGenome;
using M2SA.AppGenome.Reflection;
using JXBC.Passports.Security;
using JXBC.Passports.Providers;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    public static class ModuleEnvironment
    {
        /// <summary>
        /// 
        /// </summary>
        public static readonly string ModuleName = "passports";

        /// <summary>
        /// 
        /// </summary>
        public static readonly string TokenCacheName = "passports:token";

        /// <summary>
        /// 
        /// </summary>
        public static readonly string ThirdLinkedCacheName = null;

        /// <summary>
        /// 
        /// </summary>
        public static readonly DateTime EmptyDateTime = new DateTime(2000, 1, 1);

        /// <summary>
        /// 
        /// </summary>
        public static readonly string ResourceRoot = ConfigurationManager.AppSettings["ResourceRoot"];

        /// <summary>
        /// 
        /// </summary>
        public static readonly string IMProviderName = typeof(EasemobProvider).Name.Replace("Provider","");

        /// <summary>
        /// 
        /// </summary>
        internal static readonly string UserNamePattern = @"^[a-zA-Z]+[.-_a-zA-Z-9]{5,20}$";

        /// <summary>
        /// 
        /// </summary>
        internal static readonly string DefaultSecurityProvider = PassportSecurityProvider.GetSecurityStrategyAlias<BCryptSecurityStrategy>();

        /// <summary>
        /// 
        /// </summary>
        internal static readonly string HashSalt = "qNTy12DY6rLD04Y0";

        /// <summary>
        /// 
        /// </summary>
        internal static readonly string EncryptSalt = "02HnEOriXG4sNS12";

        /// <summary>
        /// 
        /// </summary>
        internal static readonly int BCryptFactor = 6;

        /// <summary>
        /// 
        /// </summary>
        internal static readonly int MD5Factor = 6;

        /// <summary>
        /// 
        /// </summary>
        public static readonly string WeakPasswords = @"000000,111111,11111111,123123,123456,1234567,12345678,654321,666666,888888,5201314,abc123,admin,root,qq123456,xiaoming,taobao,password,passw0rd,qwerty,qwerty,qweasd,qazwsx,superman";

        /// <summary>
        /// 
        /// </summary>
        internal static readonly PasswordStrength PasswordStrength = PasswordStrength.Average;

        static ModuleEnvironment()
        {
            UserNamePattern = GetValueFromConfig("passports:UserNamePattern", UserNamePattern);

            DefaultSecurityProvider = GetValueFromConfig("passports:Security.DefaultSecurityProvider", DefaultSecurityProvider);
            HashSalt = GetValueFromConfig("passports:Security.HashSalt", HashSalt);
            EncryptSalt = GetValueFromConfig("passports:Security.EncryptSalt", EncryptSalt);
            BCryptFactor = GetValueFromConfig("passports:Security.BCryptFactor", BCryptFactor);
            MD5Factor = GetValueFromConfig("passports:Security.MD5Factor", MD5Factor);
            WeakPasswords = GetValueFromConfig("passports:Security.WeakPasswords", WeakPasswords);
            PasswordStrength = GetValueFromConfig("passports:Security.PasswordStrength", PasswordStrength);

            ThirdLinkedCacheName = GetValueFromConfig("third:LinkedCache", ThirdLinkedCacheName);

            AppInstance.RegisterTypeAlias<IIMProvider, EasemobProvider>(IMProviderName);
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
