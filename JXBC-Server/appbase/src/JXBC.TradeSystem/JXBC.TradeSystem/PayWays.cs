using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    public static class PayWays
    {
        /// <summary>
        /// 系统支付
        /// </summary>
        public static readonly string System = "System";

        /// <summary>
        /// 钱包支付
        /// </summary>
        public static readonly string Wallet = "Wallet";

        /// <summary>
        /// 支付宝支付
        /// </summary>
        public static readonly string Alipay = "Alipay";

        /// <summary>
        /// 微信支付
        /// </summary>
        public static readonly string Wechat = "Wechat";

        /// <summary>
        /// 苹果内购
        /// </summary>
        public static readonly string AppleIAP = "AppleIAP";

        /// <summary>
        /// 线下转账
        /// </summary>
        public static readonly string Offline = "Offline";

        /// <summary>
        /// :APP支付
        /// </summary>
        public static readonly string Route_APP = "APP";
        /// <summary>
        /// 扫码支付
        /// </summary>
        public static readonly string Route_QRCODE = "QRCODE";
        /// <summary>
        /// H5支付
        /// </summary>
        public static readonly string Route_H5 = "H5";
    }
}
