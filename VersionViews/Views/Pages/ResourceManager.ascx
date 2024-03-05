<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var v = 074;
    var url = "{0}?v={1}";

    var preload = ViewData["preload"] as bool? ?? false;
    var defer = ViewData["defer"] as bool? ?? false;

    var isPaymentPage = DtmContext.PageCode == "PaymentForm" || DtmContext.PageCode == "ProcessPayment";
    var isIndex = DtmContext.PageCode == "Index";
    var isSitemap = DtmContext.PageCode == "Sitemap";
    var isLandingPage = DtmContext.Page.IsStartPageType && !isPaymentPage && !isIndex && !isSitemap;
    var isProductDetailPage = DtmContext.PageCode.Equals("ProductDetailPage", StringComparison.InvariantCultureIgnoreCase);
    var isProductCollectionPage = DtmContext.PageCode.Equals("ProductCollection", StringComparison.InvariantCultureIgnoreCase);
    var isReviewPage = DtmContext.PageCode == "ReviewPage";
    var isUpsell = DtmContext.Page.PageType.Equals("Upsell", StringComparison.InvariantCultureIgnoreCase) || isReviewPage;
    var isConfirmation = DtmContext.Page.PageType == "Confirmation";
    var isProcessPayment = DtmContext.PageCode == "ProcessPayment";
    var isFAQ = DtmContext.PageCode == "FAQ";
    var isStory = DtmContext.PageCode.Equals("Story", StringComparison.InvariantCultureIgnoreCase);
    var isBenefits = DtmContext.PageCode.Equals("Benefits", StringComparison.InvariantCultureIgnoreCase);
    var isCheckout = DtmContext.PageCode.Equals("Checkout", StringComparison.InvariantCultureIgnoreCase);
    var isSearchResults = DtmContext.PageCode.Equals("SearchResults", StringComparison.InvariantCultureIgnoreCase);
    var isExplore = DtmContext.PageCode.Equals("Explore", StringComparison.InvariantCultureIgnoreCase);
    var isArticle = DtmContext.PageCode.Equals("Article", StringComparison.InvariantCultureIgnoreCase);

    var accountPages = new string[] { "Account", "Login", "StoreCustomerOrders", "StoreCustomerProfile", "ShoppingCart" };
    var isAccount = accountPages.Contains(DtmContext.PageCode);

    var pagesRequireFancybox = new string[] { "Checkout", "ProductDetailPage", "ProcessPayment" };
    var requireFancybox = pagesRequireFancybox.Contains(DtmContext.PageCode);

    var pagesRequireSlide = new string[] { "Index", "ProductDetailPage", "SearchResults", "Benefits", "Explore" };
    var requireSlide = pagesRequireSlide.Contains(DtmContext.PageCode);

    // inform browser to preload all critical resources ahead of schedule
    if (preload)
    {
        // preload critical stylesheets
        var styles = new List<string>
        {
            "/css/default/shell.css"
        };

        if (isIndex)
        {
            styles.Add("/css/default/index.crp.css");
        }

        if (isProductCollectionPage) {
            styles.Add("/css/default/product-collection-page.crp.css");
        }

        if (isProductDetailPage) {
            styles.Add("/css/default/product-detail-page.crp.css");
        }

        if (isStory) {
            styles.Add("/css/default/story.crp.css");
        }

        if (isExplore)
        {
            styles.Add("/css/default/explore.crp.css");
        }

        if (isFAQ)
        {
            styles.Add("/css/default/faq.crp.css");
        }

        if (isSitemap) {
            styles.Add("/css/default/sitemap.css");
        }

        foreach (var style in styles)
        {
            var resource = String.Format(url, style, v);
            %>
            <link rel="preload" href="<%= resource %>" as="style">
            <%
        }

        // preload critical fonts
        var fonts = new List<string>
        {
            "/fonts/orbitron-bold.woff2",
            "/fonts/orbitron-light.woff2",
            "https://use.typekit.net/af/4eabcf/00000000000000003b9b12fd/27/l?primer=388f68b35a7cbf1ee3543172445c23e26935269fadd3b392a13ac7b2903677eb&fvd=n4&v=3",
            "https://use.typekit.net/af/f3ba4f/00000000000000003b9b12fa/27/l?primer=388f68b35a7cbf1ee3543172445c23e26935269fadd3b392a13ac7b2903677eb&fvd=n7&v=3"
        };

        foreach (var font in fonts)
        {
            %>
            <link rel="preload" href="<%= font %>" as="font" type="font/woff2" crossorigin>
            <%
        }

        // preload critical scripts
        var scripts = new List<string>
        {

        };

        foreach (var script in scripts)
        {
            var resource = String.Format(url, script, v);
            %>
            <link rel="preload" href="<%= resource %>" as="script">
            <%
        }

        // preload critical images
        if (isIndex)
        {
            %>
                <link rel="preload" href="/images/section-bg-gray.jpg" as="image" type="image/jpeg" imagesrcset="/images/section-bg-gray-600.jpg 400w, /images/section-bg-gray.jpg 863w" imagesizes="(max-width: 600px) 30vw, 863px"/>
                <link rel="preload" href="/images/Home/Hero-1.jpg" as="image" imagesrcset="/images/Home/Hero-1-mv.jpg 400w, /images/Home/Hero-1.jpg 863w" imagesizes="(max-width: 600px) 30vw, 863px">
            <%
        }
    }

    // inform browser to request resources on document parse. dispatch as critical resources
    if (!preload && !defer)
    {
        // request critical stylesheets
        var styles = new List<string>
        {
            "/css/default/shell.css"
        };

        if (isIndex) {
            styles.Add("/css/default/index.crp.css");
        }

        if (isProductCollectionPage) {
            styles.Add("/css/default/product-collection-page.crp.css");
        }

        if (isProductDetailPage) {
            styles.Add("/css/default/product-detail-page.crp.css");
        }

        if (isStory) {
            styles.Add("/css/default/story.crp.css");
        }

        if (isBenefits) {
            styles.Add("/css/default/benefits.crp.css");
        }

        if (isExplore) {
            styles.Add("/css/default/explore.crp.css");
        }

        if (isFAQ) {
            styles.Add("/css/default/faq.crp.css");
        }

        if (isSitemap) {
            styles.Add("/css/default/sitemap.css");
        }

        if (isProcessPayment) {
            styles.Add("/css/default/process-payment.css");
        }

        foreach (var style in styles)
        {
            var resource = String.Format(url, style, v);
            %>
            <link rel="stylesheet" href="<%= resource %>">
            <%
                }


                // request critical scripts. inform browser to defer script execution to document parse completion
                var scripts = new List<string>
        {


        };


                foreach (var script in scripts)
                {
                    var resource = String.Format(url, script, v);
            %>
            <script src="<%= resource %>"></script>
            <%
        }
    }

    // inform browser to request resources on document parse. dispatch as deferred resources
    if (!preload && defer)
    {
        // request deferred stylesheets
        var styles = new List<string> {
            "https://use.typekit.net/kft7lqp.css"
        };

        if (isIndex) {
            styles.Add("/css/default/index.css");
        }

        if (isLandingPage) {
            styles.Add("/css/default/landing-page.css");
        }

        if (isConfirmation) {
            styles.Add("/css/default/confirmation.css");
        }

        if (isProductDetailPage) {
            styles.Add("/css/default/product-detail-page.css");
        }

        if (isSearchResults) {
            styles.Add("/css/default/search-results.css");
        }

        if (isStory) {
            styles.Add("/css/default/story.css");
        }

        if (isBenefits) {
            styles.Add("/css/default/benefits.css");
        }

        if (isExplore) {
            styles.Add("/css/default/explore.css");
        }

        if (isArticle) {
            styles.Add("/css/default/article.css");
        }

        if (isAccount) {
            styles.Add("/css/default/account.css");
        }

        if (isCheckout) {
            styles.Add("/css/default/checkout.css");
        }

        if (requireFancybox) {
            var lightboxStyles = SettingsManager.ContextSettings["FrameworkJS/CSS.DtmStyle.Lightbox.Stylesheet", string.Empty];

            if (!string.IsNullOrEmpty(lightboxStyles)) {
                styles.Add(lightboxStyles);
                styles.Add("/css/template/fancybox.css");
            }
        }

        foreach (var style in styles)
        {
            var resource = String.Format(url, style, v);
            %>
            <link rel="stylesheet" href="<%= resource %>" media="print" onload="this.media='all'; this.onload=null;">
            <noscript>
                <link rel="stylesheet" href="<%= resource %>">
            </noscript>
            <%
        }


        // request deferred scripts. inform browser to defer script execution to document parse completion
        var scripts = new List<string>
        {
            "/js/app.js",
            "/js/observer.js",
            "/js/lazy.js",
            "/js/page.js",
            "/js/nav.js",
            "/js/validation.js",
            "/Shared/js/ModalMaster/modal.js"
        };

        if (requireSlide) {
            scripts.Add("/js/slide/slide.js");
            scripts.Add("/js/slide/components/slide.a11y.js");
            scripts.Add("/js/slide/components/slide.thumbnails.js");
            scripts.Add("/js/carousel.js");
        }

        if (requireFancybox) {
            var lightboxScript = SettingsManager.ContextSettings["FrameworkJS/CSS.DtmStyle.Lightbox.Script", string.Empty];

            if (!string.IsNullOrEmpty(lightboxScript))
            {
                scripts.Add(lightboxScript);
                scripts.Add("/js/template/fancybox.js");
            }
        }

        if (isCheckout) {
            scripts.Add("/js/express-checkout.js");
            scripts.Add("/js/validateaddress.js");
        }

        foreach (var script in scripts)
        {
            var resource = String.Format(url, script, v);
            %>
            <script defer src="<%= resource %>"></script>
            <%
        }
    }
%>