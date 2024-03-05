<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<%
    var ext = DtmContext.ApplicationExtension;
    var version = DtmContext.Version;
    var isMobile = DtmContext.IsMobile;
    var isDesktop = !isMobile;

    var productNameAttribute = SettingsManager.ContextSettings["Label.ProductName"];
    var productName = productNameAttribute;
    var productNameHtmlEntity = "Copper Fit<sup>&reg;</sup>";
%>

<main aria-labelledby="main-title" class="view section fwp fwp--reverse">
    <div id="main" class="view__anchor"></div>
    <picture class="contain contain--photo-bar" data-src-img="/images/about-us/hero-1.jpg" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "/images/about-us/hero-1-mv.jpg" }, { "media" : "(min-width: 600px)", "srcset" : "/images/about-us/hero-1.jpg" }], "img" : [{ "src" : "/images/about-us/hero-1.jpg" }]}'>
        <noscript>
            <img src="/images/about-us/hero-1.jpg" alt="About <%= productName %>">
        </noscript>
    </picture>
    <div class="fwp__overlay fwp__stage">
        <div class="fwp__content">
            <h1 id="main-title" class="fwp__small-title"><%= productNameHtmlEntity %><br />Live Limitless</h1>
        </div>
    </div>
</main>

<div class="defer">
    <div class="defer__progress">
        <section aria-labelledby="story-title" class="view">
            <div id="story" class="view__anchor"></div>
            <div class="view__in section__in">
                <div class="section__block article section__contain-article">
                    <h2 id="story-title" class="title__text">Our Story</h2>

                    <p><%= productName %> knows what it's like when you are unable to perform at your best. We know the cycle of soreness, pain, and longer recovery periods. We believe there is a better way. We are motivated by the idea of living in a world with less pain and increased mobility; encouraged by new technologies, materials, and fabrics designed to improve performance, support joints and muscles, aid in recovery, as well as reduce chafing through stitching and wicking, and odors through copper infusion.</p>
                </div>
            </div>
        </section>

        <div class="view bg bg--image">
            <picture class="bg__image" data-src-img="">

            </picture>
            <section aria-labelledby="mission-title" class="view">
                <div id="mission" class="view__anchor"></div>
                <div class="photo-article photo-article--reverse">
                    <picture class="contain contain--photo-sidebar" data-src-img="/images/about-us/Our-Mission-Img.jpg" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "/images/about-us/Our-Mission-Img-mv.jpg" }, { "media" : "(min-width: 600px)", "srcset" : "/images/about-us/Our-Mission-Img.jpg" }], "img" : [{ "src" : "/images/about-us/Our-Mission-Img.jpg" }]}'>
                        <noscript>
                            <img src="/images/about-us/Our-Mission-Img.jpg" alt="Brett Favre recommends <%= productName %>">
                        </noscript>
                    </picture>
                    <div class="article photo-article__item">
                        <div class="photo-article__copy article__copy">
                            <h2 id="mission-title">Our Mission</h2>

                            <p>Millions of people, from extreme athletes to everyday people, have already benefited from <%= productName %> products. We always keep them and our mission in mind: to seek new technologies that support vibrant, healthy lifestyles.</p>
                        </div>
                    </div>
                </div>
            </section>

            <section aria-labelledby="technology-title" class="view">
                <div id="technology" class="view__anchor"></div>
                <div class="photo-article">
                    <picture class="contain contain--photo-sidebar" data-src-img="/images/about-us/New-Technologies-Img.jpg" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "/images/about-us/New-Technologies-Img-mv.jpg" }, { "media" : "(min-width: 600px)", "srcset" : "/images/about-us/New-Technologies-Img.jpg" }], "img" : [{ "src" : "/images/about-us/New-Technologies-Img.jpg" }]}'>
                        <noscript>
                            <img src="/images/about-us/New-Technologies-Img.jpg" alt="New <%= productName %> Technologies">
                        </noscript>
                    </picture>
                    <div class="article photo-article__item">
                        <div class="photo-article__copy article__copy">
                            <h2 id="technology-title">New Technologies</h2>

                            <p>We are constantly innovating and bringing to market the latest technologies, materials, and fabrics &mdash; all designed to support aching joints and sore muscles that aid in recovery. We are always aiming higher - so you can too.</p>
                            <a href="Benefits<%= Model.Extension %>" id="technology-learn-more" class="button">Our Technology</a>
                        </div>
                    </div>
                </div>
            </section>
        </div>

        <section aria-labelledby="brand-title" class="view section">
            <div id="brand" class="view__anchor"></div>
            <div class="view__in section__in">
                <div class="section__block article section__contain-article">
                    <h2 id="brand-title" class="title__text">Brand Champions</h2>

                    <p>The champions we choose to represent <%= productName %> come from all sports and all walks of life. But they have one important thing in common: they give everything they've got to be the best they can be, and inspire others to do the same.</p>
                </div>
            </div>
        </section>

        <section aria-labelledby="brett-farve-title" class="view section fwp fwp--reverse fwp--flip">
            <div id="brett-farve" class="view__anchor"></div>
            <picture class="contain contain--photo-farve" data-src-img="/images/about-us/hero-2.jpg" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "/images/about-us/hero-2-mv.jpg" }, { "media" : "(min-width: 600px)", "srcset" : "/images/about-us/hero-2.jpg" }], "img" : [{ "src" : "/images/about-us/hero-2.jpg" }]}'>
                <noscript>
                    <img src="/images/about-us/hero-2.jpg" alt="A message from Brett">
                </noscript>
            </picture>
            <div class="fwp__overlay fwp__stage section__contain-article">
                <div class="fwp__content card card--full-width-picture">
                    <div class="card__item">
                        <picture class="contain contain--brett-farve-signature" data-src-img="/images/about-us/signature.png" data-attr='{ "alt" : "Brett Favre" }'>
                            <noscript>
                                <img src="/images/about-us/signature.png" alt="Brett Favre">
                            </noscript>
                        </picture>
                        <p>Brett Favre set a lot of records during his legendary 20-year career. In addition to being the only grandfather that has ever actively played in the NFL, he remains the undisputed king of career sacks, where in the quarterback is tackled before throwing a forward pass. Holding the #1 position is nothing to envy; if it could break, sprain, or cause pain, Favre's body experienced it. Now retired from the NFL, Favre maintains an active lifestyle and is in better shape than ever. He serves as a spokesperson and brand ambassador for <%= productName %>, the copper-infused compression garments that help reduce muscle and joint pain.</p>
                    </div>
                </div>
            </div>
        </section>

        <% Html.RenderPartial("Section-Cares", Model); %>
    </div>
</div>

</asp:Content>