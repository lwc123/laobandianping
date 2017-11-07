using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using M2SA.AppGenome.Data;
using JXBC.Passports;
using JXBC.WebCore.ViewModels;
using System.Web.Security;

namespace JXBC.BOSS.WebSite.Controllers
{
    public class AccountController : MvcController
    {
        public ActionResult SignIn()
        {
            return View();
        }

        [HttpPost]
        public ActionResult SignIn(string userName, string password)
        {
            if (string.IsNullOrEmpty(userName) || string.IsNullOrEmpty(password))
                return Json(new { success = false });

            var isAuthenticated = FormsAuthentication.Authenticate(userName, password);
            if (isAuthenticated)
                FormsAuthentication.SetAuthCookie(userName, false);

            return Json(new { success = isAuthenticated });
        }

        public ActionResult SignOut()
        {
            FormsAuthentication.SignOut();
            return Redirect("~/");
        }
    }
}