using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Threading;
using System.Web.Http;
using JXBC.Passports.Security;
using JXBC.WebCore;
using System.Security.Cryptography;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Configuration;
using JXBC.Workplace;
using M2SA.AppGenome.Logging;
using JXBC.Workplace.ThirdProviders;

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class SinowayController : MicroServiceController
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="product"></param>
        /// <param name="idCard"></param>
        /// <param name="realName"></param>
        /// <param name="mobilePhone"></param>
        /// <returns></returns>
        [HttpGet]
        public IDictionary<string, string> SendQueryRequest(string product, string idCard, string realName, string mobilePhone)
        {
            return SinowayClient.SendQueryRequest(product, idCard, realName, mobilePhone);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="product"></param>
        /// <param name="result"></param>
        /// <returns></returns>
        [HttpGet]
        public IDictionary<string, object> ParseQueryResult(string product, string result)
        {
            //queryResult = "77spskjDSPR0WCHrHfjIW3fRt90r42nlvUMf3Y3dMHEc2nRecwyZoPQ0lXjg0IBeaFoPDCmzQDaO\n5WGV6YfxFgaGhCNT+JlbaVk3VQVGa0a8xWPLiwg0np7ZlI+mtOIG3y5obHu7Wi7++GD15D41GW+w\nnoiCLCBOeAwmDCSzMpNGz/HUNFbqa1i8Wr56bXWUstL1p2MLqMUobMOUnCwl55sg+AGElUhzgiQZ\nMbYTQgsVo/ARNPP66b7NeagiuAdAVg3jeLvLPZdZAVVDXm662yrXone+/jkM1C1ZOcqazzp7QQdt\nx5zVdWv1dEh4D1hlj30zxymBomRmOggUc4gAhWy4guiZH52pBP7fsI8B2f8+VdRiraZHP4kTUtOm\nYo+zTjNVXmC57DqM4aGSjKdc/L2JyztKDIfug3OlVR6KQFngllERrefe3G7fYHaztpF+hdpqJRZI\nHE/KmGOd3h53D+uHSnz/uG9wNtLZ+pI/5fOonI99zFuNNeyYD8hYrTjBEhQ7028nXrWVxkldcaw2\n4DjT2ypkzEWJbUriY0x9gUyw+eaAkoQT3oTFqYThz662VheLM/X/eMpDIkUlEi/93guVRx/ii9Fk\n6q5WQ3u+IqtklP7xh9IUYdcUPUvv+xGub+YiS8JgegtwJ0XU4PAdSg==";
            return SinowayClient.ParseQueryResult(product, result); 
        }
        
    }


}