
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
    public partial class EntMemberRepository : SimpleRepositoryBase<EntMember,long>, IEntMemberRepository
    {
    
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="entId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<EntMember> FindByEntId(long entId, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByEntId");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("EntId", entId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, pValues, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="passportId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<EntMember> FindByPassportId(long passportId, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByPassportId");
            var pValues = new Dictionary<string, object>(1);
            pValues.Add("PassportId", passportId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, pValues, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
    } 
}