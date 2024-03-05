<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<OrderPageViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%-- Billing Address --%>
<div id="billingInformation" class="account__copy">
    <h2 class="account__header">Billing Address</h2>
    <fieldset class="account__group form__fieldset">
        <div class="form__field-label">
            <input type="text" name="BillingFirstName" id="BillingFirstName" placeholder="First Name" data-required="true" data-pattern="^[A-z]+([A-z .,'-]*)?$"  class="form__field" value="<%= ViewData["BillingFirstName"] %>">
            <label class="message__group" aria-live="assertive">
                <span class="message__label"><span class="form__error">* </span>First Name</span>
                <span class="message__invalid">Please enter a first name.</span>
            </label>
        </div>
        <div class="form__field-label">
            <input type="text" name="BillingLastName"  id="BillingLastName" placeholder="Last Name" data-required="true" data-pattern="^[A-z]+([A-z .,'-]*)?$"  class="form__field" value="<%= ViewData["BillingLastName"] %>">
            <label class="message__group" aria-live="assertive">
                <span class="message__label"><span class="form__error">* </span>Last Name</span>
                <span class="message__invalid">Please enter a last name.</span>
            </label>
        </div>
    </fieldset>
    <div class="form__field-label">
        <input type="text" name="BillingStreet" id="BillingStreet" placeholder="Address" data-required="true"   class="form__field" value="<%= ViewData["BillingStreet"] %>">
        <label class="message__group" aria-live="assertive">
            <span class="message__label"><span class="form__error">* </span>Address</span>
            <span class="message__invalid">Please enter an address.</span>
        </label>
    </div>
    <div class="form__field-label">
        <input type="text" name="BillingStreet2" id="BillingStreet2" placeholder="Address 2" class="form__field" value="<%= ViewData["BillingStreet2"] %>">
        <label class="message__group" aria-live="assertive">
            <span class="message__label">Address 2</span>
            <span class="message__invalid">Please enter an address.</span>
        </label>
    </div>
    <fieldset class="account__group form__fieldset form__city-state-zip">
        <div class="form__field-label">
            <input type="text" name="BillingCity" id="BillingCity" placeholder="City" data-required="true"   class="form__field" value="<%= ViewData["BillingCity"] %>">
            <label class="message__group" aria-live="assertive">
                <span class="message__label"><span class="form__error">* </span>City</span>
                <span class="message__invalid">Please enter a city.</span>
            </label>
        </div>
        <div class="form__field-label" id="billStateParent">
            <div class="form form--select">
                <div class="form__contain">
                    <%=Html.DropDownListFor(m => m.BillingState, new SelectList(Model.States, "StateCode", "StateName", ViewData["BillingState"]), new { @class="form__field", @data_required="true", @data_parent="billStateParent"  })%>
                    <span class="form__field form__button">
                        <svg class="icon icon--combobox">
                            <use href="#icon-chevron"></use></svg>
                    </span>
                </div>
            </div>
            <label class="message__group" aria-live="assertive">
                <span class="message__label"><span class="form__error">* </span>State</span>
                <span class="message__invalid">Please choose a state.</span>
            </label>
        </div>
        <div class="form__field-label">
            <input type="text" name="BillingZip" id="BillingZip" placeholder="Zip Code" data-required="true"   class="form__field" value="<%= ViewData["BillingZip"] %>">
            <label class="message__group" aria-live="assertive">
                <span class="message__label"><span class="form__error">* </span>Zip Code</span>
                <span class="message__invalid">Please enter a zip code.</span>
            </label>
        </div>
    </fieldset>

    <div class="form__field-label" <%=Model.Countries.Count() > 1 ? string.Empty :"style='display:none'" %>>
        <div class="form form--select">
            <div class="form__contain">
                <%=Html.DropDownListFor(m => m.BillingCountry, new SelectList(Model.Countries, "CountryCode", "CountryName", ViewData["BillingCountry"]), "Choose A Country", new { @class="form__field" })%>
                <span class="form__field form__button">
                    <svg class="icon icon--combobox">
                        <use href="#icon-chevron"></use></svg>
                </span>
            </div>
        </div>
        <label class="message__group" aria-live="assertive">
            <span class="message__label"><span class="form__error">* </span>Country</span>
            <span class="message__invalid">Please choose a country.</span>
        </label>
    </div>
    <div class="form__field-label">
        <input type="tel" name="Phone" id="Phone" placeholder="Phone" data-required="true" data-validationtype="phone"  class="form__field" value="<%= ViewData["Phone"] %>">
        <label class="message__group" aria-live="assertive">
            <span class="message__label"><span class="form__error">* </span>Phone</span>
            <span class="message__invalid">Please enter a phone number.</span>
        </label>
    </div>
    <div class="form__field-label">
        <input type="email" name="Email" id="Email" placeholder="Email Address" data-required="true" data-pattern="^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$" class="form__field" value="<%= ViewData["Email"] %>">
        <label class="message__group" aria-live="assertive">
            <span class="message__label"><span class="form__error">* </span>Email Address</span>
            <span class="message__invalid">Please enter an email address.</span>
        </label>
    </div>
</div>

