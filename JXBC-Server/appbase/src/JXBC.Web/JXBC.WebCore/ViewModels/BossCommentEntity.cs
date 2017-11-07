using System;
using System.Collections.Generic;
using System.Linq;
using M2SA.AppGenome.Reflection;
using JXBC.Passports;
using JXBC.Workplace;

namespace JXBC.WebCore.ViewModels
{
    public static class BossCommentExtension
    {
        public static IList<BossCommentEntity> ToEntities(this IList<BossComment> items)
        {
            if (items == null || items.Count < 1)
                return null;
            
            var result = new List<BossCommentEntity>();
            foreach (var item in items)
            {
                var entInfo = EntInfo.FindById(item.CommentEntId);
                result.Add(new BossCommentEntity(item, entInfo));
            }

            return result;
        }

        public static BossCommentEntity ToEntity(this BossComment item)
        {
            if (null == item) return null;

            var entInfo = EntInfo.FindById(item.CommentEntId);

            var entity = new BossCommentEntity(item, entInfo);
            return entity;
        }
    }

    public class BossCommentEntity : BossComment
    {
        /// <summary>
        /// 
        /// </summary>
        public string EntName { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string TargetName { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public string TargetIDCard { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public BossCommentEntity()
        {

        }

        internal BossCommentEntity(BossComment source, EntInfo entInfo)
        {
            this.SetPropertyValues(source.GetPropertyValues());
            //this.EntName = entInfo.EntName;


            if(false == string.IsNullOrEmpty(source.Voice))
            {
                this.Voice = ImageHelper.ToAbsoluteUri(source.Voice);
            }

            if (null != source.Images && source.Images.Length > 0)
            {
                for (var i = 0; i < source.Images.Length; i++)
                    this.Images[i] = ImageHelper.ToAbsoluteUri(source.Images[i]);
            }
        }
    }
}
