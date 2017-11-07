using System;
using System.Collections.Generic;
using System.Text;
using System.Data;
using M2SA.AppGenome;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;
using JXBC.TradeSystem;

namespace JXBC.Workplace.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class TargetEmployeRepository
    {
        #region Convert 

        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        protected override IDictionary<string, object> Convert(TargetEmploye model)
        {
            var sqlParams = base.Convert(model);
            sqlParams["Tags"] = model.Tags == null ? null : model.Tags.ToJson();
            return sqlParams;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataRow"></param>
        /// <returns></returns>
        protected override TargetEmploye Convert(DataRow dataRow)
        {
            var model = base.Convert(dataRow);

            var tags = dataRow["Tags"].Convert<string>();
            if (null != tags)
                model.Tags = tags.ConvertEntity<string[]>();

            return model;
        }

        #endregion //Convert 

    }
}