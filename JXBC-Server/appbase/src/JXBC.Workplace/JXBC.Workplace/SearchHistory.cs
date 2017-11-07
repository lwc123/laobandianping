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
    public partial class SearchHistory
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizType"></param>
        /// <param name="size"></param>
        /// <returns></returns>
        public static string[] FindHotKeywords(BizType bizType, int size)
        {
            if (size < 1) return null;

            var repository = RepositoryManager.GetRepository<ISearchHistoryRepository>(ModuleEnvironment.ModuleName);
            var result = repository.FindHotKeywords(bizType, size);
            return result;
        }
    }
}

