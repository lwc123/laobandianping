
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;

namespace JXBC.TradeSystem.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class TradeJournalRepository : SimpleRepositoryBase<TradeJournal,string>, ITradeJournalRepository
    {
        #region Convert CurrencyUnit

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        protected override IDictionary<string, object> Convert(TradeJournal entity)
        {
            var sqlParams = base.Convert(entity);
            sqlParams["TotalFee"] = (int)(entity.TotalFee * ModuleEnvironment.DBCurrencyUnit);
            return sqlParams;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataRow"></param>
        /// <returns></returns>
        protected override TradeJournal Convert(DataRow dataRow)
        {
            var model = base.Convert(dataRow);
            model.TotalFee = model.TotalFee / ModuleEnvironment.DBCurrencyUnit;
            return model;
        }

        #endregion //Convert CurrencyUnit

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <param name="tradeTypes"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public IList<TradeJournal> FindByOwnerId(long ownerId, IList<TradeType> tradeTypes, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByOwnerId");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("OwnerId", ownerId);
            pValues.Add("tradeTypes", tradeTypes);
            pValues.Add("TradeStatus", TradeStatus.BizCompleted);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, pValues, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="tradeStatus"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<TradeJournal> FindByTradeStatus(int tradeStatus, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByTradeStatus");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("TradeStatus", tradeStatus);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, pValues, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizSource"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<TradeJournal> FindByBizSource(string bizSource, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByBizSource");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("BizSource", bizSource);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, pValues, pagination);
            var result = this.Convert(dataTable);
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="trade"></param>
        /// <returns></returns>
        public bool UpdateTradeStatus(TradeJournal trade)
        {
            var sqlName = this.FormatSqlName("UpdateTradeStatus");
            var sqlParams = trade.ToDictionary();
            var affectedRows = SqlHelper.ExecuteNonQuery(sqlName, sqlParams);
            return affectedRows > 0;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="trade"></param>
        /// <returns></returns>
        public bool UpdateBizTradeCode(TradeJournal trade)
        {
            var sqlName = this.FormatSqlName("UpdateBizTradeCode");
            var sqlParams = trade.ToDictionary();
            var affectedRows = SqlHelper.ExecuteNonQuery(sqlName, sqlParams);
            return affectedRows > 0;
        }
    } 
}