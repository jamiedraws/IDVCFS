using Dtm.Framework.Base.Controllers;
using Dtm.Framework.ClientSites.Web;
using System.Data;
using System.Web.Mvc;
using System.Linq;
using System.Text.RegularExpressions;
using Dtm.Framework.Models.Ecommerce;
using System.Collections.Generic;
using System.Web.UI.WebControls;
using Dtm.Framework.Base.Models;

namespace IDVCFS.Controllers
{

    public class SearchController : DtmContextController
    {

        public ActionResult Search(string text)
        {
            var version = Request.Form["versionNumber"] ?? "";
            var offer = DtmContext.OfferCode;

            var allSearchableProducts = DtmContext.CampaignProducts
                .Where(cp =>
                   cp.PropertyIndexer.Has("Products") 
                   && cp.CategoryIndexer.Has("SEARCH") || (cp.CategoryIndexer.Has("STAGE-SEARCH") && DtmContext.IsStage))
                .ToList();
            var finalList = new List<CampaignProductView>();
            var navQuery = Request["n"] ?? string.Empty;
            var isNavSearch = navQuery != string.Empty && navQuery == "1";
            if (text.ToLower() == "all")
            {
                finalList.AddRange(allSearchableProducts);
            }
            else
            {
                var regexMatchList = !isNavSearch ? DtmContext.CampaignProducts.Where(cp =>
                    Regex.IsMatch(cp.ProductName ?? string.Empty, text, RegexOptions.IgnoreCase)
                    || Regex.IsMatch(cp.DisplayText ?? string.Empty, text, RegexOptions.IgnoreCase)
                    || Regex.IsMatch(cp.MetaKeywords ?? string.Empty, text, RegexOptions.IgnoreCase)
                    || Regex.IsMatch(cp.ShortName ?? string.Empty, text, RegexOptions.IgnoreCase)).ToList() :

                    DtmContext.CampaignProducts.Where(cp =>
                    Regex.IsMatch(cp.ProductName ?? string.Empty, text, RegexOptions.IgnoreCase)
                    || Regex.IsMatch(cp.MetaKeywords ?? string.Empty, text, RegexOptions.IgnoreCase)).ToList();


                var filteredList = regexMatchList.Where(p => (p.ProductType != "Option" && p.ProductType != "Shipping" && p.ProductType != "None")).ToList();

                

                foreach (var item in filteredList)
                {
                    var groupedItemList = allSearchableProducts.Where(cp => cp.PropertyIndexer["Products"].Contains(item.ProductCode) || cp.ProductCode == item.ProductCode);

                    foreach (var groupedItem in groupedItemList)
                    {
                        if (!finalList.Any(x => x.ProductCode == groupedItem.ProductCode))
                        {
                            finalList.Add(groupedItem);

                        }
                    }
                }
            }

            TempData["Products"] = finalList;

            return Redirect("/" + offer + "/" + version + "/SearchResults?query=" + text);

        }
    }

}