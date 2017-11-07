using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace JXBC.Passports.Security
{
    class MD5SecurityStrategy : IPassportSecurityStrategy
    {
        const int MD5InitialFactor = 5;

        internal static readonly string AlgorithmName = "MD5".Substring(0,2);

        private static readonly string SecuritySalt = "M2SA";
       

        /// <summary>
        /// 
        /// </summary>
        /// <param name="password"></param>
        /// <param name="userPassport"></param>
        /// <returns></returns>
        string IPassportSecurityStrategy.HashPassword(string password, UserPassport userPassport)
        {
            password.AssertNotNull("password");
            userPassport.AssertNotNull("userPassport");
            userPassport.UserSecurity.AssertNotNull("userPassport.UserSecurity");

            var formatTimes = int.MaxValue;
            if (string.IsNullOrEmpty(userPassport.UserSecurity.HashAlgorithm))
            {
                formatTimes = GetFormatTimes(password, null);
                userPassport.UserSecurity.HashAlgorithm = string.Concat(AlgorithmName, MD5InitialFactor + formatTimes);
                userPassport.UserSecurity.PasswordSalt = GenerateSalt(formatTimes);
            }
            else
            {
                formatTimes = GetFormatTimes(password, userPassport.UserSecurity.HashAlgorithm);
            }

            password = FormatPassword(password, userPassport);
            return ComputeHash(password, formatTimes);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="password"></param>
        /// <param name="userPassport"></param>
        /// <returns></returns>
        bool IPassportSecurityStrategy.Verify(string password, UserPassport userPassport)
        {
            password.AssertNotNull("password");
            userPassport.AssertNotNull("userPassport");
            userPassport.UserSecurity.AssertNotNull("userPassport.UserSecurity");

            password = FormatPassword(password, userPassport);
            var formatTimes = GetFormatTimes(password, userPassport.UserSecurity.HashAlgorithm);
            var passwordHash = ComputeHash(password, formatTimes);
            return passwordHash == userPassport.UserSecurity.Password;
        }

        static string ComputeHash(string password, int formatTimes)
        {
            var pwd = password;
            for (var i=0; i<= formatTimes; i++)
            {
                pwd = HashHelper.ComputeHash(pwd, HashAlgorithmName.MD5);
            }
            return pwd;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="formatTimes"></param>
        /// <returns></returns>
        static string GenerateSalt(int formatTimes)
        {
            byte[] rnd = new byte[formatTimes + ModuleEnvironment.BCryptFactor];

            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(rnd);
            }
            var salt = Convert.ToBase64String(rnd);
            return salt;
        }

        static int GetFormatTimes(string password, string passwordFormat)
        {
            var result = 0;
            if (string.IsNullOrEmpty(passwordFormat))
                result = new Random(Environment.TickCount - password.Length).Next(ModuleEnvironment.MD5Factor, ModuleEnvironment.MD5Factor * 2);
            else if (passwordFormat.StartsWith(AlgorithmName) && passwordFormat.Length > AlgorithmName.Length)
            {
                var tryTimes = 0;
                if (int.TryParse(passwordFormat.Substring(AlgorithmName.Length), out tryTimes))
                    result = tryTimes - MD5InitialFactor;
            }
            return result;
        }

        static string FormatPassword(string password, UserPassport userPassport)
        {
            var passwordFactors = string.Concat(password, userPassport.UserSecurity.PasswordSalt, SecuritySalt);

            return passwordFactors;
        }
    }
}
