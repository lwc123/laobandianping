using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome.Data;
using JXBC.Workplace.DataRepositories;

namespace JXBC.Workplace
{
    /// <summary>
    /// 
    /// </summary>
    public partial class GratuityJournal
    {
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="ids"></param>
        /// <returns></returns> 
        public static IList<GratuityJournal> FindByIds(IList<long> ids)
        {
            ids.AssertNotNull("ids");

            if (ids.Count == 0) return null;

            var repository = RepositoryManager.GetRepository<IGratuityJournalRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByIds(ids);
            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizType"></param>
        /// <param name="bizId"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public static IList<GratuityJournal> FindByBizId(BizType bizType, long bizId, Pagination pagination)
        {
            pagination.AssertNotNull("pagination");

            if (bizId < 1) return null;

            var repository = RepositoryManager.GetRepository<IGratuityJournalRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByBizId(bizType, bizId, pagination);
            return list;
        }
    }
}

