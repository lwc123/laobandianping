using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome.Data;
using JXBC.Workplace.DataRepositories;

namespace JXBC.Workplace
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public partial class ServiceContract : EntityBase<string>
    {
        #region Static Members
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static ServiceContract FindById(string id)
        {
			id.AssertNotNull("id");		
            var repository = RepositoryManager.GetRepository<IServiceContractRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }


        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="serviceId"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<ServiceContract> FindByServiceId(long serviceId, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

            if (serviceId < 1) return null;

            var repository = RepositoryManager.GetRepository<IServiceContractRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByServiceId(serviceId, pagination);
            return list;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="buyerId"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<ServiceContract> FindByBuyerId(long buyerId, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

            if (buyerId < 1) return null;

            var repository = RepositoryManager.GetRepository<IServiceContractRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByBuyerId(buyerId, pagination);
            return list;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="sellerId"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<ServiceContract> FindBySellerId(long sellerId, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

            if (sellerId < 1) return null;

            var repository = RepositoryManager.GetRepository<IServiceContractRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindBySellerId(sellerId, pagination);
            return list;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="contractStatus"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<ServiceContract> FindByContractStatus(ContractStatus contractStatus, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");
            
            var repository = RepositoryManager.GetRepository<IServiceContractRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByContractStatus(contractStatus, pagination);
            return list;
        }

	
        #endregion //Static Members
    
        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public string ContractCode
        {
            get { return this.Id; }
            set { this.Id = value; }
        }
        /// <summary> 
        ///  
        /// </summary> 
        public long BuyerId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public ContractStatus ContractStatus { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime ServiceBeginTime { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime ServiceEndTime { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public int ServicePeriod { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public decimal TotalFee { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string PaidWay { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string TradeCode { get; set; }
        
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime CreatedTime { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime ModifiedTime { get; set; }
 
        #endregion //Instance Properties
		
        /// <summary>
        /// 
        /// </summary>	
		public ServiceContract()
		{
			this.CreatedTime = DateTime.Now;
			this.ModifiedTime = this.CreatedTime;
		}

        #region Persist Methods
        
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        internal bool Save()
        {
            this.ModifiedTime = DateTime.Now;
            var repository = RepositoryManager.GetRepository<IServiceContractRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        internal bool Delete()
        {
            var repository = RepositoryManager.GetRepository<IServiceContractRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

