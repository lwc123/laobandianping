using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;

namespace JXBC.WebCore
{
    public class CookieHelper
    {
        private static readonly bool HttpOnly = true;

        #region SetCookie Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="value"></param>
        public static void SetCookie(string cookieName, string value)
        {
            SetCookie(cookieName, value, null, null, HttpOnly);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="value"></param>
        /// <param name="expires"></param>
        public static void SetCookie(string cookieName, string value, DateTime? expires)
        {
            SetCookie(cookieName, value, expires, null, HttpOnly);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="value"></param>
        /// <param name="expires"></param>
        /// <param name="domain"></param>
        public static void SetCookie(string cookieName, string value, DateTime? expires, string domain)
        {
            SetCookie(cookieName, value, expires, domain, HttpOnly);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="value"></param>
        /// <param name="expires"></param>
        /// <param name="domain"></param>
        /// <param name="httpOnly"></param>
        public static void SetCookie(string cookieName, string value, DateTime? expires, string domain, bool httpOnly)
        {
            var cookie = new HttpCookie(cookieName, value);
            cookie.HttpOnly = httpOnly;
            if (string.IsNullOrEmpty(value))
            {
                expires = DateTime.Now.AddMonths(-1);
                cookie.HttpOnly = false;
            }

            if (expires.HasValue) cookie.Expires = expires.Value;
            if (false == string.IsNullOrEmpty(domain)) cookie.Domain = domain;

            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="value"></param>
        public static void SetCookie(string cookieName, IDictionary<string, string> value)
        {
            SetCookie(cookieName, value, null, null, HttpOnly);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="value"></param>
        /// <param name="expires"></param>
        public static void SetCookie(string cookieName, IDictionary<string, string> value, DateTime? expires)
        {
            SetCookie(cookieName, value, expires, null, HttpOnly);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="value"></param>
        /// <param name="expires"></param>
        /// <param name="domain"></param>
        public static void SetCookie(string cookieName, IDictionary<string, string> value, DateTime? expires, string domain)
        {
            SetCookie(cookieName, value, expires, domain, HttpOnly);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="values"></param>
        /// <param name="expires"></param>
        /// <param name="domain"></param>
        /// <param name="httpOnly"></param>
        public static void SetCookie(string cookieName, IDictionary<string, string> values, DateTime? expires, string domain, bool httpOnly)
        {
            if (null == values)
            {
                SetCookie(cookieName, (string)null);
                return;
            }

            var cookie = new HttpCookie(cookieName);
            cookie.HttpOnly = httpOnly;
            if (expires.HasValue) cookie.Expires = expires.Value;
            if (false == string.IsNullOrEmpty(domain)) cookie.Domain = domain;
            
            foreach (var pair in values)
            {
                cookie.Values.Add(pair.Key, pair.Value);
            }
            HttpContext.Current.Response.Cookies.Add(cookie);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="cookieNames"></param>
        public static void RemoveCookies(params string[] cookieNames)
        {
            if(null == cookieNames)
                throw new ArgumentNullException("cookieNames");
            foreach (var cookieName in cookieNames)
            {
                SetCookie(cookieName, (string)null, null, null, HttpOnly);
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="cookieName"></param>
        /// <param name="domain"></param>
        public static void RemoveCookie(string cookieName, string domain)
        {
            if (null == cookieName)
                throw new ArgumentNullException("cookieName");
            SetCookie(cookieName, (string)null, null, domain, HttpOnly);
        }

        #endregion // SetCookie Methods

        #region GetCookie Methods

        public static string GetValue(string cookieName)
        {
            string value = null;
            var cookie = HttpContext.Current.Request.Cookies[cookieName];
            if (null != cookie) 
                value = cookie.Value;

            return value;
        }

        public static IDictionary<string, string> GetValues(string cookieName)
        {
            IDictionary<string, string> values = null;
            var cookie = HttpContext.Current.Request.Cookies[cookieName];
            if (null != cookie && cookie.HasKeys)
            {
                values = new Dictionary<string, string>(cookie.Values.Count);
                foreach (var key in cookie.Values.AllKeys)
                {
                    values.Add(key, cookie.Values[key]);
                }
            }

            return values;
        }

        public static string GetValue(string cookieName, string subKey)
        {
            string value = null;
            var cookie = HttpContext.Current.Request.Cookies[cookieName];
            if (null != cookie && cookie.HasKeys)
                value = cookie.Values[subKey];

            return value;
        }

        #endregion // GetCookie Methods
    }
}
