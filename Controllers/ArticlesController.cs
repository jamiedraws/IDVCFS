using Dtm.Framework.Base.Controllers;
using Dtm.Framework.ClientSites.Web;
using Dtm.Framework.ClientSites.Web.Controllers;
using System.Data;
using System.Web.Mvc;
using System.Linq;
using Dtm.Framework.Models.Ecommerce.Repositories;
namespace IDVCFS.Controllers
{

    public class ArticlesController : ClientSiteController<ClientSiteViewData>
    {

        public ActionResult GetPost(string urlSlug)
        {
            var version = Request.Url.LocalPath;

            var blogRepo = new BlogPostRepository();
            var blogPost = blogRepo.Context.BlogPosts.Where(x => x.CampaignCode == DtmContext.CampaignCode && x.IsApproved && x.UrlSlug == urlSlug).FirstOrDefault();

            var article = DtmContext.CampaignPages.FirstOrDefault(x => x.PageCode == "Article");

            DtmContext.Page = article;
            DtmContext.PageCode = article.PageCode;

            MapModelPageInformation();

            ViewData["BlogPost"] = blogPost;
            return View("Article", Model);

        }
    }

}