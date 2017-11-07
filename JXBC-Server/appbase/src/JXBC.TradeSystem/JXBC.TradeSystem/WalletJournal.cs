using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using JXBC.TradeSystem.DataRepositories;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public partial class WalletJournal : EntityBase<long>
    {
        #region Static Members

        /// <summary>
        /// 
        /// </summary>
        public static readonly string PaidWayName = "wallet";

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static Wallet FindById(long id)
        {
            if (id < 1) return null;
				
            var repository = RepositoryManager.GetRepository<IWalletRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
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
        public long WalletId { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public long HandlerId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public TradeMode TradeMode { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string TargetTradeCode { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string BizSource { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public decimal TotalFee { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string LastOperator { get; set; }
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
		public WalletJournal()
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
            var repository = RepositoryManager.GetRepository<IWalletJournalRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        #endregion //Persist Methods
    }
}

