<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" %>

<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="Dtm.Framework.Base.Models" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%
        var products = TempData["Products"] as List<Dtm.Framework.Base.Models.CampaignProductView>;
        var navQuery = Request["n"] ?? string.Empty;
        var query = Request["query"] ?? string.Empty;
        var isNavSearch = navQuery != string.Empty && navQuery == "1";
        if (products == null)
        {

            var finalList = new List<CampaignProductView>();
            var allSearchableProducts = DtmContext.CampaignProducts
                .Where(cp =>
                   cp.PropertyIndexer.Has("Products") 
                   && cp.CategoryIndexer.Has("SEARCH") || (cp.CategoryIndexer.Has("STAGE-SEARCH") && DtmContext.IsStage))
                .ToList();

            if (query.ToLower() == "all")
            {
                finalList.AddRange(allSearchableProducts);
            }
            else
            {
                var regexMatchList = !isNavSearch ? DtmContext.CampaignProducts.Where(cp =>
                    Regex.IsMatch(cp.ProductName ?? string.Empty, query, RegexOptions.IgnoreCase)
                    || Regex.IsMatch(cp.DisplayText ?? string.Empty, query, RegexOptions.IgnoreCase)
                    || Regex.IsMatch(cp.MetaKeywords ?? string.Empty, query, RegexOptions.IgnoreCase)
                    || Regex.IsMatch(cp.ShortName ?? string.Empty, query, RegexOptions.IgnoreCase)).ToList() : 

                    DtmContext.CampaignProducts.Where(cp =>
                    Regex.IsMatch(cp.ProductName ?? string.Empty, query, RegexOptions.IgnoreCase)
                    || Regex.IsMatch(cp.MetaKeywords ?? string.Empty, query, RegexOptions.IgnoreCase)).ToList();

                var filteredList = regexMatchList.Where(p => (p.ProductType != "Option" && p.ProductType != "Shipping" && p.ProductType != "None")).ToList();

                foreach (var item in filteredList)
                {
                    var groupedItemList = allSearchableProducts.Where(cp => cp.PropertyIndexer["Products"].Contains(item.ProductCode) || cp.ProductCode == item.ProductCode);

                    foreach (var groupedItem in groupedItemList)
                    {
                        if (!finalList.Any(x => x.ProductCode == groupedItem.ProductCode))
                        {
                            finalList.Add(groupedItem);

                        }
                    }
                }
            }
            products = finalList;
            TempData["CriteoProducts"] = finalList;
        }
        //var productFolder = "images/products/";

        var hasProducts = products != null;
        var hasNoProducts = !hasProducts;
        var hasResults = hasProducts && products.Any();
        var hasNoResults = !hasResults;
    %>
    <main aria-labelledby="search-results-title" class="defer defer--from-top view section">
        <div id="search-results" class="view__anchor"></div>
        <div class="defer__progress view__in section__in">
            <div class="section__block title">
                <picture class="title__picture contain contain--logo" data-src-img="/images/logos/swoosh.svg">

            </picture>
                <h2 id="search-results-title" class="title__text">Shop Copper Fit
                </h2>
                <p>
                    <% if (hasResults)
                        { %>
                Showing results for "<%= query %>".
            <% }
                else
                { %>
                No search results found for "<%=query %>". Please check your spelling and try again.
            <% } %>
                </p>
            </div>

            <% if (hasProducts)
                {
                    var itemId = "search-result";
                    products = products.OrderBy(p => p.DisplayRank).ToList();
            %>
            <form class="form">
                <div class="section__block story-card story-card--max-four story-card--carousel slide">
                    <nav aria-label="Previous and next slides for product results" class="story-card__nav slide__nav">
                        <button
                            id="search-results-slide-prev"
                            aria-label="Select the previous slide"
                            class="slide__prev"
                            type="button">
                            <svg class="icon icon--chevron">
                                <use href="#icon-chevron"></use>
                            </svg>
                        </button>
                        <button
                            id="search-results-slide-next"
                            aria-label="Select the next slide"
                            class="slide__next"
                            type="button">
                            <svg class="icon icon--chevron">
                                <use href="#icon-chevron"></use>
                            </svg>
                        </button>
                    </nav>
                    <div id="search-results-group" class="story-card__group bg story-card__into slide__into">
                        <% foreach (var p in products)
                            {
                                var isGroup = p.ProductCode.StartsWith("GDQ");
                                var isGDX = p.ProductCode.StartsWith("GDX");
                        %>
                        <% if (isGroup)
                                {
                                    var elementId = string.Format("{0}-{1}",
                                        itemId,
                                        products.IndexOf(p));
                                    Html.RenderPartial("GroupDropdown", p,
                                        new ViewDataDictionary { { "elementId", elementId } });
                                }
                           if (isGDX)
                                {
                                    var elementId = string.Format("{0}-{1}",
                                        itemId,
                                        products.IndexOf(p));
                                    Html.RenderPartial("GDX_Dropdown", p,
                                        new ViewDataDictionary { { "elementId", elementId } });
                                }
                            }
                        %>
                    </div>
                    <nav aria-label="View product results" class="story-card__thumbnails slide__thumbnails">
                        <% 
                            foreach (var p in products)
                            {
                                var index = products.IndexOf(p);
                                var elementId = string.Format("#{0}-{1}", itemId, index);
                        %>
                        <a href="<%= elementId %>" class="slide__dot slide__thumbnail" data-slide-index="<%= index %>" aria-label="Learn more about <%= p.ProductName %>"></a>
                        <%
                            }
                        %>
                    </nav>
                </div>
            </form>
            <% } %>
        </div>
    </main>

    <div style="display: none;">
        <%Html.RenderPartial("OrderFormReviewTable"); %>
    </div>

</asp:Content>
