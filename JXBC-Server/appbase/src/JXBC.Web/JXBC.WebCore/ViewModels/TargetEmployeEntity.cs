using System;
using System.Collections.Generic;
using System.Linq;
using JXBC.Passports;
using JXBC.Workplace;
using M2SA.AppGenome.Reflection;
using M2SA.AppGenome.Data;

namespace JXBC.WebCore.ViewModels
{
    public static class TargetEmployeExtension
    {
        public static TargetEmployeEntity ToEntity(this TargetEmploye item)
        {
            if (null == item) return null;

            var comments = BossComment.FindByEmployeId(item.EmployeId, new Pagination());

            var entity = new TargetEmployeEntity(item, comments.ToEntities());
            return entity;
        }
    }

    public class TargetEmployeEntity : TargetEmploye
    {
        /// <summary>
        /// 
        /// </summary>
        public IList<BossCommentEntity> Comments { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public TargetEmployeEntity()
        {

        }

        internal TargetEmployeEntity(TargetEmploye source, IList<BossCommentEntity> comments)
        {
            this.SetPropertyValues(source.GetPropertyValues());
            this.Comments = comments;
        }
    }
}
