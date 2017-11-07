
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;
using JXBC.Passports;

namespace JXBC.Workplace.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class MessageRepository : SimpleRepositoryBase<Message,long>, IMessageRepository
    {
        /// 
        public IList<Message> FindByPassportId(long toPassportId, ProfileType toProfileType, long fromPassportId, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByPassportId");
            var sqlParams = new Dictionary<string, object>(2);
            sqlParams.Add("ToPassportId", toPassportId);
            sqlParams.Add("ToProfileType", toProfileType);
            sqlParams.Add("FromPassportId", fromPassportId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
    } 
}