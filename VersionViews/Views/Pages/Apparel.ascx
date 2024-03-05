<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<OrderPageViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

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

        <%
            string[,] shopApparelList;
            shopApparelList = new string[,] {
                { "t-shirts", "T-Shirts" },
                { "base-layers", "Base Layers" },
                { "gloves", "Gloves" },
                { "socks", "Socks" },
                { "shoes", "Shoes" },
                { "insoles", "Insoles" }
            };
            int shopApparelAmount = shopApparelList.GetLength(0);
        %>
        <div class="section__block story-card story-card--max-three slide story-card--carousel">
            <nav aria-label="Previous and next slides to shop Copper Fit Apparel and Accessories" class="story-card__nav slide__nav">
                <button
                    id="shop-apparel-slide-prev"
                    aria-label="Select the previous slide"
                    class="slide__prev"
                    type="button">
                    <svg class="icon icon--chevron">
                        <use href="#icon-chevron"></use></svg>
                </button>
                <button
                    id="shop-apparel-slide-next"
                    aria-label="Select the next slide"
                    class="slide__next"
                    type="button">
                    <svg class="icon icon--chevron">
                        <use href="#icon-chevron"></use></svg>
                </button>
            </nav>
            <div id="shop-apparel-collection" class="story-card__group slide__into story-card__into">
                <%
                    for (int i = 0; i < shopApparelAmount; i++)
                    {
                        var caption = shopApparelList[i, 1];
                        var cleanCaption = caption.Replace(" ", "%20");
                        var url = string.Format("SearchResults?query={0}", cleanCaption);
                        %>
                        <figure id="shop-copper-fit-<%= i %>" class="slide__item story-card__item">
                            <div class="contain contain--square bg__picture" data-src-img="/images/clothing/<%= shopApparelList[i, 0] %>.jpg"></div>
                            <figcaption><%= caption %></figcaption>
                            <a href="<%=cleanCaption == "Balance" ? "javascript:void(0);" : url %>" class="button">Shop</a>
                        </figure>

                        <%
                    }
                %>
            </div>
            <nav aria-label="Shop Copper Fit Apparel navigation" class="slide__thumbnails story-card__thumbnails">
                <%
                    for (int i = 0; i < shopApparelAmount; i++)
                    {
                        %>
                        <a href="#shop-copper-fit-<%= i %>" data-slide-index="<%= i %>" aria-label="View <%= shopApparelList[i, 1] %>" class="slide__dot slide__thumbnail"></a>
                        <%
                    }
                %>
            </nav>
        </div>
    </div>
</section>