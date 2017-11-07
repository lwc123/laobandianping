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
    public partial class BossCommentRepository
    {
        #region Convert 

        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        protected override IDictionary<string, object> Convert(BossComment model)
        {
            var sqlParams = base.Convert(model);
            sqlParams["Images"] = model.Images == null ? null : model.Images.ToJson();
            return sqlParams;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataRow"></param>
        /// <returns></returns>
        protected override BossComment Convert(DataRow dataRow)
        {
            var model = base.Convert(dataRow);
            var texts = dataRow["Images"].Convert<string>();
            if (null != texts)
                model.Images = texts.ConvertEntity<string[]>();

            return model;
        }

        #endregion //Convert 

    }
}