using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    public enum TradeType
    {
        /// <summary>
        /// 
        /// </summary>
        All = 0,

        /// <summary>
        /// 个人对个人交易
        /// </summary>
        PersonalToPersonal = 1,

        /// <summary>
        /// 个人对公交易
        /// </summary>
        PersonalToOrganization = 2,

        /// <summary>
        /// 公对私交易
        /// </summary>
        OrganizationToPersonal = 3,

        /// <summary>
        /// 公对公交易
        /// </summary>
        OrganizationToOrganization = 4
    }
}
