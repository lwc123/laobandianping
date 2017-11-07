/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2016/12/2 20:10:01                           */
/*==============================================================*/


drop table if exists Payment_Credential;

drop index IDX_PayWay on Trade_Journal;

drop index IDX_BizSource on Trade_Journal;

drop index IDX_TradeStatus on Trade_Journal;

drop table if exists Trade_Journal;

drop table if exists Wallet;

drop table if exists Wallet_Freeze_Record;

drop table if exists Wallet_Journal;

/*==============================================================*/
/* Table: Payment_Credential                                    */
/*==============================================================*/
create table Payment_Credential
(
   TradeCode            varchar(64) not null,
   OwnerId              bigint comment '交易发起人',
   PaidWay              varchar(64) comment '第三方支付路径(微信\支付宝\银联等)',
   PaidChannel          varchar(64) comment '实际支付渠道（如钱包\余额宝\招行\工行等）',
   TotalFee             int comment '总金额(单位:分)',
   ThirdTradeCode       varchar(254),
   ThirdBuyerCode       varchar(254),
   ThirdBuyerName       varchar(254),
   ThirdSellerCode      varchar(254),
   ThirdSellerName      varchar(254),
   ThirdPaidDetails     text comment '第三方支付完成后得到的原始结果',
   CredentialSign       varchar(64) comment '支付凭据签名，支付后不可更改',
   LastOperator         varchar(64),
   PaidTime             datetime,
   primary key (TradeCode)
);

/*==============================================================*/
/* Table: Trade_Journal                                         */
/*==============================================================*/
create table Trade_Journal
(
   TradeCode            varchar(32) not null,
   TradeStatus          int,
   ParentTradeCode      varchar(32),
   OwnerId              bigint comment '交易发起人',
   TradeType            int comment '交易类型(对私交易\对公交易)',
   TradeMode            int comment '交易模式(收益\支出)',
   PayWay               varchar(32) comment '交易路径(微信\支付宝\银联等)',
   BizSource            varchar(64) comment '业务来源',
   TotalFee             int comment '总金额(单位:分)',
   CommodityCategory    varchar(64) comment '商品类别',
   CommodityCode        varchar(64) comment '商品标识',
   CommodityQuantity    int comment '商品数量',
   CommoditySubject     varchar(128) comment '商品标题',
   CommoditySummary     varchar(254) comment '商品摘要描述',
   CommodityExtension   text comment '商品扩展信息',
   BuyerId              bigint comment '买家标识(对私交易：当前用户PassportId；对公交易：所属机构的机构Id)',
   SellerId             bigint comment '卖家标识(对私交易：目标用户PassportId；;对公交易：目标用户所属机构的机构Id)',
   ClientIP             varchar(254) comment '发起交易的客户端IP',
   LastOperator         varchar(64),
   TargetBizCode        varchar(64) comment '关联的业务编码(如合同标识\业务系统消费记录Id等)',
   CreatedTime          datetime,
   ModifiedTime         datetime,
   primary key (TradeCode)
);

/*==============================================================*/
/* Index: IDX_TradeStatus                                       */
/*==============================================================*/
create index IDX_TradeStatus on Trade_Journal
(
   TradeStatus
);

/*==============================================================*/
/* Index: IDX_BizSource                                         */
/*==============================================================*/
create index IDX_BizSource on Trade_Journal
(
   BizSource
);

/*==============================================================*/
/* Index: IDX_PayWay                                            */
/*==============================================================*/
create index IDX_PayWay on Trade_Journal
(
   PayWay
);

/*==============================================================*/
/* Table: Wallet                                                */
/*==============================================================*/
create table Wallet
(
   WalletId             bigint not null,
   WalletType           int comment '钱包类型类型(私人钱包\组织钱包)',
   OwnerId              bigint comment '钱包所有者标识(私人钱包：当前用户PassportId；机构钱包：所属机构的机构Id)',
   AvailableBalance     int comment '可用余额(单位:分)',
   FreezeFee            int comment '冻结金额(单位:分)',
   CreatedTime          datetime,
   ModifiedTime         datetime,
   primary key (WalletId)
);

/*==============================================================*/
/* Table: Wallet_Freeze_Record                                  */
/*==============================================================*/
create table Wallet_Freeze_Record
(
   RecordId             bigint not null,
   WalletId             bigint not null,
   HandlerId            bigint comment '交易发起人',
   BizSource            varchar(64),
   TotalFee             int comment '总金额(单位:分)',
   LastOperator         varchar(64),
   CreatedTime          datetime,
   ModifiedTime         datetime,
   primary key (RecordId)
);

/*==============================================================*/
/* Table: Wallet_Journal                                        */
/*==============================================================*/
create table Wallet_Journal
(
   JournalId            bigint not null,
   WalletId             bigint not null,
   HandlerId            bigint comment '交易发起人',
   TradeMode            int comment '交易模式(收益\支出)',
   TargetTradeCode      varchar(64) comment '对应的交易记录标识',
   BizSource            varchar(64) comment '业务来源',
   TotalFee             int comment '总金额(单位:分)',
   LastOperator         varchar(64),
   CreatedTime          datetime,
   ModifiedTime         datetime,
   primary key (JournalId)
);

alter table Payment_Credential add constraint FK_TradeJournal_COM_PaymentCredential foreign key (TradeCode)
      references Trade_Journal (TradeCode) on delete restrict on update restrict;

alter table Wallet_Freeze_Record add constraint FK_WalletFreezeRecord_ASS_Wall foreign key (WalletId)
      references Wallet (WalletId) on delete restrict on update restrict;

alter table Wallet_Journal add constraint FK_WalletJournal_ASS_Wallet foreign key (WalletId)
      references Wallet (WalletId) on delete restrict on update restrict;

