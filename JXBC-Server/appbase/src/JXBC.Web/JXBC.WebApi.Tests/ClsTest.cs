using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using NUnit.Framework;
using JXBC.TradeSystem;

namespace JXBC.WebApi.Tests
{
    public class ClsTest
    {
        [Test]
        public void IMTest()
        {

        }


        [Test]
        public void ModelTest()
        {
            var paidDetail = "_input_charset=\"utf-8\"\u0026out_trade_no=\"89cef337d1f441a5ad76ae97a4ac19bf\"\u0026total_fee=\"0.01\"\u0026subject=\"购买服务 1\"\u0026body=\"有效期 1, ￥ 0.01\"\u0026app_id=\"2016022301158460\"\u0026service=\"mobile.securitypay.pay\"\u0026partner=\"2088221221229856\"\u0026seller_id=\"2088221221229856\"\u0026payment_type=\"1\"\u0026notify_url=\"http://ling-api.jux360.io/v-test/Payment/AlipayPaymentCallback\"\u0026success=\"true\"\u0026sign_type=\"RSA\"\u0026sign=\"QGBXkaAOO3PHOkFqmWUgfA/z2AJ4LU8NNDVQ7cccBvMAOM7aR0tTBaHKPspFFmnYuOVYrMUOnR4ibKsJjVdFB/fDN1vnNPggNQlpYkeGEvLH3Spyekj5QMP6gAX3W8IDLmGV68mTCCIb5pT2EOVO8gO7Mc/a8OwPDrg1G2WauJw=";
            var paidParams = paidDetail.Split('&');
            var paymentDetail = new Dictionary<string, string>(paidParams.Length);
            foreach (var item in paidParams)
            {
                var pair = item.Split('=');
                if (pair.Length > 1)
                    paymentDetail.Add(pair[0], string.Join("=", pair, 1, pair.Length - 1).Replace("\"",""));

            }


            Console.WriteLine(paymentDetail.ToJson());

            //PrintProperties(typeof(JXBC.Workplace.CareerService));
        }

        private void PrintProperties(Type type)
        {
            var properties = type.GetProperties();
            var names = new List<string>();
            foreach (var prop in properties)
                names.Add(prop.Name);

            names.Sort();

            foreach (var name in names)
                Console.WriteLine(name);
        }
    }
}
