<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.CampaignProductView>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var p = Model;
    string mainImage = p.PropertyIndexer["MainProductImage"] ?? "|";
    var mainImageUrl = mainImage.Split('|')[0];
    var mainImageAlt = mainImage.Contains('|') ? mainImage.Split('|')[1] : "";
    var isGroup = p.ProductCode.StartsWith("GDQ");
    var isExternalStage = (!string.IsNullOrWhiteSpace(p.PropertyIndexer["IsExternalStage"]) && DtmContext.IsStage) 
        ? p.PropertyIndexer["IsExternalStage", false] 
        : p.PropertyIndexer["IsExternal", false];
    var isExternal = isExternalStage;
    var selectLabel = string.IsNullOrWhiteSpace(p.PropertyIndexer["AlternateSelectLabel"]) ? "Size" : p.PropertyIndexer["AlternateSelectLabel"];

    if (string.IsNullOrEmpty(mainImageUrl))
    {
        mainImageUrl = "/images/default/425x425.jpg";
    }

    var productTitle = p.ProductName;
    var dropdownText = "Price: $" + p.Price.ToString("F");
    var promoCodeItem = p.ProductCode + "P";
    var finalPromoCode = DtmContext.ShoppingCart[promoCodeItem].Quantity > 0 ? promoCodeItem : p.ProductCode;

    var linkPDP = String.Format("Product{0}?item={1}", DtmContext.ApplicationExtension, p.ProductCode);

    if (isExternal)
    {
        linkPDP = p.PropertyIndexer["ExternalLink", string.Empty];
    }

    var ariaLabelPDP = String.Format("Shop for {0}", productTitle);
    var ariaLabelCart = String.Format("Add {0} to your cart", productTitle);
    var ariaLabelNav = String.Format("Add {0} to your cart or learn more about {0}", productTitle);

    var dropDownName = p.PropertyIndexer["DropdownGroup"] ?? string.Empty;
    var customPrice = p.PropertyIndexer["CustomPrice"] ?? string.Empty;
    var singleProducts = new List<Dtm.Framework.Base.Models.CampaignProductView>();
    var productCodes = DtmContext.CampaignProducts
                .Where(cp => 
                cp.CategoryIndexer.Has(p.ProductCode) 
                    || cp.CategoryIndexer.Has("BEST-" + p.ProductCode)
                    || (cp.CategoryIndexer.Has("STAGE-BEST-" + p.ProductCode) && DtmContext.IsStage)
                    || cp.CategoryIndexer.Has("APP-" + p.ProductCode)
                    || (cp.CategoryIndexer.Has("STAGE-APP-" + p.ProductCode) && DtmContext.IsStage)
                    || (cp.CategoryIndexer.Has("STAGE-" + p.ProductCode) && DtmContext.IsStage))
                .Select(cp => cp.ProductCode)
                .ToList();
    var productsString = string.Join(",", productCodes);
    productCodes.ForEach(x =>
    {
        var item = DtmContext.CampaignProducts.FirstOrDefault(y => y.ProductCode.ToLower() == x.ToLower());
        if (item != null)
        {
            singleProducts.Add(item);
        }
    });
    var multipleProducts = (singleProducts.Count() > 1);

    var elementId = ViewData["elementId"] as string ?? string.Empty;
    var elementAttributes = string.Empty;
    if (!string.IsNullOrEmpty(elementId))
    {
        elementAttributes = string.Format(@"id=""{0}""", elementId);
    }
    var price = string.IsNullOrWhiteSpace(customPrice) ? p.Price.ToString("C") : customPrice;

    var imageAttributes = string.Format(@"
        href=""{0}""
        aria-label=""{1}""
        class=""contain contain--square story-card__image-link bg__picture"" 
        data-src-img=""{2}""
    ", linkPDP, ariaLabelPDP, mainImageUrl);

    if (isExternal)
    {
        imageAttributes = string.Format(@"
        {0}
        target=""_blank""
        ", imageAttributes);
    }
%>

<figure <%= elementAttributes %> class="slide__item story-card__item">
    <a <%= imageAttributes %>></a>
    <figcaption>
        <h3 class="story-card__caption"><%= productTitle %></h3>

        <div class="story-card__price"><%= price %></div>

    </figcaption>
    <%
        if (!isExternal)
        {


    %>
    <div class="product story-card__fill">
        <div class="form__fieldset product__bold">
            <%
                if (multipleProducts)
                {%>
            <div class="product__copy">
                <div><%=selectLabel%></div>
                <div class="form form--icon-field-combobox form--select">
                    <div class="form__contain">
                        <select data-select="" class="form__field" data-dropdown-group="<%=dropDownName%>">
                            <option value="">Select</option>
                            <% foreach (var product in singleProducts)
                                {
                                    var label = product.PropertyIndexer["Size"];
                            %>
                            <option value="<%=product.ProductCode %>"><%=label %></option>
                            <% } %>
                        </select>
                        <span class="form__field form__button">
                            <svg class="icon icon--combobox">
                                <use href="#icon-chevron"></use></svg>
                        </span>
                    </div>
                </div>
            </div>
            <% }
                else
                {
                    if (productCodes.Any())
                    {%>
            <input type="hidden" data-dropdown-group="<%=dropDownName %>" value="<%=productCodes[0]%>" />
            <%}
    }

            %>
            <div class="product__copy">
                <div>Quantity</div>
                <div class="form form--icon-field-combobox">
                    <div class="form__contain">
                        <button type="button" class="form__field form__button" data-quantity-id="<%=dropDownName%>_Qty" data-exp="min" onclick="event.preventDefault();updateButtonQuantity(this);">
                            <svg class="icon">
                                <use href="#icon-minus"></use></svg>
                        </button>
                        <input class="form__field form__input" type="number" min="1" max="2" placeholder="1" value="1" id="<%=dropDownName%>_Qty" name="<%=dropDownName%>_Qty" data-max="2" onchange="validateInput(this);">
                        <button type="button" class="form__field form__button" data-quantity-id="<%=dropDownName%>_Qty" data-exp="add" onclick="event.preventDefault();updateButtonQuantity(this);">
                            <svg class="icon">
                                <use href="#icon-plus"></use></svg>
                        </button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <% 
        }
    %>
    <div class="vse_<%=dropDownName %>">
    </div>
    <nav aria-label="<%= ariaLabelNav %>" class="story-card__fill">
        <div class="story-card__buttons">
            <%if (!isExternal)
                { %>
            <a aria-label="<%= ariaLabelCart %>" href="javascript:void(0);" name="<%=dropDownName%>" data-products="<%=productsString %>" onclick="updateProductQuantity(this);" class="button button--first cart-button">Add To Cart</a>
            <a href="<%= linkPDP %>" aria-label="<%= ariaLabelPDP %>" class="button">Learn More</a>

            <% } else { %>
             <a target="_blank" href="<%= linkPDP %>" aria-label="<%= ariaLabelPDP %>" class="button">Learn More</a>
            <% } %>
        </div>
    </nav>
</figure>


