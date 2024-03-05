<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/ProductDetailPage.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>

<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="System.IO" %>
<%@ Import Namespace="System.Globalization" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%
        var ext = DtmContext.ApplicationExtension;
        var version = DtmContext.Version;
        var isMobile = DtmContext.IsMobile;
        var isDesktop = !isMobile;
        var item = Request["item"] ?? string.Empty;

        if (!string.IsNullOrEmpty(item))
        {
            var getPageId = DtmContext.CampaignPages.Where(cp => cp.PageCode == item).Select(cp => cp.PageId);
            var isGDX = item.StartsWith("GDX_");

            if (getPageId.Any())
            {
                var pageId = getPageId.FirstOrDefault();
                var upsellRepo = new Dtm.Framework.Models.Ecommerce.Repositories.UpsellRepository();
                var upsell = upsellRepo.GetByPageId(pageId);
                var upsellInfo = new { ProductFeatures = upsell.Text, AdvancedProductFeatures = upsell.UpsellTextDisclaimer };
                var productCodes = DtmContext.CampaignProducts
                    .Where(cp =>
                    cp.CategoryIndexer.Has(item)
                        || cp.CategoryIndexer.Has("BEST-" + item)
                        || (cp.CategoryIndexer.Has("STAGE-BEST-" + item) && DtmContext.IsStage)
                        || cp.CategoryIndexer.Has("APP-" + item)
                        || (cp.CategoryIndexer.Has("STAGE-APP-" + item) && DtmContext.IsStage)
                        || (cp.CategoryIndexer.Has("STAGE-" + item) && DtmContext.IsStage))
                    .Select(cp => cp.ProductCode)
                    .ToArray();
                var isExternal = DtmContext.CampaignProducts.Any(cp => cp.ProductCode == item
                && ((!string.IsNullOrWhiteSpace(cp.PropertyIndexer["IsExternalStage"]) && DtmContext.IsStage && cp.PropertyIndexer["IsExternalStage", false])
                        || (cp.PropertyIndexer["IsExternal", false] && !DtmContext.IsStage)));
                var hasProducts = (productCodes.Count() > 0);

                if (hasProducts && !isExternal)
                {
                    var productsString = string.Join(",", productCodes);
                    var groupProductInfo = DtmContext.CampaignProducts
                        .Where(cp => cp.ProductCode == item.ToUpper())
                        .Select(cp => new { ProductName = cp.ProductName, Price = cp.Price.ToString("C"), ProductDescription = cp.DisplayText })
                        .FirstOrDefault();
                    var groupProductProperties = DtmContext.CampaignProducts
                        .Where(cp => cp.ProductCode == item && !string.IsNullOrWhiteSpace(cp.PropertyIndexer["DropdownGroup"]))
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
                            TableDisclaimer = cp.PropertyIndexer["TableDisclaimer"] ?? string.Empty,
                            TableInfoContent1 = cp.PropertyIndexer["TableInfoContent1"] ?? string.Empty,
                            TableInfoContent2 = cp.PropertyIndexer["TableInfoContent2"] ?? string.Empty
                        }).FirstOrDefault();
                    var imageFolder = "/images/products/" + item;
                    var directoryPath = DtmContext.ProjectPath + imageFolder;
                    var directoryImages = Directory.Exists(directoryPath)
                        ? new DirectoryInfo(directoryPath).GetFiles("*.*").Select(i => i.Name).ToList()
                        : new List<string>();
                    var allImages = directoryImages.Where(l => l.Contains(item + ".")).ToList();
                    allImages.AddRange(directoryImages.Where(l => l.Contains(item + "-")).ToList());
                    var hasVideo = (!string.IsNullOrWhiteSpace(groupProductProperties.VimeoId));
                    var imageCount = allImages.Count;

                    var productName = SettingsManager.ContextSettings["Label.ProductName", string.Empty];
                    var price = string.IsNullOrWhiteSpace(groupProductProperties.CustomPrice) ? groupProductInfo.Price : groupProductProperties.CustomPrice;
    %>

    <%= Html.Partial("HeroBanners", new ViewDataDictionary { { "type", item } }) %>

    <div class="defer defer--from-top">
        <div class="defer__progress page">
            <section aria-labelledby="limited-time-offer-title" class="view section bg bg--image bg--dark">
                <picture class="bg__image" data-src-img="/images/section-bg-blue.jpg">

            </picture>
                <div class="view__in section__in">
                    <div class="section__block title">
                        <div class="group promo-offer">
                            <h2 id="limitd-time-offer-title" class="title__text">Special Limited Time Offer</h2>
                            <picture class="contain contain--square" data-src-img="/images/mbg.svg"></picture>
                        </div>
                    </div>
                </div>
            </section>

            <span class="svg-symbols">
                <svg>
                    <symbol id="icon-chevron" x="0px" y="0px" viewBox="0 0 5.3 8.2" style="enable-background: new 0 0 5.3 8.2;">
                        <path d="M0.8,4.2 M0.8,4.2L4,1 M4,7.4L0.8,4.2" />
                    </symbol>
                    <symbol id="icon-plus" x="0px" y="0px" viewBox="0 0 11 11" style="enable-background: new 0 0 11 11;">
                        <path d="M10.1,5.5H5.5v4.6 M5.5,5.5H0.9 M5.5,0.9v4.6" />
                    </symbol>
                    <symbol id="icon-minus" x="0px" y="0px" viewBox="0 0 11 11" style="enable-background: new 0 0 11 11;">
                        <path d="M10.1,5.5H5.4 M5.4,5.5H0.7 M5.4,5.5" />
                    </symbol>
                    <symbol id="icon-star" x="0px" y="0px" viewBox="0 0 530.4 504.4" style="enable-background: new 0 0 530.4 504.4;">
                        <polygon points="265.2,401.5 101.3,504.4 148.5,316.8 0,192.7 193.1,179.6 265.2,0 337.3,179.6 530.4,192.7
	                381.9,316.8 429.1,504.4 " />
                    </symbol>
                    <symbol id="icon-verify-badge" x="0px" y="0px" viewBox="0 0 71.5 71.5" style="enable-background: new 0 0 71.5 71.5;">
                        <path class="st0" d="M35.7,0C16,0,0,16,0,35.7s16,35.7,35.7,35.7s35.7-16,35.7-35.7S55.5,0,35.7,0z M58,24.4L29.2,53.1 c-0.5,0.5-1.2,0.8-2,0.8s-1.5-0.3-2-0.8L13.5,41.4c-1.1-1.1-1.1-2.9,0-4c1.1-1.1,2.9-1.1,4,0l9.8,9.8L54,20.4c1.1-1.1,2.9-1.1,4,0
	                C59.1,21.5,59.1,23.3,58,24.4z" />
                    </symbol>
                </svg>
            </span>

            <main class="view product page__main section">
                <div id="main" class="view__anchor"></div>
                <div class="view__in section__in">
                    <div class="">
                        <div class="group product__group">
                            <div class="product__carousel bg">
                                <div class="slide product-carousel product__carousel">
                                    <div class="product-carousel__group product-carousel__group--nav">
                                        <nav class="slide__thumbnails product-carousel__thumbnails">
                                            <%
                                                for (var i = 0; i < imageCount; i++)
                                                {
                                                    var additionalAttributes = string.Empty;

                                                    if (hasVideo && allImages[i] == groupProductProperties.ThumbnailImage)
                                                    {
                                                        additionalAttributes = String.Format(@"
                                                        data-fancybox
                                                        data-type=""iframe""
                                                        data-src=""https://player.vimeo.com/video/{0}?title=0&byline=0&portrait=0""
                                                    ", groupProductProperties.VimeoId);
                                                    }

                                                    var thumbnail = String.Format(@"
                                                    <a
                                                        href=""#product-picture-{0}""
                                                        data-slide-index=""{0}""
                                                        {3}
                                                        class=""slide__thumbnail"">
                                                        <picture id=""product-thumb-{0}""
                                                            class=""contain contain--square""
                                                            data-src-img=""{1}/{2}"">
                                                        </picture>
                                                    </a>
                                                ", i, imageFolder, allImages[i], additionalAttributes);
                                            %>
                                            <%= thumbnail %>
                                            <%} %>
                                        </nav>
                                    </div>
                                    <div class="product-carousel__group product-carousel__group--into">
                                        <nav aria-label="Previous and next slides for product in-use shots" class="product-carousel__nav slide__nav">
                                            <button
                                                id="product-detail-slide-prev"
                                                aria-label="Select the previous slide"
                                                class="slide__prev"
                                                type="button">
                                                <svg class="icon icon--chevron">
                                                    <use href="#icon-chevron"></use></svg>
                                            </button>
                                            <button
                                                id="product-detail-slide-next"
                                                aria-label="Select the next slide"
                                                class="slide__next"
                                                type="button">
                                                <svg class="icon icon--chevron">
                                                    <use href="#icon-chevron"></use></svg>
                                            </button>
                                        </nav>
                                        <div id="product-carousel" class="slide__into product-carousel__into">
                                            <%
                                                for (var i = 0; i < imageCount; i++)
                                                {
                                                    var hasVideoAndThumb = hasVideo && allImages[i] == groupProductProperties.ThumbnailImage;
                                                    var slideAttributes = String.Format(@"id=""product-picture-{0}""", i);
                                                    var slideClasses = "slide__item product-carousel__item";
                                                    var slide = String.Format(@"
                                            <picture {0}
                                                class=""contain contain--square bg__picture {3}""
                                                data-src-img=""{1}/{2}"">
                                            </picture>
                                            ", (hasVideoAndThumb ? string.Empty : slideAttributes),
                                                        imageFolder,
                                                        allImages[i],
                                                        (hasVideoAndThumb ? string.Empty : slideClasses));

                                                    if (hasVideoAndThumb)
                                                    {
                                                        slide = String.Format(@"
                                                <a href=""#""
                                                    {3}
                                                    data-fancybox
                                                    data-type=""iframe""
                                                    data-src=""https://player.vimeo.com/video/{0}?title=0&byline=0&portrait=0""
                                                    class=""{1}"">{2}
                                                </a>
                                                ", groupProductProperties.VimeoId,
                                                            slideClasses,
                                                            slide,
                                                            slideAttributes);
                                                    }
                                            %>
                                            <%= slide %>
                                            <% } %>
                                        </div>
                                    </div>
                                </div>
                            </div>
                            <div class="product__form">
                                <form>
                                    <div class="product__copy">
                                        <h2><%=groupProductInfo.ProductName %></h2>
                                        <span class="product__price"><%=price%></span>

                                    </div>

                                    <div class="section__block product__contain">
                                        <fieldset class="form__fieldset product__bold">
                                            <% if (productCodes.Count() > 1)
                                                { %>
                                            <div class="product__copy">
                                                <div><%=groupProductProperties.SelectLabel%></div>
                                                <div class="form form--icon-field-combobox form--select">
                                                    <div class="form__contain">


                                                        <%
                                                            var colorObject = new List<string>() { };
                                                            var sizeObject = new List<string>() { };
                                                            if (isGDX)
                                                            {%>
                                                        <select class="form__field" id="<%=item %>_option1" data-initial-option="<%=groupProductProperties.SelectLabel %>">
                                                            <%

                                                                var groupProperties = DtmContext.CampaignProducts.Where(x => x.ProductCode == item).Select(y => new { Color = y.PropertyIndexer["Color"], Size = y.PropertyIndexer["Size"] }).FirstOrDefault();

                                                                colorObject = groupProperties.Color.Split(',').ToList();
                                                                sizeObject = groupProperties.Size.Split(',').ToList();
                                                                foreach (var color in colorObject)
                                                                {
                                                                    var colorText = color.Split(':')[0];
                                                                    var colorValue = color.Split(':')[1];

                                                            %>
                                                            <option value="<%=colorValue %>"><%=colorText%></option>



                                                            <%}%>
                                                        </select>

                                                        <%
                                                            }
                                                            else
                                                            { %>
                                                        <select class="form__field" data-dropdown-group="<%=groupProductProperties.DropdownGroup %>">
                                                            <option value="">Select</option>
                                                            <% foreach (var productCode in productCodes)
                                                                {
                                                                    var singleProduct = DtmContext.CampaignProducts
                                                                        .Where(cp => cp.ProductCode == productCode && !string.IsNullOrWhiteSpace(cp.PropertyIndexer["Size"]));

                                                                    if (singleProduct.Any())
                                                                    {
                                                                        var singleProductProperties = singleProduct.Select(cp => new { SizeText = cp.PropertyIndexer["Size"], IsStageOnly = cp.PropertyIndexer["IsStageOnly", false] }).FirstOrDefault();

                                                                        if ((DtmContext.IsStage) || (!singleProductProperties.IsStageOnly && !DtmContext.IsStage))
                                                                        {%>
                                                            <option value="<%=productCode %>"><%=singleProductProperties.SizeText%></option>
                                                            <%}
                                                                    }
                                                                }
                                                            %>
                                                        </select>
                                                        <%
                                                            }%>

                                                        <span class="form__field form__button">
                                                            <svg class="icon icon--combobox">
                                                                <use href="#icon-chevron"></use></svg>
                                                        </span>
                                                    </div>
                                                </div>
                                            </div>
                                            <%
                                                if (isGDX)
                                                {%>
                                            <div class="product__copy">
                                                <div><%=groupProductProperties.SecondSelectLabel%></div>
                                                <div class="form form--icon-field-combobox form--select">
                                                    <div class="form__contain">
                                                        <select class="form__field" id="<%=item %>_option2" data-secondary-option="<%=groupProductProperties.SecondSelectLabel %>">

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
                                            <%}

                                                }
                                                else
                                                {%>
                                            <input type="hidden" data-dropdown-group="<%=groupProductProperties.DropdownGroup %>" value="<%=productCodes[0]%>" />
                                            <%} %>


                                            <div class="product__copy">
                                                <div>Quantity</div>
                                                <div class="form form--icon-field-combobox">
                                                    <div class="form__contain">
                                                        <button type="button" class="form__field form__button" data-quantity-id="<%=groupProductProperties.DropdownGroup %>_Qty" data-exp="min" onclick="event.preventDefault();updateButtonQuantity(this);">
                                                            <svg class="icon">
                                                                <use href="#icon-minus"></use></svg>
                                                        </button>
                                                        <input class="form__field form__input" type="number" min="1" max="2" placeholder="1" value="1" id="<%=groupProductProperties.DropdownGroup %>_Qty" name="<%=groupProductProperties.DropdownGroup %>_Qty" data-max="2" onchange="validateInput(this);" />
                                                        <button type="button" class="form__field form__button" data-quantity-id="<%=groupProductProperties.DropdownGroup %>_Qty" data-exp="add" onclick="event.preventDefault();updateButtonQuantity(this);">
                                                            <svg class="icon">
                                                                <use href="#icon-plus"></use></svg>
                                                        </button>
                                                    </div>
                                                </div>
                                            </div>
                                        </fieldset>
                                    </div>

                                    <div class="product__tables">
                                        <%
                                            var headerName1 = groupProductProperties.HeaderName1;
                                            var headerName2 = groupProductProperties.HeaderName2;
                                            var headerName3 = groupProductProperties.HeaderName3;
                                            var headerName4 = groupProductProperties.HeaderName4;
                                            var headerName5 = groupProductProperties.HeaderName5;
                                            var headerName6 = groupProductProperties.HeaderName6;
                                            var tableValues = groupProductProperties.TableValues;

                                            if (!string.IsNullOrWhiteSpace(headerName1))
                                            {

                                                var tableList = tableValues.Split(new string[] { "||" }, StringSplitOptions.None).ToList();
                                                var headerArray = new string[] { headerName1, headerName2, headerName3, headerName4, headerName5, headerName6 };

                                        %>
                                        <div class="chart product__contain product__copy">
                                            <table class="product__bold">
                                                <thead>
                                                    <tr>
                                                        <th scope="col"><%= headerName1 %></th>
                                                        <%if (!string.IsNullOrWhiteSpace(headerName2))
                                                            { %>
                                                        <th scope="col"><%= headerName2 %></th>
                                                        <%} %>
                                                        <%if (!string.IsNullOrWhiteSpace(headerName3))
                                                            { %>
                                                        <th scope="col"><%= headerName3 %></th>

                                                        <%} %>
                                                        <%if (!string.IsNullOrWhiteSpace(headerName4))
                                                            { %>
                                                        <th scope="col"><%= headerName4 %></th>

                                                        <%} %>
                                                        <%if (!string.IsNullOrWhiteSpace(headerName5))
                                                            { %>
                                                        <th scope="col"><%= headerName5 %></th>

                                                        <%} %>
                                                        <%if (!string.IsNullOrWhiteSpace(headerName6))
                                                            { %>
                                                        <th scope="col"><%= headerName6 %></th>

                                                        <%} %>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%foreach (var value in tableList)
                                                        {%>
                                                    <tr>
                                                        <%
                                                            var finalValueList = value.Split(new string[] { "," }, StringSplitOptions.None);
                                                            for (int i = 0; i < finalValueList.Length; i++)
                                                            {%>
                                                        <td data-header="<%= headerArray[i] %>"><%=finalValueList[i] %></td>
                                                        <%}
                                                        %>
                                                    </tr>
                                                    <%} %>
                                                </tbody>
                                            </table>
                                            <%
                                                var tableInfoContent1 = groupProductProperties.TableInfoContent1;

                                                if (!string.IsNullOrEmpty(tableInfoContent1))
                                                {
                                                    var stringResult = tableInfoContent1;
                                                    var containsTableContentToken = tableInfoContent1.Contains("[#TableInfoContent#]");
                                                    if (containsTableContentToken)
                                                    {
                                                        var tableContentViewData = new ViewDataDictionary { 
                                                            { "ProductCode", item },
                                                            { "TableNumber", 1 }
                                                        };

                                                        stringResult = Html.Partial("TableInfoContent", tableContentViewData).ToString();
                                                    }
                                                    %>
                                                    <div><%= stringResult %></div>
                                                    <%
                                                }
                                            %>
                                        </div>
                                        <%}
                                            if (groupProductProperties.HasSecondTable)
                                            {
                                                var secondTableProperties = DtmContext.CampaignProducts
                                                    .Where(cp => cp.ProductCode == item && !string.IsNullOrWhiteSpace(cp.PropertyIndexer["DropdownGroup"]))
                                                    .Select(cp => new
                                                    {
                                                        HeaderName1 = cp.PropertyIndexer["Table2HeaderName1"] ?? string.Empty,
                                                        HeaderName2 = cp.PropertyIndexer["Table2HeaderName2"] ?? string.Empty,
                                                        HeaderName3 = cp.PropertyIndexer["Table2HeaderName3"] ?? string.Empty,
                                                        TableValues = cp.PropertyIndexer["Table2Values"] ?? string.Empty,
                                                        HasSecondTable = cp.PropertyIndexer["Table2HeaderName1"]
                                                    }).FirstOrDefault();
                                                var table2List = secondTableProperties.TableValues.Split(new string[] { "||" }, StringSplitOptions.None).ToList();
                                                var table2HeaderArray = new string[] { secondTableProperties.HeaderName1, secondTableProperties.HeaderName2, secondTableProperties.HeaderName3 };
                                        %>
                                        <div class="chart product__copy product__contain">
                                            <table class="product__bold">
                                                <thead>
                                                    <tr>
                                                        <th scope="col"><%= secondTableProperties.HeaderName1 %></th>
                                                        <%if (!string.IsNullOrWhiteSpace(secondTableProperties.HeaderName2))
                                                            { %>
                                                        <th scope="col"><%= secondTableProperties.HeaderName2 %></th>
                                                        <%} %>
                                                        <%if (!string.IsNullOrWhiteSpace(secondTableProperties.HeaderName3))
                                                            { %>
                                                        <th scope="col"><%= secondTableProperties.HeaderName3 %></th>

                                                        <%} %>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <%foreach (var value in table2List)
                                                        {%>
                                                    <tr>
                                                        <%
                                                            var finalValueList = value.Split(new string[] { "," }, StringSplitOptions.None);
                                                            for (int i = 0; i < finalValueList.Length; i++)
                                                            {%>
                                                        <td data-header="<%= table2HeaderArray[i] %>"><%=finalValueList[i] %></td>
                                                        <%}
                                                        %>
                                                    </tr>
                                                    <%} %>
                                                </tbody>
                                            </table>
                                            <%
                                                var tableInfoContent2 = groupProductProperties.TableInfoContent2;

                                                if (!string.IsNullOrEmpty(tableInfoContent2))
                                                {
                                                    var stringResult = tableInfoContent2;
                                                    var containsTableContentToken = tableInfoContent2.Contains("[#TableInfoContent#]");
                                                    if (containsTableContentToken)
                                                    {
                                                        var tableContentViewData = new ViewDataDictionary { 
                                                            { "ProductCode", item },
                                                            { "TableNumber", 2 }
                                                        };

                                                        stringResult = Html.Partial("TableInfoContent", tableContentViewData).ToString();
                                                    }
                                                    %>
                                                    <div><%= stringResult %></div>
                                                    <%
                                                }
                                            %>
                                        </div>
                                        <%} %>
                                    </div>

                                    <%if (!string.IsNullOrWhiteSpace(groupProductProperties.TableDisclaimer))
                                        { %>
                                    <p class="product__disclaimer"><%=groupProductProperties.TableDisclaimer %></p>
                                    <%} %>

                                    <div class="vse_<%=groupProductProperties.DropdownGroup %>">
                                    </div>
                                    <div class="section__block">
                                        <div class="product__copy">

                                            <%if (isGDX)
                                                { %>

                                            <a href="javascript:void(0);" class="button cart-button" name="<%=item%>_add" onclick="addGDX('<%=item%>',event);">Add To Cart</a>

                                            <%}
                                                else
                                                {%>
                                            <a href="javascript:void(0);" class="button cart-button" name="<%=groupProductProperties.DropdownGroup %>" data-products="<%=productsString%>" onclick="updateProductQuantity(this);">Add To Cart</a>
                                            <%} %>
                                            <p><%=groupProductInfo.ProductDescription %></p>
                                        </div>
                                    </div>

                                    <ul class="dropdown section__block">
                                        <%=upsellInfo.ProductFeatures %>
                                    </ul>
                                </form>
                            </div>
                        </div>
                    </div>
                </div>
            </main>

            <%= upsellInfo.AdvancedProductFeatures %>

            <% if (!item.StartsWith("GDX_"))
                { %>
            <%= Html.Partial("Section-Icon-Caption", new ViewDataDictionary { { "type", "advantage" } }) %>

            <section aria-labelledby="related-products-title" class="view section">
                <div id="related-products" class="view__anchor"></div>
                <div class="view__in section__in"></div>
                <div class="section__block title">
                    <div class="stars">
                        <svg class="icon icon--star">
                            <use href="#icon-star"></use></svg>
                        <svg class="icon icon--star">
                            <use href="#icon-star"></use></svg>
                        <svg class="icon icon--star">
                            <use href="#icon-star"></use></svg>
                        <svg class="icon icon--star">
                            <use href="#icon-star"></use></svg>
                        <svg class="icon icon--star">
                            <use href="#icon-star"></use></svg>
                    </div>
                    <h2 id="related-products-title" class="title__text">Real Customer Stories</h2>
                </div>

                <div class="section__block">
                    <div class="card card--carousel">
                        <div id="review-slide" class="card__into">
                            <div class="card__slide card card--review">
                                <div class="card__group">
                                    <blockquote class="card__item">
                                        <div class="card__meta">
                                            <picture class="contain contain contain--cf" data-src-img="/images/logos/copper-fit.svg">
                                </picture>
                                            <svg class="icon card__badge">
                                                <use href="#icon-verify-badge"></use></svg>
                                        </div>
                                        <div class="card__meta">
                                            <div class="card__title">Kevin C.<!--Caliber-->(FMR) Lance Corporal, US Marine Corps <span>Entertainer</span></div>
                                            <div class="card__break stars">
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                            </div>
                                        </div>
                                        <div class="card__meta">
                                            <div class="card__break card__copy">
                                                <p>"It doesn't matter if you're hurt or not, you got to get through the aches and the pains and something like compression can be the difference. There's no reason why not to give it a try. It's revolutionary."</p>
                                            </div>
                                        </div>
                                    </blockquote>
                                    <blockquote class="card__item">
                                        <div class="card__meta">
                                            <picture class="contain contain contain--cf" data-src-img="/images/logos/copper-fit.svg">
                                </picture>
                                            <svg class="icon card__badge">
                                                <use href="#icon-verify-badge"></use></svg>
                                        </div>
                                        <div class="card__meta">
                                            <div class="card__title">Arlyn D.<!--Delapena-->(FMR) Capt, US Army <span>Registered Nurse</span></div>
                                            <div class="card__break stars">
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                            </div>
                                        </div>
                                        <div class="card__meta">
                                            <div class="card__break card__copy">
                                                <p>"If <%= productName %> can help you reach your next goal, why not? Because it's here to help you and it will. It's remarkable!"</p>
                                            </div>
                                        </div>
                                    </blockquote>
                                    <blockquote class="card__item">
                                        <div class="card__meta">
                                            <picture class="contain contain contain--cf" data-src-img="/images/logos/copper-fit.svg">
                                </picture>
                                            <svg class="icon card__badge">
                                                <use href="#icon-verify-badge"></use></svg>
                                        </div>
                                        <div class="card__meta">
                                            <div class="card__title">Bud G.<!--Gallaway--><span>Moving Company</span></div>
                                            <div class="card__break stars">
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                            </div>
                                        </div>
                                        <div class="card__meta">
                                            <div class="card__break card__copy">
                                                <p>"I don't work without it. I rely on it. I'm wearing <%= productName %> knee sleeves because it works for me and I need that."</p>
                                            </div>
                                        </div>
                                    </blockquote>
                                    <blockquote class="card__item">
                                        <div class="card__meta">
                                            <picture class="contain contain contain--cf" data-src-img="/images/logos/copper-fit.svg">
                                </picture>
                                            <svg class="icon card__badge">
                                                <use href="#icon-verify-badge"></use></svg>
                                        </div>
                                        <div class="card__meta">
                                            <div class="card__title">Samantha S.<!--Sage--><span>Marketing</span></div>
                                            <div class="card__break stars">
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                                <svg class="icon icon--star">
                                                    <use href="#icon-star"></use></svg>
                                            </div>
                                        </div>
                                        <div class="card__meta">
                                            <div class="card__break card__copy">
                                                <p>"The more I move it feels better and better. I haven't experienced anything like this."</p>
                                            </div>
                                        </div>
                                    </blockquote>
                                </div>
                            </div>
                        </div>
                    </div>
            </section>
            <% } %>

            <% Html.RenderPartial("RelatedProducts", Model, new ViewDataDictionary(this.ViewData) { { "RelatedProductCodes", groupProductProperties.RelatedProductCodes } }); %>
        </div>
    </div>

    <%
                }
                else
                {
                    Response.Redirect("/" + DtmContext.OfferCode + "/" + DtmContext.Version + "/Index.dtm");
                }
            }
        }
    %>
</asp:Content>
