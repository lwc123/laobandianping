using System.Configuration;
using System.Web.Mvc;
using System.Web.Security;
using JXBC.Passports;
using JXBC.Workplace;


namespace JXBC.BOSS.WebSite.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    [Authorize]
    public class TestController : MvcController
    {
        
        public ActionResult SendSMS(string phone)
        {
            var result = MessageHelper.SendSMSValidationCode(phone);
            return Content(result.ToString());
        }

        public ActionResult CheckSMSCode(string phone, string code)
        {
            var result = MessageHelper.CheckSMSValidationCode(phone, code);
            return Content(result.ToString());
        }
    }
}
