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
    public partial class SmsMessage : EntityBase<long>
    {   
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
        public string MobilePhone { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string Content { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public long PassportId { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public long FromPassportId { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public string SendStatus { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public string PushStatus { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public string FailedReason { get; set; }

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
        public SmsMessage()
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
            var repository = RepositoryManager.GetRepository<ISmsMessageRepository>(ModuleEnvironment.ModuleName);
            return repository.Save(this);
        }
  
        #endregion //Persist Methods
    }
}

