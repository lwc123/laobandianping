using M2SA.AppGenome.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    public class UserQuery
    {
        /// <summary>
        /// 
        /// </summary>
        public string MobilePhone { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Keyword { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public AttestationStatus AttestationStatus { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime MinRegisterDate { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime MaxRegisterDate { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public Pagination Pagination { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public UserQuery()
        {
            this.MaxRegisterDate = DateTime.MaxValue;
        }
    }
}
