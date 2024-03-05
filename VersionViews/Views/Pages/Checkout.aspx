<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%
        var shoppingCartItems = DtmContext.ShoppingCart.Items.Where(i => (i.Price >= 0 && i.Shipping == 0) || (i.Price > 0 && i.Shipping > 0)).ToList();
        var shippingItems = DtmContext.ShoppingCart.Items.Where(i => i.Shipping > 0 && i.Price == 0).ToList();
        var landingPageUrl = String.Format("/{0}/{1}/{2}{3}",
                        DtmContext.OfferCode,
                        DtmContext.Version,
                        "Index",
                        DtmContext.ApplicationExtension);
    %>

    <main aria-labelledby="checkout-title" class="defer defer--from-top view main section">

<div id="account" class="view__anchor"></div>

<div class="defer__progress view__in section__in">
    <div class="section__block checkout account account--checkout">
        <h1 id="checkout-title" class="checkout__banner">Checkout</h1>
        <form action="/<%=DtmContext.OfferCode %>/<%=DtmContext.Version %>/<%=DtmContext.PageCode %>.dtm" method="post">

            <% Html.RenderPartial("OrderFormReviewTable"); %>
            <div class="account__group">
                <div class="account__form form message account__copy">
                    <%
                        if (Model.CurrentCustomer == null || Model.CurrentCustomer.StoreCustomerID == Guid.Empty)
                        {
                    %>
                    <%-- Account Information --%>
                    <h2 class="account__header">Account Information</h2>
                    <p>Already have an account? <a href="/Account/Login" class="account__link">Login</a></p>
                    <%
                        }
                         %>


                    <div class="form__error">
                        <%= Html.ValidationSummary("The following errors have occurred:") %>
                    </div>

                    <%-- Payment Type --%>
                    <h2 class="account__header">Select Payment Type</h2>

                    <div id="cc" class="c-brand--form__field o-grid__col @xs-u-bs--reset @xs-u-vw--100 checkout-option ccImage"></div>
                    <div id="CardTypeCt" class="form__field-label">
                        <div class="form form--select">
                            <div class="form__contain">
                                <%= Html.DropDownList("CardType", new[]
                                            {
                                              new SelectListItem { Text = "Visa", Value = "V"},
                                              new SelectListItem { Text = "Mastercard", Value = "M"},
                                              new SelectListItem { Text = "Discover", Value = "D"},
                                              new SelectListItem { Text = "American Express", Value= "AX"}
						                  }, new { @class = "form__field" })
                                %>
                                <span class="form__field form__button">
                                    <svg class="icon icon--combobox">
                                        <use href="#icon-chevron"></use></svg>
                                </span>
                            </div>
                        </div>
                        <label class="message__group" aria-live="assertive">
                            <span class="message__label"><span class="form__error">* </span>Card Type</span>
                            <span class="message__invalid">Please choose a card type.</span>
                        </label>
                    </div>
                    <div id="CardNumberCt" class="form__field-label">
                        <input type="tel" name="CardNumber" id="CardNumber" placeholder="#### #### #### ####" class="form__field" data-required="true" data-validationtype="card" >
                        <div class="form__label message__group" aria-live="assertive">
                            <span class="message__label"><span class="form__error">* </span>Card Number</span>
                            <span class="message__invalid">Please enter a card number.</span>
                        </div>
                    </div>
                    <div id="CardExpirationCt" class="form__field-label">
                        <fieldset class="account__group form__fieldset">
                            <div class="form__field-label">
                                <div class="form form--select">
                                    <div class="form__contain">
                                        <%= Html.CardExpirationMonth("CardExpirationMonth", new { @id="CardExpirationMonth", @class = "form__field", @data_required="true", @data_validationtype="cardExp", @data_parent="CardExpirationCt" }) %>
                                        <span class="form__field form__button">
                                            <svg class="icon icon--combobox">
                                                <use href="#icon-chevron"></use></svg>
                                        </span>
                                    </div>
                                </div>
                            </div>
                            <div class="form__field-label">
                                <div class="form form--select">
                                    <div class="form__contain">
                                        <%= Html.NumericDropDown("CardExpirationYear", DateTime.Now.Year, DateTime.Now.Year + 10, ViewData["CardExpirationYear"], new {@id="CardExpirationYear", @class = "form__field" }) %>
                                        <span class="form__field form__button">
                                            <svg class="icon icon--combobox">
                                                <use href="#icon-chevron"></use></svg>
                                        </span>
                                    </div>
                                </div>
                            </div>
                        </fieldset>
                        <div class="form__label message__group" aria-live="assertive">
                            <span class="message__label"><span class="form__error">* </span>Expiration Date</span>
                            <span class="message__invalid">Please choose a valid expiration date.</span>
                        </div>
                    </div>
                    <div id="CardCvv2Ct" class="form__field-label form__cvv">
                        <input type="tel" name="CardCvv2" id="CardCvv2" data-required="true" data-validationtype="cvv"  maxlength="5" placeholder="###" class="form__field">
                        <div class="form__label message__group" aria-live="assertive">
                            <span class="message__label"><span class="form__error">* </span>CVV</span>
                            <span class="message__invalid">Please enter the CVV number.</span>
                        </div>
                        <a data-fancybox data-type="ajax" href="<%= LabelsManager.Labels["CVV2DisclaimerLink"] %>" title="<%= LabelsManager.Labels["CVV2DisclaimerLinkTitle"] %>" id="cvv2" class="account__link form__link">What is CVV2?</a>
                    </div>

                    <%
                        ViewDataDictionary billingAddressViewData;
                        ViewDataDictionary shippingAddressViewData;
                        if (Model.CurrentCustomer != null && Model.CurrentCustomer.StoreCustomerID != Guid.Empty)
                        {
                            var addresses = Model.CurrentCustomer.StoreCustomerAddresses;

                            var billingAddress = addresses
                                .Where(a => a.IsDefault.HasValue
                                && a.IsDefault.Value
                                && (!a.IsShipping.HasValue || (a.IsShipping.HasValue && !a.IsShipping.Value)))
                                .FirstOrDefault()
                                ??
                                addresses
                                .Where(a => (!a.IsShipping.HasValue || (a.IsShipping.HasValue && !a.IsShipping.Value)))
                                .FirstOrDefault()
                                ?? new StoreCustomerAddress();

                            var shippingAddress = addresses
                                .Where(a => a.IsDefault.HasValue
                                && a.IsDefault.Value
                                && a.IsShipping.HasValue
                                && a.IsShipping.Value)
                                .FirstOrDefault()
                                ??
                                addresses
                                .Where(a => a.IsShipping.HasValue
                                && a.IsShipping.Value)
                                .FirstOrDefault()
                                ?? new StoreCustomerAddress();


                            billingAddressViewData = new ViewDataDictionary {
                                    {"BillingStreet", billingAddress.Street},
                                    {"BillingStreet2", billingAddress.Street2},
                                    { "BillingFirstName", billingAddress.FirstName },
                                    { "BillingLastName", billingAddress.LastName},
                                    { "BillingZip", billingAddress.Zip },
                                    { "BillingCountry", billingAddress.Country },
                                    { "Email", Model.CurrentCustomer.Email },
                                    { "Phone", Model.CurrentCustomer.Phone },
                                    { "BillingState", billingAddress.State },
                                    { "BillingCity", billingAddress.City }
                                };
                            shippingAddressViewData = new ViewDataDictionary {
                                    {"ShippingStreet", shippingAddress.Street},
                                    {"ShippingStreet2", shippingAddress.Street2},
                                    { "ShippingFirstName", shippingAddress.FirstName },
                                    { "ShippingLastName", shippingAddress.LastName},
                                    { "ShippingZip", shippingAddress.Zip },
                                    { "ShippingCountry", shippingAddress.Country },
                                    { "ShippingState", shippingAddress.State },
                                    { "ShippingCity", shippingAddress.City }
                                };

                        }
                        else
                        {
                            var order = Model.Order ?? new Order();

                            billingAddressViewData = new ViewDataDictionary {
                                    {"BillingStreet", order.BillingStreet},
                                    {"BillingStreet2", order.BillingStreet2},
                                    { "BillingFirstName", order.BillingFirstName },
                                    { "BillingLastName", order.BillingLastName},
                                    { "BillingZip", order.BillingZip },
                                    { "BillingCountry", order.BillingCountry },
                                    { "Email", order.Email },
                                    { "Phone", order.Phone },
                                    { "BillingState", order.BillingState },
                                    { "BillingCity", order.BillingCity }
                                };

                            shippingAddressViewData = new ViewDataDictionary {
                                    {"ShippingStreet", order.ShippingStreet},
                                    {"ShippingStreet2", order.ShippingStreet2},
                                    { "ShippingFirstName", order.ShippingFirstName },
                                    { "ShippingLastName", order.ShippingLastName},
                                    { "ShippingZip", order.ShippingZip },
                                    { "ShippingCountry", order.ShippingCountry},
                                    { "ShippingState", order.ShippingState},
                                    { "ShippingCity", order.ShippingCity }
                                };
                        }
                        Html.RenderPartial("BillingInfo", Model, billingAddressViewData);
                        Html.RenderPartial("ShippingInfo", Model, shippingAddressViewData);
                        %>

                    <hr />
                    <button type="submit" class="button button--second button--express-checkout form_validation_required" id="AcceptOfferButton" name="acceptOffer" data-state="card" data-order-type='{ "PayPalEC" : "Continue with PayPal", "CARD" : "Process Order" }'>
                        <span>Process Order</span>
                    </button>
                    <p id="disclaimerText" class="form__is-hidden">By clicking the Process Order button you are placing a live order and agreeing to the terms of our 30 day money back guarantee and our <a href="/shared/Customers/67/arbitration.html" data-fancybox data-type="ajax" id="checkout-arbitration-agreement">arbitration agreement</a>.</p>

                    <div class="checkout checkout--offer-details">
                        <% Html.RenderSnippet("OFFERDETAILS"); %>
                    </div>
                </div>

                <div class="account__checkout">
                    <div class="view__scroll checkout checkout--cart">

                        <%-- Products --%>
                        <%
                            if (shoppingCartItems.Any())
                            {
                                foreach (var cartItem in shoppingCartItems)
                                {
                                    var price = (decimal)cartItem.Price;
                                    var priceString = price.ToString("C");
                                    var currentQuantity = cartItem.Quantity;
                                    var productCode = cartItem.ProductCode;
                                    var isGelPack = false;
                                    var nameProperty = cartItem.CampaignProduct.PropertyIndexer["Name"];
                                    var sizeProperty = cartItem.CampaignProduct.PropertyIndexer["Size"];
                                    var colorProperty = cartItem.CampaignProduct.PropertyIndexer["Color"];
                                    var groupProductCode = cartItem.CampaignProduct.AdditionalProductCode;
                                    var groupProductProperties = DtmContext.CampaignProducts
                                        .Where(cp => cp.ProductCode == groupProductCode && !string.IsNullOrWhiteSpace(cp.PropertyIndexer["MainProductImage"]))
                                        .Select(cp => new {
                                            Thumbnail = cp.PropertyIndexer["MainProductImage"],
                                            SelectLabel = string.IsNullOrWhiteSpace(cp.PropertyIndexer["AlternateSelectLabel"])
                                            ? "Size"
                                            : cp.PropertyIndexer["AlternateSelectLabel"]
                                        }).FirstOrDefault() ?? new { Thumbnail = string.Empty, SelectLabel = "Size"};
                                    var name = (string.IsNullOrWhiteSpace(nameProperty)) ? string.Empty : nameProperty;
                                    var size = (string.IsNullOrWhiteSpace(sizeProperty)) ? string.Empty : sizeProperty;
                                    var color = (string.IsNullOrWhiteSpace(colorProperty)) ? string.Empty : colorProperty;
                                    var thumbnail = groupProductProperties.Thumbnail;

                                    // check to see if the item is a gel pack
                                    if (productCode == "REPLBK" || productCode == "REPLKN" || productCode == "REPLSH") {
                                        isGelPack = true;
                                    }

                                    // if the item is apparel, pull a product thumb from the product itself, if not default to the category
                                    if (!string.IsNullOrWhiteSpace(groupProductCode) && groupProductCode.StartsWith("GDX") && !string.IsNullOrWhiteSpace(cartItem.CampaignProduct.PropertyIndexer["MainProductImage"])) {
                                        thumbnail = cartItem.CampaignProduct.PropertyIndexer["MainProductImage"];
                                    }

                                    // if the item is a gel pack it needs to not reference the grouping
                                    if (!string.IsNullOrWhiteSpace(cartItem.CampaignProduct.PropertyIndexer["MainProductImage"]) && isGelPack ) {
                                        thumbnail = cartItem.CampaignProduct.PropertyIndexer["MainProductImage"];
                                    }

                            %>
                        <div class="cart cart--micro bg">
                            <div class="cart__group">
                                <div class="cart__picture">
                                    <picture class="contain contain--square" data-src-img="<%= thumbnail %>"></picture>
                                    <span class="cart__burst burst"><%=currentQuantity%></span>
                                </div>
                                <div class="cart__product-price">
                                    <div class="cart__product">
                                        <h3><%= name%></h3>
                                        <p><strong>Size: </strong><%=size%></p>
                                        <% if (!string.IsNullOrWhiteSpace(color)) { %>
                                        <p><strong>Color:</strong> <%=color%></p>
                                        <% } %>
                                    </div>
                                    <div class="cart__price">
                                        <p><strong>Price:</strong><%=priceString%></p>
                                    </div>
                                </div>
                            </div>
                        </div>
                          <%}
                            if (shippingItems.Any())
                            {
                                foreach (var shippingItem in shippingItems)
                                {
                                      var currentQuantity = shippingItem.Quantity;
                                      var price = (decimal)shippingItem.Price;
                                      var priceString = price.ToString("C");
                                      var description = shippingItem.ProductName;
                                      %>
                                    <div class="cart cart--micro bg">
                                        <div class="cart__group">
                                            <div class="cart__picture">
                                                <span class="cart__burst burst"><%=currentQuantity%></span>
                                            </div>
                                            <div class="cart__product-price">
                                                <div class="cart__product">
                                                    <h3><%= description%></h3>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                <%}
                            }
                              }
                              else
                              {%>
                        <div class="account__space account__copy">
                            <p>Your cart is currently empty.</p>
                            <a href="<%=landingPageUrl%>#best-sellers" class="button button--second">Continue Shopping</a>
                        </div>
                        <%} %>
                        <div id="lastItem"></div>
                        <hr />

                        <%-- Promotional Code --%>
                        <div class="form message">
                            <div class="form__field-label form__field-button-label">

                                <input type="text" name="promoCode" id="promoCode" placeholder="Enter Promo Code" class="form__field ddlPromo" value="">
                                <label class="message__group" aria-live="assertive">
                                    <span class="message__label">Promotional Code</span>
                                    <span class="message__invalid">Please enter a valid promo code.</span>
                                    <span class="message__valid">Thank you!</span>
                                </label>
                                <button type="button" class="button button--second ddlPromoButton" onclick="_firstRun = false; handleCartChange();">Apply</button>
                            </div>
                        </div>
                        <hr />

                        <%-- Order Review --%>
                        <div class="checkout checkout--order-item">
                            <div class="checkout__group">
                                <span>Sub Total</span>
                                <span id="checkout_subTotal"></span>
                            </div>
                        </div>
                        <div class="checkout checkout--order-item">
                            <div class="checkout__group">
                                <span>Processing & Handling</span>
                                <span id="checkout_shipping"></span>
                            </div>
                        </div>
                        <div class="checkout checkout--order-item">
                            <div class="checkout__group">
                                <span class="form form--state-tax">
                                    <span class="form__field-label">
                                        <label>State Tax</label>
                                        <input type="text" name="StateTax" placeholder="Enter Zip Code" class="form__field" value="">
                                    </span>
                                </span>
                                <span id="checkout_tax"></span>
                            </div>
                        </div>
                        <div class="checkout checkout--order-item">
                            <div class="checkout__group">
                                <span>Order Total</span>
                                <span id="checkout_orderTotal"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

        </form>
    </div>
</div>
</main>
</asp:Content>
