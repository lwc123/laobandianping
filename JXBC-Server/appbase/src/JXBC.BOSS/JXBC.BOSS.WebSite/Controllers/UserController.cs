using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using M2SA.AppGenome.Data;
using JXBC.Passports;
using JXBC.Workplace;
using JXBC.WebCore.ViewModels;

namespace JXBC.BOSS.WebSite.Controllers
{
    [Authorize]
    public class UserController : MvcController
    {
        public ActionResult Index()
        {
            return Redirect("Talentes");
        }

        public ActionResult Talentes(string mobilePhone = null, string keyword = null, string minDate = null, string maxDate = null, int page = 1, int size = 20)
        {
            var query = new UserQuery()
            {
                MobilePhone = mobilePhone,
                Keyword = keyword,
                MinRegisterDate = string.IsNullOrEmpty(minDate) ? DateTime.MinValue : DateTime.Parse(minDate),
                MaxRegisterDate = string.IsNullOrEmpty(maxDate) ? DateTime.MaxValue : DateTime.Parse(maxDate),
                Pagination = new Pagination() { PageIndex = page, PageSize = size }
            };

            var pagination = new Pagination() { PageIndex = page, PageSize = size };
            var list = UserPassportManager.FindTalentes(query);
            if (null != list)
            {
                foreach (var item in list)
                    item.Profile.FormatEntity();
            }

            ViewBag.UserQuery = query;
            return View(list);
        }

        public ActionResult Consultantes(string mobilePhone = null, string keyword = null, string minDate = null, string maxDate = null
            , Passports.AttestationStatus status = Passports.AttestationStatus.None, int page = 1, int size = 20)
        {
            var query = new UserQuery()
            {
                MobilePhone = mobilePhone,
                Keyword = keyword,
                AttestationStatus = status,
                MinRegisterDate = string.IsNullOrEmpty(minDate) ? DateTime.MinValue : DateTime.Parse(minDate),
                MaxRegisterDate = string.IsNullOrEmpty(maxDate) ? DateTime.MaxValue : DateTime.Parse(maxDate),
                Pagination = new Pagination() { PageIndex = page, PageSize = size }
            };

            var pagination = new Pagination() { PageIndex = page, PageSize = size };
            var list = UserPassportManager.FindConsultantes(query);
            if (null != list)
            {
                foreach (var item in list)
                    item.Profile.FormatEntity();
            }

            ViewBag.UserQuery = query;
            return View(list);
        }        
    }
}