using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;
using JXBC.TradeSystem.DataRepositories;
using M2SA.AppGenome;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public partial class TradeJournal : Payment, IEntity<string>
    {
        #region Static Members

        /// <summary>
        /// 
        /// </summary>
        /// <param name="payment"></param>
        /// <returns></returns>
        internal static TradeJournal CreateNew(Payment payment)
        {
            payment.AssertNotNull("payment");
            payment.CommoditySubject.AssertNotNull("payment:CommoditySubject");
            payment.TradeType.AssertNotNull("payment:TradeType");

            var tradeJournal = new TradeJournal();
            tradeJournal.TradeCode = string.Concat(tradeJournal.CreatedTime.ToString("yyyyMMddHHmmssfff")
                , new Random().Next(1000000, 9999999));
            tradeJournal.ParentTradeCode = payment.ParentTradeCode;
            tradeJournal.OwnerId = payment.OwnerId;
            tradeJournal.ClientIP = payment.ClientIP;
            tradeJournal.TradeType = payment.TradeType;
            tradeJournal.TradeMode = payment.TradeMode;
            tradeJournal.PayWay = payment.PayWay;
            tradeJournal.PayRoute = payment.PayRoute;
            tradeJournal.BizSource = payment.BizSource;
            tradeJournal.CommodityCategory = payment.CommodityCategory;
            tradeJournal.CommodityCode = payment.CommodityCode;
            tradeJournal.CommodityQuantity = payment.CommodityQuantity;
            tradeJournal.CommoditySubject = payment.CommoditySubject;
            tradeJournal.CommoditySummary = payment.CommoditySummary;
            tradeJournal.CommodityExtension = payment.CommodityExtension;
            tradeJournal.ReturnUrl = payment.ReturnUrl;
            tradeJournal.TotalFee = payment.TotalFee;
            tradeJournal.TradeStatus = TradeStatus.New;
            tradeJournal.BuyerId = payment.BuyerId;
            tradeJournal.SellerId = payment.SellerId;
            tradeJournal.ClientIP = payment.ClientIP;
            tradeJournal.Save();

            return tradeJournal;
        }
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static TradeJournal FindById(string id)
        {
			id.AssertNotNull("id");		
            var repository = RepositoryManager.GetRepository<ITradeJournalRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="ownerId"></param>
        /// <param name="tradeTypes"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public static IList<TradeJournal> FindByOwnerId(long ownerId, IList<TradeType> tradeTypes, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

            if (ownerId < 1) return null;

            var repository = RepositoryManager.GetRepository<ITradeJournalRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByOwnerId(ownerId, tradeTypes, pagination);
            return list;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="tradeStatus"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<TradeJournal> FindByTradeStatus(int tradeStatus, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

            if (tradeStatus < 1) return null;

            var repository = RepositoryManager.GetRepository<ITradeJournalRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByTradeStatus(tradeStatus, pagination);
            return list;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizSource"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<TradeJournal> FindByBizSource(string bizSource, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

			bizSource.AssertNotNull("bizSource");

            var repository = RepositoryManager.GetRepository<ITradeJournalRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByBizSource(bizSource, pagination);
            return list;
        }


        #endregion //Static Members

        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public string Id
        {
            get { return this.TradeCode; }
            set { this.TradeCode = value; }
        }

        /// <summary>
        /// 
        /// </summary>
        public PersistentState PersistentState { get; set; }        


        /// <summary> 
        ///  
        /// </summary> 
        public TradeStatus TradeStatus { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public string LastOperator { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string TargetBizTradeCode { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public string ThirdBuyerCode { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public DateTime ModifiedTime { get; set; }
 
        #endregion //Instance Properties
		
        /// <summary>
        /// 
        /// </summary>	
		public TradeJournal()
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
            var repository = RepositoryManager.GetRepository<ITradeJournalRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeStatus"></param>
        /// <returns></returns>
        public bool UpdateTradeStatus(TradeStatus tradeStatus)
        {
            if (tradeStatus == TradeStatus.BizCompleted)
            {
                throw new ArgumentOutOfRangeException("tradeStatus");
            }

            this.TradeStatus = tradeStatus;
            this.ModifiedTime = DateTime.Now;
            var repository = RepositoryManager.GetRepository<ITradeJournalRepository>(ModuleEnvironment.ModuleName);
            return repository.UpdateTradeStatus(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="bizTradeCode"></param>
        /// <returns></returns>
        public bool CompletedTrade(string bizTradeCode)
        {
            bizTradeCode.AssertNotNull("bizTradeCode");

            if (false == string.IsNullOrEmpty(this.TargetBizTradeCode)) return false;
            if (this.TradeStatus != TradeStatus.Paid) return false;

            this.TradeStatus = TradeStatus.BizCompleted;
            this.TargetBizTradeCode = bizTradeCode;
            if(this.OwnerId < 0)
            {
                this.OwnerId = this.TargetBizTradeCode.Convert<long>();
            }
            this.ModifiedTime = DateTime.Now;
            var repository = RepositoryManager.GetRepository<ITradeJournalRepository>(ModuleEnvironment.ModuleName);
            return repository.UpdateBizTradeCode(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<ITradeJournalRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

