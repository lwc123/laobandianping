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
    public partial class EntMember : IEntity<long>
    {
        #region Static Members
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static EntMember FindById(long id)
        {
            if (id < 1) return null;
                
            var repository = RepositoryManager.GetRepository<IEntMemberRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }   

    
        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="entId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        public static IList<EntMember> FindByEntId(long entId, Pagination pagination)
        {  
            if (entId < 1) return null;

            var repository = RepositoryManager.GetRepository<IEntMemberRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByEntId(entId, pagination);
            return list;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="passportId"></param> 
        /// <param name="pagination"></param> 
        /// <returns></returns>         
        public static IList<EntMember> FindByPassportId(long passportId, Pagination pagination)
        {  
            if (passportId < 1) return null;

            var repository = RepositoryManager.GetRepository<IEntMemberRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByPassportId(passportId, pagination);
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
            get { return this.MemberId; }
            set { this.MemberId = value; }
        }
        
        /// <summary>
        /// 
        /// </summary>
        public PersistentState PersistentState { get; set; }        
        
        /// <summary> 
        ///  
        /// </summary> 
        public long MemberId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long EntId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long PassportId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public int MemberStatus { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string JobTitle { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public int Role { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime CreatedTime { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime ModifiedTime { get; set; }
 
        #endregion //Instance Properties

        #region Persist Methods
        
        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Save()
        {
            var repository = RepositoryManager.GetRepository<IEntMemberRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<IEntMemberRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

