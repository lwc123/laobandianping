using System;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading;
using System.Threading.Tasks;

namespace JXBC.WebCore
{
    public class CacheMessageHanlder : DelegatingHandler
    {
        public static readonly TimeSpan MicroCacheTimeSpan = AppEnvironment.GetValueFromConfig("Client:MicroCacheTimeSpan", TimeSpan.FromMilliseconds(12));
        public static readonly TimeSpan MiniCacheTimeSpan = AppEnvironment.GetValueFromConfig("Client:MiniCacheTimeSpan", TimeSpan.FromSeconds(12));
        public static readonly TimeSpan ShortCacheTimeSpan = AppEnvironment.GetValueFromConfig("Client:ShortCacheTimeSpan", TimeSpan.FromMinutes(12));
        public static readonly TimeSpan LongCacheTimeSpan = AppEnvironment.GetValueFromConfig("Client:LongCacheTimeSpan", TimeSpan.FromHours(24));

        protected override Task<HttpResponseMessage> SendAsync(HttpRequestMessage request, CancellationToken cancellationToken)
        {
            return base.SendAsync(request, cancellationToken).ContinueWith((task) =>
                {
                    HttpResponseMessage response = task.Result;

                    if (request.Method == HttpMethod.Get)
                    {
                        var cacheTimeSpan = TimeSpan.Zero;
                        var routeData = request.GetRouteData().Values;
                        if (routeData.ContainsKey("controller"))
                        {
                            var controllerName = routeData["controller"].ToString().ToLower();
                            var actionName = routeData["action"].ToString().ToLower();
                            if (controllerName == "dictionary")
                                cacheTimeSpan = LongCacheTimeSpan;
                            else if (controllerName == "user" && actionName.StartsWith("profile"))
                                cacheTimeSpan = ShortCacheTimeSpan;
                        }

                        if(cacheTimeSpan > TimeSpan.Zero)
                        {
                            response.Headers.CacheControl = new CacheControlHeaderValue();
                            response.Headers.CacheControl.MaxAge = cacheTimeSpan;
                            response.Headers.CacheControl.Public = true;
                        }
                    }                
                
                    return response;
                }
            );
        }
    }
}
