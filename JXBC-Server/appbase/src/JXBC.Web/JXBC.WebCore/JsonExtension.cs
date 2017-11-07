using System;
using System.Runtime.Remoting;
using System.Web.Http;
using M2SA.AppGenome;
using Newtonsoft.Json;
using Newtonsoft.Json.Converters;

namespace JXBC.WebCore
{
    /// <summary>
    /// 
    /// </summary>
    public static class JsonExtension
    {
        /// <summary>
        /// 
        /// </summary>
        /// <param name="obj"></param>
        /// <returns></returns>
        public static string ToJson(this object obj)
        {
            ArgumentAssertion.IsNotNull(obj, "obj");
            var json = JsonConvert.SerializeObject(obj, BuildSerializerSettings());
            return json;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="jsonData"></param>
        /// <returns></returns>
        public static T ConvertEntity<T>(this string jsonData)
        {
            ArgumentAssertion.IsNotNull(jsonData, "jsonData");
            var entity = JsonConvert.DeserializeObject<T>(jsonData, BuildSerializerSettings());
            return entity;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="jsonData"></param>
        /// <param name="entity"></param>
        /// <returns></returns>
        public static bool TryConvertEntity<T>(this string jsonData, out T entity)
        {
            ArgumentAssertion.IsNotNull(jsonData, "jsonData");
            entity = default(T);
            try
            {
                entity = ConvertEntity<T>(jsonData);
                return true;
            }
            catch
            {
                return false;
            }
        }

        /// <summary>
        /// 
        /// </summary>
        /// <returns></returns>
        public static JsonSerializerSettings BuildSerializerSettings()
        {
            var serializerSettings = new JsonSerializerSettings()
            {
                Formatting = Formatting.None,
                DefaultValueHandling = DefaultValueHandling.Include,
                NullValueHandling = NullValueHandling.Ignore
            };
            serializerSettings.Converters.Add(new DateTimeConvertor());
            return serializerSettings;
        }

        #region DateTimeConvertor

        /// <summary>
        /// 
        /// </summary>
        internal class DateTimeConvertor : DateTimeConverterBase
        {
            /// <summary>
            /// 
            /// </summary>
            /// <param name="value"></param>
            /// <returns></returns>
            public static string ToUniversalString(DateTime value)
            {
                return value.ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ");
            }

            /// <summary>
            /// 
            /// </summary>
            /// <param name="reader"></param>
            /// <param name="objectType"></param>
            /// <param name="existingValue"></param>
            /// <param name="serializer"></param>
            /// <returns></returns>
            public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
            {
                return DateTime.SpecifyKind(DateTime.Parse(reader.Value.ToString()), DateTimeKind.Utc).ToLocalTime();
            }

            /// <summary>
            /// 
            /// </summary>
            /// <param name="writer"></param>
            /// <param name="value"></param>
            /// <param name="serializer"></param>
            public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
            {
                writer.WriteValue(ToUniversalString((DateTime)value));
            }
        }

        #endregion
    }
}
