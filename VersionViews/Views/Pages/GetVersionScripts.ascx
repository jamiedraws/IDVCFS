<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>

<%
    var isShoppingCartPage = string.Equals(DtmContext.PageCode, "shoppingcart", StringComparison.InvariantCultureIgnoreCase);
    var isProductCollectionPage = string.Equals(DtmContext.PageCode, "productcollection", StringComparison.InvariantCultureIgnoreCase);
    var isProductDetailPage = string.Equals(DtmContext.PageCode, "productdetailpage", StringComparison.InvariantCultureIgnoreCase);
    var isSearchResultPage = string.Equals(DtmContext.PageCode, "searchresults", StringComparison.InvariantCultureIgnoreCase);
    var isCheckoutPage = string.Equals(DtmContext.PageCode, "checkout", StringComparison.InvariantCultureIgnoreCase) || string.Equals(DtmContext.PageCode, "processpayment", StringComparison.InvariantCultureIgnoreCase);
    var modalText = isCheckoutPage ? "Processing" : "Loading";
    var landingPages = new string[] { "Index", "FAQ", "Benefits", "Explore", "Article", "Story" };
%>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script>
<script>window.jQuery || document.write('<script src=\"\/shared\/js\/jquery-3.3.1.min.js\"><\/script>')</script>

<% if (!landingPages.Contains(DtmContext.PageCode)) { %>
    <script type="text/javascript" src="/shared/js/common.js"></script>
<% } %>
<% if (isShoppingCartPage) {%><script defer type="text/javascript" src="/js/shoppingcart.js"></script><% } %>
<% if (isProductDetailPage || isSearchResultPage || isProductCollectionPage) {%><script defer type="text/javascript" src="/js/productdetail.js"></script><% } %>

<span id="form-response" class="toast toast--alert toast--hidden toast--polite">
    <span class="toast__stage toast" aria-live="polite" aria-labelledby="form-response-title" aria-modal="true">
        <span class="toast__text toast__group toast">
            <p id="form-response-title"></p>
            <button id="form-response-dismiss" class="toast__close"></button>
        </span>
    </span>
</span>

<div class="modal" role="dialog" aria-labelledby="modal-text">
    <div class="modal__load-state"></div>
    <div id="modal-text" class="modal__text"><%=modalText %></div>
    <%if (!isCheckoutPage)
        {           
         %>
            <button type="button" class="modal__button button">Close</button>
       <%}%>
</div>
 <%if (isCheckoutPage)
    { %>
<script src="//cdnjs.cloudflare.com/ajax/libs/jquery-scrollTo/2.1.2/jquery.scrollTo.min.js"></script>
  <%}%>
<script>
    <%
    if (isCheckoutPage)
    {
     %>
    $(window).on("load", function () {
        refreshTableValues();
        getPromoCodeInfo();
    });

    if (!$('#ShippingIsDifferentThanBilling').is(':checked')) { $('#shippingInformation').hide(); }

    registerEvent("CartChange", function () {

        // get validation message container
        var $promo = $('.promo-message');
        var $promoInput = $('#promoCode');

        // if user hasn't interacted with promo field yet
        if (event.detail.promoCode === null || event.detail.promoCode === "") {
            $promo.hide();
            return;
        }

        // if valid promo, target will pass as string
        if (typeof (event.detail.promoCodeTarget) === 'string') {
            $promoInput.removeClass('message__is-invalid');
            $promoInput.addClass('message__is-valid');
            $promo.show();
            // if invalid promo, target will pass as object
        }else if (event.detail.promoCode.toUpperCase().startsWith('CFS')) {
            var cartItems = $.grep(event.detail.items, function (element, index) { return element.id !== 'SH4' && element.id !== 'ADDSHIP'});
            var itemsLength = cartItems.length;
            if (itemsLength > 1) {
                $promoInput.removeClass('message__is-invalid');
                $promoInput.addClass('message__is-valid');
                $promo.show();
            } else {
                $promoInput.removeClass('message__is-valid');
                $promoInput.addClass('message__is-invalid');
                $('.message__invalid').html('Please add 2 items to your cart to use promo code ' + event.detail.promoCode);
                $promoInput.val(event.detail.promoCode);
                $promo.show();

            }
            // if invalid promo, target will pass as object
        } else {
            $promoInput.removeClass('message__is-valid');
            $promoInput.addClass('message__is-invalid'); 
            $('.message__invalid').html('Please enter a valid promo code.');
            $promoInput.val('');
            $promo.show();
        }

        refreshTableValues();
        getPromoCodeInfo();
    });

    $(".ddlPromoButton").on("click", function () {
        getPromoCodeInfo();
    });

    function getPromoCodeInfo() {
        let promoCodeInfo = {};
        $("td[data-cart-code*=Price]").each(function (index, value) {
            let priceText = $(value).text();
            if (priceText.indexOf("-") > -1) {
                let description = "";
                let price = priceText;
                let shipping = "";

                $.each($(value).parent().children(), function (i, v) {
                    if ($(v).attr("data-eflex--category-label") === "Item") {
                        description = encodeURI($(v).text());
                    }
                    if (typeof $(v).attr("data-cart-code") !== "undefined" && $(v).attr("data-cart-code").indexOf("Shipping") > -1) {
                        shipping = $(v).text();
                    }
                });

                promoCodeInfo = { description: description, price: price, shipping: shipping };
            }
        });
        if (Object.keys(promoCodeInfo).length !== 0) {
            $("#promoCodeItem").remove();
            addPromoCodeLineItem(promoCodeInfo);
        }
    }

    function addPromoCodeLineItem(promoCodeInfo) {
        let html = "<div class=\"cart cart--micro bg\" id=\"promoCodeItem\"><div class=\"cart__group\"><div class=\"cart__picture\"><span class=\"cart__burst burst\">1</span></div><div class=\"cart__product-price\"><div class=\"cart__product\"><h3>" + decodeURI(promoCodeInfo.description) + "</h3></div><div class=\"cart__price\"><p><strong>Price:</strong>" + promoCodeInfo.price + "</p></div></div></div></div>";
        $(html).insertBefore("#lastItem");
    }

    function refreshTableValues() {
        $("#checkout_subTotal").text($("label.subtotal").text());
        $("#checkout_shipping").text($("label.phtotal").text());
        $("#checkout_tax").text($("span.taxtotal").text());
        $("#checkout_orderTotal").text($("span.summary-total").text());
    }

    $(document).ready(function () {
        $("#ShippingIsDifferentThanBilling").on("click", toggleShippingContainer);
    });

    function toggleShippingContainer() {
        $(".shipping__required").each(function (index, value) {
            if ($("#ShippingIsDifferentThanBilling").is(":checked")) {
                $(value).prop("required", true);
            }
            else {
                $(value).prop("required", false);
            }
        });
    }
    <%}
    if (DtmContext.PageCode.ToUpper() == "PRODUCTDETAILPAGE")
    {
        var selectedProductCodes = DtmContext.ShoppingCart.Select(sc => sc.ProductCode).ToList();
        var groupProducts = DtmContext.CampaignProducts
            .Where(cp => selectedProductCodes.Contains(cp.ProductCode) && !string.IsNullOrWhiteSpace(cp.PropertyIndexer["DropdownGroup"]))
            .Select(cp => new { ProductCode = cp.ProductCode, DropdownGroup = cp.PropertyIndexer["DropdownGroup"] })
            .ToList();
    %>
    function customLoadItemState(productCode, qty) {
        switch (productCode) {
            <% foreach (var groupProduct in groupProducts)
    {%>
            case "<%=groupProduct.ProductCode%>":
                $("select[data-dropdown-group=<%=groupProduct.DropdownGroup%>]").val("<%=groupProduct.ProductCode%>");
                $("#<%=groupProduct.DropdownGroup%>_Qty").val(qty);
                break;
            <%}%>
        }
    }
   <%}%>

    function registerEvent(evType, fn, element, useCapture) {
        var elm = element || window;
        if (elm.addEventListener) {
            elm.addEventListener(evType, fn, useCapture || false);
        }
        else if (elm.attachEvent) {
            var r = elm.attachEvent(evType, fn);
        }
        else {
            elm[evType] = fn;
        }
    }
    //Subscribe Email Function
    function saveEmailOptIn(e) {
        let emailElement = document.getElementById("discountEmail");

        let subscribeMessageElement = document.getElementById("subscribeMessage");
        let subscribeMessage = "Processing...";
        if (emailElement) {
            let email = emailElement.value;
            if (email === "") {
                subscribeMessageElement.innerHTML = "Invalid Email Address";
                return false;
            }
            else {
                let reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;

                if (reg.test(email) === false) {
                    subscribeMessageElement.innerHTML = "Invalid Email Address";
                    return false;
                }
            }
            subscribeMessageElement.innerHTML = subscribeMessage;
            let request = new XMLHttpRequest();
            request.open("GET", "/Cart/Subscribe/<%=DtmContext.PageCode%>?email=" + email);
            request.dataType = "json";
            request.async = false;
            request.onload = function (data) {
                if (request.status === 200) {
                    subscribeMessageElement.innerHTML = "Your email has been submitted!";
                    subscribeMessageElement.classList.add("success");
                }
                else {
                    subscribeMessageElement.classList.add("error");
                    subscribeMessageElement.innerHTML = "Unable to process request at this time, please try again.";
                }
                subscribeMessageElement.value = "";
                setTimeout(function () {
                    subscribeMessageElement.value = "";
                    subscribeMessageElement.innerHTML = "";
                    subscribeMessageElement.style.display = "none";
                    emailElement.value = "";
                }, 8000);
            };
            request.onerror = function () {
                subscribeMessageElement.innerHTML = "Unable to process request at this time, please try again.";
                setTimeout(function () {
                    subscribeMessageElement.classList.remove(["error", "success"]);
                    subscribeMessageElement.value = "";
                    subscribeMessageElement.style.display = "none";
                    emailElement.value = "";
                }, 8000);
            };
            request.send();
        }


        return true;
    }
</script>
<div class="l-controls left-absolute top-absolute @print-only-hide">
    <% Html.RenderSiteControls(SiteControlLocation.ContentTop); %>
    <% Html.RenderSiteControls(SiteControlLocation.ContentBottom); %>
    <% Html.RenderSiteControls(SiteControlLocation.PageBottom); %>
    <style>
        .hud {
            display: none;
        }
    </style>
</div>
