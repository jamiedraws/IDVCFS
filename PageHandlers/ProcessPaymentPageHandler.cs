using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web.Mvc;
using Dtm.Framework.ClientSites.Web;
using Dtm.Framework.Models;
using Dtm.Framework.Models.Ecommerce;


namespace IDVCFS.PageHandlers
{
    public class ProcessPaymentPageHandler : PageHandler
    {

        #region " Overrides... "
        public override void PostValidate(ModelStateDictionary modelState)
        {
            if(DtmContext.Order != null && DtmContext.Order.Email == "decline@digitaltargetmarketing.com")
            {
                modelState.AddModelError("Form", "Error has been forced for testing");
            }
            
        }
        #endregion
    }
}
