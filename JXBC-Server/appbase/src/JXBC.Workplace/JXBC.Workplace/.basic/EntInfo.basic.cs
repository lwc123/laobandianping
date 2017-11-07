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
    public partial class EntInfo : IEntity<long>
    {
        #region Static Members
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static EntInfo FindById(long id)
        {
            if (id < 1) return null;
                
            var repository = RepositoryManager.GetRepository<IEntInfoRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }   

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="entName"></param> 
        /// <returns></returns> 
        public static EntInfo FindByEntName(string entName)
        {  
            ArgumentAssertion.IsNotNull(entName, "entName");

            var repository = RepositoryManager.GetRepository<IEntInfoRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByEntName(entName);
            return model;
        }

    
        
        
        #endregion //Static Members
    
        #region Instance Properties

        /// <summary>
        /// Entity Id
        /// </summary>
        [NonSerializedProperty]
        public long Id
        {
            get { return this.EntId; }
            set { this.EntId = value; }
        }
        
        /// <summary>
        /// 
        /// </summary>
        public PersistentState PersistentState { get; set; }        
        
        /// <summary> 
        ///  
        /// </summary> 
        public long EntId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string EntName { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string DisplayName { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public ContractStatus EntStatus { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string RegisterLocation { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string HomePage { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string LegalRepresentative { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string Description { get; set; }
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
            var repository = RepositoryManager.GetRepository<IEntInfoRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<IEntInfoRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

