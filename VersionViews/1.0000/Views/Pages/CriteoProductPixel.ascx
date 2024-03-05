<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl" %>
<%
    string itemId = (string)ViewData["itemId"];
    string price = (string)ViewData["price"];
    string midCsv = (string)ViewData["midCsv"];
    string accountId = (string)ViewData["accountId"] ?? "24869";
    string sendItemId = (string)ViewData["sendItemId"] ?? "true";
    string preConversion = (string)ViewData["isPreConversion"] ?? "false";
    string showViewItemOnly = (string)ViewData["showViewItemOnly"] ?? "false";

    var groupProductIdMap = new Dictionary<string, string>()
    {
        {"GDQ_FACEPRO","11782741" },
        {"GDQ_HANDPRO","11782742" },
        {"GDQ_ANGEL","11782736" },
        {"GDQ_PLUSSOCKS","11782740" },
        {"GDQ_PLUSSOCKS6","11782740" },
        {"GDQ_ICE","11782743" },
        {"GDQ_SLEEVES","11782738" },
        {"GDQ_GLOVES","11782737" },
        {"GDQ_BACKPRO","11782735" },
        {"GDQ_RAPIDRELIEF","11782744" },
        {"GDQ_LOSTMASK","11782739" },
        {"GDQ_LOSTMASK10","11782739" }

    };
    var productIdMap = new Dictionary<string, string>()
    {
        {"MASK2G,MASK6G","11782741" },
        {"GHANDSM,GHANDLXL","11782742" },
        {"ANGS,ANGK","11782736" },
        {"EPLUSM,EPLUSLXL","11782740" },
        {"EPLUSM6,EPLUSLXL6","11782740" },
        {"ICES,ICEL","11782743" },
        {"KM,KL,KXL,EM,EL","11782738" },
        {"GLOVS,GLOVL","11782737" },
        {"ABPSM,ABPLXL","11782735" },
        {"RRB","11782744" },
        {"NLMASK4","11782739" },
        {"NLMASK10","11782739" }

    };
    bool passItem = true;
    bool isPreConversion = false;
    bool treatAsUpsell = false;

    Boolean.TryParse(sendItemId, out passItem);
    Boolean.TryParse(preConversion, out isPreConversion);
    Boolean.TryParse(showViewItemOnly, out treatAsUpsell);

    if (String.IsNullOrWhiteSpace(itemId))
    {
        new SiteExceptionHandler("Pixel is missing Item ID parameter");
        return;
    }
    if (String.IsNullOrWhiteSpace(price))
    {
        new SiteExceptionHandler("Pixel is missing Price parameter");
        return;
    }
    if (String.IsNullOrWhiteSpace(midCsv))
    {
        new SiteExceptionHandler("Pixel is missing MID parameter");
        return;
    }

    if (String.IsNullOrWhiteSpace(accountId))
    {
        new SiteExceptionHandler("Pixel is missing Account ID parameter");
        return;
    }

    var isUpsell = DtmContext.Page.PageType.ToUpper() == "UPSELL" || treatAsUpsell;

    var conversionOrderStatus = new[] { 3 };
    var fireLanding = DtmContext.Page.IsStartPageType && !treatAsUpsell;
    var fireConversion = !DtmContext.Page.IsStartPageType
        && DtmContext.PageCode.ToUpper().Contains("CONFIRMATION")
        && conversionOrderStatus.Contains(DtmContext.Order.OrderStatusId);
    if (fireConversion)
    {
        const string conversionLabel = "CriteoConversion";
        var vsRepo = new Dtm.Framework.Models.Ecommerce.Repositories.VisitorSessionRepository();
        var conversionValue = vsRepo.GetVisitorSessionData(DtmContext.VisitorSessionId, conversionLabel);
        const string coversionExpectedValue = "1";
        var hasAlreadyConverted = conversionValue == coversionExpectedValue;
        if (hasAlreadyConverted)
        {
            fireConversion = false;
        }
        else
        {
            vsRepo.SaveVisitorSessionData(DtmContext.VisitorSessionId, conversionLabel, coversionExpectedValue);
        }
    }
    var products = TempData["Products"] as List<Dtm.Framework.Base.Models.CampaignProductView> ?? TempData["CriteoProducts"] as List<Dtm.Framework.Base.Models.CampaignProductView>;
    var isHomePage = DtmContext.Page.IsStartPageType && DtmContext.PageCode.ToUpper() == "INDEX";
    var isSearch = DtmContext.PageCode.ToUpper() == "SEARCHRESULTS" && products != null;
    var isProductPage = DtmContext.PageCode.ToUpper() == "PRODUCTDETAILPAGE";
    var isCartPage = (DtmContext.PageCode.ToUpper() == "CHECKOUT" || DtmContext.PageCode.ToUpper() == "SHOPPINGCART") && DtmContext.ShoppingCart.Any();
    var isVisit = (!isHomePage && !isSearch && !isProductPage && !isCartPage) && !fireConversion;

    var shoppingCart = DtmContext.ShoppingCart.Where(x => x.CampaignProduct.ProductTypeId != 6);

    if (isVisit)
    {
%>
<!-- Begin Impression -->
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js?a=82324" async="true"></script>
<script type="text/javascript">
    window.criteo_q = window.criteo_q || [];
    var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
    window.criteo_q.push(
        { event: "setAccount", account: <%= accountId %> },
        { event: "setSiteType", type: deviceType },
        { event: "viewPage" }

    );
</script>
<%}
    if (isHomePage)
    {
%>
<!-- Begin Impression -->
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js?a=82324" async="true"></script>
<script type="text/javascript">
    window.criteo_q = window.criteo_q || [];
    var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
    window.criteo_q.push(
        { event: "setAccount", account: <%= accountId %> },
        { event: "setSiteType", type: deviceType },
        {
            event: "viewList", item: ["11782741", "11782742", "11782736", "11782740", "11782739", "11782739",
                "11782743", "11782738", "11782737", "11782735", "11782744"]
         }

    );
</script>


<%
    }


    if (isSearch)
    {

        var productCodeArray = products.Select(p => p.ProductCode);
        var itemIdFinalList = new List<string>() { };
        foreach (var item in groupProductIdMap)
        {
            var productCodes = item.Key;
            var criteoId = item.Value;

            foreach (var product in productCodeArray)
            {
                if (productCodes == product)
                {
                    itemIdFinalList.Add(criteoId);
                }
            }
        }
        var finalSearchlist = itemIdFinalList.Distinct().Take(3);

%>
<!-- Begin Impression -->
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js?a=82324" async="true"></script>
<script type="text/javascript">
    window.criteo_q = window.criteo_q || [];
    var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
    window.criteo_q.push(
        { event: "setAccount", account: <%= accountId %> },
        { event: "setSiteType", type: deviceType },
        {
            event: "viewList", item: [
                <%foreach (var item in finalSearchlist )
    {%>
                "<%=item%>"
   <% 
    if (item != finalSearchlist.Last())
    {%>
                ,
        <%}
    }%>
            ]
        }
    );
</script>

<%}
    if (isProductPage)
    {
        var product = groupProductIdMap.Where(x => x.Key.Contains(Request.QueryString["item"] ?? string.Empty)).FirstOrDefault().Value ?? string.Empty;
%>
<!-- Begin Impression -->
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js?a=82324" async="true"></script>
<script type="text/javascript">
    window.criteo_q = window.criteo_q || [];
    var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
    window.criteo_q.push(
        { event: "setAccount", account: <%= accountId %> },
        { event: "setSiteType", type: deviceType },
        { event: "viewItem", item: "<%=product%>" }

    );
</script>
<!-- End Impression -->

<%}
    if (isCartPage)
    {
%>
<!-- Begin Impression -->
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js?a=82324" async="true"></script>
<script type="text/javascript">
    window.criteo_q = window.criteo_q || [];
    var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
    window.criteo_q.push(
        { event: "setAccount", account: <%= accountId %> },
        { event: "setSiteType", type: deviceType },
        {
            event: "viewBasket", item: [
                <%foreach (var item in shoppingCart)
    {
        var criteoFinalId = "";
        foreach (var product in productIdMap)
        {
            var productCodes = product.Key.Split(',').ToList();
            var criteoId = product.Value;

            if (productCodes.Contains(item.CampaignProduct.ProductCode))
            {
                criteoFinalId = criteoId;
            }

        }
    %>
                { id: "<%=criteoFinalId%>", price: <%=item.Price%>, quantity: <%=item.Quantity%> }
           <%     if (item != shoppingCart.Last())
    {%>
                ,
        <%}
    }%>


            ]
        }

    );
</script>
<!-- End Impression -->
<% }
    else if (fireConversion)
    {
%>
<!-- Begin Conversion -->
<script type="text/javascript" src="//static.criteo.net/js/ld/ld.js" async="true"></script>
<script type="text/javascript">
    window.criteo_q = window.criteo_q || [];
    var deviceType = /iPad/.test(navigator.userAgent) ? "t" : /Mobile|iP(hone|od)|Android|BlackBerry|IEMobile|Silk/.test(navigator.userAgent) ? "m" : "d";
    window.criteo_q.push(
        { event: "setAccount", account: <%= accountId %> },
        { event: "setSiteType", type: deviceType },
        {
            event: "trackTransaction", id: "<%= DtmContext.Order.OrderID%>",

            item: [

            <%foreach (var item in DtmContext.Order.ContextOrderItems.Where(x => x.CachedProductInfo.ProductTypeId != 6  && x.CachedProductInfo.ProductTypeId != 9).ToList())
    {
         var criteoFinalId = "";
        foreach (var product in productIdMap)
        {
            var productCodes = product.Key.Split(',').ToList();
            var criteoId = product.Value;

            if (productCodes.Contains(item.CampaignProduct.ProductCode))
            {
                criteoFinalId = criteoId;
            }

        }
        %>
            { id: "<%= criteoFinalId %>", price: "<%=item.Price %>", quantity: <%=item.Quantity%> }

             <%     if (item != DtmContext.Order.ContextOrderItems.Last())
    {%>
            ,
        <%}
    }%>



            ]
        }
    );
</script>
<!-- End Conversion -->
<%
    }%>