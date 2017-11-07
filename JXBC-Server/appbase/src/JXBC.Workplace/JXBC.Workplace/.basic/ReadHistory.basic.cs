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
    public partial class ReadHistory : EntityBase<long>
    {
        #region Static Members
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static ReadHistory FindById(long id)
        {
            if (id < 1) return null;
				
            var repository = RepositoryManager.GetRepository<IReadHistoryRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }


        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizSource"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<ReadHistory> FindByBizSource(string bizSource, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

			bizSource.AssertNotNull("bizSource");

            var repository = RepositoryManager.GetRepository<IReadHistoryRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByBizSource(bizSource, pagination);
            return list;
        }

	
        #endregion //Static Members
    
        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public long ItemId
        {
            get { return this.Id; }
            set { this.Id = value; }
        }		
        
        /// <summary> 
        ///  
        /// </summary> 
        public long PassportId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string BizSource { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string BizSourceId { get; set; }
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
		public ReadHistory()
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
            var repository = RepositoryManager.GetRepository<IReadHistoryRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<IReadHistoryRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

