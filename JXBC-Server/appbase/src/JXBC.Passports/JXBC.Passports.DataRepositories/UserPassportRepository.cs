using System;
using System.Collections.Generic;
using System.Linq;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class UserPassportRepository : SimpleRepositoryBase<UserPassport, long>, IUserPassportRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        public long FindIdByEmail(string email)
        {
            var sqlName = this.FormatSqlName("SelectPassportIdByEmail");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("Email", email);
            var idValue = SqlHelper.ExecuteScalar(sqlName, sqlParams);
            return idValue.Convert<long>(0);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="mobilePhone"></param>
        /// <returns></returns>
        public long FindIdByMobilePhone(string mobilePhone)
        {
            var sqlName = this.FormatSqlName("SelectPassportIdByMobilePhone");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("MobilePhone", mobilePhone);

            var idValue = SqlHelper.ExecuteScalar(sqlName, sqlParams);
            return idValue.Convert<long>(0);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        public long FindIdByUserName(string userName)
        {
            var sqlName = this.FormatSqlName("SelectPassportIdByUserName");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("UserName", userName);

            var idValue = SqlHelper.ExecuteScalar(sqlName, sqlParams);
            return idValue.Convert<long>(0);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <returns></returns>
        public UserPassport FindUserWithSecurityById(long passportId)
        {
            var sqlName = this.FormatSqlName("SelectUserWithSecurityById");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("Id", passportId);

            var dataset = SqlHelper.ExecuteDataSet(sqlName, sqlParams);

            UserPassport userPassport = null;
            if (dataset.Tables.Count > 1 && dataset.Tables[0].Rows.Count == 1 && dataset.Tables[1].Rows.Count == 1)
            {
                userPassport = this.Convert(dataset.Tables[0].Rows[0]);
                var userSecurity = dataset.Tables[1].Rows[0].Serialize<UserSecurity>();
                userPassport.UserSecurity = userSecurity;
            }

            return userPassport;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        public IList<UserPassport> FindByIds(IList<long> ids)
        {
            var sqlName = this.FormatSqlName("SelectByIds");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("ids", ids);

            var dataset = SqlHelper.ExecuteDataSet(sqlName, sqlParams);

            var list = this.Convert(dataset.Tables[0]);
            var userProfiles = dataset.Tables[1].Convert<UserProfile>();
            var consultantProfiles = dataset.Tables[2].Convert<OrganizationProfile>();

            if(null != list)
            {
                foreach (var item in list)
                {
                    if (item.ProfileType == ProfileType.OrganizationProfile && null != consultantProfiles)
                        item.Profile = consultantProfiles.Single(o => o.PassportId == item.PassportId);
                    else if (null != userProfiles)
                        item.Profile = userProfiles.Single(o => o.PassportId == item.PassportId);
                }
            }

            return list;
        }                
    }
}