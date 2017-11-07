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
    public partial class DictionaryEntry : EntityBase<long>
    {   
        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public long EntryId
        {
            get { return this.Id; }
            set { this.Id = value; }
        }		
        
        /// <summary> 
        ///  
        /// </summary> 
        public string Code { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public string Name { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public string RelativeKeys { get; set; }

        /// <summary> 
        ///  
        /// </summary> 
        public bool Forbidden { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime CreatedTime { get; set; }
        /// <summary> 
        ///  
        /// </summary> 
        public DateTime ModifiedTime { get; set; }
 
        #endregion //Instance Properties
    }
}

