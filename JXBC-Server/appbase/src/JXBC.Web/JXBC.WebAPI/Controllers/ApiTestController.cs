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
    public class ApiTestController : ApiController
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="seconds"></param>
        /// <returns></returns>
        [HttpGet]
        public int Timeout(int seconds = 30)
        {
            Thread.Sleep(seconds * 1000);
            return seconds;
        }

        [HttpGet]
        public IDictionary<string, string> SendQueryRequest(string productCode, string idCard, string realName, string mobilePhone)
        {
            return SinowayClient.SendQueryRequest(productCode, idCard, realName, mobilePhone);
        }
    }

    
}