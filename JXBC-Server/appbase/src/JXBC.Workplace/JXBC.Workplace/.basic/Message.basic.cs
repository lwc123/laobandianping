using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome.Data;
using JXBC.Passports;
using JXBC.Workplace.DataRepositories;

namespace JXBC.Workplace
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public partial class Message : EntityBase<long>
    {
        #region Static Members

        /// <summary>
        /// 
        /// </summary>
        /// <param name="id"></param>
        /// <returns></returns>
        public static Message FindById(long id)
        {
            if (id < 1) return null;
				
            var repository = RepositoryManager.GetRepository<IMessageRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindById(id);
            return model;
        }


	
        #endregion //Static Members
    
        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public long MessageId
        {
            get { return this.Id; }
            set { this.Id = value; }
        }		
        
        /// <summary> 
        ///  
        /// </summary> 
        public string MessageType { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long FromPassportId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long ToPassportId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public ProfileType ToProfileType { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string Subject { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string Picture { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string Url { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string Content { get; set; }
        /// <summary>
        /// 
        /// </summary>
        public string ExtendParams { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime SentTime { get; set; }
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
		public Message()
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
            var repository = RepositoryManager.GetRepository<IMessageRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public bool Delete()
        {
            var repository = RepositoryManager.GetRepository<IMessageRepository>(ModuleEnvironment.ModuleName);
            return repository.Remove(this);
        }

        #endregion //Persist Methods
    }
}

