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
    public partial interface IGratuityJournalRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        IList<GratuityJournal> FindByIds(IList<long> ids);


        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizType"></param>
        /// <param name="bizId"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        IList<GratuityJournal> FindByBizId(BizType bizType, long bizId, Pagination pagination);
    }
}