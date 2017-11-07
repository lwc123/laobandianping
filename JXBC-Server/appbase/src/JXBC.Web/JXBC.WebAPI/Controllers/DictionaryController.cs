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
using JXTB.CommonData;
using JXBC.WebCore.ViewModels;
using JXBC.Passports;
using JXBC.TradeSystem;
using JXBC.Workplace;
using JXBC.WebCore;

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class DictionaryController : ApiController
    {
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        [HttpGet]
        public IDictionary<string, ComplexDictionary> Dictionaries(string codes = null)
        {
            if (string.IsNullOrEmpty(codes)) return null;

            var codeArray = codes.Split(new char[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            var result = new Dictionary<string, ComplexDictionary>(codeArray.Length);
            foreach(var code in codeArray)
            {
                var dicData = DictionaryPool.GetSimpleDictionary(code);
                result.Add(code, new ComplexDictionary(code, dicData));
            }
            return result;
        }
    }
}
