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
    public partial class OpenAccountRequest : IEntity<long>
    {
        #region Static Members
        
        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static OpenAccountRequest FindById(long id)
        {
            if (id < 1) return null;
                
            var repository = RepositoryManager.GetRepository<IOpenAccountRequestRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }   

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="passportId"></param> 
        /// <returns></returns> 
        public static OpenAccountRequest FindByPassportId(long passportId)
        {  
            if (passportId < 1) return null;

            var repository = RepositoryManager.GetRepository<IOpenAccountRequestRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByPassportId(passportId);
            return model;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="entName"></param> 
        /// <returns></returns> 
        public static OpenAccountRequest FindByEntName(string entName)
        {  
            ArgumentAssertion.IsNotNull(entName, "entName");

            var repository = RepositoryManager.GetRepository<IOpenAccountRequestRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByEntName(entName);
            return model;
        }

        /// <summary> 
        ///  
        /// </summary> 
        /// <param name="attestationStatus"></param> 
        /// <returns></returns> 
        public static OpenAccountRequest FindByAttestationStatus(int attestationStatus)
        {  
            if (attestationStatus < 1) return null;

            var repository = RepositoryManager.GetRepository<IOpenAccountRequestRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByAttestationStatus(attestationStatus);
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
            get { return this.RequestId; }
            set { this.RequestId = value; }
        }
        
        /// <summary>
        /// 
        /// </summary>
        public PersistentState PersistentState { get; set; }        
        
        /// <summary> 
        ///  
        /// </summary> 
        public long RequestId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long PassportId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string EntName { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string LegalRepresentative { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string[] AttestationImages { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public AttestationStatus AttestationStatus { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime AttestationTime { get; set; }
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
            var repository = RepositoryManager.GetRepository<IOpenAccountRequestRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<IOpenAccountRequestRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

