<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>

<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="System.Globalization" %>
<%@ Import Namespace="IDVCFS.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%
        var ext = DtmContext.ApplicationExtension;
        var version = DtmContext.Version;
        var isMobile = DtmContext.IsMobile;
        var isDesktop = !isMobile;
        var productName = SettingsManager.ContextSettings["Label.ProductName", string.Empty];
        var productNameHtmlEntity = "Copper Fit<sup>&reg;</sup>";
        var productCategories = Model.Categories
            .Where(c => !string.IsNullOrWhiteSpace(c.Code) 
            && ((c.Code.StartsWith("BEST", true, new CultureInfo("en-US"))) || (c.Code.StartsWith("STAGE-BEST", true, new CultureInfo("en-US")) && DtmContext.IsStage)) 
            && (!c.Code.EndsWith("OOS")))
            .ToList();
        var productDetailUrl = String.Format("/{0}/{1}/{2}{3}",
                    DtmContext.OfferCode,
                    DtmContext.Version,
                    "Product",
                    DtmContext.ApplicationExtension);

        var shopCopperFitUrl = "SearchResults?query=copper%20fit";

%>

    <main aria-labelledby="main-title" class="view section fwp bg bg--dark">
        <div id="main" class="view__anchor"></div>

        <%
            var heroCarousel = new SortedList<string, SortedList<string, string>>
            {
                {
                    "hero-carousel-item-1",
                    new SortedList<string, string>
                    {
                        { "title", "Hero-1" }
                    }
                },
                {
                    "hero-carousel-item-2",
                    new SortedList<string, string>
                    {
                        { "title", "Hero-2" }
                    }
                },
                {
                    "hero-carousel-item-3",
                    new SortedList<string, string>
                    {
                        { "title", "Hero-3" }
                    }
                },
                {
                    "hero-carousel-item-4",
                    new SortedList<string, string>
                    {
                        { "title", "Hero-4" }
                    }
                },
                {
                    "hero-carousel-item-5",
                    new SortedList<string, string>
                    {
                        { "title", "Hero-5" }
                    }
                }
            };
        %>
        <div class="slide--fade">
            <div id="hero-carousel" class="slide__into" tabindex="0" data-slide-config='{ "auto" : true, "delay" : 5000 }'>
            <%
                foreach (var carouselItem in heroCarousel)
                {
                    var id = carouselItem.Key ?? string.Empty;

                    foreach (var carouselImage in carouselItem.Value)
                    {
                        var index = heroCarousel.IndexOfKey(id);
                        var firstPicture = index == 0;

                        var title = carouselImage.Key ?? string.Empty;
                        var name = carouselImage.Value ?? string.Empty;
                        var landscapeImage = String.Format("/images/Home/{0}.jpg", name);
                        var portraitImage = String.Format("/images/Home/{0}-mv.jpg", name);

                        var pictureClasses = "contain contain--photo-bar slide__item";

                        if (firstPicture)
                        {
                            pictureClasses = string.Format("{0} slide__item--current", pictureClasses);
                        }
                        %>
                        <picture id="<%= id %>" class="<%= pictureClasses %>" data-src-img="/images/home/hero-1.jpg" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "<%= portraitImage %>" }, { "media" : "(min-width: 600px)", "srcset" : "<%= landscapeImage %>" }], "img" : [{ "src" : "<%= landscapeImage %>", "alt" : "<%= title %>" }]}' data-attr='{ "alt" : "<%= title %>" }'>
                            <noscript>
                                <img src="<%= landscapeImage %>" alt="<%= title %>">
                            </noscript>
                        </picture>
                        <%
                    }
                }
            %>
            </div>
        </div>
        <div class="fwp__overlay fwp__stage">
            <div class="fwp__content">
                <h1 id="main-title" class="fwp__title">Live<br />
                    Limitless</h1>
                <a href="<%= shopCopperFitUrl %>" class="button fwp__button">Shop Copper Fit</a>
            </div>
        </div>
    </main>

    <section aria-labelledby="best-sellers-title" class="view section bg bg--image">
                <picture class="bg__image">
                    <source srcset="/images/section-bg-gray-600.jpg" media="(max-width: 600px)" />
                    <source srcset="/images/section-bg-gray.jpg" media="(min-width: 600px)" />
                    <img src="/images/section-bg-gray.jpg" />
                </picture>
                <div id="best-sellers" class="view__anchor"></div>
                <div class="view__in section__in">
                    <div class="section__block title">
                        <picture class="title__picture contain contain--logo bg__ignore-picture" data-src-img="/images/logos/swoosh.svg">

                    </picture>
                        <h2 id="best-sellers-title" class="title__text">Best Sellers</h2>
                    </div>

                    <div class="section__block story-card story-card--max-four">
                        <div id="best-seller-products" class="story-card__group">
                            <% foreach (var category in productCategories)
                                {
                                    var groupProductCode = category.Code.Split('-').Where(code => code.Contains("GDQ")).FirstOrDefault();
                                    var groupProductInfo = DtmContext.CampaignProducts
                                        .Where(cp => cp.ProductCode == groupProductCode.ToUpper())
                                        .Select(cp => new {
                                            ProductName = category.Name,
                                            Price = cp.Price.ToString("C"),
                                            ImageSource = cp.PropertyIndexer["MainProductImage"],
                                            CustomPrice = cp.PropertyIndexer["CustomPrice"] ?? string.Empty,
                                            IsExternal = (!string.IsNullOrWhiteSpace(cp.PropertyIndexer["IsExternalStage"]) && DtmContext.IsStage) ?
                                                cp.PropertyIndexer["IsExternalStage", false]
                                                : cp.PropertyIndexer["IsExternal", false],
                                            ExternalLink = cp.PropertyIndexer["ExternalLink", string.Empty]
                                        })
                                        .FirstOrDefault();
                                    var fullProductDetailUrl = string.Format("{0}{1}", productDetailUrl, category.RedirectUrl);

                                    if(groupProductInfo.IsExternal)
                                    {
                                        fullProductDetailUrl = groupProductInfo.ExternalLink;
                                    }

                                    var index = productCategories.IndexOf(category);
                                    var price = string.IsNullOrWhiteSpace(groupProductInfo.CustomPrice) ? groupProductInfo.Price : groupProductInfo.CustomPrice;
                                    %>
                            <figure class="story-card__item" id="best-seller-item-<%= index %>">
                                <a href="<%=fullProductDetailUrl%>" <%=groupProductInfo.IsExternal ? "target=_blank" :string.Empty %> class="story-card__image-link contain contain--square bg__picture" data-src-img="<%=groupProductInfo.ImageSource%>">
                                    <span class="button story-card__image-button">Buy Now</span>
                                </a>
                                <figcaption>
                                    <h3 class="story-card__caption"><%=groupProductInfo.ProductName%></h3>
                                    <div class="story-card__price"><%=price%></div>
                                </figcaption>
                            </figure>
                            <% }%>
                        </div>
                    </div>
                </div>
            </section>

    <div class="defer defer--from-top">
        <div class="defer__progress">

            <%= Html.Partial("Section-Icon-Caption", new ViewDataDictionary { { "type", "technology" } }) %>

            <section aria-labelledby="shop-copper-fit-title" class="view section bg bg--image">
                <picture class="bg__image">
                    <source srcset="/images/section-bg-gray-600.jpg" media="(max-width: 600px)" />
                    <source srcset="/images/section-bg-gray.jpg" media="(min-width: 600px)" />
                    <img src="/images/section-bg-gray.jpg" />
                </picture>
                <div id="shop-copper-fit" class="view__anchor"></div>
                <div class="view__in section__in">
                    <div class="section__block title">
                        <picture class="title__picture contain contain--logo" data-src-img="/images/logos/swoosh.svg">

                    </picture>
                        <h2 id="shop-copper-fit-title" class="title__text">Shop Copper Fit <small>By Collection</small></h2>
                    </div>

                    <div class="section__block story-card story-card--max-three">
                        <div id="shop-copper-fit-collection" class="story-card__group story-card__into">
                            <%
                                var productCollection = new NavigationProductCollection();

                                foreach (var product in productCollection.List)
                                {
                                    %>
                                    <figure id="shop-copper-fit-<%= product.Id %>" class="story-card__item">
                                        <a href="<%= product.Link %>" class="contain contain--square bg__picture story-card__image-link" data-src-img="/images/collections/<%= product.Id %>.jpg">
                                    </a>
                                        <figcaption><%= product.Name %></figcaption>
                                    </figure>
                                    <%
                                }
                            %>
                        </div>
                    </div>

                    <div class="section__block story-card">
                        <a href="<%= shopCopperFitUrl %>" class="button">Shop All</a>
                    </div>
                </div>
            </section>

            <picture class="contain contain--photo-bar" data-src-img="/images/home/hero-2.jpg" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "/images/home/hero-2-mv.jpg" }, { "media" : "(min-width: 600px)", "srcset" : "/images/home/hero-2.jpg" }], "img" : [{ "src" : "/images/home/hero-2.jpg" }]}'>
                <noscript>
                    <img src="/images/home/hero-2.jpg" alt="<%= productName %> is perfect for the military">
                </noscript>
            </picture>

            <section aria-labelledby="shop-apparel-title" class="view section bg--image">
                 <picture class="bg__image">
                    <source srcset="/images/section-bg-gray-600.jpg" media="(max-width: 600px)">
                    <source srcset="/images/section-bg-gray.jpg" media="(min-width: 600px)">
                    <img src="/images/section-bg-gray.jpg">
                </picture>
                <div id="shop-apparel" class="view__anchor"></div>
                <div class="view__in section__in">
                    <div class="section__block title">
                        <picture class="title__picture contain contain--logo" data-src-img="/images/logos/swoosh.svg">

                        </picture>
                        <h2 id="shop-apparel-title" class="title__text">Apparel, Accessories, &amp; Footwear</h2>
                    </div>

                    <div class="section__block story-card story-card--max-three">
                        <div id="shop-apparel-products" class="story-card__group">

                    <%
                    string[,] shopApparelList;
                    shopApparelList = new string[,] {
                            { "mens-crew-black", "Men's Dry Performance Crew T-Shirt", "MC" },
                            { "mens-polo-gray", "Men's Dry Performance Golf Polo Shirt", "MP" },
                            { "mens-long-sleeve-black", "Men's Dry Performance Long Sleeve Crew", "MLC" },
                            { "mens-quarter-gray", "Men's Dry Performance Quarter Zip", "MQZ" },
                            { "womens-crew-black", "Women's Short Sleeve Crew T-Shirt", "WC" },
                            { "womens-yoga", "Women's Full-Length Leggings", "WL" },
                        };
                    int shopApparelAmount = shopApparelList.GetLength(0);

                    for (int i = 0; i < shopApparelAmount; i++)
                    {
                        var caption = shopApparelList[i, 1];
                        var cleanCaption = caption.Replace(" ", "%20");
                        var url = string.Format("SearchResults?query={0}", cleanCaption);
                        var apparelLink = "Product" + Model.Extension + "?item=GDX_" + shopApparelList[i, 2];
                            %>
                            <figure id="shop-copper-fit-<%= i %>" class="story-card__item">
                                <a href="<%= apparelLink %>" class="contain contain--square bg__picture story-card__image-link" data-src-img="/images/products/GDX_<%= shopApparelList[i, 2] %>/GDX_<%= shopApparelList[i, 2] %>.jpg">
                                    <span class="button story-card__image-button">Buy Now</span>
                                </a>
                                <figcaption><%= caption %></figcaption>
                            </figure>

                            <%
                    }
                            %>
                        </div>
                    </div>
                </div>
            </section>
         
            <section aria-labelledby="real-customer-stories-title" class="view section bg bg--image bg--dark">
                <picture class="bg__image" data-src-img="/images/section-bg-blue.jpg"></picture>
                <div id="real-customer-stories" class="view__anchor"></div>
                <div class="view__in section__in">
                    <div class="section__block title">
                        <h2 id="real-customer-stories-title" class="title__text">Real Customer Stories</h2>
                    </div>

                    <div class="section__block carousel slide slide--no-scrollbar">
                        <nav aria-label="Previous and next slides for real customer stories" class="carousel__nav slide__nav">
                            <button
                                id="customer-stories-slide-prev"
                                aria-label="Select the previous slide"
                                class="slide__prev"
                                type="button">
                                <svg class="icon icon--chevron">
                                    <use href="#icon-chevron"></use></svg>
                            </button>
                            <button
                                id="customer-stories-slide-next"
                                aria-label="Select the next slide"
                                class="slide__next"
                                type="button">
                                <svg class="icon icon--chevron">
                                    <use href="#icon-chevron"></use></svg>
                            </button>
                        </nav>
                        <div id="real-customer-stories-carousel" class="carousel__into slide__into">
                            <div class="carousel__item slide__item">
                                <blockquote class="carousel__view quote">
                                    <p>"It doesn't matter if you're hurt or not, you got to get through the aches and the pains and something like compression can be the difference. There's no reason why not to give it a try. It's revolutionary."</p>
                                    <footer>Kevin C.<!--Caliber-->(FMR) Lance Corporal, US Marine Corps | Entertainer</footer>
                                    <div class="contain contain--video quote__video" data-src-iframe="https://player.vimeo.com/video/481458623?autoplay=0&title=0&byline=0&portrait=0"></div>
                                </blockquote>
                            </div>
                            <div class="carousel__item slide__item">
                                <blockquote class="carousel__view quote">
                                    <p>"If <%= productName %> can help you reach your next goal, why not? Because it's here to help you and it will. It's remarkable!"</p>
                                    <footer>Arlyn D.<!--Delapena-->(FMR) Capt, US Army | Registered Nurse</footer>
                                    <div class="contain contain--video quote__video" data-src-iframe="https://player.vimeo.com/video/481459479?autoplay=0&title=0&byline=0&portrait=0"></div>
                                </blockquote>
                            </div>
                            <div class="carousel__item slide__item">
                                <blockquote class="carousel__view quote">
                                    <p>"I don't work without it. I rely on it. I'm wearing <%= productName %> knee sleeves because it works for me and I need that."</p>
                                    <footer>Bud G.<!--Gallaway-->| Moving Company</footer>
                                    <div class="contain contain--video quote__video" data-src-iframe="https://player.vimeo.com/video/481460958?autoplay=0&title=0&byline=0&portrait=0"></div>
                                </blockquote>
                            </div>
                            <div class="carousel__item slide__item">
                                <blockquote class="carousel__view quote">
                                    <p>"The more I move it feels better and better. I haven't experienced anything like this."</p>
                                    <footer>Samantha S.<!--Sage-->| Marketing</footer>
                                    <div class="contain contain--video quote__video" data-src-iframe="https://player.vimeo.com/video/481461667?autoplay=0&title=0&byline=0&portrait=0"></div>
                                </blockquote>
                            </div>
                            <div class="carousel__item slide__item">
                                <blockquote class="carousel__view quote">
                                    <p>"When you put it on, wow, the compression. It's great to find something that actually works. I haven't felt this good in years! You can't ask for anything better than that."</p>
                                    <footer>Kenny W.<!--Ware-->| Restaurant Services</footer>
                                    <div class="contain contain--video quote__video" data-src-iframe="https://player.vimeo.com/video/481462302?autoplay=0&title=0&byline=0&portrait=0">
                                </div>
                                </blockquote>
                            </div>
                            <div class="carousel__item slide__item">
                                <blockquote class="carousel__view quote">
                                    <p>"It holds your head and neck in an aligned position so you can have a good nights rest all night long."</p>
                                    <footer>Angel Sleeper&trade; User</footer>
                                    <div class="contain contain--video quote__video" data-src-iframe="https://player.vimeo.com/video/481463408?autoplay=0&title=0&byline=0&portrait=0"></div>
                                </blockquote>
                            </div>
                            <div class="carousel__item slide__item">
                                <blockquote class="carousel__view quote">
                                    <p>"You spend a third of your life laying your head on a pillow. So why would you not have the best pillow you can possibly get?"</p>
                                    <footer>Angel Sleeper&trade; User</footer>
                                    <div class="contain contain--video quote__video" data-src-iframe="https://player.vimeo.com/video/481463392?autoplay=0&title=0&byline=0&portrait=0"></div>
                                </blockquote>
                            </div>
                            <div class="carousel__item slide__item">
                                <blockquote class="carousel__view quote">
                                    <p>"You need total control of your hands when you are doing anything with construction. Your hands are your livelihood. The <%= productName %> gloves are great! The grip is outstanding with the different ribs. Makes my hands a lot more useable. It just feels like you're ready to start the job!"</p>
                                    <footer>Dave K.<!--Klec-->| Licensed Contractor</footer>
                                    <div class="contain contain--video quote__video" data-src-iframe="https://player.vimeo.com/video/481777436?autoplay=0&title=0&byline=0&portrait=0"></div>
                                </blockquote>
                            </div>
                            <div class="carousel__item slide__item">
                                <blockquote class="carousel__view quote">
                                    <p>"The gloves have been a game changer for me. They help with flexibility, pain and soreness. They allow me to do my job even better!"</p>
                                    <footer>Amanda J.<!--Jenkins-->| Professional Hairstylist</footer>
                                    <div class="contain contain--video quote__video" data-src-iframe="https://player.vimeo.com/video/481779059?autoplay=0&title=0&byline=0&portrait=0"></div>
                                </blockquote>
                            </div>
                            <div class="carousel__item slide__item">
                                <blockquote class="carousel__view quote">
                                    <p>"Being a SWAT commander, we train to win. The <%= productName %> Energy Socks, they didn't feel like other compression socks. It totally exceeded my expectations."</p>
                                    <footer>Lt. Christopher C.<!--Cano-->| SWAT Commander</footer>
                                    <div class="contain contain--video quote__video" data-src-iframe="https://player.vimeo.com/video/481793730?autoplay=0&title=0&byline=0&portrait=0"></div>
                                </blockquote>
                            </div>
                        </div>
                    </div>
                </div>
            </section>


            <main aria-labelledby="main-title" class="view section fwp fwp--flip bg bg--dark">
                <div id="favre-story" class="view__anchor"></div>
                <picture class="contain contain--photo-bar" data-src-img="/images/home/hero-3.jpg" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "/images/home/hero-3-mv.jpg" }, { "media" : "(min-width: 600px)", "srcset" : "/images/home/hero-3.jpg" }], "img" : [{ "src" : "/images/home/hero-3.jpg" }]}'>
                    <noscript>
                        <img src="/images/home/hero-3.jpg" alt="">
                    </noscript>
                </picture>
                <div class="fwp__overlay fwp__stage">
                    <div class="fwp__content card card--full-width-picture card--headline">
                        <blockquote class="card__item">
                            <h2>&ldquo;I played 20 years in the NFL... No one could  take a beating like I did. As soon as I put on <%= productNameHtmlEntity %> I could  feel the support.&rdquo;</h2>
                            <footer class="card__author">
                                Brett Favre <br>
                                <small>QUARTERBACK LEGEND</small>
                            </footer>
                            <a href="Story<%= Model.Extension %>" class="button card__button">Our Story</a>
                        </blockquote>
                    </div>
                </div>
            </main>

        </div>
    </div>



</asp:Content>
