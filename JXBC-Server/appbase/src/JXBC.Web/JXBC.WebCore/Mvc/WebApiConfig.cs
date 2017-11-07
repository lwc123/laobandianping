using System;
using System.Web.Http;

namespace JXBC.WebCore.Mvc
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            config.Formatters.Remove(config.Formatters.XmlFormatter);

            GlobalConfiguration.Configuration.Formatters.JsonFormatter.SerializerSettings =
                JsonExtension.BuildSerializerSettings();

            config.Filters.Add(new UnhandledFilterAttribute());

            config.MessageHandlers.Add(new CacheMessageHanlder());


            config.Routes.MapHttpRoute(
                name: "ActionApi",
                routeTemplate: "{controller}/{action}/{id}",
                defaults: new { action = RouteParameter.Optional, id = RouteParameter.Optional }
            );

            config.MessageHandlers.Add(new CacheMessageHanlder());
        }
    }
}
