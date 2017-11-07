using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using JXBC.Passports.Security;
using System.Security.Cryptography;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Configuration;
using JXBC.Workplace;
using M2SA.AppGenome.Logging;
using JXBC.TradeSystem;

namespace JXBC.Workplace.ThirdProviders
{
    /// <summary>
    /// 
    /// </summary>
    public class SinowayClient : ResolveObjectBase
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="productCode"></param>
        /// <param name="idCard"></param>
        /// <param name="realName"></param>
        /// <param name="mobilePhone"></param>
        /// <returns></returns>
        public static IDictionary<string, string> SendQueryRequest(string productCode, string idCard, string realName, string mobilePhone)
        {
            productCode.AssertNotNull("productCode");
            idCard.AssertNotNull("idCard");
            realName.AssertNotNull("realName");
            mobilePhone.AssertNotNull("mobilePhone");

            var client = ObjectIOCFactory.GetSingleton<SinowayClient>();
            if (null == client.ApiProviders || false == client.ApiProviders.ContainsKey(productCode))
                throw new ArgumentOutOfRangeException("productCode", string.Format("Not support the productCode : {0}", productCode));

            return client.ApiProviders[productCode].SendQueryRequest(idCard, realName, mobilePhone);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="productCode"></param>
        /// <param name="queryResult"></param>
        /// <returns></returns>
        public static IDictionary<string, object> ParseQueryResult(string productCode, string queryResult)
        {
            queryResult.AssertNotNull("queryResult");

            var client = ObjectIOCFactory.GetSingleton<SinowayClient>();
            if (null == client.ApiProviders || false == client.ApiProviders.ContainsKey(productCode))
                throw new ArgumentOutOfRangeException("productCode", string.Format("Not support the productCode : {0}", productCode));

            return client.ApiProviders[productCode].ParseQueryResult(queryResult);
        }

        public IDictionary<string, SinowayApiProvider> ApiProviders { get; set; }
    }

    /// <summary>
    /// 
    /// </summary>
    public class SinowayApiProvider : ResolveObjectBase
    {
        const string ApiUri = "http://mcp.sinowaycredit.com:8089/sinoway_mcp/creditReportInfo?chnlcod={0}&prdcod={1}";

        public string prdcod { get; set; }
        public string secret { get; set; }
        public string chnlcod { get; set; }
        public string orgno { get; set; }
        public string usrid { get; set; }
        public string vector { get; set; }
        public int datori { get; set; }
        public int queryreason { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public SinowayApiProvider()
        {
            this.vector = "sinoway8";
            this.datori = 2;
            this.queryreason = 6;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="idCard"></param>
        /// <param name="realName"></param>
        /// <param name="mobilePhone"></param>
        /// <returns></returns>
        public IDictionary<string,string> SendQueryRequest(string idCard, string realName, string mobilePhone)
        {
            var postData = new Dictionary<string, object>();
            postData["header"] = new Dictionary<string, object>()
            {
                {"orgno", this.orgno},
                {"usrid", this.usrid},
                {"datori", this.datori},
                {"queryreason", this.datori}
            };
            postData["body"] = new Dictionary<string, object>()
            {
                {"trninfo",
                    new Dictionary<string, object>()
                    {
                        {"prsnnam", realName},
                        {"idcard", idCard},
                        {"mobile", mobilePhone}
                    }
                }
            };

            var postBody = postData.ToJson();

            var apiUrl = string.Format(ApiUri, this.chnlcod, this.prdcod);
            var responseContent = this.SendApiRequest(apiUrl, postBody);


            LogManager.GetLogger().Info(" Sinoway Query : {0}", responseContent);

            if (!string.IsNullOrEmpty(responseContent))
            {
                var responseData = responseContent.ConvertEntity<Dictionary<string, object>>();
                if (responseData.ContainsKey("header"))
                {
                    return responseData["header"].ToString().ConvertEntity<Dictionary<string, string>>();
                }
            }
            return null;

        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="queryResult"></param>
        /// <returns></returns>
        public IDictionary<string, object> ParseQueryResult(string queryResult)
        {
            queryResult.AssertNotNull("queryResult");

            var result = DecryptWithJava(this.secret, this.vector, queryResult);

            return result.ConvertEntity<Dictionary<string, object>>();
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="apiUrl"></param>
        /// <param name="postBody"></param>
        /// <returns></returns>
        protected string SendApiRequest(string apiUrl, string postBody)
        {
            var headers = new Dictionary<string, string>()
            {
                {"checkcod", HashHelper.ComputeHash(string.Concat(this.chnlcod, this.secret, postBody), HashAlgorithmName.MD5)}
            };

            var encryptPostBody = EncryptWithJava(this.secret, this.vector, postBody);

            string responseContent = string.Empty;
            try
            {
                var postData = Encoding.UTF8.GetBytes(encryptPostBody);
                string boundary = "----------------------------" + DateTime.Now.Ticks.ToString("x");
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(apiUrl);
                request.ContentType = "multipart/form-data; boundary=" + boundary;
                request.Method = "POST";
                request.KeepAlive = true;
                request.Credentials = System.Net.CredentialCache.DefaultCredentials;
                request.UserAgent = "JXBC(Beijing juxianwang Technology Co., Ltd)";
                if (headers != null && headers.Count > 0)
                {
                    foreach (var item in headers)
                    {
                        request.Headers.Add(item.Key, item.Value);
                    }
                }
                request.ContentLength = postData.Length;
                Stream newStream = request.GetRequestStream();
                if (postData != null)
                    newStream.Write(postData, 0, postData.Length);//写入参数
                newStream.Close();

                HttpWebResponse response = (HttpWebResponse)request.GetResponse();
                StreamReader sr = new StreamReader(response.GetResponseStream(), Encoding.UTF8);
                responseContent = sr.ReadToEnd();
                if (!string.IsNullOrEmpty(responseContent) && !responseContent.StartsWith("{"))
                {
                    responseContent = DecryptWithJava(this.secret, this.vector, responseContent);
                }

                sr.Close();
                response.Close();
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return responseContent;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="desKey"></param>
        /// <param name="desVector"></param>
        /// <param name="original"></param>
        /// <returns></returns>
        protected string EncryptWithJava(string desKey, string desVector, string original)
        {
            DESCryptoServiceProvider desc = new DESCryptoServiceProvider();
            var encryptor = desc.CreateEncryptor(ASCIIEncoding.UTF8.GetBytes(desKey.Substring(0, 8)), ASCIIEncoding.UTF8.GetBytes(desVector));

            using (MemoryStream ms = new MemoryStream())
            {
                using (CryptoStream cs = new CryptoStream(ms, encryptor, CryptoStreamMode.Write))
                {
                    var inputData = Encoding.UTF8.GetBytes(original);
                    cs.Write(inputData, 0, inputData.Length);
                    cs.FlushFinalBlock();
                }
                return Convert.ToBase64String(ms.ToArray());
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="desKey"></param>
        /// <param name="desVector"></param>
        /// <param name="data"></param>
        /// <returns></returns>
        protected string DecryptWithJava(string desKey, string desVector, string data)
        {
            DESCryptoServiceProvider desc = new DESCryptoServiceProvider();
            var cryptoTransform = desc.CreateDecryptor(ASCIIEncoding.UTF8.GetBytes(desKey.Substring(0, 8)), ASCIIEncoding.UTF8.GetBytes(desVector));

            using (MemoryStream mStream = new MemoryStream(Convert.FromBase64String(data)))
            {
                using (CryptoStream cStream = new CryptoStream(mStream, cryptoTransform, CryptoStreamMode.Read))
                {
                    using (var sr = new StreamReader(cStream))
                    {
                        return sr.ReadLine();
                    }
                }
            }
        }
    }
}
