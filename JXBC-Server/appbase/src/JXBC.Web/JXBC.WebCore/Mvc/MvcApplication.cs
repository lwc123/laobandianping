using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Principal;
using System.Text;
using System.Web;
using System.Web.Http;
using System.Web.Mvc;
using System.Web.Routing;
using M2SA.AppGenome;
using JXBC.Workplace.PaymentExtension;

namespace JXBC.WebCore.Mvc
{
    public class MvcApplication : BaseApplication
    {
        protected override void Application_Start()
        {
            base.Application_Start();
            MvcRouteConfig.RegisterRoutes(RouteTable.Routes);
        }
    }
}
