using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using M2SA.AppGenome.Data;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public interface IThirdIMAccountRepository : IRepository<ThirdIMAccount, long>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="platform"></param>
        /// <param name="platformAccountId"></param>
        /// <returns></returns>
        ThirdIMAccount FindByPlatformAccountId(string platform, string platformAccountId);
    }
}