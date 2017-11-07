using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;

namespace JXBC.Workplace.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial interface IReadHistoryRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizSource"></param>
        /// <returns></returns>
        ReadHistory FindByBizSource(long passportId, string bizSource);


        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizSource"></param>
        /// <param name="bizSourceId"></param>
        /// <returns></returns>
        ReadHistory FindByBizSourceId(long passportId, string bizSource, string bizSourceId);
    }    
}