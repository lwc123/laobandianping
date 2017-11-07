using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Data;
using JXBC.Passports.DataRepositories;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    public class UserPassportManager
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        public static IList<UserPassport> FindTalentes(UserQuery query)
        {
            var repository = RepositoryManager.GetRepository<IUserPassportManagerRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindTalentes(query);

            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="query"></param>
        /// <returns></returns>
        public static IList<UserPassport> FindConsultantes(UserQuery query)
        {
            var repository = RepositoryManager.GetRepository<IUserPassportManagerRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindConsultantes(query);

            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="attestationStatus"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public static IList<UserPassport> FindByAttestationStatus(AttestationStatus attestationStatus, Pagination pagination)
        {
            var repository = RepositoryManager.GetRepository<IUserPassportManagerRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByAttestationStatus(attestationStatus, pagination);

            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static int GetSubmitedCount()
        {
            var pagination = new Pagination();
            var list = FindByAttestationStatus(AttestationStatus.Submited, pagination);
            return pagination.TotalCount;
        }
    }
}
