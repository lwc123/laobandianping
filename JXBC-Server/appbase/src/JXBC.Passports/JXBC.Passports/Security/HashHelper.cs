using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace JXBC.Passports.Security
{
    /// <summary>
    /// 
    /// </summary>
    public enum HashAlgorithmName
    {
        /// <summary>
        /// 
        /// </summary>
        MD5,
        /// <summary>
        /// 
        /// </summary>
        SHA1,
        /// <summary>
        /// 
        /// </summary>
        SHA256,
        /// <summary>
        /// 
        /// </summary>
        SHA512
    }

    /// <summary>
    /// 
    /// </summary>
    public static class HashHelper
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="text"></param>
        /// <param name="algorithmName"></param>
        /// <returns></returns>
        public static string ComputeHash(string text, HashAlgorithmName algorithmName)
        {
            HashAlgorithm algorithmProvider = null;
            switch (algorithmName)
            {
                case HashAlgorithmName.MD5: { algorithmProvider = MD5.Create(); break; }
                case HashAlgorithmName.SHA1: { algorithmProvider = SHA1.Create(); break; }
                case HashAlgorithmName.SHA512: { algorithmProvider = SHA512.Create(); break; }
                default: { algorithmProvider = SHA256.Create(); break; }
            }

            using (algorithmProvider)
            {
                byte[] hashed = algorithmProvider.ComputeHash(Encoding.UTF8.GetBytes(text));
                StringBuilder sBuilder = new StringBuilder();
                for (int i = 0; i < hashed.Length; i++)
                {
                    sBuilder.Append(hashed[i].ToString("X2"));
                }
                return sBuilder.ToString();
            }
        }
    }
}
