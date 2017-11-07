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
    public partial class SearchHistory : EntityBase<int>
    {
        #region Static Members
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static SearchHistory FindById(int id)
        {
            if (id < 1) return null;
				
            var repository = RepositoryManager.GetRepository<ISearchHistoryRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }


        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizSource"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<SearchHistory> FindByBizSource(string bizSource, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

			bizSource.AssertNotNull("bizSource");

            var repository = RepositoryManager.GetRepository<ISearchHistoryRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByBizSource(bizSource, pagination);
            return list;
        }

	
        #endregion //Static Members
    
        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public int ItemId
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
        public string Keyword { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public int SearchTimes { get; set; }
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
		public SearchHistory()
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
            var repository = RepositoryManager.GetRepository<ISearchHistoryRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<ISearchHistoryRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

