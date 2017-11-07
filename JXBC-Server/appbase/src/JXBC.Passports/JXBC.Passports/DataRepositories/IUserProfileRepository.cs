using M2SA.AppGenome.Data;
using System.Collections.Generic;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public interface IUserProfileRepository : IRepository<UserProfile, long>
    {
    }

    /// <summary>
    /// 
    /// </summary>
    public interface IOrganizationProfileRepository : IRepository<OrganizationProfile, long>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        bool ChangeAttestationStatus(OrganizationProfile model);
    }
}