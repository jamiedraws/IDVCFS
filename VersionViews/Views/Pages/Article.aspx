<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/BlogArticle.master" Inherits="System.Web.Mvc.ViewPage<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="Dtm.Framework.Models.Ecommerce" %>
<%@ Import Namespace="Dtm.Framework.Models.Ecommerce.Repositories" %>
<%@ Import Namespace="Dtm.Framework.Base.TokenEngines" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<% 
    var blogRepo = new BlogPostRepository();
    var blogPosts = blogRepo.Context.BlogPosts.Where(x => x.CampaignCode == DtmContext.CampaignCode && x.IsApproved);
    var blogPost = ViewData["BlogPost"] as BlogPost ?? blogPosts.FirstOrDefault();
%>

<main aria-labelledby="main-title" class="article article--contain article--post">
    <div class="article__title section__block">
        <% 
            var category = blogPost.BlogPostsBlogCategories.Select(p => p.BlogCategory.Name).FirstOrDefault();
            var hasCategory = !string.IsNullOrEmpty(category);

            if (hasCategory)
            {
                category = category.Replace("-", " ");
            }
        %>
        <% if (hasCategory) { %>
            <strong class="article__category"><%= category %></strong>
        <% } %>
        <h1 id="main-title"><%=blogPost.Title %></h1>
    </div>

    <article class="article__copy section__block">
        <%
            var pubDate = blogPost.ChangeDate.ToString("dddd, MMMM dd, yyyy");  
            var dateTime = blogPost.ChangeDate.ToString("o");
            var author = blogPost.Author ?? "Tommy Z";
        %>
        <div class="article__date-address">
            <time dattime="<%= dateTime %>"><%= pubDate %></time>
            <address><%= author %></address>
        </div>
        <div class="article__copy">
            <%
                var toke = new TokenEngine();
            %>
            <%= toke.Process(blogPost.Description, baseClientViewData: Model).Content %>
        </div>
    </article>

    <%
        

        var prevPosts = blogPosts.Where(x => x.ChangeDate < blogPost.ChangeDate).OrderByDescending(x => x.ChangeDate);
        var nextPosts = blogPosts.Where(x => x.ChangeDate > blogPost.ChangeDate).OrderBy(x => x.ChangeDate);

        var prevPostUrl = string.Empty;
        var nextPostUrl = string.Empty;

        if (prevPosts.Any())
        {
            var prevPost = prevPosts.FirstOrDefault();
            prevPostUrl = prevPost.UrlSlug;
        }

        if (nextPosts.Any())
        {
            var nextPost = nextPosts.FirstOrDefault();
            nextPostUrl = nextPost.UrlSlug;
        }

        var hasPrevPost = !string.IsNullOrEmpty(prevPostUrl);
        var hasNextPost = !string.IsNullOrEmpty(nextPostUrl);
    %>

    <nav aria-label="View other articles" class="article article--nav">
        <% if (hasPrevPost) { %>
        <a href="<%= prevPostUrl %>" class="article__prev">
            <svg class="icon icon--chevron">
                <use href="#icon-chevron"></use>
            </svg>
            <span>Previous</span>
        </a>
        <% } %>
        <% if (hasNextPost) { %>
        <a href="<%= nextPostUrl %>" class="article__next">
            <svg class="icon icon--chevron">
                <use href="#icon-chevron"></use>
            </svg>
            <span>Next</span>
        </a>
        <% } %>
    </nav>
</main>

</asp:Content>