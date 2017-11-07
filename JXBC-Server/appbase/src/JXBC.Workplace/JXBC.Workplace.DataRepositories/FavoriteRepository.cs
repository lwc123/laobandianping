
using System;
using System.Collections.Generic;
using System.Data;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;

namespace JXBC.Workplace.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class FavoriteRepository : IFavoriteRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizType"></param>
        /// <param name="bizId"></param>
        /// <returns></returns>
        public Favorite FindByPassportWithBizId(long passportId, BizType bizType, long bizId)
        {
            var sqlName = this.FormatSqlName("SelectByPassportWithBizId");
            var sqlParams = new Dictionary<string, object>(3);
            sqlParams.Add("passportId", passportId);
            sqlParams.Add("bizType", bizType);
            sqlParams.Add("bizId", bizId);
            var dataTable = SqlHelper.ExecuteDataSet(sqlName, sqlParams).Tables[0];
            Favorite model = null;
            if (dataTable.Rows.Count > 0)
            {
                model = this.Convert(dataTable.Rows[0]);
            }
            return model;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizType"></param>
        /// <param name="bizIds"></param>
        /// <returns></returns>
        public IList<long> FindByPassportWithBizIds(long passportId, BizType bizType, IList<long> bizIds)
        {
            var sqlName = this.FormatSqlName("SelectByPassportWithBizIds");
            var sqlParams = new Dictionary<string, object>(3);
            sqlParams.Add("passportId", passportId);
            sqlParams.Add("bizType", bizType);
            sqlParams.Add("bizIds", bizIds);
            var dataTable = SqlHelper.ExecuteDataSet(sqlName, sqlParams).Tables[0];
            List<long> list = null;
            
            if (dataTable.Rows.Count > 0)
            {
                list = new List<long>(dataTable.Rows.Count);
                foreach (DataRow row in dataTable.Rows)
                    list.Add(row["BizId"].Convert<long>());
            }
            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizType"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public IList<Favorite> FindHistroy(long passportId, BizType bizType, Pagination pagination)
        {
            var sqlName = this.FormatSqlName("SelectByBizTypeWithPassport");
            var sqlParams = new Dictionary<string, object>(2);
            sqlParams.Add("passportId", passportId);
            sqlParams.Add("bizType", bizType);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }        
    } 
}