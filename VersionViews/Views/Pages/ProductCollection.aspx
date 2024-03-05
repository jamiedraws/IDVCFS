<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>

<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<section aria-labelledby="main-title" class="view section fwp bg bg--dark">
    <div id="main" class="view__anchor"></div>
    <picture class="contain contain--photo-bar" data-src-img="https://via.placeholder.com/2000x740" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "https://via.placeholder.com/2000x740" }, { "media" : "(min-width: 600px)", "srcset" : "https://via.placeholder.com/2000x740" }], "img" : [{ "src" : "https://via.placeholder.com/2000x740" }]}'>
        <noscript>
            <img src="https://via.placeholder.com/2000x740" alt="">
        </noscript>
    </picture>
    <div class="fwp__overlay fwp__stage">
        <div class="fwp__content">
            <h1 id="main-title" class="fwp__small-title"><strong>Pro Series</strong><br />Targeted<br />Compression</h1>
        </div>
    </div>
</section>

<div class="defer defer--from-top">
    <div class="defer__progress">
        <%-- story article --%>
        <main aria-labelledby="detail-title" class="view section">
            <div id="detail" class="view__anchor"></div>
            <div class="section__block story-article">
                <div class="story-article__group">
                    <div class="story-article__copy">
                        <h2 id="detail-title">Targeted<br /><strong>Kinesiology</strong><br />Therapy</h2>

                        <p>The Copper Fit Pro Series combines high-performance, copper-infused compression with built-in kinesiology bands to give you the support you need to succeed.</p>
                        <p>Kinesiology bands provide targeted compression and dynamic support while still allowing a functional range of motion.</p>
                        <p>Designed to reduce the recovery time of muscles and supports improved circulation and oxygenation of working muscles.</p>
                    </div>
                    <div class="contain contain--video story-article__video" data-src-img="https://via.placeholder.com/843x474" data-attr='{ "alt" : "" }'>
                    </div>
                </div>
            </div>
        </main>

        <%-- story card --%>
        <%
            var relatedProductCodes = "GDQ_ICE,GDQ_PLUSSOCKS,GDQ_SLEEVES,GDQ_BACKPRO";
            var relatedProducts = DtmContext.CampaignProducts
                .Where(cp => relatedProductCodes.Contains(cp.ProductCode))
                .ToList();
        %>

        <section aria-labelledby="category-products-title" class="view section bg bg--image">
            <picture class="bg__image" data-src-img="/images/section-bg-gray.jpg"></picture>
            <div id=category-products" class="view__anchor"></div>
            <div class="view__in section__in">
                <div class="section__block title">
                    <picture class="title__picture contain contain--logo bg__ignore-picture" data-src-img="/images/logos/swoosh.svg">

                    </picture>
                    <h2 id="category-products-title" class="title__text">Pro-Series Targeted Compression</h2>
                </div>
                <%
                    var itemId = "related-product";
                %>
                <div class="section__block story-card story-card--max-four slide story-card--carousel">
                    <nav aria-label="Previous and next slides for related products" class="story-card__nav slide__nav">
                        <button
                            id="related-products-slide-prev"
                            aria-label="Select the previous slide"
                            class="slide__prev"
                            type="button">
                            <svg class="icon icon--chevron">
                                <use href="#icon-chevron"></use></svg>
                        </button>
                        <button
                            id="related-products-slide-next"
                            aria-label="Select the next slide"
                            class="slide__next"
                            type="button">
                            <svg class="icon icon--chevron">
                                <use href="#icon-chevron"></use></svg>
                        </button>
                    </nav>
                    <div id="related-products-group" class="story-card__group story-card__into slide__into">
                       <% 
                        foreach (var relatedProduct in relatedProducts) {
                            var elementId = string.Format("{0}-{1}", 
                                itemId, 
                                relatedProducts.IndexOf(relatedProduct));

                            Html.RenderPartial("GroupDropdown", 
                                relatedProduct, 
                                new ViewDataDictionary { { "elementId", elementId } }
                            );
                        }
                        %>
                    </div>
                    <nav aria-label="View related products" class="story-card__thumbnails slide__thumbnails">
                       <% 
                        foreach (var relatedProduct in relatedProducts) {
                            var index = relatedProducts.IndexOf(relatedProduct);
                            var elementId = string.Format("#{0}-{1}", itemId, index);
                            %>
                            <a href="<%= elementId %>" class="slide__dot slide__thumbnail" data-slide-index="<%= index %>" aria-label="Learn more about <%= relatedProduct.ProductName %>"></a>
                            <%
                        }
                        %>
                    </nav> 
                </div>
            </div>
        </section>

        <%-- fwp --%>
        <section class="view section fwp fwp--reverse bg bg--dark">
            <div class="view__anchor"></div>
            <picture class="contain contain--photo-bar" data-src-img="https://via.placeholder.com/2000x740" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "https://via.placeholder.com/2000x740" }, { "media" : "(min-width: 600px)", "srcset" : "https://via.placeholder.com/2000x740" }], "img" : [{ "src" : "https://via.placeholder.com/2000x740" }]}'>
                <noscript>
                    <img src="https://via.placeholder.com/2000x740" alt="">
                </noscript>
            </picture>
            <div class="fwp__overlay fwp__stage">
                <div class="fwp__content">
                    <h1 class="fwp__small-title">The <strong>Power</strong> To<br />Power Through</h1>
                </div>
            </div>
        </section>

        <%-- supporting photo grid (PDP) --%>
        <section class="view section">
            <div class="view__in section__in">
                <div class="section__block">
                    <div class="group">
                        <picture class="contain contain--photo-gallery" data-src-img="/images/products/GDQ_PLUSSOCKS/PLUSSOCKS-ACTION-1.jpg">
                        </picture>
                        <picture class="contain contain--photo-gallery" data-src-img="/images/products/GDQ_PLUSSOCKS/PLUSSOCKS-ACTION-2.jpg">
                        </picture>
                    </div>
                </div>
            </div>
        </section>

        <%-- why it works (copper fit tech) --%>
        <%= Html.Partial("Section-Icon-Caption", new ViewDataDictionary { { "type", "advantage" } }) %>

        <%-- FAQ --%>
        <%= Html.Partial("FAQList") %>
    </div>
</div>

<div style="display: none;">
    <%Html.RenderPartial("OrderFormReviewTable"); %>
</div>

</asp:Content>