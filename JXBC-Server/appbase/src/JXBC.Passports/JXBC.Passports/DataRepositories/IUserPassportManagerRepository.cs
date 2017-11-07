using System;
using System.Collections.Generic;
using M2SA.AppGenome.Data;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public interface IUserPassportManagerRepository : IRepository<UserPassport, long>
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="attestationStatus"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        IList<UserPassport> FindByAttestationStatus(AttestationStatus attestationStatus, Pagination pagination);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        IList<UserPassport> FindTalentes(UserQuery query);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        IList<UserPassport> FindConsultantes(UserQuery query);
    }
}