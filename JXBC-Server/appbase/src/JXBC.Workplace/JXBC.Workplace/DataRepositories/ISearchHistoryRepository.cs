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
    public partial interface ISearchHistoryRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizType"></param>
        /// <param name="size"></param>
        /// <returns></returns>
        string[] FindHotKeywords(BizType bizType, int size);
    }    
}