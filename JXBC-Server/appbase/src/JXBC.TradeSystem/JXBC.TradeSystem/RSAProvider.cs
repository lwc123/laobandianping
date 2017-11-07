using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using Org.BouncyCastle.Security;
using Org.BouncyCastle.Crypto.Parameters;
using System.IO;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    public class RSAProvider
    {
        #region Sign & Verify

        /// <summary>
        /// 
        /// </summary>
        /// <param name="privateKey"></param>
        /// <param name="original"></param>
        /// <returns></returns>
        public static string GenerateSignature(string privateKey, string original)
        {
            using (var rsaProvider = CreateProviderPrivateKey(privateKey))
            {
                var data = Encoding.UTF8.GetBytes(original);
                byte[] signatureData = rsaProvider.SignData(data, "SHA1");
                return Convert.ToBase64String(signatureData);
            }            
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="original"></param>
        /// <param name="publicKey"></param>
        /// <param name="signature"></param>
        /// <returns></returns>
        public static bool VerifySignature(string original, string publicKey, string signature)
        {
            using (var rsaProvider = CreateProviderPublicKey(publicKey))
            {
                using (SHA1CryptoServiceProvider sha1 = new SHA1CryptoServiceProvider())
                {
                    var byteSignContent = Encoding.UTF8.GetBytes(original);
                    var byteSign = Convert.FromBase64String(signature);
                    var verified = rsaProvider.VerifyData(byteSignContent, sha1, byteSign);
                    return verified;
                }
            }
        }

        #endregion //Sign & Verify

        #region Encrypt & Decrypt

        /// <summary>
        /// 
        /// </summary>
        /// <param name="publicKey"></param>
        /// <param name="original"></param>
        /// <returns></returns>
        public static string Encrypt(string publicKey, string original)
        {
            using (var rsaProvider = CreateProviderPublicKey(publicKey))
            {
                byte[] data = rsaProvider.Encrypt(Encoding.UTF8.GetBytes(original), false);
                return Convert.ToBase64String(data);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="privateKey"></param>
        /// <param name="original"></param>
        /// <returns></returns>
        public static string Decrypt(string privateKey, string original)
        {
            using (var rsaProvider = CreateProviderPrivateKey(privateKey))
            {
                var data = rsaProvider.Decrypt(Convert.FromBase64String(original), false);
                return Encoding.UTF8.GetString(data);
            }
        }

        #endregion //Encrypt & Decrypt

        #region Create Provider

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Reliability", "CA2000:丢失范围之前释放对象")]
        private static RSACryptoServiceProvider CreateProviderPublicKey(string publicKey)
        {
            var rsaPublicKey = ConvertPublicKeyToRSAKey(publicKey);
            RSACryptoServiceProvider rsaProvider = new RSACryptoServiceProvider();
            rsaProvider.FromXmlString(rsaPublicKey);
            return rsaProvider;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Reliability", "CA2000:丢失范围之前释放对象")]
        private static RSACryptoServiceProvider CreateProviderPrivateKey(string privateKey)
        {
            var privatekey = Convert.FromBase64String(privateKey);
            byte[] MODULUS, E, D, P, Q, DP, DQ, IQ;

            // --------- Set up stream to decode the asn.1 encoded RSA private key ------
            using (MemoryStream mem = new MemoryStream(privatekey))
            {
                using (BinaryReader binr = new BinaryReader(mem))
                {
                    byte bt = 0;
                    ushort twobytes = 0;
                    int elems = 0;
                    twobytes = binr.ReadUInt16();
                    if (twobytes == 0x8130) //data read as little endian order (actual data order for Sequence is 30 81)
                        binr.ReadByte();    //advance 1 byte
                    else if (twobytes == 0x8230)
                        binr.ReadInt16();    //advance 2 bytes
                    else
                        return null;

                    twobytes = binr.ReadUInt16();
                    if (twobytes != 0x0102) //version number
                        return null;
                    bt = binr.ReadByte();
                    if (bt != 0x00)
                        return null;

                    //------ all private key components are Integer sequences ----
                    elems = GetIntegerSize(binr);
                    MODULUS = binr.ReadBytes(elems);

                    elems = GetIntegerSize(binr);
                    E = binr.ReadBytes(elems);

                    elems = GetIntegerSize(binr);
                    D = binr.ReadBytes(elems);

                    elems = GetIntegerSize(binr);
                    P = binr.ReadBytes(elems);

                    elems = GetIntegerSize(binr);
                    Q = binr.ReadBytes(elems);

                    elems = GetIntegerSize(binr);
                    DP = binr.ReadBytes(elems);

                    elems = GetIntegerSize(binr);
                    DQ = binr.ReadBytes(elems);

                    elems = GetIntegerSize(binr);
                    IQ = binr.ReadBytes(elems);


                    // ------- create RSACryptoServiceProvider instance and initialize with public key -----
                    CspParameters cspParameters = new CspParameters();
                    cspParameters.Flags = CspProviderFlags.UseMachineKeyStore;
                    var provider = new RSACryptoServiceProvider(1024, cspParameters);
                    RSAParameters rsaParams = new RSAParameters();
                    rsaParams.Modulus = MODULUS;
                    rsaParams.Exponent = E;
                    rsaParams.D = D;
                    rsaParams.P = P;
                    rsaParams.Q = Q;
                    rsaParams.DP = DP;
                    rsaParams.DQ = DQ;
                    rsaParams.InverseQ = IQ;
                    provider.ImportParameters(rsaParams);
                    return provider;
                }
            }            
        }

        private static string ConvertPublicKeyToRSAKey(string publicKey)
        {
            publicKey.AssertNotNull("publicKey");
            RsaKeyParameters publicKeyParam = (RsaKeyParameters)PublicKeyFactory.CreateKey(Convert.FromBase64String(publicKey));
            return string.Format("<RSAKeyValue><Modulus>{0}</Modulus><Exponent>{1}</Exponent></RSAKeyValue>",
                Convert.ToBase64String(publicKeyParam.Modulus.ToByteArrayUnsigned()),
                Convert.ToBase64String(publicKeyParam.Exponent.ToByteArrayUnsigned()));
        }

        private static int GetIntegerSize(BinaryReader binr)
        {
            byte bt = 0;
            byte lowbyte = 0x00;
            byte highbyte = 0x00;
            int count = 0;
            bt = binr.ReadByte();
            if (bt != 0x02)		//expect integer
                return 0;
            bt = binr.ReadByte();

            if (bt == 0x81)
                count = binr.ReadByte();	// data size in next byte
            else
                if (bt == 0x82)
            {
                highbyte = binr.ReadByte(); // data size in next 2 bytes
                lowbyte = binr.ReadByte();
                byte[] modint = { lowbyte, highbyte, 0x00, 0x00 };
                count = BitConverter.ToInt32(modint, 0);
            }
            else
            {
                count = bt;     // we already have the data size
            }

            while (binr.ReadByte() == 0x00)
            {	//remove high order zeros in data
                count -= 1;
            }
            binr.BaseStream.Seek(-1, SeekOrigin.Current);		//last ReadByte wasn't a removed zero, so back up a byte
            return count;
        }

        #endregion //Create Provider
    }
}
