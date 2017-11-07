using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Text;
using System.Web;
using System.Web.Http;
using M2SA.AppGenome.Data;
using M2SA.AppGenome.Reflection;
using JXBC.TradeSystem;
using JXBC.WebCore;
using JXBC.WebCore.ViewModels;
using JXBC.Workplace.PaymentExtension;
using JXBC.Passports;

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class UserWalletController : AuthenticatedApiController
    {
        [HttpGet]
        public IList<TradeJournalEntity> TradeHistory(int page = 1, int size = 10)
        {
            if (page < 1) page = 1;
            if (size < 1) size = 10;
            var pagination = new Pagination() { PageIndex = page, PageSize = size };

            string[] bizSources = new string[] { PaymentSources.OpenEnterpriseService };
            var list = TradeJournal.FindByOwnerId(MvcContext.Current.PassportId, bizSources, pagination);
            return list.ToEntities();
        }
    }
}
