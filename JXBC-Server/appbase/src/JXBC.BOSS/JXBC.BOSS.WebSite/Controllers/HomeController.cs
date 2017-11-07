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
    public class HomeController : MvcController
    {
        
        public ActionResult Index()
        {
            ViewBag.ConsultanApplyCount = UserPassportManager.GetSubmitedCount();
            return View();
        }           
    }
}
