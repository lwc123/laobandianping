
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
    public partial class SearchHistoryRepository : SimpleRepositoryBase<SearchHistory,int>, ISearchHistoryRepository
    {
    
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizSource"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<SearchHistory> FindByBizSource(string bizSource, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByBizSource");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("BizSource", bizSource);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
    } 
}