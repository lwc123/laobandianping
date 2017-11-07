using System.Collections.Generic;
using System.Data;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;
using Newtonsoft.Json;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class OrganizationProfileRepository : SimpleRepositoryBase<OrganizationProfile, long>, IOrganizationProfileRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        public IList<OrganizationProfile> FindByIds(IList<long> ids)
        {
            var sqlName = this.FormatSqlName("SelectByIds");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("Ids", ids);
            var dataSet = SqlHelper.ExecuteDataSet(sqlName, pValues);
            var list = this.Convert(dataSet.Tables[0]);
            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public bool ChangeAttestationStatus(OrganizationProfile model)
        {
            var sqlName = this.FormatSqlName("ChangeAttestationStatus");
            var sqlParams = new Dictionary<string, object>(3);
            sqlParams.Add("PassportId", model.PassportId);
            sqlParams.Add("AttestationStatus", model.AttestationStatus);
            sqlParams.Add("AttestationTime", model.AttestationTime);
            sqlParams.Add("AttestationRejectedReason", model.AttestationRejectedReason);

            var affectedRows = SqlHelper.ExecuteNonQuery(sqlName, sqlParams);
            return affectedRows > 0;
        }

        #region Convert AuthenticationImages

        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        protected override IDictionary<string, object> Convert(OrganizationProfile model)
        {
            var sqlParams = base.Convert(model);
            sqlParams["AuthenticationImages"] = model.AuthenticationImages == null ? null : JsonConvert.SerializeObject(model.AuthenticationImages);
            return sqlParams;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataRow"></param>
        /// <returns></returns>
        protected override OrganizationProfile Convert(DataRow dataRow)
        {
            var model = base.Convert(dataRow);

            var images = dataRow["AuthenticationImages"].Convert<string>();
            if (null != images)
                model.AuthenticationImages = JsonConvert.DeserializeObject<string[]>(images);
            return model;
        }

        #endregion //Convert AuthenticationImages
    }
}