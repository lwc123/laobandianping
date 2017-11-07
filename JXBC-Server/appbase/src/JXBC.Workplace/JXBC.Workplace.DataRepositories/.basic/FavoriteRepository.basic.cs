
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
    public partial class FavoriteRepository : SimpleRepositoryBase<Favorite,long>, IFavoriteRepository
    {
    
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizType"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<Favorite> FindByBizType(BizType bizType, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByBizType");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("BizType", bizType);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
    } 
}