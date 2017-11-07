using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome.Reflection;
using JXBC.Passports;

namespace JXBC.WebCore.ViewModels
{
    public static class ProfileExtension
    {
        public static UserProfile FormatEntity(this UserProfile item)
        {
            if (null == item) return item;

            item.Avatar = ImageHelper.ToAbsoluteUri(item.Avatar);
            if (string.IsNullOrEmpty(item.Avatar))
            {
                //if(item.Gender == 0)
                //    item.Avatar = ImageHelper.ToAbsoluteUri("/avatar/default_man.png");
                //else if (item.Gender == 1)
                //    item.Avatar = ImageHelper.ToAbsoluteUri("/avatar/default_woman.png");
                //else
                //    item.Avatar = ImageHelper.ToAbsoluteUri("/avatar/default_common.png");

                item.Avatar = ImageHelper.ToAbsoluteUri("/avatar/default_common.png");
            }

            if (item is OrganizationProfile)
            {
                var consultantProfile = (OrganizationProfile)item;

                if (null != consultantProfile.AuthenticationImages && consultantProfile.AuthenticationImages.Length > 0)
                {
                    for(var i=0; i< consultantProfile.AuthenticationImages.Length;i++)
                        consultantProfile.AuthenticationImages[i] = ImageHelper.ToAbsoluteUri(consultantProfile.AuthenticationImages[i]);
                }
            }
            return item;
        }
    }
}
