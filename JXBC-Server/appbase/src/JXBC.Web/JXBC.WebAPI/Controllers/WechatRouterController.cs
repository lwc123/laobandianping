using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.Mvc;
using JXBC.WebCore.ViewModels;
using M2SA.AppGenome;
using JXBC.TradeSystem;
using JXBC.WebCore;
using JXBC.WebCore.Mvc;
using JXBC.TradeSystem.Providers;
using M2SA.AppGenome.Logging;

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class WechatRouterController : Controller
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ActionResult AuthRoute()
        {
            var authCode = this.Request.QueryString.Get("code");
            var tradeCode = this.Request.QueryString.Get("state");
            if (string.IsNullOrEmpty(authCode) || string.IsNullOrEmpty(tradeCode))
                return Content("failed");

            var redirectUri = this.Request.QueryString.Get("redirect_uri");
            redirectUri = redirectUri + (redirectUri.Contains("?") ? "&" : "?") + "code=" + authCode;

            return Redirect(redirectUri);
        }
    }
}