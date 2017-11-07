using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Reflection;
using JXBC.TradeSystem;
using JXBC.Workplace.PaymentExtension;

namespace JXBC.WebCore.ViewModels
{
    public static class UserWalletJournalExtension
    {
        public static IList<UserWalletJournalEntity> ToEntities(this IList<WalletJournal> items)
        {
            if (items == null || items.Count < 1)
                return null;
            var result = new List<UserWalletJournalEntity>();
            foreach (var item in items)
            {
                result.Add(new UserWalletJournalEntity(item));
            }

            return result;
        }

        public static UserWalletJournalEntity ToEntity(this WalletJournal item)
        {
            if (null == item) return null;

            var entity = new UserWalletJournalEntity(item);
            return entity;
        }
    }

    public class UserWalletJournalEntity : WalletJournal
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

        public UserWalletJournalEntity()
        {
        }

        internal UserWalletJournalEntity(WalletJournal source)
        {
            this.SetPropertyValues(source.GetPropertyValues());
            this.Title = GetJournalTitle(this.BizSource);
        }
    }
}
