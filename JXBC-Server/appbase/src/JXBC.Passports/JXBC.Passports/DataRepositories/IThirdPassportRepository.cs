using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using M2SA.AppGenome.Data;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public interface IThirdPassportRepository : IRepository<ThirdPassport, long>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="platform"></param>
        /// <param name="platformPassportId"></param>
        /// <returns></returns>
        ThirdPassport FindByPlatformPassportId(string platform, string platformPassportId);
    }
}