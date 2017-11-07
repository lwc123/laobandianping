
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;

namespace JXBC.Workplace.DataRepositories
{
    public partial class ServiceContractRepository : IServiceContractRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="buyerId"></param>
        /// <returns></returns>
        public ServiceContract FindLastOneByBuyer(long buyerId)
        {
            var sqlName = this.FormatSqlName("SelectLastOneByBuyer");
            var sqlParams = new Dictionary<string, object>(3);
            sqlParams.Add("BuyerId", buyerId);
            var dataTable = SqlHelper.ExecuteDataSet(sqlName, sqlParams).Tables[0];

            ServiceContract contract = null;
            if (dataTable.Rows.Count > 0)
            {
                contract = this.Convert(dataTable.Rows[0]);
            }

            return contract;
        }
        

        #region Convert CurrencyUnit

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        protected override IDictionary<string, object> Convert(ServiceContract entity)
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
        protected override ServiceContract Convert(DataRow dataRow)
        {
            var model = base.Convert(dataRow);
            model.TotalFee = model.TotalFee / JXBC.TradeSystem.ModuleEnvironment.DBCurrencyUnit;
            return model;
        }

        #endregion //Convert CurrencyUnit
    }
}
