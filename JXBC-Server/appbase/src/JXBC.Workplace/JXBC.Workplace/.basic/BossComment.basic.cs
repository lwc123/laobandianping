using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using JXBC.Workplace.DataRepositories;

namespace JXBC.Workplace
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public partial class BossComment : IEntity<long>
    {
        #region Static Members
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static BossComment FindById(long id)
        {
            if (id < 1) return null;
                
            var repository = RepositoryManager.GetRepository<IBossCommentRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }   

    
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="employeId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        public static IList<BossComment> FindByEmployeId(long employeId, Pagination pagination)
        {  
            if (employeId < 1) return null;

            var repository = RepositoryManager.GetRepository<IBossCommentRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByEmployeId(employeId, pagination);
            return list;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="commentEntId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        public static IList<BossComment> FindByCommentEntId(long commentEntId, Pagination pagination)
        {  
            if (commentEntId < 1) return null;

            var repository = RepositoryManager.GetRepository<IBossCommentRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByCommentEntId(commentEntId, pagination);
            return list;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="commentatorId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        public static IList<BossComment> FindByCommentatorId(long commentatorId, Pagination pagination)
        {  
            if (commentatorId < 1) return null;

            var repository = RepositoryManager.GetRepository<IBossCommentRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByCommentatorId(commentatorId, pagination);
            return list;
        }

        
        
        #endregion //Static Members
    
        #region Instance Properties

        /// <summary>
        /// Entity Id
        /// </summary>
        [NonSerializedProperty]
        public long Id
        {
            get { return this.CommentId; }
            set { this.CommentId = value; }
        }
        
        /// <summary>
        /// 
        /// </summary>
        public PersistentState PersistentState { get; set; }        
        
        /// <summary> 
        ///  
        /// </summary> 
        public long CommentId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long EmployeId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long CommentEntId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long CommentatorId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string CommentatorName { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string CommentatorJobTitle { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string TargetJobTitle { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public int WorkAbility { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public int WorkManner { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public int WorkAchievement { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string Text { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string Voice { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public int VoiceLength { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string[] Images { get; set; }
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
        public BossComment()
        {
            this.CreatedTime = DateTime.Now;
        }

        #region Persist Methods
        
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Save()
        {
            this.ModifiedTime = DateTime.Now;
        
            var repository = RepositoryManager.GetRepository<IBossCommentRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<IBossCommentRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

