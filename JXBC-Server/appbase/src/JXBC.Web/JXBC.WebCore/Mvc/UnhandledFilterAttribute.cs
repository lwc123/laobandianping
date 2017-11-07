using System;
using System.Collections;
using System.Web;
using System.Web.Http.Filters;
using System.Web.Mvc;
using M2SA.AppGenome.Logging;
using System.Net.Http;
using System.Net;
using JXBC.WebCore.ViewModels;

namespace JXBC.WebCore.Mvc
{
    /// <summary>
    /// 
    /// </summary>
    public class UnhandledFilterAttribute : ExceptionFilterAttribute, System.Web.Mvc.IExceptionFilter
    {
        public override void OnException(HttpActionExecutedContext actionExecutedContext)
        {
            var exSource = actionExecutedContext.Exception;
            if (null == exSource) return;
            
            var ex = new HttpUnhandledException(exSource.Message, exSource);
            HandleException(ex, null);

            if (actionExecutedContext.Response == null)
            {
                actionExecutedContext.Response = new HttpResponseMessage();

            }
            actionExecutedContext.Response.StatusCode = HttpStatusCode.InternalServerError;
            actionExecutedContext.Response.Content = new StringContent(new MessageResult() { Message = ex.Message }.ToJson());
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

        public void OnException(ExceptionContext filterContext)
        {
            var exSource = filterContext.Exception;
            if (null == exSource) return;

            var ex = new HttpUnhandledException(exSource.Message, exSource);
            HandleException(ex, null);
            filterContext.HttpContext.Response.StatusCode = (int)HttpStatusCode.InternalServerError;
            filterContext.Result = new ContentResult() { Content = new MessageResult() { Message = ex.Message }.ToJson() };
        }
    }
}
