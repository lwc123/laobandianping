using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace JXBC.TradeSystem
{
    /// <summary>
    /// 
    /// </summary>
    [Serializable]
    public class Payment
    {
        #region Instance Properties

        /// <summary>
        /// 交易编号(服务器生成)
        /// </summary>
        public string TradeCode { get; set; }

        /// <summary>
        /// 交易发起人
        /// </summary>
        public long OwnerId { get; set; }

        /// <summary>
        /// 父交易编号(A购买B时，A有一条交易记录，B会产生一个以A交易号为父交易编号的交易记录)
        /// </summary>
        public string ParentTradeCode { get; set; }

        /// <summary>
        /// 交易类型(对私交易\对公交易)
        /// </summary>
        public TradeType TradeType { get; set; }

        /// <summary>
        /// 交易模式(收益\支出)
        /// </summary>
        public TradeMode TradeMode { get; set; }
        /// <summary>
        /// 支付方式(微信\支付宝\银联等)
        /// </summary>
        public string PayWay { get; set; }
        /// <summary>
        /// 支付路径(APP\网站支付\扫码支付等)
        /// </summary>
        public string PayRoute { get; set; }
        /// <summary> 
        ///  业务来源
        /// </summary> 
        public string BizSource { get; set; }
        
        /// <summary>
        /// 总金额
        /// </summary>
        public decimal TotalFee { get; set; }
        /// <summary>
        ///  商品类别
        /// </summary>
        public string CommodityCategory { get; set; }
        /// <summary> 
        ///  商品标识
        /// </summary> 
        public string CommodityCode { get; set; }
        /// <summary> 
        ///  商品数量
        /// </summary> 
        public int CommodityQuantity { get; set; }
        /// <summary> 
        ///  商品标题
        /// </summary> 
        public string CommoditySubject { get; set; }
        /// <summary> 
        ///  商品摘要描述
        /// </summary> 
        public string CommoditySummary { get; set; }
        /// <summary> 
        ///  商品扩展信息(JSON)
        /// </summary> 
        public string CommodityExtension { get; set; }

        /// <summary>
        /// 支付成功后的跳转地址
        /// </summary>
        public string ReturnUrl { get; set; }
        /// <summary> 
        ///  买家标识(对私交易：当前用户PassportId；对公交易：所属机构的机构Id)
        /// </summary> 
        public long BuyerId { get; set; }
        /// <summary> 
        ///  卖家标识(对私交易：目标用户PassportId；;对公交易：目标用户所属机构的机构Id)
        /// </summary> 
        public long SellerId { get; set; }


        /// <summary>
        /// 
        /// </summary>
        public string ClientIP { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public DateTime CreatedTime { get; set; }

        /// <summary>
        /// 第三方支付所需的（签名后）参数
        /// </summary>
        public string SignedParams { get; set; }

        #endregion //Instance Properties

        /// <summary>
        /// 
        /// </summary>	
        public Payment()
        {
            this.CreatedTime = DateTime.Now;
        }
    }
}
