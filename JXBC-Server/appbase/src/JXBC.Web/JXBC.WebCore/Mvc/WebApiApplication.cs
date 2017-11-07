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
    public class WebApiApplication : BaseApplication
    {
        protected override void Application_Start()
        {
            base.Application_Start();
            WebApiRouteConfig.RegisterRoutes(RouteTable.Routes);
            WebApiConfig.Register(GlobalConfiguration.Configuration);
        }
    }
}
