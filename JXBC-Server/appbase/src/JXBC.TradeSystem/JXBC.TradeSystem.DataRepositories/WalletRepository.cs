
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
    public partial class WalletRepository : SimpleRepositoryBase<Wallet,long>, IWalletRepository
    {    
        /// <summary>
        /// 
        /// </summary>
        /// <param name="walletType"></param>
        /// <param name="ownerId"></param>
        /// <returns></returns>
        public Wallet FindByOwnerId(WalletType walletType, long ownerId)
        {            
            var sqlName = this.FormatSqlName("SelectByOwnerId");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("WalletType", walletType);
            sqlParams.Add("OwnerId", ownerId);
            var dataTable = SqlHelper.ExecuteDataSet(sqlName, sqlParams).Tables[0];
            Wallet model = null;
            if(dataTable.Rows.Count>0)
                model = this.Convert(dataTable.Rows[0]);
            return model;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <param name="totalFee"></param>
        /// <param name="addWithdrawBalance"></param>
        /// <returns></returns>
        public bool AddBalance(Wallet model, decimal totalFee, bool addWithdrawBalance)
        {
            var sqlName = this.FormatSqlName("AddBalance");
            var sqlParams = this.Convert(model);
            var balance = (int)(totalFee * ModuleEnvironment.DBCurrencyUnit);
            sqlParams["Balance"] = balance;
            sqlParams["WithdrawBalance"] = addWithdrawBalance ? balance : 0;

            var affectedRows = SqlHelper.ExecuteNonQuery(sqlName, sqlParams);
            return affectedRows > 0;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public bool ChangeBankAccount(Wallet model)
        {
            var sqlName = this.FormatSqlName("ChangeBankAccount");
            var sqlParams = this.Convert(model);

            var affectedRows = SqlHelper.ExecuteNonQuery(sqlName, sqlParams);
            return affectedRows > 0;
        }

        #region Convert CurrencyUnit

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        protected override IDictionary<string, object> Convert(Wallet entity)
        {
            var sqlParams = base.Convert(entity);
            sqlParams["AvailableBalance"] = (int)(entity.AvailableBalance * ModuleEnvironment.DBCurrencyUnit);
            sqlParams["CanWithdrawBalance"] = (int)(entity.CanWithdrawBalance * ModuleEnvironment.DBCurrencyUnit);
            sqlParams["FreezeBalance"] = (int)(entity.FreezeBalance * ModuleEnvironment.DBCurrencyUnit);
            return sqlParams;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataRow"></param>
        /// <returns></returns>
        protected override Wallet Convert(DataRow dataRow)
        {
            var model = base.Convert(dataRow);
            model.AvailableBalance = model.AvailableBalance / ModuleEnvironment.DBCurrencyUnit;
            model.CanWithdrawBalance = model.CanWithdrawBalance / ModuleEnvironment.DBCurrencyUnit;
            model.FreezeBalance = model.FreezeBalance / ModuleEnvironment.DBCurrencyUnit;
            return model;
        }

        #endregion //Convert CurrencyUnit
    }
}