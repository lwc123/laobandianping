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
    public partial interface IServiceContractRepository : IRepository<ServiceContract,string>
    {
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="serviceId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<ServiceContract> FindByServiceId(long serviceId, Pagination pagination);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="buyerId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<ServiceContract> FindByBuyerId(long buyerId, Pagination pagination);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="sellerId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<ServiceContract> FindBySellerId(long sellerId, Pagination pagination);

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="contractStatus"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        IList<ServiceContract> FindByContractStatus(ContractStatus contractStatus, Pagination pagination);

    }    
}