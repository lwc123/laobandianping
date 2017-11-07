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
    public partial interface IOpenAccountRequestRepository : IRepository<OpenAccountRequest,long>
    {        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="passportId"></param> 
        /// <returns></returns>         
        OpenAccountRequest FindByPassportId(long passportId);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="entName"></param> 
        /// <returns></returns>         
        OpenAccountRequest FindByEntName(string entName);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="attestationStatus"></param> 
        /// <returns></returns>         
        OpenAccountRequest FindByAttestationStatus(int attestationStatus);


    }    
}