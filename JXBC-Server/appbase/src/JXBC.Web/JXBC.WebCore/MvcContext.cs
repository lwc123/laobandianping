using System;
using System.Security.Principal;
using System.Web;
using JXBC.Passports;
using JXBC.WebCore.ViewModels;

namespace JXBC.WebCore
{
    public class MvcContext
    {
        private const string ContextKey = "JXBC.WebCore:MvcContext";

        [ThreadStatic] 
        private static MvcContext ThreadContext = null;

        public static MvcContext Current
        {
            get { return LoadContext(); }
        }

        private static MvcContext LoadContext()
        {
            var httpContext = HttpContext.Current;
            if (null == httpContext)
            {
                if (null == ThreadContext)
                {
                    ThreadContext = new MvcContext().Initialize();
                }
                return ThreadContext;
            }

            MvcContext currentContext = null;
            if (false == httpContext.Items.Contains(ContextKey))
            {
                currentContext = new MvcContext().Initialize();
                httpContext.Items.Add(ContextKey, currentContext);
            }

            currentContext = HttpContext.Current.Items[ContextKey] as MvcContext;
            return currentContext;
        }

        #region instance properties

        private UserPassport userPassport = null;

        public string Host { get; set; }

        public bool IsAuthenticated 
        {
            get { return this.PassportId > 0; }
        }

        /// <summary>
        /// 
        /// </summary>
        public long PassportId { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public bool Test { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public AnonymousAccount ClientAccount { get; set; }

        /// <summary>
        /// 
        /// </summary>
        public UserPassport UserPassport {
            get
            {
                if (false == this.IsAuthenticated) 
                    return null;

                if (null != this.userPassport) 
                    return this.userPassport;

                if (this.PassportId > 0)
                {
                    this.userPassport = UserPassport.FindById(this.PassportId);
                }
                return this.userPassport;
            }
            internal set
            {
                this.userPassport = value;
                if (null == value)
                    this.PassportId = 0;
                else
                    this.PassportId = value.PassportId;
            }
        }

        #endregion

        internal MvcContext()
        {

        }

        private MvcContext Initialize()
        {
            this.Test = AppEnvironment.GetValueFromConfig("application:test", false);

            var userAgnet = HttpContext.Current.Request.UserAgent;
            this.Host = HttpContext.Current.Request.Url.Host;

            var anonymousAccount = AccountAuthentication.LoadAuthenticationInfo();

            if (null != anonymousAccount)
            {
                this.ClientAccount = anonymousAccount;
                this.PassportId = anonymousAccount.PassportId;
                if (this.PassportId > 0)
                {                    
                    HttpContext.Current.User = new GenericPrincipal(new GenericIdentity(anonymousAccount.PassportId.ToString()), null);
                }
            }

            return this;
        }

        public void SignOut()
        {
            AccountAuthentication.SignOut();
        }
    }
}
