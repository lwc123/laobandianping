using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;

namespace JXBC.Workplace.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial interface IFavoriteRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizType"></param>
        /// <param name="bizId"></param>
        /// <returns></returns>
        Favorite FindByPassportWithBizId(long passportId, BizType bizType, long bizId);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizType"></param>
        /// <param name="bizIds"></param>
        /// <returns></returns>
        IList<long> FindByPassportWithBizIds(long passportId, BizType bizType, IList<long> bizIds);

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizType"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        IList<Favorite> FindHistroy(long passportId, BizType bizType, Pagination pagination);        
    }    
}