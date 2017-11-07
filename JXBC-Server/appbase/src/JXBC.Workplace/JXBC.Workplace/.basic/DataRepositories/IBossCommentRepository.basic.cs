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
    public partial interface IBossCommentRepository : IRepository<BossComment,long>
    {        

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="employeId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<BossComment> FindByEmployeId(long employeId, Pagination pagination);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="commentEntId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<BossComment> FindByCommentEntId(long commentEntId, Pagination pagination);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="commentatorId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<BossComment> FindByCommentatorId(long commentatorId, Pagination pagination);

    }    
}