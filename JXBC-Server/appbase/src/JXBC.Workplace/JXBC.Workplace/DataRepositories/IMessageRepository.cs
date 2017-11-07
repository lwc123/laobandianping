using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using JXBC.Passports;

namespace JXBC.Workplace.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial interface IMessageRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="toPassportId"></param>
        /// <param name="toProfileType"></param>
        /// <param name="fromPassportId"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        IList<Message> FindByPassportId(long toPassportId, ProfileType toProfileType, long fromPassportId, Pagination pagination);        
    }    
}