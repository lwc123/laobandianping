using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using M2SA.AppGenome;
using M2SA.AppGenome.Reflection;

namespace JXBC.WebCore.ViewModels
{
    /// <summary>
    /// 
    /// </summary>
    public static class ModelExtension
    {
        private static readonly string[] IgnoresEntityProperties = new string[] { "Id", "PersistentState", "CreatedTime", "ModifiedTime"
                                                                        , "Avatar", "VisitingCard", "AttestationImage", "Voice", "Images" };

        // TODO: !!! hide the Code, this using by import data.
        //private static readonly string[] IgnoresEntityProperties = new string[] { "Id", "PersistentState", "CreatedTime", "ModifiedTime"
        //                                                                , "VisitingCard", "AttestationImage" };

        /// <summary>
        /// 
        /// </summary>
        /// <typeparam name="T"></typeparam>
        /// <param name="model"></param>
        /// <param name="entity"></param>
        public static T FillPropertiesFromEntity<T>(this T model, T entity)
        {
            return model.FillPropertiesFromEntity(entity, false);
        }

        public static T FillPropertiesFromEntity<T>(this T model, T entity, bool ingoreNullValue)
        {
            ArgumentAssertion.IsNotNull(model, "model");
            ArgumentAssertion.IsNotNull(entity, "entity");

            var sourcePropMap = model.GetType().GetPersistProperties();
            var targetPropMap = entity.GetType().GetPersistProperties();
            var properties = new List<string>();

            foreach (var item in targetPropMap)
            {
                if (false == IgnoresEntityProperties.Contains(item.Key)
                    && sourcePropMap.ContainsKey(item.Key))
                    properties.Add(item.Key);
            }

            var source = entity.GetPropertyValues(properties);
            
            if (ingoreNullValue)
            {
                var values = new Dictionary<string, object>(source.Count);
                foreach(var item in source)
                {                   
                    if(item.Value != null)
                    {
                        if (item.Value is string && string.Empty == (string)item.Value)
                            continue;
                        else if (item.Value is DateTime && DateTime.MinValue == (DateTime)item.Value)
                            continue;

                        values.Add(item.Key, item.Value);
                    }
                }

                source = values;
            }

            model.SetPropertyValues(source);
            return model;
        }
    }
}
