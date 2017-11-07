using M2SA.AppGenome;
using M2SA.AppGenome.Data;

namespace JXBC.Passports.DataRepositories
{
    /// <summary>
    /// 
    /// </summary>
    public partial class UserSecurityRepository : SimpleRepositoryBase<UserSecurity, long>, IUserSecurityRepository
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="model"></param>
        /// <returns></returns>
        public override bool Save(UserSecurity model)
        {
            ArgumentAssertion.IsNotNull(model, "model");

            var result = base.Save(model);
            //if (model.PersistentState == PersistentState.Persistent)
            //{
            //    SyncToJux360(model);
            //}
            return result;
        }
    }
}