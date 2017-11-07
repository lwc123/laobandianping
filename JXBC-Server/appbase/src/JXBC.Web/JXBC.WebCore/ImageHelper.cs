using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using M2SA.AppGenome;
using JXBC.Passports.Security;

namespace JXBC.WebCore
{
    /// <summary>
    /// 
    /// </summary>
    public static class ImageHelper
    {
        private static readonly string AvatarBasicDirectory = "avatar";
        private static readonly string BossCommentBasicDirectory = "boss-comment";
        private static readonly string OpenAccountBasicDirectory = "open-account";

        public static string ToAbsoluteUri(string path)
        {
            var absoluteUri = path;
            if (false == string.IsNullOrEmpty(path) && false == path.StartsWith("http://"))
                absoluteUri = string.Concat(AppEnvironment.ResourcesSiteRoot, path);
            return absoluteUri;
        }

        public static string SaveAvatar(long passportId, string avatarStream)
        {
            string avatarUrl = null;

            var avatarFile = string.Format("{0}.jpg"
                , HashHelper.ComputeHash(string.Format("{0}-{1}", AvatarBasicDirectory, passportId), HashAlgorithmName.MD5));
            var firstDirectory = (passportId / 256 % 256).ToString();
            var secondDirectory = (passportId % 256).ToString();
            var directory = Path.Combine(AvatarBasicDirectory, firstDirectory, secondDirectory);
            var avatarFilePath = Path.Combine(AppEnvironment.ResourcesPhysicalRoot, directory, avatarFile);

            avatarFilePath = FileHelper.GetFullPath(avatarFilePath);
            FileHelper.CreateDirectoryForFile(avatarFilePath);

            var saved = SaveFileFromBase64Data(avatarFilePath, avatarStream);

            if (saved)
            {
                avatarUrl = string.Format("/{0}/{1}/{2}/{3}"
                    , AvatarBasicDirectory, firstDirectory, secondDirectory, avatarFile);
            }
            return avatarUrl;
        }

        public static string SaveOpenAccountImage(long bizId, DateTime createdTime, string imageStream)
        {
            return SaveBizFile(OpenAccountBasicDirectory, bizId, createdTime, imageStream, "jpg");
        }

        public static string SaveBossCommentImage(long bizId, DateTime createdTime, string imageStream)
        {
            return SaveBizFile(BossCommentBasicDirectory, bizId, createdTime, imageStream, "jpg");
        }

        public static string SaveBossCommentVoice(long bizId, DateTime createdTime, string voiceStream)
        {
            return SaveBizFile(BossCommentBasicDirectory, bizId, createdTime, voiceStream, "mp3");
        }

        private static string SaveBizFile(string basicDirectory, long bizId, DateTime createdTime, string streamData, string fileExtension)
        {
            string imageUrl = null;

            var imageFile = string.Format("{0}-{1}.{2}", bizId, Guid.NewGuid().ToString("N"), fileExtension);
            var firstDirectory = createdTime.ToString("yyyyMMdd");
            var secondDirectory = (bizId % 256).ToString();
            var directory = Path.Combine(basicDirectory, firstDirectory, secondDirectory);
            var imageFilePath = Path.Combine(AppEnvironment.ResourcesPhysicalRoot, directory, imageFile);

            imageFilePath = FileHelper.GetFullPath(imageFilePath);
            FileHelper.CreateDirectoryForFile(imageFilePath);

            var saved = false;
            if("jpg" == fileExtension)
                saved = SaveImageFileFromBase64Data(imageFilePath, streamData);
            else
                saved = SaveFileFromBase64Data(imageFilePath, streamData);

            if (saved)
            {
                imageUrl = string.Format("/{0}/{1}/{2}/{3}"
                    , basicDirectory, firstDirectory, secondDirectory, imageFile);
            }
            return imageUrl;
        }

        private static bool SaveImageFileFromBase64Data(string file, string data)
        {
            try
            {
                byte[] stream = Convert.FromBase64String(data);
                using (var ms = new MemoryStream(stream))
                {
                    var image = new Bitmap(ms);
                    image.Save(file, ImageFormat.Jpeg);
                }
                return true;
            }
            catch(Exception ex)
            {
                var info = new Dictionary<string, string>();
                info["file"] = file;
                info["data"] = data;
                ex.HandleException(info);
                return false;
            }
        }

        private static bool SaveFileFromBase64Data(string file, string data)
        {
            try
            {
                if (File.Exists(file)) FileHelper.Delete(file);

                byte[] stream = Convert.FromBase64String(data);
                using (var writer = new BinaryWriter(new FileStream(file, FileMode.CreateNew)))
                {
                    writer.Write(stream);
                }
                return true;
            }
            catch (Exception ex)
            {
                var info = new Dictionary<string, string>();
                info["file"] = file;
                info["data"] = data;
                ex.HandleException(info);
                return false;
            }
        }
    }
}
