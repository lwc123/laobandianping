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
    public partial interface ITargetEmployeRepository : IRepository<TargetEmploye,long>
    {        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="passportId"></param> 
        /// <returns></returns>         
        TargetEmploye FindByPassportId(long passportId);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="iDCard"></param> 
        /// <returns></returns>         
        TargetEmploye FindByIDCard(string iDCard);


    }    
}