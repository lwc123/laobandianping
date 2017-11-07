using System.Web;
using System.Web.Mvc;

namespace JXBC.WebCore.Mvc
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            filters.Add(new UnhandledExceptionAttribute());
            filters.Add(new UnhandledFilterAttribute());
        }
    }
}