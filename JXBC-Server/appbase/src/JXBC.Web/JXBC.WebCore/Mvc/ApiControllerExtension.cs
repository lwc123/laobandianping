using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web.Http;

namespace JXBC.WebCore.Mvc
{
    public static class ApiControllerExtension
    {
        public static void ReturnPreconditionFailedMessage(this ApiController controller, string content = null, string reason = null)
        {
            if (string.IsNullOrEmpty(reason))
                reason = "不符合预期的输入参数";

            if (string.IsNullOrEmpty(content))
                reason = "不符合预期的输入参数";

            controller.ReturnFailedMessage(HttpStatusCode.PreconditionFailed, content, reason);
        }

        public static void ReturnFailedMessage(this ApiController controller, HttpStatusCode statusCode, string content, string reason = null)
        {
            if (null == content)
                content = string.Empty;
            if (null == reason)
                reason = string.Empty;

            var message = new HttpResponseMessage(statusCode)
            {
                Content = new StringContent(content),
                ReasonPhrase = reason
            };
            throw new HttpResponseException(message);
        }
    }
}
