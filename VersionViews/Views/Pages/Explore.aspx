<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>

<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="Dtm.Framework.Models.Ecommerce.Repositories" %>
<%@ Import Namespace="System.IO" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%
        var ext = DtmContext.ApplicationExtension;
        var version = DtmContext.Version;
        var isMobile = DtmContext.IsMobile;
        var isDesktop = !isMobile;

        var productNameAttribute = SettingsManager.ContextSettings["Label.ProductName"];
        var productName = productNameAttribute.Replace("&reg;", "<sup>&reg;</sup>");
        var blogRepo = new BlogPostRepository();
        var blogPosts = blogRepo.Context.BlogPosts.Where(x => x.CampaignCode == DtmContext.CampaignCode && x.IsApproved)
            .OrderByDescending(x => x.AddDate)
            .Take(12);
    %>

    <section aria-labelledby="main-title" class="view section fwp fwp--reverse bg bg--dark">
        <div id="main" class="view__anchor"></div>
        <picture class="contain contain--photo-bar" data-src-img="/images/explore/hero-1.jpg" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "/images/explore/hero-1-mv.jpg" }, { "media" : "(min-width: 600px)", "srcset" : "/images/explore/hero-1.jpg" }], "img" : [{ "src" : "/images/explore/hero-1.jpg" }]}'>
        <noscript>
            <img src="/images/explore/hero-1.jpg" alt="Baseball player <%= productName %>">
        </noscript>
    </picture>
        <div class="fwp__overlay fwp__stage">
            <div class="fwp__content">
                <h1 id="main-title" class="fwp__title">Explore</h1>
            </div>
        </div>
    </section>

    <div class="defer defer--from-top">
        <div class="defer__progress">

            <!-- copper fit news section goes here -->

            <section aria-labelledby="copper-fit-videos-title" class="view section bg bg--image">
                <div id="copper-fit-videos" class="view__anchor"></div>
                <div class="view__in section__in">
                    <div class="section__block title">
                        <h2 id="copper-fit-videos-title" class="title__text">Copper Fit<sup>&reg;</sup> Videos</h2>
                    </div>

                    <div class="section__block slide story-card story-card--videos excerpt story-card--carousel">
                        <nav aria-label="Previous and next slides for articles" class="slide__nav story-card__nav">
                            <button
                                id="video-slide-prev"
                                aria-label="Select the previous video"
                                class="slide__prev"
                                type="button">
                                <svg class="icon icon--chevron">
                                    <use href="#icon-chevron"></use></svg>
                            </button>
                            <button
                                id="video-slide-next"
                                aria-label="Select the next video"
                                class="slide__next"
                                type="button">
                                <svg class="icon icon--chevron">
                                    <use href="#icon-chevron"></use></svg>
                            </button>
                        </nav>
                        <%
                            var videos = new SortedList<string, string>
                        {
                            { "380048613", "Angel Sleeper" },
                            { "394451647", "Ice Knee Sleeves" },
                            { "283947334", "Compression Gloves" },
                            { "318639052", "Compression Sleeves" },
                            { "434812384", "Energy Plus Socks" },
                            { "276064337", "Advanced Back Pro" },
                            { "423634593", "Guardwell Face Protector" },
                            { "442752549", "Guardwell Hand Protector" },
                            { "497073904", "Never Lost Mask" }
                        };
                        %>
                        <div id="video-group" class="slide__into story-card__into story-card__group">
                            <%
                                foreach (var video in videos)
                                {
                                    var index = videos.IndexOfKey(video.Key);
                            %>
                            <div id="video-<%= index %>" class="excerpt__item slide__item story-card__item">
                                <div class="contain contain--video bg__picture">
                                    <iframe id="player" src="https://player.vimeo.com/video/<%= video.Key %>?autoplay=0&title=0&byline=0&portrait=0" frameborder="0" webkitallowfullscreen mozallowfullscreen allowfullscreen></iframe>
                                </div>
                                <div class="excerpt__content">
                                    <div class="excerpt__category">Video</div>
                                    <h3 class="excerpt__title"><%= video.Value %></h3>
                                </div>
                            </div>
                            <%
                                }
                            %>
                        </div>
                    </div>
                </div>
            </section>

            <section aria-labelledby="copper-fit-stories-title" class="view section bg bg--image">
                <picture class="bg__image" data-src-img="/images/section-bg-gray.jpg"></picture>
                <div id="copper-fit-stories" class="view__anchor"></div>
                <div class="view__in section__in">
                    <div class="section__block title">
                        <h2 id="copper-fit-stories-title" class="title__text">Copper Fit<sup>&reg;</sup> Stories</h2>
                    </div>
                    <div class="section__block story-card story-card--max-four slide excerpt excerpt--carousel">
                        <nav aria-label="Previous and next slides for articles" class="excerpt__nav slide__nav">
                            <button
                                id="blogroll-slide-prev"
                                aria-label="Select the previous set of articles"
                                class="slide__prev"
                                type="button">
                                <svg class="icon icon--chevron">
                                    <use href="#icon-chevron"></use></svg>
                            </button>
                            <button
                                id="blogroll-slide-next"
                                aria-label="Select the next set of articles"
                                class="slide__next"
                                type="button">
                                <svg class="icon icon--chevron">
                                    <use href="#icon-chevron"></use></svg>
                            </button>
                        </nav>
                        <div id="blogroll" class="slide__into excerpt__into excerpt__group story-card__group" data-slide-config='{ "steps" : 4 }'>
                            <% 
                                foreach (var post in blogPosts)
                                {
                                    var category = post.BlogPostsBlogCategories.Select(p => p.BlogCategory.Name).FirstOrDefault();
                                    var hasCategory = !string.IsNullOrEmpty(category);

                                    if (hasCategory)
                                    {
                                        category = category.Replace("-", " ");
                                    }

                                    var postLink = String.Format("Articles/{0}", post.UrlSlug);
                            %>
                            <a href="/<%= postLink %>" aria-label="Full article for <%= post.Title %>" class="excerpt__item slide__item">
                                <%
                                    var postThumbnail = post.Meta;
                                    var hasPostThumbnail = !string.IsNullOrEmpty(postThumbnail) && File.Exists(Server.MapPath(postThumbnail));

                                    if (!hasPostThumbnail)
                                    {
                                        postThumbnail = "/images/default/365x375.jpg";
                                    }
                                %>
                                <picture class="contain contain--article-thumbnail bg__picture" data-src-img="<%= postThumbnail %>"></picture>
                                <div class="excerpt__content">
                                    <% if (hasCategory)
                                    { %>
                                    <div class="excerpt__category"><%= category %></div>
                                    <% } %>
                                    <h3 class="excerpt__title"><%= post.Title %></h3>
                                    <div class="excerpt__desc"><%= post.ShortDescription %></div>
                                </div>
                            </a>
                            <% 
                                }
                            %>
                        </div>
                    </div>
                </div>
            </section>

            <% Html.RenderPartial("Section-Cares", Model); %>
        </div>
    </div>

</asp:Content>
