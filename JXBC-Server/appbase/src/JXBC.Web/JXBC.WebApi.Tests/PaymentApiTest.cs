using System;
using System.Net;
using System.Collections.Generic;
using System.IO;
using NUnit.Framework;
using JXBC.TradeSystem;
using JXBC.WebCore;
using JXBC.WebCore.ViewModels;
using JXBC.WebApi.Tests.Mocks;
using JXBC.Workplace.PaymentExtension;
using M2SA.AppGenome;
using JXBC.TradeSystem.Providers;

namespace JXBC.WebApi.Tests
{
    [TestFixture]
    public class PaymentApiTest : AuthenticatedTestBase
    {
        [Test]
        public void WechatPaidCallbackTest()
        {
            var callbackParams = new Dictionary<string, string>();
            callbackParams["out_trade_no"] = "123456";

            var postData = "total_amount=1.00&buyer_id=2088102003814050&trade_no=2017012021001004050258653172&notify_time=2017-01-20+09%3A31%3A08&open_id=20881086018030361302899570514605&subject=%E5%BC%80%E9%80%9A%E4%BC%81%E4%B8%9A%E6%9C%8D%E5%8A%A1&sign_type=RSA&buyer_logon_id=251***%40qq.com&auth_app_id=2016122304548210&charset=UTF-8&notify_type=trade_status_sync&out_trade_no=201701200907183692478672&trade_status=WAIT_BUYER_PAY&version=1.0&sign=S8z7LfCmsOArLrzx2AZ1tO4OJjhTaM%2F9TCcNQCiRzPp8Zjm50JZLmf9HM087j%2FVqM4fCVorxgZZOc7KmVc7r%2BQWqu1LStExEwExjzQBusSQpaIye3qgmX%2BGwLBTB4JK0iM%2Bo%2BP91QAhdDwOtpyv4%2FtFgFcnzsef3PNi0qyGsXh4%3D&gmt_create=2017-01-20+09%3A07%3A36&app_id=2016122304548210&seller_id=2088521429620463&notify_id=c54a77b54e758d85e4f580f92807a51gdy&seller_email=laobandianping%40163.com";
            var responseResult = new TradeSystem.HttpDecorator().HttpPost("http://bc-api.jx.io:8120/v-test/appbase/PaymentRouter/AlipayPaidCallback", postData, null);
            Console.WriteLine(responseResult.Content);
        }

        [Test]
        public void CreateTest()
        {
            var payment = new Payment();
            payment.PayWay = PayWays.Alipay;
            payment.TradeMode = TradeMode.Payout;
            payment.BizSource = PaymentSources.OpenEnterpriseService;
            payment.CommodityQuantity = 1;
            payment.TotalFee = 0.01M;
            payment.CommoditySubject = string.Format("购买服务 ￥{0}", payment.TotalFee);
            payment.BuyerId = payment.OwnerId;
            
            var responseResult = WebApiClient.HttpPost(ApiEnvironment.Payment_CreateTrade_Endpoint, payment);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);

            var result = WebCore.JsonExtension.ConvertEntity<PaymentResult>(responseResult.Content);
            Assert.IsTrue(result.Success);
            Console.WriteLine(responseResult.Content);
        }

        [Test]
        public void PaymentCompletedTest()
        {
            var paidDetail = "_input_charset=\"utf-8\"\u0026out_trade_no=\"89cef337d1f441a5ad76ae97a4ac19bf\"\u0026total_fee=\"0.01\"\u0026subject=\"购买服务 1\"\u0026body=\"有效期 1, ￥ 0.01\"\u0026app_id=\"2016022301158460\"\u0026service=\"mobile.securitypay.pay\"\u0026partner=\"2088221221229856\"\u0026seller_id=\"2088221221229856\"\u0026payment_type=\"1\"\u0026notify_url=\"http://ling-api.jux360.io/v-test/Payment/AlipayPaymentCallback\"\u0026success=\"true\"\u0026sign_type=\"RSA\"\u0026sign=\"QGBXkaAOO3PHOkFqmWUgfA/z2AJ4LU8NNDVQ7cccBvMAOM7aR0tTBaHKPspFFmnYuOVYrMUOnR4ibKsJjVdFB/fDN1vnNPggNQlpYkeGEvLH3Spyekj5QMP6gAX3W8IDLmGV68mTCCIb5pT2EOVO8gO7Mc/a8OwPDrg1G2WauJw=";

            var pResult = new PaymentResult() { PayWay = PayWays.Alipay, PaidDetail = paidDetail };

            var responseResult = WebApiClient.HttpPost(ApiEnvironment.Payment_PaymentCompleted_Endpoint, pResult);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);

            var result = WebCore.JsonExtension.ConvertEntity<PaymentResult>(responseResult.Content);
            Assert.IsTrue(result.Success);
            Console.WriteLine(responseResult.Content);
        }


        [Test]
        public void WalletTest()
        {
            var payment = new Payment();
            payment.PayWay = PayWays.Wallet;
            payment.TradeMode = TradeMode.Payout;
            payment.BizSource = PaymentSources.OpenEnterpriseService;
            payment.CommodityQuantity = 1;
            payment.TotalFee = 0.01M;
            payment.CommoditySubject = string.Format("购买服务 ￥{0}", payment.TotalFee);
            payment.BuyerId = payment.OwnerId;

            var responseResult = WebApiClient.HttpPost(ApiEnvironment.Payment_CreateTrade_Endpoint, payment);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);

            var paymentResult = WebCore.JsonExtension.ConvertEntity<PaymentResult>(responseResult.Content);
            Assert.IsTrue(paymentResult.Success);
            Console.WriteLine(responseResult.Content);

            var payResult = Wallet.Pay(8, paymentResult.TradeCode);
            Assert.IsTrue(payResult.Success);

            var paidDetail = new Dictionary<string, string>();
            paidDetail["TotalFee"] = payment.TotalFee.ToString();
            paidDetail["TradeCode"] = paymentResult.TradeCode;

            var pResult = new PaymentResult() { TradeCode = paymentResult.TradeCode, PayWay = PayWays.Wallet, PaidDetail = TradeSystem.JsonExtension.ToJson(paidDetail) };

            responseResult = WebApiClient.HttpPost(ApiEnvironment.Payment_PaymentCompleted_Endpoint, pResult);
            Assert.AreEqual(HttpStatusCode.OK, responseResult.StatusCode);
            Assert.IsNotNullOrEmpty(responseResult.Content);

            paymentResult = WebCore.JsonExtension.ConvertEntity<PaymentResult>(responseResult.Content);
            Assert.IsTrue(paymentResult.Success);
            Console.WriteLine(responseResult.Content);
        }
    }
}
