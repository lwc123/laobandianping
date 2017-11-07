using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;

namespace JXBC.TradeSystem.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial interface ITradeJournalRepository : IRepository<TradeJournal,string>
    {

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <param name="tradeTypes"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        IList<TradeJournal> FindByOwnerId(long ownerId, IList<TradeType> tradeTypes, Pagination pagination);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="tradeStatus"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<TradeJournal> FindByTradeStatus(int tradeStatus, Pagination pagination);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizSource"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<TradeJournal> FindByBizSource(string bizSource, Pagination pagination);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="trade"></param>
        /// <returns></returns>
        bool UpdateTradeStatus(TradeJournal trade);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="trade"></param>
        /// <returns></returns>
        bool UpdateBizTradeCode(TradeJournal trade);

    }    
}