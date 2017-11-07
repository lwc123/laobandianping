using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using JXBC.Passports.DataRepositories;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;

namespace JXBC.Passports
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class ClientDevice : EntityBase<long>
    {
        private static readonly object Sync = new object();

        #region Static Methods

        /// <summary>
        /// 
        /// </summary>
        /// <param name="deviceKey"></param>
        /// <returns></returns>
        public static ClientDevice FindByKey(string deviceKey)
        {
            var repository = RepositoryManager.GetRepository<IClientDeviceRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByKey(deviceKey);
            return model;
        }

        #endregion //Static Methods


        #region Instance Properties

        /// <summary>
        /// 
        /// </summary>
        public long DeviceId
        {
            get { return this.Id; }
            set { this.Id = value; }
        }

        /// <summary>
        /// 
        /// </summary>
        public string DeviceKey { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public int SdkVersion { get; set; }
        
        /// <summary>
        /// 
        /// </summary>
        public string Device { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Brand { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string Product { get; set; }

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
        public ClientDevice()
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
            this.ModifiedTime = this.CreatedTime;

            var oldModel = FindByKey(this.DeviceKey);
            if (null != oldModel)
            {
                this.DeviceId = oldModel.DeviceId;
                this.PersistentState = PersistentState.Persistent;
                return true;
            }

            lock (Sync)
            {
                oldModel = FindByKey(this.DeviceKey);
                if (null != oldModel)
                {
                    this.DeviceId = oldModel.DeviceId;
                    this.PersistentState = PersistentState.Persistent;
                    return true;
                }

                var repository = RepositoryManager.GetRepository<IClientDeviceRepository>(ModuleEnvironment.ModuleName);
                var isSaved = repository.Save(this);
                return isSaved;
            }
        }

        #endregion //Persist Methods
    }
}