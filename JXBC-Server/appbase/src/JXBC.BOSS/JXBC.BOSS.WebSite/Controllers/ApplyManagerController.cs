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
    public class ApplyManagerController : MvcController
    {
        public ActionResult Index()
        {
            return Redirect("/");
        }

        #region Consultant Apply

        public ActionResult ConsultantApplyList(Passports.AttestationStatus status = Passports.AttestationStatus.Submited, int page = 1, int size = 10)
        {
            var pagination = new Pagination() { PageIndex = page, PageSize = size };
            var list = UserPassportManager.FindByAttestationStatus(status, pagination);
            if (null != list)
            {
                foreach (var item in list)
                    item.Profile.FormatEntity();
            }

            ViewBag.AttestationStatus = status;
            ViewBag.Pagination = pagination;
            return View(list);
        }

        public ActionResult ConsultantApplyDetail(long id)
        {
            var model = UserPassport.FindById(id);
            if(null != model) model.Profile.FormatEntity();
            return View(model);
        }

        [HttpPost]
        public ActionResult ConsultantAuthenticate(long passportId, Passports.AttestationStatus status, int grade = 0, string rejectedReason = null)
        {
            var model = UserPassport.FindById(passportId);
            if(null == model) return Json(new { success = false, message="Not exists the user!" });

            var consultantProfile = model.Profile as OrganizationProfile;
            consultantProfile.AttestationStatus = status;
            consultantProfile.AttestationRejectedReason = rejectedReason;
            var changed = consultantProfile.ChangeAttestationStatus();

            if(changed)
            {
                MessageHelper.SendAuthenticateResult(consultantProfile, status, rejectedReason);
            }

            return Json(new { success = changed });
        }

        #endregion //Consultant Apply

        #region Open Account Request

        public ActionResult OpenRequestList(Workplace.AttestationStatus status = Workplace.AttestationStatus.Submited, int page = 1, int size = 10)
        {
            var pagination = new Pagination() { PageIndex = page, PageSize = size };
            IList<OpenAccountRequest> list = null;// OpenAccountRequest.FindByAttestationStatus(status, pagination);

            ViewBag.AttestationStatus = status;
            ViewBag.Pagination = pagination;

            var entities = null == list ? null : list;
            return View(entities);
        }

        [HttpPost]
        public ActionResult ProcessOpenRequest(long id, Workplace.AttestationStatus status, string rejectedReason = null)
        {
            var model = OpenAccountRequest.FindById(id);
            if (null == model) return Json(new { success = false, message = "Not exists the user!" });

            model.AttestationStatus = status;
            var saved = model.Save();

            return Json(new { success = saved });
        }

        #endregion //Service Apply
        
    }
}