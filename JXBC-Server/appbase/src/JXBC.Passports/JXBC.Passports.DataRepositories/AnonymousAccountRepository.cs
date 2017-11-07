using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Logging;
using M2SA.AppGenome.Reflection;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public class AnonymousAccountRepository : SimpleRepositoryBase<AnonymousAccount, long>, IAnonymousAccountRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="accessToken"></param>
        /// <returns></returns>
        public AnonymousAccount FindByAccessToken(string accessToken)
        {
            var sqlName = this.FormatSqlName("SelectByAccessToken");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("AccessToken", accessToken);

            var dataset = SqlHelper.ExecuteDataSet(sqlName, sqlParams);
            AnonymousAccount account = null;
            if (dataset.Tables[0].Rows.Count > 0)
            {
                account = this.Convert(dataset.Tables[0].Rows[0]);
            }
            return account;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <returns></returns>
        public AnonymousAccount FindLastByPassport(long passportId)
        {
            var sqlName = this.FormatSqlName("SelectLastByPassport");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("passportId", passportId);

            var dataset = SqlHelper.ExecuteDataSet(sqlName, sqlParams);
            AnonymousAccount account = null;
            if (dataset.Tables[0].Rows.Count > 0)
            {
                account = this.Convert(dataset.Tables[0].Rows[0]);
            }
            return account;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataRow"></param>
        /// <returns></returns>
        protected override AnonymousAccount Convert(DataRow dataRow)
        {
            ArgumentAssertion.IsNotNull(dataRow, "dataRow");
            var model = base.Convert(dataRow);
            if (dataRow.Table.Columns.Contains("AccessToken"))
                model.Token = dataRow.Serialize<AnonymousAccount.AccountToken>();

            return model;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        protected override IDictionary<string, object> Convert(AnonymousAccount entity)
        {
            ArgumentAssertion.IsNotNull(entity, "entity");

            var sqlParams = base.Convert(entity);
            if (null != entity.Token)
            {
                var tokenParams = entity.Token.ToDictionary();
                foreach (var pair in tokenParams)
                {
                    if (sqlParams.ContainsKey(pair.Key)) continue;
                    sqlParams[pair.Key] = pair.Value;
                }
            }

            return sqlParams;
        }
    }
}