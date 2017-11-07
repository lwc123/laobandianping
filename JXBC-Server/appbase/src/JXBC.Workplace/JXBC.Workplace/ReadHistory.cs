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
    public partial class ReadHistory
    {
        /// <summary>
        /// 
        /// </summary>
        public static readonly string BizSource_SoldServices = "SoldServices";

        /// <summary>
        /// 
        /// </summary>
        public static readonly string BizSource_Message = "Message";

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizSource"></param>
        /// <returns></returns>
        public static bool AppendReadHistory(long passportId, string bizSource)
        {
            var item = FindByBizSource(passportId, bizSource);
            if(null == item)
            {
                item = new ReadHistory()
                {
                    PassportId = passportId,
                    BizSource = bizSource
                };
            }
            return item.Save();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizSource"></param>
        /// <returns></returns>
        public static ReadHistory FindByBizSource(long passportId, string bizSource)
        {
            bizSource.AssertNotNull("bizSource");

            if (passportId < 1) return null;

            var repository = RepositoryManager.GetRepository<IReadHistoryRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByBizSource(passportId, bizSource);
            return model;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="passportId"></param>
        /// <param name="bizSource"></param>
        /// <param name="bizSourceId"></param>
        /// <returns></returns>
        public static ReadHistory FindByBizSourceId(long passportId, string bizSource, string bizSourceId)
        {
            bizSource.AssertNotNull("bizSource");

            if (passportId < 1) return null;

            var repository = RepositoryManager.GetRepository<IReadHistoryRepository>(ModuleEnvironment.ModuleName);
            var model = repository.FindByBizSourceId(passportId, bizSource, bizSourceId);
            return model;
        }
    }
}

