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
    public partial interface IGratuityJournalRepository : IRepository<GratuityJournal,long>
    {        

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizType"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<GratuityJournal> FindByBizType(int bizType, Pagination pagination);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="buyerId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<GratuityJournal> FindByBuyerId(long buyerId, Pagination pagination);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="sellerId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<GratuityJournal> FindBySellerId(long sellerId, Pagination pagination);
    }    
}