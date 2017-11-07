
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;


namespace JXBC.Workplace.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class SearchHistoryRepository : ISearchHistoryRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizType"></param>
        /// <param name="size"></param>
        /// <returns></returns>
        public string[] FindHotKeywords(BizType bizType, int size)
        {
            var sqlName = this.FormatSqlName("SelectByBizType");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("bizType", bizType);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, new Pagination() { PageSize = size });

            string[] result = null;
            if(dataTable.Rows.Count > 0)
            {
                var list = new List<string>(dataTable.Rows.Count);
                foreach(DataRow row in dataTable.Rows)
                {
                    list.Add(row["Keyword"].Convert<string>());
                }
                result = list.ToArray();
            }
            
            return result;
        }
    } 
}