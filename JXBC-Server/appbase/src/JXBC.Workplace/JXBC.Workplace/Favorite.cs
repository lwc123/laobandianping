using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome.Data;
using JXBC.Workplace.DataRepositories;

namespace JXBC.Workplace
{
    /// <summary>
    /// 
    /// </summary>
    public partial class Favorite
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizType"></param>
        /// <param name="bizId"></param>
        /// <returns></returns>
        public static Favorite FindByPassportWithBizId(long passportId, BizType bizType, long bizId)
        {
            if (bizId < 1) return null;

            var repository = RepositoryManager.GetRepository<IFavoriteRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByPassportWithBizId(passportId, bizType, bizId);
            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizType"></param>
        /// <param name="bizIds"></param>
        /// <returns></returns>
        public static IList<long> FindByPassportWithBizIds(long passportId, BizType bizType, IList<long> bizIds)
        {
            if (bizIds == null || bizIds.Count < 1) return null;

            var repository = RepositoryManager.GetRepository<IFavoriteRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByPassportWithBizIds(passportId, bizType, bizIds);
            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizType"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public static IList<Favorite> FindHistroy(long passportId, BizType bizType, Pagination pagination)
        {
            pagination.AssertNotNull("pagination");

            if (passportId < 1) return null;

            var repository = RepositoryManager.GetRepository<IFavoriteRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindHistroy(passportId, bizType, pagination);
            return list;
        }
    }
}

