using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Reflection;
using JXBC.Passports;
using JXBC.Workplace;
using System.Web;

namespace JXBC.WebCore.ViewModels
{
    public static class MessageExtension
    {
        public static IList<Message> ToEntities(this IList<Message> items)
        {
            if (items == null || items.Count < 1)
                return null;

            foreach (var item in items)
            {
                item.ToEntity();
            }

            return items;
        }

        public static Message ToEntity(this Message item)
        {
            
            if (null == item) return item;

            item.Picture = ImageHelper.ToAbsoluteUri(item.Picture);
            if (false == string.IsNullOrEmpty(item.Url) && false == item.Url.StartsWith("http://"))
                item.Url = string.Concat("http://", HttpContext.Current.Request.Url.Host
                    , HttpContext.Current.Request.Url.Port == 80 ? "" : ":"+ HttpContext.Current.Request.Url.Port.ToString()
                    , HttpContext.Current.Request.ApplicationPath, item.Url);

            return item;
        }
    }
}
