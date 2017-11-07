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
using JXBC.Workplace;

namespace JXBC.WebAPI.Controllers
{
    /// <summary>
    /// 
    /// </summary>
    public class BossCommentController : AuthenticatedApiController
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="idCard">身份证</param>
        /// <param name="name">姓名</param>
        /// <param name="company">公司</param>
        /// <param name="page"></param>
        /// <param name="size"></param>
        /// <returns></returns>
        [HttpGet]
        public TargetEmployeEntity Search(string idCard = null, string name = null, string company = null, int page = 1, int size = 10)
        {
            if (string.IsNullOrEmpty(idCard)) return null;

            if (page < 1) page = 1;
            if (size < 1) size = 10;
            var pagination = new Pagination() { PageIndex = page, PageSize = size };
            
            var target = TargetEmploye.FindByIDCard(idCard);
            if(null == target)
            {
                target = new TargetEmploye();
                target.RealName = name;
                target.IDCard = idCard;
                target.Tags = new string[] { target.RealName, target.IDCard.Substring(0, target.IDCard.Length > 6 ? 6 : target.IDCard.Length) };
            }
            return target.ToEntity();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        [Authorize]
        [HttpPost]
        public long Post([FromBody] BossCommentEntity entity)
        {
            if (null == entity) return -1;
            if (string.IsNullOrEmpty(entity.TargetIDCard)) return -1;

            var target = TargetEmploye.FindByIDCard(entity.TargetIDCard);
            if (null == target)
            {
                target = new TargetEmploye();                
                target.RealName = entity.TargetName;
                target.IDCard = entity.TargetIDCard;
                target.Tags = new string[] { target.RealName, target.IDCard.Substring(0, target.IDCard.Length > 6 ? 6 : target.IDCard.Length) };
                target.Save();
            }
            else if(target.RealName != entity.TargetName)
            {
                target.RealName = entity.TargetName;
                target.Save();
            }

            var userProfile = MvcContext.Current.UserPassport.Profile;
            var model = new BossComment();
            model.FillPropertiesFromEntity(entity, true);
            var request = OpenAccountRequest.FindByPassportId(userProfile.PassportId);
            model.EmployeId = target.EmployeId;
            model.CommentEntId = 0;// EntInfo.FindByEntName(request.EntName).EntId;
            model.CommentatorId = userProfile.PassportId;
            model.CommentatorName = userProfile.RealName;
            model.CommentatorJobTitle = userProfile.CurrentJobTitle;

            var saved = model.Save();
            if (saved && (false == string.IsNullOrEmpty(entity.Voice) || null != entity.Images))
            {
                if(false == string.IsNullOrEmpty(entity.Voice))
                {
                    model.Voice = ImageHelper.SaveBossCommentVoice(model.CommentId, model.CreatedTime, entity.Voice) + "?t=" + DateTime.Now.ToString("yyMMddHHmmssfff");
                }
                    
                if (null != entity.Images && entity.Images.Length > 0)
                {
                    string[] applyImages = null == entity.Images ? null : new string[entity.Images.Length];
                    if (null != entity.Images)
                    {
                        for (var i = 0; i < entity.Images.Length; i++)
                        {
                            var imageUrl = ImageHelper.SaveBossCommentImage(model.CommentId, model.CreatedTime, entity.Images[i]);
                            applyImages[i] = imageUrl + "?t=" + DateTime.Now.ToString("yyMMddHHmmssfff");
                        }
                        model.Images = applyImages;
                    }
                }

                saved = model.Save();
            }            

            return model.CommentId;
        }
    }
}
