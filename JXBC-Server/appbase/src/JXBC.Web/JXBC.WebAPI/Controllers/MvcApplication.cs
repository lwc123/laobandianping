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

namespace JXL.WebCore.Mvc
{
    public class MvcApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            AreaRegistration.RegisterAllAreas();

            RouteConfig.RegisterRoutes(RouteTable.Routes);

            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            

            ApplicationHost.GetInstance().Start();
        }

        protected void Application_Stop()
        {
            ApplicationHost.GetInstance().Stop();
        }

        public override void Init()
        {
            this.AuthenticateRequest += OnAuthenticateRequest;
        }

        protected void Application_Error()
        {
            if (false == this.Context.IsCustomErrorEnabled) return;

            Exception source = this.Server.GetLastError();
            var routeData = new RouteData();
            routeData.Values["controller"] = "UnhandledError";

            if ((source is HttpException) && ((source as HttpException).GetHttpCode() != 404))
            {
                routeData.Values["action"] = "Index";
            }
            else if (false == (source is HttpException))
            {
                routeData.Values["action"] = "Index";
            }
            else
            {
                routeData.Values["action"] = "NotFound404";
            }

            
            Response.TrySkipIisCustomErrors = true;
            IController errorController = new UnhandledErrorController();
            HttpContextWrapper wrapper = new HttpContextWrapper(Context);
            var requestContext = new RequestContext(wrapper, routeData);
            errorController.Execute(requestContext);
        }

        void OnAuthenticateRequest(object sender, EventArgs e)
        {
            //Todo:使用Jux360的cookie认证方式，以兼容老的站点
            var context = MvcContext.Current;
            if (context.IsAuthenticated)
            {
                this.Context.User = new GenericPrincipal(new GenericIdentity(context.PassportId.ToString()), null);
            }
        }
    }
}
