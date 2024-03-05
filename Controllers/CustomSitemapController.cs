using Dtm.Framework.Base.Controllers;
using Dtm.Framework.ClientSites;
using Dtm.Framework.ClientSites.Web;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Web;
using System.Web.Mvc;
using System.Xml.Linq;

namespace IDVCFS.Controllers
{
    public class CustomSitemapController : CrawlerController
    {
        public ActionResult CustomSiteMapXml()
        {
            if (DtmContext.IsProxyIpAddress)
                throw new HttpException((int)HttpStatusCode.NotFound, "Sitemap.xml does not exist on proxy.");

            var url = DtmContext.CampaignDomains
                  .Where(d => d.IsSEO)
                  .Select(d => (d.RequiresSSL ? "https://" : "http://") + d.Domain)
                  .FirstOrDefault();

            if (string.IsNullOrWhiteSpace(url))
            {
                new SiteExceptionHandler("Sitemap.xml SEO domain is not configured.");
                return Content("Not configured.");
            }

            var sitemapStack = CreateSiteMapXml();

            var enableSiteMapExtension = SettingsManager.ContextSettings["SiteMap.EnableExtension", true];
            var extension = enableSiteMapExtension ? DtmContext.ApplicationExtension : string.Empty;

            var doc = new XDocument(
                new XDeclaration("1.0", "UTF-8", string.Empty),
                new XElement("urlset",
                    new XAttribute("nsattr", "http://www.google.com/schemas/sitemap/0.9"),
                    sitemapStack.Select(p => new XElement("url",
                    new XElement("loc", string.Format("{0}{1}", url, string.IsNullOrWhiteSpace(p.Item1) ? string.Empty : "/" + p.Item1 + (p.Item3 ? extension : string.Empty))),
                    new XElement("lastmod", p.Item2.ToString("yyyy-MM-dd")),
                    new XElement("changefreq", "monthly"),
                    new XElement("priority", "0.5")
                    ))));

            var xmlBuilder = new StringBuilder();
            xmlBuilder.AppendLine(doc.Declaration.ToString().Replace("standalone=\"\"", string.Empty));
            xmlBuilder.AppendLine(doc.ToString().Replace("nsattr", "xmlns"));
            Response.Cache.SetCacheability(HttpCacheability.Public);
            return Content(xmlBuilder.ToString(), "text/xml");
        }

        private Stack<Tuple<string, DateTime, bool>> CreateSiteMapXml()
        {
            int test;
            var pageTypeIds = SettingsManager.ContextSettings["Sitemap.PageTypeIds", "1,11,22"].Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries)
                .Where(i => int.TryParse(i, out test))
                .Select(int.Parse)
                .ToList();
            var pageCodes = SettingsManager.ContextSettings["Sitemap.PageCodes", "index"].Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            var excludePagesCodes = SettingsManager.ContextSettings["Sitemap.ExcludePageCodes", "ProductCollection,Checkout,Articles,Article,Stories,ProductDetailPage,ShoppingCart"].Split(new[] { ',' }, StringSplitOptions.RemoveEmptyEntries);
            var pages = DtmContext.CampaignPages
                 .Where(p => ((p.PageTypeId.HasValue && pageTypeIds.Contains(p.PageTypeId.Value))
                     || pageCodes.Any(pc => pc.Equals(p.PageCode, StringComparison.InvariantCultureIgnoreCase)))
                     && !excludePagesCodes.Any(pc=> pc.Equals(p.PageCode, StringComparison.InvariantCultureIgnoreCase)))
                 .ToList();

            // Custom sitemap stack - request from Graphics
            var sitemapStack = new Stack<Tuple<string, DateTime, bool>>();

            // Product Pages
            if (SettingsManager.ContextSettings["SiteMap.EnableProductPages", false])
            {
                var products = DtmContext.CampaignProducts
                    .Where(cp => cp.ProductTypeId == 2 && !string.IsNullOrWhiteSpace(cp.ShortName))
                    .Select(cp => Regex.Replace(cp.ShortName, "[^A-Za-z0-9_]", string.Empty))
                    .OrderByDescending(name => name)
                    .ToList();

                var dupes = products.GroupBy(p => p).Where(g => g.Count() > 1).ToList();
                if (dupes.Any())
                {
                    new SiteExceptionHandler("Duplicate Short names detected: " + string.Join(",", dupes.Select(d => d.Key)));
                    products = products.Distinct().OrderByDescending(name => name).ToList();
                }

                products.ForEach(name =>
                    sitemapStack.Push(new Tuple<string, DateTime, bool>(
                        string.Format(SettingsManager.ContextSettings["SiteMap.ProductPagesFormat", "Product/Detailsbyname/{0}"], name),
                        pages.Min(p => p.AddDate),
                        false)));
            }

            // Category Pages
            if (SettingsManager.ContextSettings["SiteMap.EnableCategoryPages", false] && !string.IsNullOrWhiteSpace(SettingsManager.ContextSettings["SiteMap.CategoryCodes"]))
            {
                var validCategories = (SettingsManager.ContextSettings["SiteMap.CategoryCodes", string.Empty] ?? string.Empty)
                    .Split(new[] { "," }, StringSplitOptions.RemoveEmptyEntries)
                    .Select(c => c.Trim())
                    .ToArray();

                var categories = DtmContext.CampaignCategories
                    .Where(cc => !string.IsNullOrWhiteSpace(cc.Name) && !string.IsNullOrWhiteSpace(cc.Code)
                        && validCategories.Any(c => !string.IsNullOrWhiteSpace(c) && cc.Code.Equals(c, StringComparison.InvariantCultureIgnoreCase)))
                    .Select(cc => Regex.Replace(cc.Name, "[^A-Za-z0-9]", string.Empty))
                    .OrderByDescending(name => name)
                    .ToList();

                var dupes = categories.GroupBy(p => p).Where(g => g.Count() > 1).ToList();
                if (dupes.Any())
                {
                    categories = categories.Distinct().OrderByDescending(name => name).ToList();
                }

                categories.ForEach(name =>
                    sitemapStack.Push(new Tuple<string, DateTime, bool>(
                        string.Format(SettingsManager.ContextSettings["SiteMap.CategoryPagesFormat", "Product/List/{0}"], name),
                        pages.Min(p => p.AddDate),
                        false)));
            }

            // Domian Url
            sitemapStack.Push(new Tuple<string, DateTime, bool>(string.Empty, pages.Min(p => p.AddDate), true));

            // Index
            var index = pages.FirstOrDefault(p => p.PageCode.Equals("Index", StringComparison.InvariantCultureIgnoreCase));
            if (index != null)
                sitemapStack.Push(new Tuple<string, DateTime, bool>(index.PageAlias, index.AddDate, true));

            // Sitemap
            var sitemap = pages.FirstOrDefault(p => p.PageCode.Equals("Sitemap", StringComparison.InvariantCultureIgnoreCase));
            if (sitemap != null)
                sitemapStack.Push(new Tuple<string, DateTime, bool>(sitemap.PageAlias, sitemap.AddDate, true));

            // Order page types - ordered by page code
            var orderPages = pages
                .Where(p => sitemapStack.All(s => s.Item1 != p.PageAlias) && p.PageTypeId == 1)
                .OrderBy(p => p.PageCode)
                .Select(p => new Tuple<string, DateTime, bool>(p.PageAlias, p.AddDate, true))
                .ToList();
            orderPages.ForEach(sitemapStack.Push);

            // Other Pages - ordered by page code
            var otherPages = pages
                .Where(p => sitemapStack.All(s => s.Item1 != p.PageAlias))
                .OrderBy(p => p.PageCode)
                .Select(p => new Tuple<string, DateTime, bool>(p.PageAlias, p.AddDate, true))
                .ToList();
            otherPages.ForEach(sitemapStack.Push);

            return sitemapStack;
        }

    }
}