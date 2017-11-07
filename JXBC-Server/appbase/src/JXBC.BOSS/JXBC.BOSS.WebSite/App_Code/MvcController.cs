using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace JXBC.BOSS.WebSite
{
    public class MvcController : Controller
    {
        public string ControllerName
        {
            get
            {
                return this.RouteData.Values["controller"] as string;
            }
        }
        public string ActionName
        {
            get
            {
                return this.RouteData.Values["action"] as string;
            }
        }
        protected override void Initialize(RequestContext requestContext)
        {
            base.Initialize(requestContext);
            ViewBag.CurrentController = this.ControllerName;
            ViewBag.CurrentAction = this.ActionName;

            ViewBag.LeftActive = requestContext.HttpContext.Request["leftFrom"];
            ViewBag.HeaderActive = requestContext.HttpContext.Request["headerFrom"];
        }
    }
}