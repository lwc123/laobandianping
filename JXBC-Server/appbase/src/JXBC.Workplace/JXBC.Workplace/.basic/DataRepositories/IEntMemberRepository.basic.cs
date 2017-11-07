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
    public partial interface IEntMemberRepository : IRepository<EntMember,long>
    {        

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="entId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<EntMember> FindByEntId(long entId, Pagination pagination);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="passportId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<EntMember> FindByPassportId(long passportId, Pagination pagination);

    }    
}