using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using M2SA.AppGenome;

namespace JXBC.Passports.Security
{
    /// <summary>
    /// 
    /// </summary>
    public static class EncryptProvider
    {
        private static readonly int IndexSalt = 107;
        private static readonly int KeyLength = 32;
        private static readonly byte[] IV = { 0x39, 0x2B, 0x71, 0x57, 0x6D, 0xCE, 0xA7, 0x90, 0x2C,0xAA, 0x6F, 0xF9, 0xC6, 0x8E, 0xD6, 0x1E };
        private static readonly string RndChars = "ABCEGLOPQRSUVXabceklnopqruvx";


        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static string GenerateSalt()
        {
            byte[] rnd = new byte[8];

            using (RandomNumberGenerator rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(rnd);
            }
            var salt = Convert.ToBase64String(rnd);
            return salt;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="original"></param>
        /// <param name="privateKey"></param>
        /// <returns></returns>
        public static string Encrypt(string original, string privateKey)
        {
            ArgumentAssertion.IsNotNull(original, "original");
            ArgumentAssertion.IsNotNull(privateKey, "privateKey");

            var key = GenerateKey(privateKey);
            var text = AddSalt(original, key);            

            using (RijndaelManaged rijndaelProvider = new RijndaelManaged())
            {
                rijndaelProvider.Key = Encoding.UTF8.GetBytes(key);
                rijndaelProvider.IV = IV;
                ICryptoTransform rijndaelEncrypt = rijndaelProvider.CreateEncryptor();

                byte[] inputData = Encoding.UTF8.GetBytes(text);
                byte[] encryptedData = rijndaelEncrypt.TransformFinalBlock(inputData, 0, inputData.Length);

                return Convert.ToBase64String(encryptedData);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="decryption"></param>
        /// <param name="privateKey"></param>
        /// <returns></returns>
        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        public static string Decrypt(string decryption, string privateKey)
        {
            ArgumentAssertion.IsNotNull(decryption, "original");
            ArgumentAssertion.IsNotNull(privateKey, "privateKey");

            var key = GenerateKey(privateKey);
            try
            {
                using (RijndaelManaged rijndaelProvider = new RijndaelManaged())
                {
                    rijndaelProvider.Key = Encoding.UTF8.GetBytes(key);
                    rijndaelProvider.IV = IV;
                    ICryptoTransform rijndaelDecrypt = rijndaelProvider.CreateDecryptor();

                    byte[] inputData = Convert.FromBase64String(decryption);
                    byte[] decryptedData = rijndaelDecrypt.TransformFinalBlock(inputData, 0, inputData.Length);

                    var original = Encoding.UTF8.GetString(decryptedData);

                    if (original.Length > KeyLength)
                    {
                        original = RemoveSalt(original, key);
                    }

                    return original;
                }
            }
            catch
            {
                return null;
            }
        }

        private static string RemoveSalt(string text, string privateKey)
        {            
            var index = 0;
            for (var i = text.Length - 1; i >= 0; i--)
            {
                if (RndChars.Contains<char>(text[i]))
                {
                    index = i;
                    break;
                }
            }

            var lengthValue = text.Substring(index + 1);
            var startIndex = Convert.ToInt32(text.Substring(text.Length - lengthValue.Length - 4, 3)) - IndexSalt;
            var length = Convert.ToInt32(lengthValue) - startIndex - IndexSalt + 49;
            var original = text.Substring(startIndex, length);            ;
            var hashed = HashHelper.ComputeHash(string.Concat(original, privateKey), HashAlgorithmName.SHA1);
            if (false == text.Remove(startIndex, length).Contains(hashed))
                original = null;

            return original;

        }

        private static string AddSalt(string text, string privateKey)
        {
            var r = new Random(Environment.TickCount + text.Length);

            var hashed = HashHelper.ComputeHash(string.Concat(text, privateKey), HashAlgorithmName.SHA1);
            var textSalt = string.Concat(DateTime.Now.ToString(string.Format("{0}ssMM{1}mm{2}dd{3}{4}HH", RndChars[r.Next(0, RndChars.Length)]
                , RndChars[r.Next(0, RndChars.Length)], RndChars[r.Next(0, RndChars.Length)], RndChars[r.Next(0, RndChars.Length)]
                , RndChars[r.Next(0, RndChars.Length)])), hashed);
            
            var startIndex = r.Next(0, textSalt.Length);
            var endIndex = startIndex + IndexSalt + text.Length - 49;
            textSalt = textSalt.Insert(startIndex, text);
            textSalt = string.Concat(textSalt, (startIndex + IndexSalt).ToString(), RndChars[r.Next(0, RndChars.Length)], endIndex.ToString());

            return textSalt;
        }

        private static string GenerateKey(string privateKey)
        {
            ArgumentAssertion.IsNotNull(privateKey, "privateKey");

            var key = HashHelper.ComputeHash(string.Concat(privateKey, ModuleEnvironment.EncryptSalt), HashAlgorithmName.MD5);
            return key;
        }
    }
}
