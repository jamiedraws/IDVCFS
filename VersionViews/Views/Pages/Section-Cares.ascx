<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var ext = DtmContext.ApplicationExtension;
    var version = DtmContext.Version;
    var isMobile = DtmContext.IsMobile;
    var isDesktop = !isMobile;

    var productNameAttribute = SettingsManager.ContextSettings["Label.ProductName"];
    var productName = productNameAttribute;
    var productNameHtmlEntity = "Copper Fit<sup>&reg;</sup>";
%>

<section aria-labelledby="copper-fit-cares-title" class="view section">
    <div id="copper-fit-cares" class="view__anchor"></div>
    <div class="view__in section__in">
        <div class="section__block story-article">
            <div class="story-article__group">
                <div class="story-article__copy">
                    <small class="story-article__standfirst"><%= productNameHtmlEntity %> cares</small>
                    <h2 id="copper-fit-cares-title">Thank you for the countless hours of service.</h2>

                    <p>During COVID-19, thousands of <%= productName %> Energy Compression Socks were donated across the country to help ease aches and pains of healthcare and essential workers.</p>
                </div>
                <picture class="contain contain--square" data-src-img="/images/about-us/copper-fit-cares-img.jpg" data-attr='{ "alt" : "Woman looking at her knee while wearing <%= productName %> compression socks" }'>
                    <noscript>
                        <img src="/images/about-us/copper-fit-cares-img.jpg" alt="Woman looking at her knee while wearning compression socks">
                    </noscript>
                </picture>
            </div>
        </div>
    </div>
</section>