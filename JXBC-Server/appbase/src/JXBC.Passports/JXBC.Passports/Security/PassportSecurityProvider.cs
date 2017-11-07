using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;
using System.Security.Cryptography;
using System.Text;
using M2SA.AppGenome;

namespace JXBC.Passports.Security
{
    /// <summary>
    /// 
    /// </summary>
    public static class PassportSecurityProvider
    {
        static PassportSecurityProvider()
        {
            AppInstance.RegisterTypeAlias<IPassportSecurityStrategy, MD5SecurityStrategy>(GetSecurityStrategyAlias<MD5SecurityStrategy>());
            AppInstance.RegisterTypeAlias<IPassportSecurityStrategy, BCryptSecurityStrategy>(GetSecurityStrategyAlias<BCryptSecurityStrategy>());
        }

        internal static string GetSecurityStrategyAlias<T>() where T : IPassportSecurityStrategy
        {
            return typeof(T).Name.Replace("SecurityStrategy", "");
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="algorithmName"></param>
        /// <returns></returns>
        public static IPassportSecurityStrategy LoadSecurityStrategy(string algorithmName)
        {
            IPassportSecurityStrategy securityStrategy = null;
            if (string.IsNullOrEmpty(algorithmName))
            {
                securityStrategy = ObjectIOCFactory.GetSingleton<IPassportSecurityStrategy>(ModuleEnvironment.DefaultSecurityProvider);
            }
            else
            {
                if (algorithmName.StartsWith(MD5SecurityStrategy.AlgorithmName))
                    securityStrategy = ObjectIOCFactory.GetSingleton<MD5SecurityStrategy>();
                else if (algorithmName.StartsWith(BCryptSecurityStrategy.AlgorithmName))
                    securityStrategy = ObjectIOCFactory.GetSingleton<BCryptSecurityStrategy>();
                else
                    securityStrategy = ObjectIOCFactory.GetSingleton<IPassportSecurityStrategy>(ModuleEnvironment.DefaultSecurityProvider);
            }
            return securityStrategy;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="password"></param>
        /// <param name="userPassport"></param>
        /// <returns></returns>
        internal static string HashPassword(string password, UserPassport userPassport)
        {
            ArgumentAssertion.IsNotNull(userPassport, "userPassport");
            ArgumentAssertion.IsNotNull(userPassport.UserSecurity, "userPassport.UserSecurity");

            var securityStrategy = LoadSecurityStrategy(userPassport.UserSecurity.HashAlgorithm);
            return securityStrategy.HashPassword(password, userPassport);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="password"></param>
        /// <param name="userPassport"></param>
        /// <returns></returns>
        internal static bool Verify(string password, UserPassport userPassport)
        {
            var securityStrategy = LoadSecurityStrategy(userPassport.UserSecurity.HashAlgorithm);
            return securityStrategy.Verify(password, userPassport);
        }
    }
}
