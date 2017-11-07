using System;
using System.Collections.Generic;
using M2SA.AppGenome.Data;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public interface IUserPassportRepository : IRepository<UserPassport, long>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="email"></param>
        /// <returns></returns>
        long FindIdByEmail(string email);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="mobilePhone"></param>
        /// <returns></returns>
        long FindIdByMobilePhone(string mobilePhone);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="userName"></param>
        /// <returns></returns>
        long FindIdByUserName(string userName);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <returns></returns>
        UserPassport FindUserWithSecurityById(long passportId);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ids"></param>
        /// <returns></returns>
        IList<UserPassport> FindByIds(IList<long> ids);        
    }
}