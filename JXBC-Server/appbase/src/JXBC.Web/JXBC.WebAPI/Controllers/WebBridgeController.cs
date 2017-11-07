using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.Mvc;
using JXBC.WebCore.ViewModels;
using JXBC.Passports;
using JXBC.TradeSystem;
using JXBC.Workplace;
using JXBC.WebCore;
using M2SA.AppGenome.Data;

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class WebBridgeController : Controller
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public ActionResult LoadAccountInfo()
        {
            AccountEntity accountEntity = null;

            if (null != this.Request.UserAgent && null != this.Request.UrlReferrer)
            {
                var accessToken = CookieHelper.GetValue(AccountAuthentication.TokenKey);
                if(null == accessToken)
                {
                    var device = new ClientDevice();
                    accountEntity = new AccountEntity(AccountAuthentication.CreateNew(device), null);;

                    CookieHelper.SetCookie(AccountAuthentication.TokenKey, accountEntity.Token.AccessToken, DateTime.MaxValue);
                }
                else
                {
                    accountEntity = new AccountEntity(MvcContext.Current.ClientAccount, MvcContext.Current.UserPassport);
                }
            }

            return View("LoadAccountJS", accountEntity);
        }
    }
}
