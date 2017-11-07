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
    public partial class GratuityJournal : EntityBase<long>
    {
        #region Static Members
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static GratuityJournal FindById(long id)
        {
            if (id < 1) return null;
				
            var repository = RepositoryManager.GetRepository<IGratuityJournalRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }


        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizType"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<GratuityJournal> FindByBizType(int bizType, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

            if (bizType < 1) return null;

            var repository = RepositoryManager.GetRepository<IGratuityJournalRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByBizType(bizType, pagination);
            return list;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="buyerId"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<GratuityJournal> FindByBuyerId(long buyerId, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

            if (buyerId < 1) return null;

            var repository = RepositoryManager.GetRepository<IGratuityJournalRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByBuyerId(buyerId, pagination);
            return list;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="sellerId"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<GratuityJournal> FindBySellerId(long sellerId, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

            if (sellerId < 1) return null;

            var repository = RepositoryManager.GetRepository<IGratuityJournalRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindBySellerId(sellerId, pagination);
            return list;
        }

	
        #endregion //Static Members
    
        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public long JournalId
        {
            get { return this.Id; }
            set { this.Id = value; }
        }		
        
        /// <summary> 
        ///  
        /// </summary> 
        public BizType BizType { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long BizId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long BuyerId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long SellerId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public decimal TotalFee { get; set; }
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
		public GratuityJournal()
		{
			this.CreatedTime = DateTime.Now;
			this.ModifiedTime = this.CreatedTime;
		}

        #region Persist Methods
        
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Save()
        {
            this.ModifiedTime = DateTime.Now;
            var repository = RepositoryManager.GetRepository<IGratuityJournalRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<IGratuityJournalRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

