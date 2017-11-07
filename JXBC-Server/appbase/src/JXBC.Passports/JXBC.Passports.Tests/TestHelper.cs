using System;
using System.Collections.Generic;
using M2SA.AppGenome.Reflection;
using NUnit.Framework;

namespace JXL.Passports.Tests
{
    public static class TestHelper
    {
        #region Random Methods

        public static DateTime GetRndDateTime()
        {
            return new DateTime(GetRndNumber(1949, 2008), GetRndNumber(1, 11), GetRndNumber(1, 28));
        }

        public static DateTime GetNextDateTime(DateTime date)
        {
            return date.AddYears(GetRndNumber(1, 5));
        }

        public static bool GetRndBoolean()
        {
            var n = GetRndNumber();
            return (n % 2 == 1);
        }

        public static IList<int> GetRndCodes(string codeType)
        {
            var list = new List<int>();
            //var count = GetRndNumber(1, 5);
            //if (string.IsNullOrEmpty(codeType))
            //{
            //    list.Add(GetRndNumber(1, 99));
            //    return list;
            //}
            //ClassInfo classInfo = null;
            //try
            //{
            //    classInfo = (ClassInfo)ClassInfo.OpenObjectByDicType(codeType);
            //}
            //catch (Exception ex)
            //{
            //    Trace.TraceWarning("====== not find ClassInfo : {0} =================", codeType);
            //    list.Add(GetRndNumber(1, 99));
            //    return list;
            //}

            //var codeList = classInfo.Children;
            //if (codeList.Count == 0)
            //{
            //    list.Add(GetRndNumber(1, 99));
            //    return list;
            //}

            //for (var i = 0; i < count; i++)
            //{
            //    var index = GetRndNumber(0, codeList.Count - 1);
            //    var codeItem = (CodeItem)codeList[index];
            //    var code = Convert.ToInt32(codeItem.Code);
            //    if (list.Contains(code))
            //    {
            //        index = GetRndNumber(0, codeList.Count - 1);
            //        codeItem = (CodeItem)codeList[index];
            //        code = Convert.ToInt32(codeItem.Code);
            //    }
            //    list.Add(code);
            //}
            return list;
        }

        public static string GetRndString()
        {
            return GetRndNumber(1, 10000000).ToString();
        }

        public static int GetRndNumber()
        {
            return GetRndNumber(1, 10000000);
        }

        public static int GetRndNumber(int minValue, int maxValue)
        {
            var r = new Random((int)(DateTime.Now - new DateTime(DateTime.Now.Year, 6, 1)).Ticks);
            var n = r.Next(minValue, maxValue);
            System.Threading.Thread.Sleep(10);
            return n;
        }

        #endregion

        public static object GetRndValue(string propName, Type propType)
        {
            if (propType.IsEnum)
            {
                var values = Enum.GetValues(propType);
                var index = GetRndNumber(0, values.Length);
                return values.GetValue(index);
            }

            if (propType == typeof (Guid))
            {
                return Guid.NewGuid();
            }

            var code = Type.GetTypeCode(propType);
            switch (code)
            {
                case TypeCode.Int32:
                    {
                        return GetRndNumber();
                    }
                case TypeCode.Int64:
                    {
                        return (long)GetRndNumber();
                    }
                case TypeCode.Decimal:
                    {
                        return (decimal)GetRndNumber();
                    }
                case TypeCode.Boolean:
                    {
                        return GetRndBoolean();
                    }
                case TypeCode.DateTime:
                    {
                        return GetRndDateTime();
                    }
                default:
                    {
                        var postfix = propName.Substring(2, propName.Length - 2);
                        if (postfix.Length > 3)
                        {
                            postfix = postfix.Substring(0, 3);
                        }
                        return string.Format("{0}{1}{2}", propName.Substring(0, 2), GetRndString(), postfix);
                    }
            }
        }

        public static void FillRndProperties(this object obj, params string[] ignores)
        {
            var targetType = obj.GetType();
            var propMap = targetType.GetPersistProperties();
            var values = new Dictionary<string, object>(propMap.Count);

            foreach (var item in propMap)
            {
                var isIgnore = false;
                foreach (var ignoreName in ignores)
                {
                    if (ignoreName == item.Key)
                    {
                        isIgnore = true;
                        break;
                    }
                }
                if (isIgnore == false)
                {
                    values[item.Key] = GetRndValue(item.Key, item.Value);
                }
            }

            obj.SetPropertyValues(values);
        }

        public static void AssertObject(this object o1, object o2)
        {
            var targetType = o1.GetType();
            Assert.AreEqual(targetType, o2.GetType());

            var values = o1.GetPropertyValues();
            var assertValues = o2.GetPropertyValues();
            Assert.AreEqual(values.Count, assertValues.Count);

            foreach (var item in values)
            {
                if (item.Value != null && item.Value is DateTime)
                    Assert.AreEqual(((DateTime)item.Value).ToString("YYYYMMDDHHmmss"), ((DateTime)assertValues[item.Key]).ToString("YYYYMMDDHHmmss"), "{0}.{1}", targetType.Name, item.Key);
                else if(null!= item.Value && item.Value.GetType().IsPrimitiveType())
                    Assert.AreEqual(item.Value, assertValues[item.Key], "{0}.{1}", targetType.Name, item.Key);
                else if(null== item.Value)
                    Assert.AreEqual(item.Value, assertValues[item.Key], "{0}.{1}", targetType.Name, item.Key);
            }
        }
    }
}
