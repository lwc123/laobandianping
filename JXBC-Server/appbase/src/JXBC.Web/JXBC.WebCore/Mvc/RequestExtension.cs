using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Http;

namespace JXBC.WebCore.Mvc
{
    public static class RequestExtension
    {
        public static string GetClientIP(this HttpRequestMessage request)
        {
            var clientIP = string.Empty;
            if(null != HttpContext.Current)
            {
                var headerKeys = HttpContext.Current.Request.Headers.AllKeys;
                if (string.IsNullOrEmpty(clientIP)&& headerKeys.Contains("X-Real-IP"))
                {
                    clientIP = HttpContext.Current.Request.Headers["X-Real-IP"];
                }
                if (string.IsNullOrEmpty(clientIP) && headerKeys.Contains("X-Forwarded-For"))
                {
                    clientIP = HttpContext.Current.Request.Headers["X-Forwarded-For"];
                }

                if (string.IsNullOrEmpty(clientIP))
                {
                    clientIP = HttpContext.Current.Request.UserHostAddress;
                }                

                if (string.IsNullOrEmpty(clientIP))
                {
                    clientIP = HttpContext.Current.Request.ServerVariables["REMOTE_ADDR"];
                }

                if (!string.IsNullOrEmpty(clientIP) && clientIP.Length > 64)
                {
                    clientIP = clientIP.Substring(0, 64);
                }
                
            }
            return clientIP;
        }

        public static string GetUserAgent(this HttpRequestMessage request)
        {
            var userAgent = "";
            if (request.Headers.Contains("User-Agent"))
            {
                userAgent = string.Join(" ", request.Headers.GetValues("User-Agent"));
            }
            return userAgent;
        }
    }
}
