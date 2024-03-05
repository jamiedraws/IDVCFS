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
    var groupProductProperties = DtmContext.CampaignProducts
                     .Where(cp => cp.ProductCode == p.ProductCode && !string.IsNullOrWhiteSpace(cp.PropertyIndexer["DropdownGroup"]))
                     .Select(cp => new
                     {
                         RelatedProductCodes = (string.IsNullOrWhiteSpace(cp.PropertyIndexer["RelatedProducts"]))
                         ? new string[] { }
                         : cp.PropertyIndexer["RelatedProducts"].Split(','),
                         DropdownGroup = cp.PropertyIndexer["DropdownGroup"],
                         SelectLabel = string.IsNullOrWhiteSpace(cp.PropertyIndexer["AlternateSelectLabel"]) ? "Size" : cp.PropertyIndexer["AlternateSelectLabel"],
                         SecondSelectLabel = cp.PropertyIndexer["SecondSelectLabel"] ?? string.Empty,
                         CustomPrice = cp.PropertyIndexer["CustomPrice"] ?? string.Empty,
                         VimeoId = cp.PropertyIndexer["VimeoId"],
                         ThumbnailImage = cp.PropertyIndexer["VideoThumbImage"],
                         HeaderName1 = cp.PropertyIndexer["TableHeaderName1"] ?? string.Empty,
                         HeaderName2 = cp.PropertyIndexer["TableHeaderName2"] ?? string.Empty,
                         HeaderName3 = cp.PropertyIndexer["TableHeaderName3"] ?? string.Empty,
                         HeaderName4 = cp.PropertyIndexer["TableHeaderName4"] ?? string.Empty,
                         HeaderName5 = cp.PropertyIndexer["TableHeaderName5"] ?? string.Empty,
                         HeaderName6 = cp.PropertyIndexer["TableHeaderName6"] ?? string.Empty,
                         TableValues = cp.PropertyIndexer["TableValues"] ?? string.Empty,
                         HasSecondTable = (!string.IsNullOrWhiteSpace(cp.PropertyIndexer["Table2HeaderName1"])),
                         TableDisclaimer = cp.PropertyIndexer["TableDisclaimer"] ?? string.Empty
                     }).FirstOrDefault();

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

    var colorObject = new List<string>() { };
    var sizeObject = new List<string>() { };
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

        int colorsCount = 0;

    %>
    <div class="product story-card__fill">
        <div class="form__fieldset product__bold">

            <div class="product__copy">
                <div><%=selectLabel%></div>
                <div class="form form--icon-field-combobox form--select">
                    <div class="form__contain">
                        <select class="form__field" id="<%=p.ProductCode %>_option1" data-initial-option="<%=groupProductProperties.SelectLabel %>">
                            <%

                                var groupProperties = DtmContext.CampaignProducts.Where(x => x.ProductCode == p.ProductCode).Select(y => new { Color = y.PropertyIndexer["Color"], Size = y.PropertyIndexer["Size"] }).FirstOrDefault();

                                colorObject = groupProperties.Color.Split(',').ToList();
                                sizeObject = groupProperties.Size.Split(',').ToList();
                                colorsCount = 0;
                                foreach (var color in colorObject)
                                {
                                    var colorText = color.Split(':')[0];
                                    var colorValue = color.Split(':')[1];
                                    colorsCount = colorsCount + 1;

                            %>
                            <option value="<%=colorValue %>"><%=colorText%></option>

                            <%}%>
                        </select>
                        <% if (colorsCount > 1) { %>
                        <span class="form__field form__button">
                            <svg class="icon icon--combobox">
                                <use href="#icon-chevron"></use></svg>
                        </span>
                        <% } %>
                    </div>
                </div>
            </div>
            <div class="product__copy">
                <div><%=groupProductProperties.SecondSelectLabel%></div>
                <div class="form form--icon-field-combobox form--select">
                    <div class="form__contain">
                        <select class="form__field" id="<%=p.ProductCode %>_option2" data-secondary-option="<%=groupProductProperties.SecondSelectLabel %>">

                            <%  foreach (var size in sizeObject)
                                {
                                    var sizeText = size.Split(':')[0];
                                    var sizeValue = size.Split(':')[1];

                            %>
                            <option value="<%=sizeValue %>"><%=sizeText%></option>

                            <%
                                }

                            %>
                        </select>
                        <span class="form__field form__button">
                            <svg class="icon icon--combobox">
                                <use href="#icon-chevron"></use></svg>
                        </span>
                    </div>
                </div>
            </div>
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

            <a href="javascript:void(0);" class="button button--first cart-button" name="<%=p.ProductCode%>_add" onclick="addGDX('<%=p.ProductCode%>',event);">Add To Cart</a>

            <a target="_blank" href="<%= linkPDP %>" aria-label="<%= ariaLabelPDP %>" class="button">Learn More</a>

        </div>
    </nav>
</figure>


