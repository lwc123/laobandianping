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
    public partial interface IReadHistoryRepository : IRepository<ReadHistory,long>
    {        

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizSource"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<ReadHistory> FindByBizSource(string bizSource, Pagination pagination);

    }    
}