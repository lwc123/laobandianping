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
   OwnerId              bigint comment '���׷�����',
   PaidWay              varchar(64) comment '������֧��·��(΢��\֧����\������)',
   PaidChannel          varchar(64) comment 'ʵ��֧����������Ǯ��\��\����\���еȣ�',
   TotalFee             int comment '�ܽ��(��λ:��)',
   ThirdTradeCode       varchar(254),
   ThirdBuyerCode       varchar(254),
   ThirdBuyerName       varchar(254),
   ThirdSellerCode      varchar(254),
   ThirdSellerName      varchar(254),
   ThirdPaidDetails     text comment '������֧����ɺ�õ���ԭʼ���',
   CredentialSign       varchar(64) comment '֧��ƾ��ǩ����֧���󲻿ɸ���',
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
   OwnerId              bigint comment '���׷�����',
   TradeType            int comment '��������(��˽����\�Թ�����)',
   TradeMode            int comment '����ģʽ(����\֧��)',
   PayWay               varchar(32) comment '����·��(΢��\֧����\������)',
   BizSource            varchar(64) comment 'ҵ����Դ',
   TotalFee             int comment '�ܽ��(��λ:��)',
   CommodityCategory    varchar(64) comment '��Ʒ���',
   CommodityCode        varchar(64) comment '��Ʒ��ʶ',
   CommodityQuantity    int comment '��Ʒ����',
   CommoditySubject     varchar(128) comment '��Ʒ����',
   CommoditySummary     varchar(254) comment '��ƷժҪ����',
   CommodityExtension   text comment '��Ʒ��չ��Ϣ',
   BuyerId              bigint comment '��ұ�ʶ(��˽���ף���ǰ�û�PassportId���Թ����ף����������Ļ���Id)',
   SellerId             bigint comment '���ұ�ʶ(��˽���ף�Ŀ���û�PassportId��;�Թ����ף�Ŀ���û����������Ļ���Id)',
   ClientIP             varchar(254) comment '�����׵Ŀͻ���IP',
   LastOperator         varchar(64),
   TargetBizCode        varchar(64) comment '������ҵ�����(���ͬ��ʶ\ҵ��ϵͳ���Ѽ�¼Id��)',
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
   WalletType           int comment 'Ǯ����������(˽��Ǯ��\��֯Ǯ��)',
   OwnerId              bigint comment 'Ǯ�������߱�ʶ(˽��Ǯ������ǰ�û�PassportId������Ǯ�������������Ļ���Id)',
   AvailableBalance     int comment '�������(��λ:��)',
   FreezeFee            int comment '������(��λ:��)',
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
   HandlerId            bigint comment '���׷�����',
   BizSource            varchar(64),
   TotalFee             int comment '�ܽ��(��λ:��)',
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
   HandlerId            bigint comment '���׷�����',
   TradeMode            int comment '����ģʽ(����\֧��)',
   TargetTradeCode      varchar(64) comment '��Ӧ�Ľ��׼�¼��ʶ',
   BizSource            varchar(64) comment 'ҵ����Դ',
   TotalFee             int comment '�ܽ��(��λ:��)',
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

