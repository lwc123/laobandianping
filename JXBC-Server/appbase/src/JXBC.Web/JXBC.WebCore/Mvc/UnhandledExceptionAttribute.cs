using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Mvc;
using M2SA.AppGenome;
using M2SA.AppGenome.Logging;
using JXBC.WebCore.ViewModels;

namespace JXBC.WebCore.Mvc
{
    public class UnhandledExceptionAttribute : HandleErrorAttribute
    {
        public override void OnException(ExceptionContext filterContext)
        {
            var exSource = filterContext.Exception;
            if(null == exSource) return;

            var test = false;
            try
            {
                test = MvcContext.Current.Test;
            }
            catch
            {
                Console.WriteLine();
            }

            if (filterContext.HttpContext.Request.IsAjaxRequest())
            {
                filterContext.ExceptionHandled = true;
                var resultModel = new MessageResult() {Success = false};
                if (test) resultModel.Message = filterContext.Exception.Message;
                else resultModel.MsgType = "error:500";

                filterContext.Result = new JsonResult()
                {
                    Data = resultModel,
                    JsonRequestBehavior = JsonRequestBehavior.AllowGet
                };                
            }

            if (null != filterContext.Exception)
                HandleException(filterContext.Exception, null);
        }

        [System.Diagnostics.CodeAnalysis.SuppressMessage("Microsoft.Design", "CA1031:DoNotCatchGeneralExceptionTypes")]
        public Exception HandleException(Exception exception, IDictionary bizInfo)
        {
            try
            {
                LogManager.GetLogger("ExceptionLogger").Error(exception,bizInfo);
            }
            catch (Exception ex)
            {
                EffectiveFileLogger.WriteException(exception);
                EffectiveFileLogger.WriteException(ex);
            }
            return exception;
        }
    }
}
