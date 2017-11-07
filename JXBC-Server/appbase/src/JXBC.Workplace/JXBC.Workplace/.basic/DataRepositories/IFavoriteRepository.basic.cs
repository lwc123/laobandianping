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
    public partial interface IFavoriteRepository : IRepository<Favorite,long>
    {        

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizType"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<Favorite> FindByBizType(BizType bizType, Pagination pagination);

    }    
}