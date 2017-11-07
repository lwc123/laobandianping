using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.WebCore.ViewModels
{
    /// <summary>
    /// 
    /// </summary>
    public class MicroServiceEntity
    {
        /// <summary>
        /// 
        /// </summary>
        [JsonProperty(PropertyName = "appid")]
        public string AppId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [JsonProperty(PropertyName = "nonce")]
        public string Nonce { get; set; }

        /// <summary>
        /// 
        /// </summary>
        [JsonProperty(PropertyName = "sign")]
        public string Sign { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public object BizModel { get; set; }
    }
}
