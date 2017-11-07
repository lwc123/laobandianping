
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
    public partial class BossCommentRepository : SimpleRepositoryBase<BossComment,long>, IBossCommentRepository
    {
    
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="employeId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<BossComment> FindByEmployeId(long employeId, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByEmployeId");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("EmployeId", employeId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, pValues, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="commentEntId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<BossComment> FindByCommentEntId(long commentEntId, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByCommentEntId");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("CommentEntId", commentEntId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, pValues, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="commentatorId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<BossComment> FindByCommentatorId(long commentatorId, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByCommentatorId");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("CommentatorId", commentatorId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, pValues, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
    } 
}