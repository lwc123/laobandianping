
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
    public partial class PaymentCredentialRepository : SimpleRepositoryBase<PaymentCredential,string>, IPaymentCredentialRepository
    {

        #region Convert CurrencyUnit

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        protected override IDictionary<string, object> Convert(PaymentCredential entity)
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
        protected override PaymentCredential Convert(DataRow dataRow)
        {
            var model = base.Convert(dataRow);
            model.TotalFee = model.TotalFee / ModuleEnvironment.DBCurrencyUnit;
            return model;
        }

        #endregion //Convert CurrencyUnit
    }
}