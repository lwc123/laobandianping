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
    public partial class Favorite : EntityBase<long>
    {
        #region Static Members
        
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="bizType"></param>
		/// <param name="pagination"></param>
        /// <returns></returns> 
        public static IList<Favorite> FindByBizType(BizType bizType, Pagination pagination)
        {
			pagination.AssertNotNull("pagination");

            var repository = RepositoryManager.GetRepository<IFavoriteRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByBizType(bizType, pagination);
            return list;
        }
	
        #endregion //Static Members
    
        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public long FavoriteId
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
        public BizType BizType { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long BizId { get; set; }
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
		public Favorite()
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
            var repository = RepositoryManager.GetRepository<IFavoriteRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<IFavoriteRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

