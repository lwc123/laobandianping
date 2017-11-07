using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.WebCore.ViewModels
{
    /// <summary>
    /// 
    /// </summary>
    public class ComplexDictionary
    {
        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public string Code { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime Expires { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string[] Keys { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public IDictionary<string, string> Data { get; set; }

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>
        /// <param name="code"></param>
        /// <param name="data"></param>
        public ComplexDictionary(string code, IDictionary<string, string> data)
        {
            this.Code = code;
            this.Expires = DateTime.Now.Add(CacheMessageHanlder.ShortCacheTimeSpan);
            this.Data = data;
            this.Keys = this.Data.Keys.ToArray();
        }
    }
}
