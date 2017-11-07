using System.Collections.Generic;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public class ThirdPassportRepository : SimpleRepositoryBase<ThirdPassport, long>, IThirdPassportRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="platform"></param>
        /// <param name="platformPassportId"></param>
        /// <returns></returns>
        public ThirdPassport FindByPlatformPassportId(string platform, string platformPassportId)
        {
            var sqlName = this.FormatSqlName("SelectByPlatformPassportId");
            var sqlParams = new Dictionary<string, object>(2);
            sqlParams.Add("platform", platform);
            sqlParams.Add("platformPassportId", platformPassportId);

            var dataset = SqlHelper.ExecuteDataSet(sqlName, sqlParams);
            ThirdPassport model = null;
            if (dataset.Tables[0].Rows.Count > 0)
            {
                model = this.Convert(dataset.Tables[0].Rows[0]);
            }

            return model;
        }
    }
}