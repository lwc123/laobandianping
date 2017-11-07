using System.Collections.Generic;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public class ThirdIMAccountRepository : SimpleRepositoryBase<ThirdIMAccount, long>, IThirdIMAccountRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="platform"></param>
        /// <param name="platformAccountId"></param>
        /// <returns></returns>
        public ThirdIMAccount FindByPlatformAccountId(string platform, string platformAccountId)
        {
            var sqlName = this.FormatSqlName("SelectByPlatformAccountId");
            var sqlParams = new Dictionary<string, object>(2);
            sqlParams.Add("platform", platform);
            sqlParams.Add("platformAccountId", platformAccountId);

            var dataset = SqlHelper.ExecuteDataSet(sqlName, sqlParams);
            ThirdIMAccount model = null;
            if (dataset.Tables[0].Rows.Count > 0)
            {
                model = this.Convert(dataset.Tables[0].Rows[0]);
            }

            return model;
        }
    }
}