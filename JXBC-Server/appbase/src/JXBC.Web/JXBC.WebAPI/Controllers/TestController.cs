using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.Web.Mvc;
using JXBC.WebCore.ViewModels;
using JXBC.Passports;
using JXBC.Workplace;
using JXBC.WebCore;
using JXBC.TradeSystem.Providers;
using M2SA.AppGenome;

namespace JXBC.WebAPI.Controllers
{
    public class TestController : Controller
    {
        static void InitClient()
        {
            var accessToken = CookieHelper.GetValue(AccountAuthentication.TokenKey);
            if(null == accessToken)
            {
                var clientDevice = new ClientDevice()
                {
                    DeviceKey = "0000",
                    Product = "JUXIAN",
                    Brand = "JUXIAN"
                };

                var signResult = new AccountController().CreateNew(clientDevice);
                if(null != signResult)
                {
                    CookieHelper.SetCookie(AccountAuthentication.TokenKey, signResult.Account.Token.AccessToken);                    
                }
            }            
        }

        [HttpGet]
        public ActionResult Index()
        {
            return View(); 
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public ActionResult SignIn()
        {
            InitClient();
            return View();
        }

        [HttpPost]
        public ActionResult SignIn(string phone, string password)
        {
            if (string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(password))
                return Json(new { Success = false, Message = "手机号和密码不能为空" });

            var entity = new AccountSign()
            {
                MobilePhone = phone,
                Password = password
            };

            UserPassport userPassport = null;
            var success = AccountAuthentication.SignIn(phone, password, null, out userPassport);
            if (!success)
                return Json(new { Success = false, Message = "手机号或密码错误" });

            var account = AnonymousAccount.FindLastByPassport(userPassport.PassportId);
            if (account == null)
                return Json(new { Success = false, Message = "Token已失效" });

            CookieHelper.SetCookie(AccountAuthentication.TokenKey, account.Token.AccessToken);
            return Json(new { Success = true, Message = "登陆成功" });
        }

        [HttpPost]
        public ActionResult ShortcutSignIn(string phone, string code)
        {
            if (string.IsNullOrEmpty(phone) || string.IsNullOrEmpty(code))
                return Json(new { Success = false, Message = "手机号和验证码不能为空" });

            var entity = new AccountSign()
            {
                MobilePhone = phone,
                ValidationCode = code
            };

            var signResult = new AccountController().ShortcutSignIn(entity);            
            if (signResult.SignStatus != SignStatus.Success )
                return Json(new { Success = false, Message = "验证码错误" });

            var account = AnonymousAccount.FindLastByPassport(signResult.Account.PassportId);
            if (account == null)
                return Json(new { Success = false, Message = "Token已失效" });

            CookieHelper.SetCookie(AccountAuthentication.TokenKey, account.Token.AccessToken);
            return Json(new { Success = true, Message = "登陆成功" });
        }

        [HttpGet]
        public ActionResult SignOut()
        {
            CookieHelper.RemoveCookie(AccountAuthentication.TokenKey, null);
            return Redirect("~/test/signin");
        }
    }
}
