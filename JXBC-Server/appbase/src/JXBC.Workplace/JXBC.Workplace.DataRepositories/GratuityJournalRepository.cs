
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;

namespace JXBC.Workplace.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class GratuityJournalRepository : IGratuityJournalRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizType"></param>
        /// <param name="bizId"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public IList<GratuityJournal> FindByBizId(BizType bizType, long bizId, Pagination pagination)
        {
            var sqlName = this.FormatSqlName("SelectByBizId");
            var sqlParams = new Dictionary<string, object>(2);
            sqlParams.Add("bizType", bizType);
            sqlParams.Add("bizId", bizId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        public IList<GratuityJournal> FindByIds(IList<long> ids)
        {
            var sqlName = this.FormatSqlName("SelectByIds");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("ids", ids);
            var dataTable = SqlHelper.ExecuteDataSet(sqlName, sqlParams).Tables[0];
            var result = this.Convert(dataTable);
            return result;
        }

        #region Convert CurrencyUnit

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        protected override IDictionary<string, object> Convert(GratuityJournal entity)
        {
            var sqlParams = base.Convert(entity);
            sqlParams["TotalFee"] = (int)(entity.TotalFee * JXBC.TradeSystem.ModuleEnvironment.DBCurrencyUnit);
            return sqlParams;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataRow"></param>
        /// <returns></returns>
        protected override GratuityJournal Convert(DataRow dataRow)
        {
            var model = base.Convert(dataRow);
            model.TotalFee = model.TotalFee / JXBC.TradeSystem.ModuleEnvironment.DBCurrencyUnit;
            return model;
        }

        #endregion //Convert CurrencyUnit
    }
}