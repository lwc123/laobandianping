using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Net;
using System.IO;
using M2SA.AppGenome;
using M2SA.AppGenome.Reflection;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    public static class HttpDecoratorExtension
    {
        /// <summary>
        /// Json序列化
        /// </summary>
        public static IList<KeyValuePair<string, object>> Add(this IList<KeyValuePair<string, object>> postData, string key, object value)
        {
            ArgumentAssertion.IsNotNull(postData, "postData");
            postData.Add(new KeyValuePair<string, object>(key, value));
            return postData;
        }
    }

    /// <summary>
    /// 
    /// </summary>
    public class HttpDecorator
    {
        #region Sub Classes

        /// <summary>
        /// 
        /// </summary>
        public enum HttpMethod
        {
            /// <summary>
            /// 
            /// </summary>
            GET,
 
            /// <summary>
            /// 
            /// </summary>
            POST,

            /// <summary>
            /// 
            /// </summary>
            PUT,

            /// <summary>
            /// 
            /// </summary>
            HEAD
        }

        /// <summary>
        /// 
        /// </summary>
        public class HttpResponseResult
        {
            /// <summary>
            /// 
            /// </summary>
            public WebExceptionStatus Status { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public HttpStatusCode StatusCode { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public HttpResourceType ResourceType { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string ResponseUri { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public bool Redirected { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public string Content { get; set; }

            /// <summary>
            /// 
            /// </summary>
            public byte[] Stream { get; set; }
        }

        /// <summary>
        /// 
        /// </summary>
        public enum HttpResourceType
        {
            /// <summary>
            /// 
            /// </summary>
            Unknow,
            
            /// <summary>
            /// 
            /// </summary>
            Html,
            
            /// <summary>
            /// 
            /// </summary>
            Xml,
            
            /// <summary>
            /// 
            /// </summary>
            Text,

            /// <summary>
            /// 
            /// </summary>
            ApplicationFile,
            
            /// <summary>
            /// 
            /// </summary>
            Image,
        }

        #endregion

        static readonly Regex HtmlRegex = new Regex(@"text\/[(htm)|(html)]", RegexOptions.IgnoreCase | RegexOptions.Compiled);
        static readonly Regex XmlRegex = new Regex(@"[a-zA-Z]{3,20}\/([a-zA-Z]{3,12}\+)?xml", RegexOptions.IgnoreCase | RegexOptions.Compiled);
        static readonly Regex TextRegex = new Regex(@"text\/[a-zA-Z]{3,8}", RegexOptions.IgnoreCase | RegexOptions.Compiled);
        static readonly Regex ApplicationRegex = new Regex(@"application\/[a-zA-Z]{2,32}", RegexOptions.IgnoreCase | RegexOptions.Compiled);
        static readonly Regex ImageRegex = new Regex(@"image\/[a-zA-Z]{3,8}", RegexOptions.IgnoreCase | RegexOptions.Compiled);
        static readonly Regex EncodeRegex = new Regex(@"<meta[^>]*charset=(?<w1>[\w|-]+)[^>]*>", RegexOptions.IgnoreCase | RegexOptions.Compiled);
        static int Timeout = 2 * 60 * 1000;
        static string DefaultEncode = "utf-8";

        /// <summary>
        /// 
        /// </summary>
        public bool AllowAutoRedirect { get; set; }
        
        /// <summary>
        /// 
        /// </summary>
        public CookieContainer CookieContainer { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public HttpDecorator()
        {
            ServicePointManager.ServerCertificateValidationCallback = (sender, certificate, chain, errors) => true;
            this.CookieContainer = new CookieContainer();
            this.AllowAutoRedirect = true;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public HttpResponseResult HttpHead(string url)
        {
            return this.HttpHead(url, null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="url"></param>
        /// <param name="headers"></param>
        /// <returns></returns>
        public HttpResponseResult HttpHead(string url, IDictionary<string, string> headers)
        {
            HttpResponseResult result = null;
            Uri uri = null;

            if (Uri.TryCreate(url, UriKind.RelativeOrAbsolute, out uri))
            {
                //LogManager.GetLogger().Trace("HttpGet:{0}", url);
                var httpRequest = CreateHttpRequest(uri, headers);
                httpRequest.Method = HttpMethod.HEAD.ToString();
                result = SendRequest(httpRequest);
            }

            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="url"></param>
        /// <returns></returns>
        public HttpResponseResult HttpGet(string url)
        {
            return this.HttpGet(url, null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="url"></param>
        /// <param name="headers"></param>
        /// <returns></returns>
        public HttpResponseResult HttpGet(string url, IDictionary<string, string> headers)
        {
            HttpResponseResult result = null;
            Uri uri = null;

            if (Uri.TryCreate(url, UriKind.RelativeOrAbsolute, out uri))
            {
                //LogManager.GetLogger().Trace("HttpGet:{0}", url);
                var httpRequest = CreateHttpRequest(uri, headers);
                result = SendRequest(httpRequest);
            }

            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="url"></param>
        /// <param name="postData"></param>
        /// <returns></returns>
        public HttpResponseResult HttpPost(string url, IList<KeyValuePair<string, object>> postData)
        {
            return this.HttpPost(url, postData, null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="url"></param>
        /// <param name="postData"></param>
        /// <returns></returns>
        public HttpResponseResult HttpPost(string url, string postData)
        {
            return this.HttpPost(url, postData, null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="url"></param>
        /// <param name="postData"></param>
        /// <param name="headers"></param>
        /// <returns></returns>
        public HttpResponseResult HttpPost(string url, IList<KeyValuePair<string, object>> postData, IDictionary<string, string> headers)
        {
            var postParams = EncodeRequestData(postData);
            return this.HttpPost(url, postParams, headers);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="httpMethod"></param>
        /// <param name="url"></param>
        /// <param name="jsonData"></param>
        /// <param name="headers"></param>
        /// <returns></returns>
        public HttpResponseResult HttpJson(HttpMethod httpMethod, string url, string jsonData, IDictionary<string, string> headers)
        {
            HttpResponseResult result = null;
            Uri uri = null;

            if (Uri.TryCreate(url, UriKind.RelativeOrAbsolute, out uri))
            {
                var resEncode = DefaultEncode;// DomainSetting.FindDomainRule(httpRequest.RequestUri.Host).Encode;
                byte[] buffer = Encoding.GetEncoding(resEncode).GetBytes(jsonData);

                var httpRequest = CreateHttpRequest(uri, headers);
                httpRequest.Method = httpMethod.ToString();
                httpRequest.ContentType = "application/json";
                httpRequest.ContentLength = buffer.Length;

                using (var postStream = httpRequest.GetRequestStream())
                {
                    postStream.Write(buffer, 0, buffer.Length);
                }

                result = SendRequest(httpRequest);
            }

            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="url"></param>
        /// <param name="postData"></param>
        /// <param name="headers"></param>
        /// <returns></returns>
        public HttpResponseResult HttpPost(string url, string postData, IDictionary<string, string> headers)
        {
            HttpResponseResult result = null;
            Uri uri = null;

            if (Uri.TryCreate(url, UriKind.RelativeOrAbsolute, out uri))
            {
                var resEncode = DefaultEncode;// DomainSetting.FindDomainRule(httpRequest.RequestUri.Host).Encode;
                byte[] buffer = Encoding.GetEncoding(resEncode).GetBytes(postData);

                var httpRequest = CreateHttpRequest(uri, headers);
                httpRequest.Method = HttpMethod.POST.ToString();
                httpRequest.ContentType = "application/x-www-form-urlencoded";
                httpRequest.ContentLength = buffer.Length;

                using (var postStream = httpRequest.GetRequestStream())
                {
                    postStream.Write(buffer, 0, buffer.Length);
                }

                result = SendRequest(httpRequest);
            }

            return result;
        }

        HttpWebRequest CreateHttpRequest(Uri uri, IDictionary<string, string> headers)
        {
            var httpRequest = (HttpWebRequest)WebRequest.Create(uri);
            httpRequest.CookieContainer = this.CookieContainer;
            httpRequest.AllowAutoRedirect = this.AllowAutoRedirect;
            httpRequest.Method = HttpMethod.GET.ToString();
            httpRequest.Accept = "image/gif, image/jpeg, image/pjpeg, image/pjpeg, application/x-shockwave-flash, application/x-ms-application, application/x-ms-xbap, application/vnd.ms-xpsdocument, application/xaml+xml, application/vnd.ms-excel, application/vnd.ms-powerpoint, application/msword, */*";
            httpRequest.UserAgent = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; MReader 0.3)";
            httpRequest.Timeout = Timeout;

            httpRequest.Headers.Add("Accept-Language", "zh-cn");
            if (headers != null && headers.Count > 0)
            {
                foreach (var item in headers)
                {
                    httpRequest.Headers.Add(item.Key, item.Value);
                }
            }

            return httpRequest;
        }

        HttpResponseResult SendRequest(HttpWebRequest httpRequest)
        {
            HttpWebResponse httpResponse = null;
            var status = WebExceptionStatus.UnknownError;
            try
            {
                httpResponse = (HttpWebResponse)httpRequest.GetResponse();
                status = WebExceptionStatus.Success;
            }
            catch (WebException ex)
            {
                // only handle protocol errors that have valid responses
                if (ex.Response == null)
                {
                    Console.WriteLine("err : {0}\t{1}", ex.Status, httpRequest.RequestUri.AbsoluteUri);
                    throw;
                }
                status = ex.Status;
                httpResponse = (HttpWebResponse)ex.Response;
            }

            var result = new HttpResponseResult();
            result.Status = status;
            result.ResourceType = GetHttpResourceType(httpResponse.ContentType);
            result.StatusCode = httpResponse.StatusCode;
            result.ResponseUri = httpResponse.ResponseUri.ToString();
            result.Redirected = httpResponse.ResponseUri.Host != httpRequest.RequestUri.Host;

            if (status == WebExceptionStatus.Success && httpRequest.Method != HttpMethod.HEAD.ToString())
            {
                switch (result.ResourceType)
                {
                    case HttpResourceType.Html:
                    case HttpResourceType.Text:
                    case HttpResourceType.Xml:
                    case HttpResourceType.ApplicationFile:
                        {
                            result.Content = GetContent(httpResponse);
                            break;
                        }
                    default:
                        {
                            result.Stream = GetBytes(httpResponse);
                            break;
                        }
                }
            }

            return result;
        }

        private static byte[] GetBytes(HttpWebResponse response)
        {
            var length = (int)response.ContentLength;
            byte[] data;

            using (var memoryStream = new MemoryStream())
            {
                var buffer = new byte[0x100];

                using (var rs = response.GetResponseStream())
                {
                    for (var i = rs.Read(buffer, 0, buffer.Length); i > 0; i = rs.Read(buffer, 0, buffer.Length))
                    {
                        memoryStream.Write(buffer, 0, i);
                    }
                }

                data = memoryStream.ToArray();
            }

            return data;
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        private static string GetContent(HttpWebResponse response)
        {
            var content = string.Empty;
            var buffer = GetBytes(response);

            var charset = response.CharacterSet;
            if (string.IsNullOrEmpty(charset) || string.Compare(charset, "ISO-8859-1") == 0)
            {
                var defaultEncode = Encoding.UTF8;
                content = defaultEncode.GetString(buffer);
                if (EncodeRegex.IsMatch(content))
                {
                    var encodeStr = EncodeRegex.Match(content).Groups["w1"].Value;
                    var contentEncode = defaultEncode;
                    if (string.IsNullOrEmpty(encodeStr) == false)
                    {
                        try
                        {
                            contentEncode = Encoding.GetEncoding(encodeStr);
                            if (contentEncode.Equals(defaultEncode) == false)
                            {
                                content = contentEncode.GetString(buffer);
                            }
                        }
                        catch (Exception ex)
                        {
                            ex.HandleException();
                        }
                    }
                }
            }
            else
            {
                var encoding = Encoding.GetEncoding(charset);
                content = encoding.GetString(buffer);
            }

            return content;
        }

        static HttpResourceType GetHttpResourceType(string contentType)
        {
            var resourceType = HttpResourceType.Unknow;
            if (HtmlRegex.IsMatch(contentType))
                resourceType = HttpResourceType.Html;
            else if (XmlRegex.IsMatch(contentType))
                resourceType = HttpResourceType.Xml;
            else if (TextRegex.IsMatch(contentType))
                resourceType = HttpResourceType.Text;
            else if (ApplicationRegex.IsMatch(contentType))
                resourceType = HttpResourceType.ApplicationFile;
            else if (ImageRegex.IsMatch(contentType))
                resourceType = HttpResourceType.Image;

            return resourceType;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="requestData"></param>
        /// <returns></returns>
        public static string EncodeRequestData(IList<KeyValuePair<string, object>> requestData)
        {
            ArgumentAssertion.IsNotNull(requestData, "requestData");

            var buffer = new StringBuilder(1024);

            if (requestData.Count > 0)
            {
                var processFirst = false;
                foreach (var item in requestData)
                {
                    if (processFirst == false)
                    {
                        processFirst = true;
                    }
                    else
                    {
                        buffer.Append("&");
                    }
                    buffer.AppendFormat("{0}={1}", item.Key, item.Value);
                }
            }


            return buffer.ToString();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="url"></param>
        /// <param name="requestData"></param>
        /// <returns></returns>
        public static string CombineRequest(string url, IList<KeyValuePair<string, object>> requestData)
        {
            ArgumentAssertion.IsNotNull(url, "url");

            if (null == requestData || requestData.Count == 0)
                return url;

            var queryString = EncodeRequestData(requestData);
            return string.Concat(url, url.EndsWith("?") ? "" : "?", queryString);
        }
    }
}
