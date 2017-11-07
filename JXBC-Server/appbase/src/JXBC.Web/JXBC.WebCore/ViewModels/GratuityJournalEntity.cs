using System;
using System.Collections.Generic;
using System.Linq;
using M2SA.AppGenome.Reflection;
using JXBC.Passports;
using JXBC.Workplace;

namespace JXBC.WebCore.ViewModels
{
    public static class GratuityJournalExtension
    {
        public static IList<GratuityJournalEntity> ToEntities(this IList<GratuityJournal> items)
        {
            if (items == null || items.Count < 1)
                return null;

            var profiles = UserPassport.FindByIds(items.Select(o => o.BuyerId).Distinct().ToArray());

            var result = new List<GratuityJournalEntity>();
            foreach (var item in items)
            {
                var profile = profiles.First(o => o.PassportId == item.BuyerId).Profile;
                result.Add(new GratuityJournalEntity(item, profile));
            }

            return result;
        }

        public static GratuityJournalEntity ToEntity(this GratuityJournal item)
        {
            if (null == item) return null;

            var profile = (OrganizationProfile)UserPassport.FindById(item.BuyerId).Profile;

            var entity = new GratuityJournalEntity(item, profile);
            return entity;
        }
    }

    public class GratuityJournalEntity : GratuityJournal
    {
        private UserProfile profile = null;
        /// <summary>
        /// 
        /// </summary>
        public UserProfile Profile
        {
            get { return profile; }
            set
            {
                this.profile = value;
                if (null != this.profile)
                    this.profile.FormatEntity();
            }
        }

        public GratuityJournalEntity()
        {
        }

        internal GratuityJournalEntity(GratuityJournal source, UserProfile profile)
        {
            this.SetPropertyValues(source.GetPropertyValues());
            this.Profile = profile;
        }
    }
}
