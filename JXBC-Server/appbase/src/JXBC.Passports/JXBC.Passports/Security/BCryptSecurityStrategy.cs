using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;

namespace JXBC.Passports.Security
{
    class BCryptSecurityStrategy : IPassportSecurityStrategy
    {
        internal static readonly string AlgorithmName = "BCrypt";

        #region Static Methods

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
            var result = ModuleEnvironment.BCryptFactor;
            if (string.IsNullOrEmpty(passwordFormat))
                result = new Random(Environment.TickCount - password.Length).Next(ModuleEnvironment.BCryptFactor, ModuleEnvironment.BCryptFactor * 2);
            else if (passwordFormat.StartsWith(AlgorithmName) && passwordFormat.Length > AlgorithmName.Length)
            {
                var tryTimes = 0;
                if (int.TryParse(passwordFormat.Substring(AlgorithmName.Length), out tryTimes))
                    result = tryTimes;
            }
            return result;
        }

        static string FormatPassword(int formatTimes, string password, UserPassport userPassport)
        {
            var result = password;
            for (var i = 0; i < formatTimes; i++)
            {
                result = FormatPassword(result, userPassport);
            }
            return result;
        }

        static string FormatPassword(string password, UserPassport userPassport)
        {
            var factorParams = new[]
            {
                password, 
                ModuleEnvironment.HashSalt,
                userPassport.CreatedTime.ToString("ssmmHHddMMyy").ToString(), 
                userPassport.UserSecurity.PasswordSalt,
                userPassport.UserSecurity.HashAlgorithm
            }.OrderBy(x => x).ToArray();

            var passwordFactors = string.Join("", factorParams);

            return HashHelper.ComputeHash(passwordFactors, HashAlgorithmName.SHA256);
        }

        #endregion //Static Methods

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
                userPassport.UserSecurity.HashAlgorithm = string.Concat(AlgorithmName, GetFormatTimes(password, null));
                userPassport.UserSecurity.PasswordSalt = GenerateSalt(formatTimes);
            }
            else
            {
                formatTimes = GetFormatTimes(password, userPassport.UserSecurity.HashAlgorithm);
            }

            password = FormatPassword(formatTimes, password, userPassport);
            return BCrypt.HashPassword(password, formatTimes);
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

            var formatTimes = GetFormatTimes(password, userPassport.UserSecurity.HashAlgorithm);
            password = FormatPassword(formatTimes, password, userPassport);
            return BCrypt.Verify(password, userPassport.UserSecurity.Password);
        }
    }
}
