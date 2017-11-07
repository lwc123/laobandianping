using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace JXBC.WebCore.Mvc
{
    /// <summary>
    /// 
    /// </summary>
    public class UnhandledErrorController : Controller
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="code"></param>
        /// <returns></returns>
        public ActionResult Index(string code)
        {
            ViewBag.Test = MvcContext.Current.Test;
            var exception = this.HttpContext.Server.GetLastError();
            if (string.IsNullOrEmpty(code) && null != exception && exception is HttpException)
            {
                code = (exception as HttpException).ErrorCode.ToString();
            }
            if (exception == null)
            {
                exception = new Exception("exception is null.");
            }


            if (code == "404")
            {
                return NotFound404();
            }
            if (string.IsNullOrEmpty(code)) code = "500";

            this.HttpContext.Response.StatusCode = 500;
            this.HttpContext.Server.ClearError();
            return View("_common_error_500", new HandleErrorInfo(exception, "UnhandledError", code));
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public ActionResult NotFound404()
        {
            this.HttpContext.Response.StatusCode = 404;
            this.HttpContext.Server.ClearError();
            return View("_common_error_404");
        }
    }
}
