using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Reflection;
using JXBC.TradeSystem;
using JXBC.Workplace.PaymentExtension;

namespace JXBC.WebCore.ViewModels
{
    public static class TradeJournalExtension
    {
        public static IList<TradeJournalEntity> ToEntities(this IList<TradeJournal> items)
        {
            if (items == null || items.Count < 1)
                return null;
            var result = new List<TradeJournalEntity>();
            foreach (var item in items)
            {
                result.Add(new TradeJournalEntity(item));
            }

            return result;
        }

        public static TradeJournalEntity ToEntity(this TradeJournal item)
        {
            if (null == item) return null;

            var entity = new TradeJournalEntity(item);
            return entity;
        }
    }

    public class TradeJournalEntity : TradeJournal
    {
        private static string GetJournalTitle(string bizSource)
        {
            if(bizSource == BizSources.Deposit)
                return "充值";
            else if (bizSource == PaymentSources.OpenEnterpriseService)
                return "开通服务";
            else
                return bizSource;
        }

        public string Title { get; set; }

        public TradeJournalEntity()
        {
        }

        internal TradeJournalEntity(TradeJournal source)
        {
            this.SetPropertyValues(source.GetPropertyValues());
            this.Title = GetJournalTitle(this.BizSource);
        }
    }
}
