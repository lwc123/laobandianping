using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace JXBC.WebCore.Mvc
{
    public class WebApiRouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(
                name: "test",
                url: "test/{action}/{id}",
                defaults: new { controller = "Test", action = "Index", id = UrlParameter.Optional }
            );


            routes.MapRoute(
                name: "WebBridges",
                url: "WebBridge/{action}/{id}",
                defaults: new { controller = "WebBridge", action = "Index", id = UrlParameter.Optional }
            );

            routes.MapRoute(
                name: "pages",
                url: "page/{action}",
                defaults: new { controller = "Page", action = "Index" }
            );

            routes.MapRoute(
                name: "PaymentRouter",
                url: "PaymentRouter/{action}",
                defaults: new { controller = "PaymentRouter", action = "Index" }
            );

            routes.MapRoute(
                name: "WechatRouter",
                url: "WechatRouter/{action}",
                defaults: new { controller = "WechatRouter", action = "Index" }
            );

        }
    }
}