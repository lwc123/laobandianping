using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.ExceptionHandling;
using M2SA.AppGenome.Logging;

namespace JXBC.TradeSystem.Handlers
{
    /// <summary>
    /// 
    /// </summary>
    public class WebProxyHandler : IPaymentHandler
    {
        /// <summary>
        /// 
        /// </summary>
        public virtual string TargetBizSource { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string PreprocessApi { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string BizProcessApi { get; set; }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="paymentParams"></param>
        /// <returns></returns>
        public virtual bool Preprocess(Payment paymentParams)
        {
            this.BizProcessApi.AssertNotNull("BizProcessApi");
            paymentParams.AssertNotNull("paymentParams");

            var data = paymentParams.ToJson();

            
            try
            {
                var sw = System.Diagnostics.Stopwatch.StartNew();
                var response = new HttpDecorator().HttpPostJson(this.PreprocessApi, data, null);
                sw.Stop();

                LogManager.GetLogger().Info("Preprocess [{0}-{1}] {2}", response.StatusCode, sw.Elapsed, this.PreprocessApi);
                if (response.StatusCode == System.Net.HttpStatusCode.OK)
                {
                    LogManager.GetLogger().Info("Preprocess [{0}] {1}", response.Content, paymentParams.ToJson());

                    if (null != response.Content && response.Content.ToString().ToLower() == "true")
                    {                        
                        return true;
                    }
                }

                var errotInfo = new Dictionary<string, object>();
                errotInfo.Add("tradeJournal", paymentParams.ToJson());
                errotInfo.Add("BizProcessApi", this.PreprocessApi);
                errotInfo.Add("HttpStatusCode", response.StatusCode);
                if (response.StatusCode == System.Net.HttpStatusCode.OK)
                {
                    errotInfo.Add("HttpResult", response.Content);
                }
                LogManager.GetLogger().Error(errotInfo);
                return false;
            }
            catch(Exception ex)
            {
                var info = new Dictionary<string, object>();
                info.Add("paymentParams", paymentParams.ToJson());
                ex.HandleException(info);
                return false; 
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="tradeJournal"></param>
        public virtual BizProcessResult BizProcess(TradeJournal tradeJournal)
        {
            this.BizProcessApi.AssertNotNull("BizProcess");
            tradeJournal.AssertNotNull("tradeJournal");

            var data = tradeJournal.ToJson();

            try
            {
                var sw = System.Diagnostics.Stopwatch.StartNew();
                var response = new HttpDecorator().HttpPostJson(this.BizProcessApi, data, null);
                sw.Stop();

                LogManager.GetLogger().Info("BizProcess [{0}-{1}] {2}", response.StatusCode, sw.Elapsed, this.BizProcessApi);

                if (response.StatusCode == System.Net.HttpStatusCode.OK)
                {
                    if (null != response.Content)
                    {
                        LogManager.GetLogger().Info("BizProcess [{0}] <<===== {1}", response.Content, tradeJournal.ToJson());
                        var result = response.Content.ConvertEntity<BizProcessResult>();
                        return result;
                    }

                }

                var errorInfo = new Dictionary<string, object>();
                errorInfo.Add("tradeJournal", tradeJournal.ToJson());
                errorInfo.Add("BizProcessApi", this.BizProcessApi);
                errorInfo.Add("HttpStatusCode", response.StatusCode);
                if (response.StatusCode == System.Net.HttpStatusCode.OK)
                {
                    errorInfo.Add("HttpResult", response.Content);
                }
                LogManager.GetLogger().Error(errorInfo);
                return BizProcessResult.CreateErrorResult(this.GetType().Name, string.Format("the request failed[{0}].", response.StatusCode));
            }
            catch (Exception ex)
            {
                var info = new Dictionary<string, object>();
                info.Add("tradeJournal", tradeJournal.ToJson());
                ex.HandleException(info);
                return BizProcessResult.CreateErrorResult(this.GetType().Name, ex.Message);
            }
        }                
    }
}
