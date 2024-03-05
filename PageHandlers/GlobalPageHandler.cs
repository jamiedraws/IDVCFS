using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using Dtm.Framework.ClientSites.Web;
using Dtm.Framework.Models;
using Dtm.Framework.Models.Ecommerce;
using Dtm.Framework.Services.DtmApi;

namespace IDVCFS.PageHandlers
{
    public class GlobalPageHandler : PageHandler
    {
        #region " Overrides... "
        public override void OnProcessCustomPromoCode(PromoCodeRule promoCodeAction, SafeDictionary postData)
        {

            var promoCode = promoCodeAction.PromoCode;
            var discountItems = DtmContext.ShoppingCart.Where(sc => sc.CampaignProduct.ProductTypeId == 1 || sc.CampaignProduct.ProductTypeId == 2).Select(sc => sc.ProductCode).ToList(); 
            var discountPercent = .2M;  // 20%
            var errorMessage = "Please add 2 items to your cart to use promo code " + promoCode + ".";

            OnProcessPromoCode(promoCode, discountItems, discountPercent, errorMessage);

        }
        private void OnProcessPromoCode(string promoCode, List<string> discountedItems, decimal discountedPercent, string errorMessage)
        {
            var cartQty = DtmContext.ShoppingCart.Where(sc => discountedItems.Contains(sc.ProductCode)).Sum(x => x.Quantity);
            if (DtmContext.Page.IsStartPageType && cartQty > 1)
            {
                var discountedCartTotal = DtmContext.ShoppingCart.Where(sc => discountedItems.Contains(sc.ProductCode)).Sum(sc => sc.Price * sc.Quantity);
                var discount = -(discountedCartTotal * discountedPercent);
                var discountRounded = Math.Round((decimal)discount, 2, MidpointRounding.AwayFromZero);
                OrderManager.SetProductQuantity(promoCode, 1);
                Order.Items[promoCode].Price = discountRounded;
                DtmContext.ShoppingCart[promoCode].Price = discount;
            }
            else
            {
                OrderManager.SetProductQuantity(promoCode, 0);
                if (DtmContext.Page.IsStartPageType)
                {
                    AddModelStateError("form", errorMessage);
                }
            }
        }

        public override void PostValidate(ModelStateDictionary modelState)
        {
                //Validate individual OOS SKUs
                var outOfStockSkus = new List<string>() { "CFTBM", "CFTBXL", "CFTGXL", "MCBM", "MCBX", "MCGL", "MCGX", "MQZBS" };
                var outOfStockItemsQty = FormCart.Where(x => outOfStockSkus.Contains(x.ProductSku)).Sum(y => y.Quantity);
                if (outOfStockItemsQty > 0)
                {
                    modelState.AddModelError("Form", "One of your items is out of stock. Please try again.");
                }
        }

        public override void PostProcessPageActions()
        {
            //Checking for the pages code based on the main order pages array on line ten.
            if (DtmContext.Page.IsStartPageType)
            {
                // Custom Promo Code CFSAVE20
                var promoCodeQty = DtmContext.ShoppingCart.Where(sc => sc.ProductCode == "CFSAVE20").Sum(x => x.Quantity);
                var totalCartQty = DtmContext.ShoppingCart.Where(x => x.CampaignProduct.ProductTypeId == 1 || x.CampaignProduct.ProductTypeId == 2).Sum(y => y.Quantity);
                if (promoCodeQty >= 1 && totalCartQty > 1)
                {
                    var promoList = DtmContext.PromoCodeRules.Where(p => p.ActionType == PromoCodeRuleType.Custom).ToList();
                    foreach (var p in promoList)
                    {
                        if (p.PromoCode == "CFSAVE20")
                        {
                            OnProcessCustomPromoCode(p, null);
                        }
                    }
                }
                else
                {
                    OrderManager.SetProductQuantity("CFSAVE20", 0);
                }

                var excludeCodes = new List<string>() { "ADDSHIP", "SH3", "SH5", "SH6", "SH4" };
                var currentItems = DtmContext.ShoppingCart.Where(i => !excludeCodes.Contains(i.ProductCode)).Select(i => i.ProductCode).ToList();

                //New Shipping rules task_id=102727 
                var onlyExcludedItems = true;

                foreach (var item in currentItems)
                {
                    if (!item.StartsWith("GLOV") && !item.StartsWith("ICE"))
                    {
                        onlyExcludedItems = false;
                    }
                }

                if (onlyExcludedItems){
                    OrderManager.SetProductQuantity("SH4", 0);
                }else{
                    OrderManager.SetProductQuantity("SH4", 1);
                }

                //var apparelItems = new List<string>()
                //{
                //    "MCBS","MCBM","MCBL","MCBX",
                //    "MLCBS","MLCBM","MLCBS","MLCBS",
                //    "MQZBS","MQZBM","MQZBL","MQZBX",
                //    "MPBS","MPBM","MPBL","MPBX",
                //    "MCGS","MCGM","MCGL","MCGX",
                //    "MLCGS","MLCGM","MLCGL","MLCGX",
                //    "MQZGS","MQZGM","MQZGL","MQZGX",
                //    "MPCS","MPCM","MPCL","MPCX",
                //    "WCBS","WCBM","WCBL","MCBX",
                //    "WLBS","WLBM","WLBL","WLBX",
                //    "WCMS","WCMM","WCML","WCMX"
                //};
                //var onlyGloves = true;

                //foreach (var item in currentItems)
                //{
                //    if (!item.StartsWith("GLOV")) onlyGloves = false;
                //}
                //var hasApparelItems = currentItems.Any(item => apparelItems.Contains(item));
                //var sh5Codes = new List<string>() { "RRB", "ABPSM", "ABPLXL" };
                //var sh5CodesCount = DtmContext.ShoppingCart.Where(i => sh5Codes.Contains(i.ProductCode)).Sum(i => i.Quantity);
                //var sh6Codes = new List<string>() { "ANGS", "ANGK" };
                //var sh6CodesCount = DtmContext.ShoppingCart.Where(i => sh6Codes.Contains(i.ProductCode)).Sum(i => i.Quantity);

                //if (sh5CodesCount > 0)
                //{
                //    OrderManager.SetProductQuantity("SH5", 1);
                //    OrderManager.SetProductQuantity("SH3", 0);
                //    OrderManager.SetProductQuantity("SH6", 0);

                //}
                //if (sh6CodesCount == 1)
                //{
                //    OrderManager.SetProductQuantity("SH6", 1);
                //    OrderManager.SetProductQuantity("SH3", 0);
                //    OrderManager.SetProductQuantity("SH5", 0);
                //}
                //if (sh6CodesCount > 1)
                //{
                //    OrderManager.SetProductQuantity("SH6", 0);
                //    OrderManager.SetProductQuantity("SH3", 0);
                //    OrderManager.SetProductQuantity("SH5", 0);
                //}
                //if (onlyGloves)
                //{
                //    OrderManager.SetProductQuantity("SH5", 0);
                //    OrderManager.SetProductQuantity("SH3", 0);
                //    OrderManager.SetProductQuantity("SH6", 0);
                //}
                //else if (sh6CodesCount == 0 && sh5CodesCount == 0 && !onlyGloves)
                //{
                //    OrderManager.SetProductQuantity("SH5", 0);
                //    OrderManager.SetProductQuantity("SH6", 0);
                //    var shippingFee = hasApparelItems ? "APPSH" : "SH3";
                //    OrderManager.SetProductQuantity(shippingFee, 1);
                //}
            }
        }

        #endregion
    }
}
