using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Reflection;
using JXBC.Passports;
using JXBC.Workplace;

namespace JXBC.WebCore.ViewModels
{    public class OpenAccountRequestEntity : OpenAccountRequest
    {
        /// <summary>
        /// 
        /// </summary>
        public string Password { get; set; }

        public OpenAccountRequestEntity()
        {
        }
    }
}
