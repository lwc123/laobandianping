using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Configuration;

namespace JXBC.WebApi.Tests
{
    /// <summary>
    /// 
    /// </summary>
    public static class ApiEnvironment
    {
        public static string ApiHost = ConfigurationManager.AppSettings["ApiDomain"]; 

        public static string Account_CreateNew_Endpoint = "/account/createNew";
        public static string Account_SignInByToken_Endpoint = "/account/signInByToken";
        public static string Account_SignUp_Endpoint = "/account/signUp";
        public static string Account_OpenAccount_Endpoint = "/account/OpenAccount";
        public static string Account_SignIn_Endpoint = "/account/signIn";
        public static string Account_SignOut_Endpoint = "/account/signOut";
        public static string Account_BindThirdPassport_Endpoint = "/account/bindThirdPassport";
        public static string Account_ExistsMobilePhone_Endpoint = "/account/existsMobilePhone";
        public static string Account_ResetPassword_Endpoint = "/account/ResetPassword";

        public static string User_Summary_Endpoint = "/user/Summary";
        public static string User_ChangeProfile_Endpoint = "/user/ChangeProfile";
        public static string User_ChangeAvatar_Endpoint = "/user/ChangeAvatar";
        public static string User_Page_Endpoint = "/user/Page";

        public static string Consultant_Summary_Endpoint = "/consultant/Summary";
        public static string Consultant_ApplyAuthentication_Endpoint = "/consultant/ApplyAuthentication";
        public static string Consultant_ChangeProfile_Endpoint = "/consultant/ChangeProfile";
        public static string Consultant_ChangeAvatar_Endpoint = "/consultant/ChangeAvatar";
        public static string Consultant_Page_Endpoint = "/consultant/Page";
        public static string Consultant_OpenCareerService_Endpoint = "/consultant/OpenCareerService";
        public static string Consultant_ChangeToConsultant_Endpoint = "/consultant/ChangeToConsultant";
        public static string Consultant_ChangeToUser_Endpoint = "/consultant/ChangeToUser";        

        public static string Payment_CreateTrade_Endpoint = "/Payment/CreateTrade";
        public static string Payment_PaymentCompleted_Endpoint = "/Payment/PaymentCompleted";

        public static string BossComment_Search_Endpoint = "/bossComment/Search";
        public static string BossComment_Post_Endpoint = "/bossComment/Post";

        public static string Mobile_Send_Endpoint = "/Mobile/Send";        

        public static string Profile_GetProfile_Endpoint = "/Profile/GetProfile";
        public static string Profile_ChangeProfile_Endpoint = "/Profile/ChangeProfile";
        public static string Profile_ChangeAvatar_Endpoint = "/Profile/ChangeAvatar";

        /// <summary>
        /// 
        /// </summary>
        /// <param name="apiEndpoint"></param>
        /// <returns></returns>
        public static string GetApiEndpoint(string apiEndpoint)
        {
            return string.Concat(ApiHost, apiEndpoint);
        }
    }
}
