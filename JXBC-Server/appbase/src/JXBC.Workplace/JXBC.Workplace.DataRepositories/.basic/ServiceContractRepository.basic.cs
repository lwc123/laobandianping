
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
    public partial class ServiceContractRepository : SimpleRepositoryBase<ServiceContract,string>, IServiceContractRepository
    {

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="serviceId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<ServiceContract> FindByServiceId(long serviceId, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByServiceId");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("ServiceId", serviceId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="buyerId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<ServiceContract> FindByBuyerId(long buyerId, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByBuyerId");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("BuyerId", buyerId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="sellerId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<ServiceContract> FindBySellerId(long sellerId, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectBySellerId");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("SellerId", sellerId);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="contractStatus"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>  
        public IList<ServiceContract> FindByContractStatus(ContractStatus contractStatus, Pagination pagination)
        {            
            var sqlName = this.FormatSqlName("SelectByContractStatus");
            var sqlParams = new Dictionary<string, object>(1);
            sqlParams.Add("ContractStatus", contractStatus);
            var dataTable = SqlHelper.ExecutePaginationTable(sqlName, sqlParams, pagination);
            var result = this.Convert(dataTable);
            return result;
        }
        
    } 
}