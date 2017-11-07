using JXBC.WebCore;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.WebApi.Tests.Mocks
{
    /// <summary>
    /// 
    /// </summary>
    public static class WebApiClient
    {
        private static readonly string JXTokenKey = "JX-TOKEN";
        private static readonly string JXDeviceKey = "JX-DEVICE";
        private static readonly string DeviceKey = Guid.NewGuid().ToString("N");

        private static string AuthToken = null;

        /// <summary>
        /// 
        /// </summary>
        /// <param name="token"></param>
        public static void SaveAuthToken(string token)
        {
            AuthToken = token;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="apiEndpoint"></param>
        /// <returns></returns>
        public static HttpDecorator.HttpResponseResult HttpGet(string apiEndpoint)
        {
            return HttpGet(apiEndpoint, null);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="apiEndpoint"></param>
        /// <param name="requestData"></param>
        /// <returns></returns>
        public static HttpDecorator.HttpResponseResult HttpGet(string apiEndpoint, IList<KeyValuePair<string, object>> requestData)
        {
            var httpDecorator = new HttpDecorator();
            var headers = new Dictionary<string, string>();
            headers.Add(JXTokenKey, AuthToken);
            headers.Add(JXDeviceKey, DeviceKey);
            var remoteApiEndpoint = ApiEnvironment.GetApiEndpoint(apiEndpoint);
            remoteApiEndpoint = HttpDecorator.CombineRequest(remoteApiEndpoint, requestData);
            var responseResult = httpDecorator.HttpGet(remoteApiEndpoint, headers);

            Console.WriteLine("[GET]{0}", remoteApiEndpoint);
            return responseResult;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="apiEndpoint"></param>
        /// <param name="postData"></param>
        /// <returns></returns>
        public static HttpDecorator.HttpResponseResult HttpPost(string apiEndpoint, string postData)
        {
            var httpDecorator = new HttpDecorator();
            var headers = new Dictionary<string, string>();
            headers.Add(JXTokenKey, AuthToken);
            headers.Add(JXDeviceKey, DeviceKey);
            var remoteApiEndpoint = ApiEnvironment.GetApiEndpoint(apiEndpoint);
            var responseResult = httpDecorator.HttpPost(remoteApiEndpoint, postData, headers);
            Console.WriteLine("[POST]{0}", remoteApiEndpoint);
            return responseResult;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="apiEndpoint"></param>
        /// <param name="entity"></param>
        /// <returns></returns>
        public static HttpDecorator.HttpResponseResult HttpPost(string apiEndpoint, object entity)
        {
            var postParams = entity.ToJson();
            return HttpPost(apiEndpoint, postParams);
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="apiEndpoint"></param>
        /// <param name="postData"></param>
        /// <returns></returns>
        public static HttpDecorator.HttpResponseResult HttpPost(string apiEndpoint, IList<KeyValuePair<string, object>> postData)
        {
            var postParams = HttpDecorator.EncodeRequestData(postData);
            return HttpPost(apiEndpoint, postParams);
        }
    }
}
