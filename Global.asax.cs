using Dtm.Framework.ClientSites.Web;
using System.Web.Mvc;
using Dtm.Framework.Models;
using System.Web.Routing;
using System.Collections.Generic;

namespace IDVCFS
{
    public class MvcApplication : ClientSiteApplication
    {

        protected override void OnAppStart()
        {
            var discountPercentpromoCodes = new Dictionary<string, decimal>()
            {
                //10% off promo codes
                { "CF10", 0.1M }, { "FIT10", 0.1M },
                { "SAVE10", 0.1M }, { "FACE10", 0.1M },
                { "DAD10", 0.1M }, { "FREE10", 0.1M },
                //20% off promo codes
                { "FRIDAY20", 0.2M }, { "MONDAY20", 0.2M },
                { "FIT20", 0.2M }, { "FREE20", 0.2M },
                { "USA20", 0.2M }, { "CHEERS20", 0.2M }
            };

            foreach (var discountPercentPromoCode in discountPercentpromoCodes)
            {
                DtmContext.PromoCodeRules.Add(new PromoCodeRule(discountPercentPromoCode.Key, PromoCodeRuleType.AddDiscountPercent, discountPercentPromoCode.Key, discountPercentPromoCode.Value, 1));
            }

            // Custom Promo Codes
            DtmContext.PromoCodeRules.Add(new PromoCodeRule("CFSAVE20", PromoCodeRuleType.Custom, "CFSAVE20", 1));

            base.OnAppStart();
        }

        protected override void ConfigureAdditionalRoutes(RouteCollection routes)
        {

            routes.MapRoute("Search", "Search", new { controller = "Search", action = "Search" });
            routes.MapRoute("AddAddress", "Profile/AddAddress", new { controller = "Profile", action = "AddAddress" });
            routes.MapRoute("EditAddress", "Profile/EditAddress", new { controller = "Profile", action = "EditAddress" });
            routes.MapRoute("RemoveAddress", "Profile/RemoveAddress", new { controller = "Profile", action = "DeleteAddress" });
            routes.MapRoute("Articles", "Articles/{urlSlug}", new { controller = "Articles", action = "GetPost" });
            var routeBase = routes["Sitemap.xml"];
            if (routeBase != null)
            {
                routes.Remove(routeBase);
            }

            routes.MapRoute("Sitemap.xml", "Sitemap.xml", new { controller = "CustomSitemap", action = "CustomSiteMapXml", pageCode = "" });
            base.ConfigureAdditionalRoutes(routes);


           
        }

    }
}