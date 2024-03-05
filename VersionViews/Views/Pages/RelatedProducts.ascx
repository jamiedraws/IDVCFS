<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.ClientSites.Web.OrderPageViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var relatedProductCodes = (string[])ViewData["RelatedProductCodes"];
    var relatedProducts = DtmContext.CampaignProducts
        .Where(cp => relatedProductCodes.Contains(cp.ProductCode))
        .ToList();
%>

<section aria-labelledby="related-products-title" class="view section bg bg--image">
    <picture class="bg__image" data-src-img="/images/section-bg-gray.jpg"></picture>
    <div id="related-products" class="view__anchor"></div>
    <div class="view__in section__in">
        <div class="section__block title">
            <picture class="title__picture contain contain--logo bg__ignore-picture" data-src-img="/images/logos/swoosh.svg">

            </picture>
            <h2 id="related-products-title" class="title__text">Related</h2>
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
                    foreach (var relatedProduct in relatedProducts)
                    {
                        var elementId = string.Format("{0}-{1}",
                            itemId,
                            relatedProducts.IndexOf(relatedProduct));
                        var isGDX = relatedProduct.ProductCode.StartsWith("GDX");

                        if (isGDX)
                        {

                            Html.RenderPartial("GDX_Dropdown", relatedProduct,
                                new ViewDataDictionary { { "elementId", elementId } });
                        }
                        else
                        {
                            Html.RenderPartial("GroupDropdown",
                           relatedProduct,
                           new ViewDataDictionary { { "elementId", elementId } }
                                        );
                        }
                    }

                %>
            </div>
            <nav aria-label="View related products" class="story-card__thumbnails slide__thumbnails">
                <% 
                    foreach (var relatedProduct in relatedProducts)
                    {
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

