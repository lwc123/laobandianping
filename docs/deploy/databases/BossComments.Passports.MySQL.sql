/*==============================================================*/
/* DBMS name:      MySQL 5.0                                    */
/* Created on:     2016/11/24 20:57:04                          */
/*==============================================================*/


drop table if exists Anonymous_Account;

drop table if exists Anonymous_Account_Token;

drop table if exists Client_Device;

drop table if exists Signed_In_Log;

drop table if exists Signed_Up_Info;

drop table if exists Third_Passport;

drop table if exists User_Passport;

drop table if exists User_Profile;

drop table if exists User_Security;

/*==============================================================*/
/* Table: Anonymous_Account                                     */
/*==============================================================*/
create table Anonymous_Account
(
   AccountId            bigint not null,
   DeviceId             bigint not null,
   PassportId           bigint,
   Nickname             varchar(64),
   Avatar               varchar(254),
   CreatedTime          datetime,
   ModifiedTime         datetime,
   primary key (AccountId)
);

/*==============================================================*/
/* Table: Anonymous_Account_Token                               */
/*==============================================================*/
create table Anonymous_Account_Token
(
   AccountId            bigint not null,
   TokenId              bigint not null,
   PassportId           bigint,
   AccessToken          varchar(254),
   ExpiresTime          datetime,
   CreatedTime          datetime,
   ModifiedTime         datetime,
   primary key (AccountId, TokenId)
);

/*==============================================================*/
/* Table: Client_Device                                         */
/*==============================================================*/
create table Client_Device
(
   DeviceId             bigint not null,
   DeviceKey            varchar(64),
   SdkVersion           varchar(254),
   Device               varchar(254),
   Brand                varchar(254),
   Product              varchar(254),
   CreatedTime          datetime,
   ModifiedTime         datetime,
   primary key (DeviceId)
);

/*==============================================================*/
/* Table: Signed_In_Log                                         */
/*==============================================================*/
create table Signed_In_Log
(
   LogId                bigint not null,
   PassportId           bigint not null,
   SignedInTime         datetime,
   SignedInIP           varchar(254),
   UtmSource            varchar(254),
   RefererDomain        varchar(254),
   HttpReferer          varchar(254),
   HttpUserAgent        varchar(2048),
   primary key (LogId)
);

/*==============================================================*/
/* Table: Signed_Up_Info                                        */
/*==============================================================*/
create table Signed_Up_Info
(
   PassportId           bigint not null,
   InvitePassportId     bigint,
   InviteCode           varchar(254) comment '邀请码（包含邀请人和邀请人所属机构）',
   SignedUpTime         datetime,
   SignedUpIP           varchar(254),
   UtmSource            varchar(254),
   RefererDomain        varchar(254),
   HttpReferer          varchar(254),
   HttpUserAgent        varchar(2048),
   primary key (PassportId)
);

/*==============================================================*/
/* Table: Third_Passport                                        */
/*==============================================================*/
create table Third_Passport
(
   PassportId           bigint not null,
   ThirdPassportId      bigint not null,
   ThirdPlatform        varchar(64),
   ThirdAccountId       varchar(254),
   ThirdPassword        varchar(254),
   ThirdNickname        varchar(254),
   ThirdPhotoUrl        varchar(254),
   ThirdPassportInfo    text,
   ThirdAccessToken     varchar(254),
   ThirdTokenExpiresTime datetime,
   SyncTime             datetime,
   CreatedTime          datetime,
   ModifiedTime         datetime,
   primary key (PassportId, ThirdPassportId)
);

/*==============================================================*/
/* Table: User_Passport                                         */
/*==============================================================*/
create table User_Passport
(
   PassportId           bigint not null,
   MobilePhone          varchar(32),
   Email                varchar(254),
   UserName             varchar(64),
   PassportStatus       int,
   ProfileType          int,
   CreatedTime          datetime,
   ModifiedTime         datetime,
   primary key (PassportId)
);

/*==============================================================*/
/* Table: User_Profile                                          */
/*==============================================================*/
create table User_Profile
(
   PassportId           bigint not null,
   RealName             varchar(64),
   Gender               int,
   Avatar               varchar(254),
   MobilePhone          varchar(32),
   QQ                   varchar(32),
   Signature            varchar(254),
   CurrentCompany       varchar(64),
   CurrentJobTitle      varchar(64),
   SelfIntroduction     varchar(1024),
   LastSignInTime       datetime,
   LastActivityTime     datetime,
   CreatedTime          datetime,
   ModifiedTime         datetime,
   primary key (PassportId)
);

/*==============================================================*/
/* Table: User_Security                                         */
/*==============================================================*/
create table User_Security
(
   PassportId           bigint not null,
   Password             varchar(128),
   HashAlgorithm        varchar(64),
   PasswordSalt         varchar(64),
   LastPasswordChangedTime datetime,
   IsLocked             bool,
   LastLockedTime       datetime,
   FailedPasswordAttemptCount int,
   primary key (PassportId)
);

alter table Anonymous_Account add constraint FK_AnonymousAccount_ASS_ClientDevice foreign key (DeviceId)
      references Client_Device (DeviceId) on delete restrict on update restrict;

alter table Anonymous_Account_Token add constraint FK_AnonymousAccount_COM_Token foreign key (AccountId)
      references Anonymous_Account (AccountId) on delete restrict on update restrict;

alter table Signed_In_Log add constraint FK_UserPassport_ASS_SignedInLog foreign key (PassportId)
      references User_Passport (PassportId) on delete restrict on update restrict;

alter table Signed_Up_Info add constraint FK_UserPassport_ASS_SignedUpIn foreign key (PassportId)
      references User_Passport (PassportId) on delete restrict on update restrict;

alter table Third_Passport add constraint FK_UserPassport_COM_ThirdPassport foreign key (PassportId)
      references User_Passport (PassportId) on delete restrict on update restrict;

alter table User_Profile add constraint FK_UserPassport_COM_UserProfile foreign key (PassportId)
      references User_Passport (PassportId) on delete restrict on update restrict;

alter table User_Security add constraint FK_UserPassport_COM_UserSecurity foreign key (PassportId)
      references User_Passport (PassportId) on delete restrict on update restrict;

