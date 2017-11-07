using System.Collections.Generic;
using System.Security.Cryptography.X509Certificates;
using M2SA.AppGenome.Data;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public interface IAnonymousAccountRepository : IRepository<AnonymousAccount, long>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="accessToken"></param>
        /// <returns></returns>
        AnonymousAccount FindByAccessToken(string accessToken);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <returns></returns>
        AnonymousAccount FindLastByPassport(long passportId);
    }
}