
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
    public partial class ReadHistoryRepository : IReadHistoryRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizSource"></param>
        /// <returns></returns>
        public ReadHistory FindByBizSource(long passportId, string bizSource)
        {
            var sqlName = this.FormatSqlName("SelectByBizSourceWithPassport");
            var sqlParams = new Dictionary<string, object>(2);
            sqlParams.Add("passportId", passportId);
            sqlParams.Add("bizSource", bizSource);
            var dataSet = SqlHelper.ExecuteDataSet(sqlName, sqlParams);
            ReadHistory model = null;
            if(dataSet.Tables[0].Rows.Count > 0)
                model = this.Convert(dataSet.Tables[0].Rows[0]);
            return model;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizSource"></param>
        /// <param name="bizSourceId"></param>
        /// <returns></returns>
        public ReadHistory FindByBizSourceId(long passportId, string bizSource, string bizSourceId)
        {
            var sqlName = this.FormatSqlName("SelectByBizSourceWithPassport");
            var sqlParams = new Dictionary<string, object>(3);
            sqlParams.Add("passportId", passportId);
            sqlParams.Add("bizSource", bizSource);
            sqlParams.Add("bizSourceId", bizSourceId);
            var dataSet = SqlHelper.ExecuteDataSet(sqlName, sqlParams);
            ReadHistory model = null;
            if (dataSet.Tables[0].Rows.Count > 0)
                model = this.Convert(dataSet.Tables[0].Rows[0]);
            return model;
        }
    } 
}