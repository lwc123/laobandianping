using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Http;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;
using JXBC.Workplace;
using JXBC.WebCore;
using JXBC.WebCore.ViewModels;

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class SearchController : ApiController
    {
        [HttpGet]
        public string[] HotKeywords(BizType bizType = BizType.CareerService)
        {
            var keywords = SearchHistory.FindHotKeywords(bizType, 8);
            return keywords;
        }
    }
}
