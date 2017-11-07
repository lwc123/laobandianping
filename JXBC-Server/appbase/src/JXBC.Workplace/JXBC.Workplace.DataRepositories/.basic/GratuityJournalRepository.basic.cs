
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
    public partial class GratuityJournalRepository : SimpleRepositoryBase<GratuityJournal,long>, IGratuityJournalRepository
    {
    
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizType"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<GratuityJournal> FindByBizType(int bizType, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByBizType");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("BizType", bizType);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="buyerId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<GratuityJournal> FindByBuyerId(long buyerId, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByBuyerId");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("BuyerId", buyerId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="sellerId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<GratuityJournal> FindBySellerId(long sellerId, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectBySellerId");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("SellerId", sellerId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
    } 
}