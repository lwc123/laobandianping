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
    public class PageController : Controller
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public ActionResult index(string name)
        {
            return View("error");
        }        

        public ActionResult user(long oid)
        {
            var userPassport = UserPassport.FindById(oid);
            if (null == userPassport) return View("error");

            var entity = new UserPageEntity();
            entity.Profile = userPassport.Profile;
            return View(entity);
        }

        public ActionResult hello()
        {
            return View();
        }
    }
}
