using System;
using System.Collections.Generic;
using System.Linq;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;
using System.Data;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class UserPassportManagerRepository : SimpleRepositoryBase<UserPassport, long>, IUserPassportManagerRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="query"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public IList<UserPassport> FindTalentes(UserQuery query)
        {
            var sqlName = this.FormatSqlName("SelectTalentesByQuery");
            var sqlParams = new Dictionary<string, object>(6);
            sqlParams.Add("ProfileType", ProfileType.UserProfile);
            sqlParams.Add("MobilePhone", query.MobilePhone);
            sqlParams.Add("Keyword", query.Keyword);
            sqlParams.Add("MinRegisterDate", query.MinRegisterDate);
            sqlParams.Add("MaxRegisterDate", query.MaxRegisterDate);

            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, query.Pagination);

            IList<UserPassport> result = null;
            if (dataTable.Rows.Count > 0)
            {
                var idList = new List<long>(dataTable.Rows.Count);
                foreach (DataRow row in dataTable.Rows)
                {
                    idList.Add(row["PassportId"].Convert<long>());
                }

                result = UserPassport.FindByIds(idList);
            }

            return result;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="query"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public IList<UserPassport> FindConsultantes(UserQuery query)
        {
            var sqlName = this.FormatSqlName("SelectConsultantesByQuery");
            var sqlParams = new Dictionary<string, object>(6);
            sqlParams.Add("ProfileType", ProfileType.OrganizationProfile);
            sqlParams.Add("MobilePhone", query.MobilePhone);
            sqlParams.Add("Keyword", query.Keyword);
            sqlParams.Add("MinRegisterDate", query.MinRegisterDate);
            sqlParams.Add("MaxRegisterDate", query.MaxRegisterDate);            
            sqlParams.Add("AttestationStatus", query.AttestationStatus == AttestationStatus.None ? null : ((int)query.AttestationStatus).ToString());

            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, query.Pagination);

            IList<UserPassport> result = null;
            if (dataTable.Rows.Count > 0)
            {
                var idList = new List<long>(dataTable.Rows.Count);
                foreach (DataRow row in dataTable.Rows)
                {
                    idList.Add(row["PassportId"].Convert<long>());
                }

                result = UserPassport.FindByIds(idList);
            }

            return result;
        }
        /// <summary>
        /// 
        /// </summary>
        /// <param name="attestationStatus"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public IList<UserPassport> FindByAttestationStatus(AttestationStatus attestationStatus, Pagination pagination)
        {
            var sqlName = this.FormatSqlName("SelectByAttestationStatus");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("AttestationStatus", attestationStatus == AttestationStatus.None ? null : ((int)attestationStatus).ToString());
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);

            IList<UserPassport> result = null;            
            if (dataTable.Rows.Count > 0)
            {
                var idList = new List<long>(dataTable.Rows.Count);
                foreach (DataRow row in dataTable.Rows)
                {
                    idList.Add(row["PassportId"].Convert<long>());
                }

                result = UserPassport.FindByIds(idList);
            }

            return result;
        }
    }
}