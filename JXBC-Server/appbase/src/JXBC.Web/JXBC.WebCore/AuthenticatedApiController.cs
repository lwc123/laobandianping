using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Web;
using System.Web.Http;

namespace JXBC.WebCore
{
    /// <summary>
    /// 
    /// </summary>
    [Authorize]
    public abstract class AuthenticatedApiController : ApiController
    {
    }
}
