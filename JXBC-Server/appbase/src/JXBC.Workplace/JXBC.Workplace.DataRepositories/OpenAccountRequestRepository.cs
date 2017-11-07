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
    public partial class OpenAccountRequestRepository
    {
        #region Convert 

        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        protected override IDictionary<string, object> Convert(OpenAccountRequest model)
        {
            var sqlParams = base.Convert(model);
            sqlParams["AttestationImages"] = model.AttestationImages == null ? null : model.AttestationImages.ToJson();
            return sqlParams;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="dataRow"></param>
        /// <returns></returns>
        protected override OpenAccountRequest Convert(DataRow dataRow)
        {
            var model = base.Convert(dataRow);
            var texts = dataRow["AttestationImages"].Convert<string>();
            if (null != texts)
                model.AttestationImages = texts.ConvertEntity<string[]>();
            return model;
        }

        #endregion //Convert 

    }
}