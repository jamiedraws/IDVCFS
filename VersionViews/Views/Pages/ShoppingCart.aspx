<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<%-- 8. View Cart --%>
<main aria-labelledby="account-title" class="defer defer--from-top view main section">
  <div id="account" class="view__anchor"></div>
  <div class="defer__progress view__in section__in">
      <div class="section__block checkout account">
          <h1 id="story-title" class="account__banner">Your Cart</h1>
          <div class="account__contain account__copy">
            <%
                var subTotal = DtmContext.ShoppingCart.SubTotal.ToString("C");
                var shoppingCartItems = DtmContext.ShoppingCart.Items.Where(i => i.CampaignProduct.ProductTypeId == 1 || i.CampaignProduct.ProductTypeId == 2).ToList();
                var hasItems = (shoppingCartItems.Count() > 0) ? true : false;
                var landingPageUrl = String.Format("/{0}/{1}/{2}{3}",
                    DtmContext.OfferCode,
                    DtmContext.Version,
                    "Index",
                    DtmContext.ApplicationExtension);

                var exitUrl = (hasItems)
                    ? String.Format("/{0}/{1}/{2}{3}",
                      DtmContext.OfferCode,
                      DtmContext.Version,
                      "Checkout",
                      DtmContext.ApplicationExtension)
                    : landingPageUrl;

                if (hasItems)
                {
            %>
              <div class="account__group" id="cartContainer">
                  <form class="form account__form">
                      <% Html.RenderPartial("OrderFormReviewTable"); %>
                      <div class="checkout__banner">
                          <span>Products</span>
                      </div>
                      <%
                          var index = 0;
                          foreach (var cartItem in shoppingCartItems)
                          {
                              var price = (decimal)cartItem.Price;
                              var priceString = price.ToString("C");
                              var productCode = cartItem.ProductCode;
                              var isGelPack = false;
                              var productMaxQuantity = cartItem.CampaignProduct.MaxQuantity;
                              var currentQuantity = cartItem.Quantity;
                              var nameProperty = cartItem.CampaignProduct.PropertyIndexer["Name"];
                              var sizeProperty = cartItem.CampaignProduct.PropertyIndexer["Size"];
                              var colorProperty = cartItem.CampaignProduct.PropertyIndexer["Color"];
                              var groupProductCode = cartItem.CampaignProduct.AdditionalProductCode;
                              var thumbnail = DtmContext.CampaignProducts
                                  .Where(cp => cp.ProductCode == groupProductCode && !string.IsNullOrWhiteSpace(cp.PropertyIndexer["MainProductImage"]))
                                  .Select(cp => cp.PropertyIndexer["MainProductImage"])
                                  .FirstOrDefault();
                              // check to see if the item is a gel pack
                              if (productCode == "REPLBK" || productCode == "REPLKN" || productCode == "REPLSH") {
                                  isGelPack = true;
                              }
                              // if the item is apparel, pull a product thumb from the product itself, if not default to the category
                              if (!string.IsNullOrWhiteSpace(groupProductCode) &&  groupProductCode.StartsWith("GDX") && !string.IsNullOrWhiteSpace(cartItem.CampaignProduct.PropertyIndexer["MainProductImage"])) {
                                  thumbnail = cartItem.CampaignProduct.PropertyIndexer["MainProductImage"];
                              }
                              // if the item is a gel pack it needs to not reference the grouping
                              if (!string.IsNullOrWhiteSpace(cartItem.CampaignProduct.PropertyIndexer["MainProductImage"]) && isGelPack ) {
                                  thumbnail = cartItem.CampaignProduct.PropertyIndexer["MainProductImage"];
                              }
                              var name = (string.IsNullOrWhiteSpace(nameProperty)) ? string.Empty : nameProperty;
                              var size = (string.IsNullOrWhiteSpace(sizeProperty)) ? string.Empty : sizeProperty;
                              var color = (string.IsNullOrWhiteSpace(colorProperty)) ? string.Empty : colorProperty;
                      %>

                      <div class="cart bg" id="itemIndex<%=index%>">
                          <div class="cart__group">
                              <picture class="contain contain--square" data-src-img="<%=thumbnail%>"></picture>
                              <div class="cart__content">
                                  <h3><%=name%></h3>
                                  <p><strong>Size:</strong> <%=size%></p>
                                  <% if (!string.IsNullOrWhiteSpace(color)) { %>
                                  <p><strong>Color:</strong> <%=color%></p>
                                  <% } %>
                                  <p><strong>Price:</strong> <%=priceString%></p>
                                  <nav>
                                    <div class="cart__group">
                                        <div class="form form--icon-field-combobox cart__qty">
                                            <div class="form__contain">
                                                <button type="button" class="form__field form__button" aria-label="Subtract current quantity by 1" data-quantity-id="<%=productCode%>Qty" data-exp="min" onclick="event.preventDefault();updateButtonQuantity(this);">
                                                    <svg class="icon"><use href="#icon-minus"></use></svg>
                                                </button>
                                                <input class="form__field form__input cartParam" type="number" aria-label="Current quantity" value="<%=currentQuantity%>" placeholder="1" min="1" max="2" id="<%=productCode%>Qty" name="<%=productCode%>Qty" data-max="2"/>
                                                <button type="button" class="form__field form__button" aria-label="Add current quantity by 1" data-quantity-id="<%=productCode%>Qty" data-exp="add" onclick="event.preventDefault();updateButtonQuantity(this);">
                                                    <svg class="icon"><use href="#icon-plus"></use></svg>
                                                </button>
                                            </div>
                                        </div>
                                        <button type="button" class="button button--second button--contrast" data-product-code="<%=productCode%>" id="<%=productCode%>" data-max="2" onclick="updateProductQuantity(this);">Update Cart</button>
                                        <button type="button" class="cart__link" id="<%=productCode%>_Remove" onclick="removeCartItem('<%=productCode%>','<%=index%>','<%=landingPageUrl%>')">X Remove</button>
                                        <div class="vse_<%=productCode%>"></div>
                                    </div>
                                  </nav>
                              </div>
                          </div>
                      </div>
                      <%  index++;
                          } %>
                  </form>
                  <aside class="account__sidebar">
                      <div class="account__copy view__scroll">
                          <div class="checkout__banner">
                              <span>Order Summary</span>
                          </div>
                          <div class="account__group checkout__order-item">
                              <span>Sub Total</span>
                              <span id="summarySubTotal"><%=subTotal%></span>
                          </div>
                          <hr />
                          <nav aria-label="Order summary" class="account__group account__nav">
                            <a href="<%= exitUrl %>" id="order-summary-checkout" class="button button--second">Proceed To Checkout</a>
                            <a href="<%= landingPageUrl %>#best-sellers" id="order-summary-shopping" class="button button--second">Continue Shopping</a>
                          </nav>
                      </div>
                  </aside>
              </div>
            <% } else { %>
              <div class="account__space account__copy">
                <h2 class="account__header">Details</h2>
                <p>Your cart is currently empty.</p>
                <a href="<%= exitUrl %>#best-sellers" class="button button--second">Continue Shopping</a>
              </div>
            <% } %>
          </div>
      </div>
  </div>
</main>

</asp:Content>