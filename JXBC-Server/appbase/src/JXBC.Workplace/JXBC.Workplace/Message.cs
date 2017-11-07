using System;
using System.Collections.Generic;
using System.Text;
using M2SA.AppGenome.Data;
using JXBC.Workplace.DataRepositories;
using JXBC.Passports;

namespace JXBC.Workplace
{
    /// <summary>
    /// 
    /// </summary>
    public partial class Message
    {
        /// <summary>
        /// 
        /// </summary>
        public static readonly int SystemNotificationPassportId = 1;

        /// <summary>
        /// 
        /// </summary>
        public static readonly string ImageType = "image";
        /// <summary>
        /// 
        /// </summary>
        public static readonly string TextType = "text";

        /// <summary>
        /// 
        /// </summary>
        public static readonly string PhoneType = "Phone";

        /// <summary>
        /// 
        /// </summary>
        /// <param name="toPassportId"></param>
        /// <param name="toProfileType"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public static IList<Message> FindSystemNotifications(long toPassportId, ProfileType toProfileType, Pagination pagination)
        {
            pagination.AssertNotNull("pagination");

            if (toPassportId < 1) return null;

            return FindByPassportId(toPassportId, toProfileType, SystemNotificationPassportId, pagination);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="toPassportId"></param>
        /// <param name="toProfileType"></param>
        /// <param name="fromPassportId"></param>
        /// <param name="pagination"></param>
        /// <returns></returns>
        public static IList<Message> FindByPassportId(long toPassportId, ProfileType toProfileType, long fromPassportId, Pagination pagination)
        {
            pagination.AssertNotNull("pagination");

            if (toPassportId < 1 || fromPassportId < 1) return null;

            var repository = RepositoryManager.GetRepository<IMessageRepository>(ModuleEnvironment.ModuleName);
            var list = repository.FindByPassportId(toPassportId, toProfileType, fromPassportId, pagination);
            return list;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public static bool AddNewMessage(Message model)
        {
            var saved = model.Save();
            if (saved)
            {
                //MessageContact.UpdateForLastMessage(model);
            }
            return saved;
        }
    }
}
