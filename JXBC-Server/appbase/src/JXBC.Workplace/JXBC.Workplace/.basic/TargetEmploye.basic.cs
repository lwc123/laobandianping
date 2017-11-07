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
    public partial class TargetEmploye : IEntity<long>
    {
        #region Static Members
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static TargetEmploye FindById(long id)
        {
            if (id < 1) return null;
                
            var repository = RepositoryManager.GetRepository<ITargetEmployeRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }   

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="passportId"></param> 
        /// <returns></returns> 
        public static TargetEmploye FindByPassportId(long passportId)
        {  
            if (passportId < 1) return null;

            var repository = RepositoryManager.GetRepository<ITargetEmployeRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByPassportId(passportId);
            return model;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="iDCard"></param> 
        /// <returns></returns> 
        public static TargetEmploye FindByIDCard(string iDCard)
        {  
            ArgumentAssertion.IsNotNull(iDCard, "iDCard");

            var repository = RepositoryManager.GetRepository<ITargetEmployeRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByIDCard(iDCard);
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
            get { return this.EmployeId; }
            set { this.EmployeId = value; }
        }
        
        /// <summary>
        /// 
        /// </summary>
        public PersistentState PersistentState { get; set; }        
        
        /// <summary> 
        ///  
        /// </summary> 
        public long EmployeId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long PassportId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string RealName { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string IDCard { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string[] Tags { get; set; }
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
        public TargetEmploye()
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
        
            var repository = RepositoryManager.GetRepository<ITargetEmployeRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<ITargetEmployeRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

