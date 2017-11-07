using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    public enum PassportStatus
    {
        /// <summary>
        /// 
        /// </summary>
        Standard = 0,

        /// <summary>
        /// 
        /// </summary>
        Locked = 500,

        /// <summary>
        /// 
        /// </summary>
        Hibernation = 900,

        /// <summary>
        /// 
        /// </summary>
        Cancellation = 999
    }
}
