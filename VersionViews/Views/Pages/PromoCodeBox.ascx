<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<OrderPageViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<!-- // Promo Code Banner -->
<div class="promo success-message-container" id="promo">
    <label class="promo__label" for="promoCode">
        <strong>PROMO CODE:</strong>
    </label> 
    <div class="row-to-center u-vw--100">
        <div class="col @mv-u-vw--50 @dv-u-pad--right @mv-u-pad--reset">
            <input type="text" class="ddlPromo u-vw--100" name="promoCode" id="promoCode">
        </div>
        <div class="col @mv-u-vw--50 u-mar--top">
            <input type="button" class="confirm-button ddlPromoButton u-vw--100" value="Apply Code">
        </div> 
    </div>
    <div class="promo-message hide center-text top-margin">
        <div class="container bg--white u-vw--100 no-margin">
            <i class="icon-checkmark"></i> <p class="message__in column-block no-margin">Thank you! Your promo code was applied.</p>
        </div>
    </div> 
</div>


