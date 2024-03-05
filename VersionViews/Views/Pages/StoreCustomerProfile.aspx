<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%
        switch (Model.Action)
        {
            case "Register":
    %>
    <%-- 3. Create An Account --%>
    <main aria-labelledby="account-title" class=" view defer defer--from-top main section">
        <div id="account" class="view__anchor"></div>
        <div class=" view__in section__in defer__progress">
            <div class="section__block checkout account">
                <h1 id="account-title" class="account__banner">Create an Account</h1>
                <div class="account__contain">
                    <div class="account__group">
                        <%
                            using (Html.BeginForm(Model.Action, "Account", FormMethod.Post, new { @class = "account__copy account__form form message" }))
                            {
                        %>
                        <div class="form__error">
                            <%=Html.ValidationSummary("The following errors have occured")%>
                        </div>
                        <div class="form__field-label">
                            <input type="text" id="FirstName" name="CurrentCustomer.FirstName" placeholder="First Name"  data-required="true" data-pattern="^[A-z]+([A-z .,'-]*)?$" class="form__field" required>
                            <label for="FirstName" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>First Name</span>
                                <span class="message__invalid">Please enter a first name.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input type="text" id="LastName" name="CurrentCustomer.LastName" placeholder="Last Name" data-required="true" data-pattern="^[A-z]+([A-z .,'-]*)?$" class="form__field" required>
                            <label for="LastName" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Last Name</span>
                                <span class="message__invalid">Please enter a last name.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input type="email" name="CurrentCustomer.Email" placeholder="Email Address" data-required="true" data-pattern="^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$" class="form__field" required>
                            <label for="EmailAddress" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Email Address</span>
                                <span class="message__invalid">Please enter an email address.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input type="tel" name="CurrentCustomer.Phone" id="Phone" placeholder="Phone" data-validationtype="phone" class="form__field">
                            <label for="Phone" class="message__group" aria-live="assertive">
                                <span class="message__label">Phone</span>
                                <span class="message__invalid">Please enter a phone number.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input type="password" name="CurrentCustomer.Password" id="Password" data-required="true" placeholder="Password" class="form__field" autocomplete="off" required>
                            <label for="Password" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Password</span>
                                <span class="message__invalid">Please enter a password.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input type="text" name="BillingAddress.Street" id="Street" data-required="true" placeholder="Street" class="form__field" required>
                            <label for="Street" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Street</span>
                                <span class="message__invalid">Please enter a street address.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input type="text" name="BillingAddress.Street2" id="Street2" placeholder="Street 2" class="form__field">
                            <label for="Street2" class="message__group" aria-live="assertive">
                                <span class="message__label">Street 2</span>
                                <span class="message__invalid">Please enter a street address.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input type="text" name="BillingAddress.City" id="City"  data-required="true" placeholder="City" class="form__field" required>
                            <label for="City" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>City</span>
                                <span class="message__invalid">Please enter a city.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <div class="form form--select">
                                <div class="form__contain">
                                    <%=Html.DropDownListFor(m => m.BillingAddress.Country, new SelectList(Model.Countries, "CountryCode", "CountryName", Model.BillingAddress.Country),  new { @class = "form__field" })%>
                                    <span class="form__field form__button">
                                        <svg class="icon icon--combobox">
                                            <use href="#icon-chevron"></use></svg>
                                    </span>
                                </div>
                            </div>
                            <label for="Country" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Country</span>
                                <span class="message__invalid">Please choose a country.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <div class="form form--select">
                                <div class="form__contain">
                                    <%=Html.DropDownListFor(m => m.BillingAddress.State, new SelectList(Model.States, "StateCode", "StateName", Model.BillingAddress.State),  new { @class = "form__field" })%>
                                    <span class="form__field form__button">
                                        <svg class="icon icon--combobox">
                                            <use href="#icon-chevron"></use></svg>
                                    </span>
                                </div>
                            </div>
                            <label for="State" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>State</span>
                                <span class="message__invalid">Please choose a state.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input type="text" name="BillingAddress.Zip" data-required="true" id="Zip" placeholder="Zip Code" class="form__field" required>
                            <label for="Zip" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Zip Code</span>
                                <span class="message__invalid">Please enter a zip code.</span>
                            </label>
                        </div>
                        <button type="submit" id="Save" value="Save" class="button button--contrast button--second form_validation_required">Create an account</button>
                        <a href="/Account/Index" class="account__link">Return to Login</a>
                        <%=Html.HiddenFor(m => m.ReturnUrl)%>
                        <%=Html.HiddenFor(m => m.BillingAddress.AddressId)%>
                        <%=Html.HiddenFor(m => m.Action) %>
                        <%=Html.HiddenFor(m => m.CurrentCustomer.StoreCustomerID) %>

                        <%
                            }
                        %>
                        <aside class="account__sidebar account__copy">
                        </aside>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <%
            break;
        case "Profile":

            var mode = Request.Params["mode"] ?? string.Empty;
            switch (mode)
            {
                case "addAddress":
    %>

    <%-- 7. Add New Address --%>
    <main aria-labelledby="account-title" class="defer defer--from-top view main section">
        <div id="account" class="view__anchor"></div>
        <div class="defer__progress view__in section__in">
            <div class="section__block checkout account">
                <h1 id="account-title" class="account__banner">My Account</h1>
                <div class="account__contain account__space account__copy">
                    <a href="/Account/Index" class="account__link">Return to Account Details</a>

                    <div class="account__group">
                        <%
                            using (Html.BeginForm("AddAddress", "Profile", FormMethod.Post, new { @class = "account__copy account__form form message" }))
                            {
                        %>
                        <div class="form__error">
                            <%=Html.ValidationSummary("The following errors have occured")%>
                        </div>
                        <h2 class="account__header">Add New Address</h2>
                        <fieldset class="account__group form__fieldset">
                            <div class="form__field-label">
                                <input type="text" name="BillingFirstName" placeholder="First Name" data-required="true" data-pattern="^[A-z]+([A-z .,'-]*)?$" required class="form__field">
                                <label class="message__group" aria-live="assertive">
                                    <span class="message__label"><span class="form__error">* </span>First Name</span>
                                    <span class="message__invalid">Please enter a first name.</span>
                                </label>
                            </div>
                            <div class="form__field-label">
                                <input type="text" name="BillingLastName" placeholder="Last Name" data-required="true" data-pattern="^[A-z]+([A-z .,'-]*)?$" required class="form__field">
                                <label class="message__group" aria-live="assertive">
                                    <span class="message__label"><span class="form__error">* </span>Last Name</span>
                                    <span class="message__invalid">Please enter a last name.</span>
                                </label>
                            </div>
                        </fieldset>
                        <div class="form__field-label">
                            <input type="text" name="BillingAddress.Street" placeholder="Address" data-required="true" required class="form__field">
                            <label class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Address</span>
                                <span class="message__invalid">Please enter an address.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input type="text" name="BillingAddress.Street2" placeholder="Address 2" class="form__field">
                            <label class="message__group" aria-live="assertive">
                                <span class="message__label">Address</span>
                            </label>
                        </div>
                        <fieldset class="account__group form__fieldset form__city-state-zip">
                            <div class="form__field-label">
                                <input type="text" name="BillingAddress.City" placeholder="City" data-required="true" required class="form__field">
                                <label class="message__group" aria-live="assertive">
                                    <span class="message__label"><span class="form__error">* </span>City</span>
                                    <span class="message__invalid">Please enter a city.</span>
                                </label>
                            </div>
                            <div class="form__field-label">
                                <div class="form form--select">
                                    <div class="form__contain">
                                        <%=Html.DropDownListFor(m => m.BillingAddress.State, new SelectList(Model.States, "StateCode", "StateName", Model.BillingAddress.State), new { @class = "form__field" })%>
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
                                <input type="text" name="BillingAddress.Zip" placeholder="Zip Code" data-required="true" required class="form__field">
                                <label class="message__group" aria-live="assertive">
                                    <span class="message__label"><span class="form__error">* </span>Zip Code</span>
                                    <span class="message__invalid">Please enter a zip code.</span>
                                </label>
                            </div>
                            <div class="form__field-label">
                                <div class="form form--select">
                                    <div class="form__contain">
                                        <%=Html.DropDownListFor(m => m.BillingAddress.Country,  new SelectList(Model.Countries, "CountryCode", "CountryName", Model.BillingAddress.Country), new { @class="form__field" })%>
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
                        </fieldset>
                        <label class="form__checkbox-label">
                            <input name="IsDefault" value="true" type="checkbox">
                            <span class="form__checkbox"></span>
                            <span>Set as default address</span>
                        </label>
                        <label class="form__checkbox-label">
                            <input name="IsShipping" value="true" type="checkbox">
                            <span class="form__checkbox"></span>
                            <span>Set as shipping address</span>
                        </label>
                        <nav class="account__nav">
                            <div class="account__group">
                                <button type="submit" class="button button--second">Add Address</button>
                                <a href="/Account/Profile">Cancel</a>
                            </div>
                        </nav>
                        <%
                            }
                        %>

                        <address>
                            <div class="view__scroll account__copy">
                                <h2 class="account__header">Customer Address Book</h2>
                                <%
                                    var addLength = Model.CurrentCustomer.StoreCustomerAddresses.Count;
                                    for (int i = 0; i < addLength; i++)
                                    {
                                        var address = Model.CurrentCustomer.StoreCustomerAddresses[i];
                                %>
                                <div><%=address.IsShipping.HasValue && address.IsShipping.Value ? "Shipping" : "Billing" %> Address</div>
                                <div><%=address.FirstName %>&nbsp;<%=address.LastName %></div>
                                <div class="account__address">
                                    <%=address.Street %><br>
                                    <%=!string.IsNullOrWhiteSpace(address.Street2) ? address.Street2 + "<br>" : string.Empty %>
                                    <%=address.City %>,&nbsp;<%=address.State %>&nbsp;<%=address.Zip %><br>
                                    <%=address.Country %>
                                </div>
                                <nav>
                                    <a href="/Account/Profile?mode=editAddress&addressId=<%=address.StoreCustomerAddressID %>" class="button button--second button--contrast">Edit</a>
                                    <a href="javascript:void(0);" data-addressid="<%=address.StoreCustomerAddressID %>" class="button button--second button--contrast removeAddress">Remove</a>
                                </nav>
                                <%
                                    }
                                %>
                            </div>
                        </address>


                    </div>
                </div>
            </div>
        </div>
    </main>
    <%
            break;
        case "editAddress":

            var addressIdParam = Request.Params["addressId"] ?? string.Empty;
            Guid addressId;
            Guid.TryParse(addressIdParam, out addressId);
            var editAddress = Model.CurrentCustomer.StoreCustomerAddresses.Where(s => s.StoreCustomerAddressID == addressId).FirstOrDefault()
                ?? new StoreCustomerAddress();

    %>
    <%-- 6. Edit Address --%>
    <main aria-labelledby="account-title" class="defer defer--from-top view main section">
        <div id="account" class="view__anchor"></div>
        <div class="defer__progress view__in section__in">
            <div class="section__block checkout account">
                <h1 id="account-title" class="account__banner">My Account</h1>
                <div class="account__contain account__space account__copy">
                    <a href="/Account/Index" class="account__link">Return to Account Details</a>

                    <div class="account__group">
                        <%
                            using (Html.BeginForm("EditAddress", "Profile", FormMethod.Post, new { @class = "account__copy account__form form message" }))
                            {
                        %>
                        <div class="form__error">
                            <%=Html.ValidationSummary("The following errors have occured")%>
                        </div>
                        <h2 class="account__header">Edit Address</h2>
                        <fieldset class="account__group form__fieldset">
                            <div class="form__field-label">
                                <input type="text" name="BillingFirstName" placeholder="First Name" data-required="true" data-pattern="^[A-z]+([A-z .,'-]*)?$" required class="form__field" value="<%=editAddress.FirstName %>">
                                <label class="message__group" aria-live="assertive">
                                    <span class="message__label"><span class="form__error">* </span>First Name</span>
                                    <span class="message__invalid">Please enter a first name.</span>
                                </label>
                            </div>
                            <div class="form__field-label"> 
                                <input type="text" name="BillingLastName" placeholder="Last Name" data-required="true" data-pattern="^[A-z]+([A-z .,'-]*)?$" required class="form__field" value="<%=editAddress.LastName %>">
                                <label class="message__group" aria-live="assertive">
                                    <span class="message__label"><span class="form__error">* </span>Last Name</span>
                                    <span class="message__invalid">Please enter a last name.</span>
                                </label>
                            </div>
                        </fieldset>
                        <div class="form__field-label">
                            <input type="text" name="BillingAddress.Street" placeholder="Address" data-required="true" required class="form__field" value="<%=editAddress.Street %>">
                            <label class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Address</span>
                                <span class="message__invalid">Please enter an address.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input type="text" name="BillingAddress.Street2" placeholder="Address 2" class="form__field" value="<%=editAddress.Street2 %>">
                            <label class="message__group" aria-live="assertive">
                                <span class="message__label">Address</span>
                            </label>
                        </div>
                        <fieldset class="account__group form__fieldset form__city-state-zip">
                            <div class="form__field-label">
                                <input type="text" name="BillingAddress.City" placeholder="City" data-required="true" required class="form__field" value="<%=editAddress.City %>">
                                <label class="message__group" aria-live="assertive">
                                    <span class="message__label"><span class="form__error">* </span>City</span>
                                    <span class="message__invalid">Please enter a city.</span>
                                </label>
                            </div>
                            <div class="form__field-label">
                                <div class="form form--select">
                                    <div class="form__contain">
                                        <%=Html.DropDownListFor(m => m.BillingAddress.State, new SelectList(Model.States, "StateCode", "StateName", editAddress.State), new { @class="form__field" })%>
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
                                <input type="text" name="BillingAddress.Zip" placeholder="Zip Code" data-required="true" required class="form__field" value="<%=editAddress.Zip %>">
                                <label class="message__group" aria-live="assertive">
                                    <span class="message__label"><span class="form__error">* </span>Zip Code</span>
                                    <span class="message__invalid">Please enter a zip code.</span>
                                </label>
                            </div>
                            <div class="form__field-label">
                                <div class="form form--select">
                                    <div class="form__contain">
                                        <%=Html.DropDownListFor(m => m.BillingAddress.Country,  new SelectList(Model.Countries, "CountryCode", "CountryName", editAddress.Country), new { @class="form__field" })%>
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
                            
                        </fieldset>
                        <label class="form__checkbox-label">
                            <input name="IsDefault" value="true" type="checkbox" <%=editAddress.IsDefault.HasValue && editAddress.IsDefault.Value ? "checked" : string.Empty %> >
                            <span class="form__checkbox"></span>
                            <span>Set as default address</span>
                        </label>
                        <label class="form__checkbox-label">
                            <input name="IsShipping" value="true" type="checkbox" <%=editAddress.IsShipping.HasValue && editAddress.IsShipping.Value ? "checked" : string.Empty %>  >
                            <span class="form__checkbox"></span>
                            <span>Set as shipping address</span>
                        </label>
                        <nav class="account__nav">
                            <div class="account__group">
                                <input type="hidden" name="BillingAddress.AddressId" value="<%=addressId %>" />
                                <button type="submit" class="button button--second">Update Address</button>
                                <a href="/Account/Profile">Cancel</a>
                            </div>
                        </nav>
                        <%
                            }
                        %>

                        <address>
                            <div class="view__scroll account__copy">
                                <h2 class="account__header">Customer Address Book</h2>
                                <%
                                    var editAddresses = Model.CurrentCustomer.StoreCustomerAddresses.Where(s => s.StoreCustomerAddressID != addressId).ToList();
                                    var editLength = editAddresses.Count;
                                    for (int i = 0; i < editLength; i++)
                                    {
                                        var address = editAddresses[i];
                                %>
                                <div><%=address.IsShipping.HasValue && address.IsShipping.Value ? "Shipping" : "Billing" %> Address</div>
                                <div><%=address.FirstName %>&nbsp;<%=address.LastName %></div>
                                <div class="account__address">
                                    <%=address.Street %><br>
                                    <%=!string.IsNullOrWhiteSpace(address.Street2) ? address.Street2 + "<br>" : string.Empty %>
                                    <%=address.City %>,&nbsp;<%=address.State %>&nbsp;<%=address.Zip %><br>
                                    <%=address.Country %>
                                </div>
                                <nav>
                                    <a href="/Account/Profile?mode=editAddress&addressId=<%=address.StoreCustomerAddressID %>" class="button button--second button--contrast">Edit</a>
                                    <a href="javascript:void(0);" data-addressid="<%=address.StoreCustomerAddressID %>" class="button button--second button--contrast removeAddress">Remove</a>
                                </nav>
                                <%
                                    }
                                %>
                            </div>
                        </address>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <%
            break;
        default:
    %>
    <%-- 5. View Addresses --%>
    <main aria-labelledby="account-title" class="defer defer--from-top view main section">
        <div id="account" class="view__anchor"></div>
        <div class="defer__progress view__in section__in">
            <div class="section__block checkout account">
                <h1 id="account-title" class="account__banner">My Account</h1>
                <div class="account__contain account__space account__copy">
                    <a href="/Account/Profile?mode=addAddress" class="button button--second">Add new address</a>
                    <a href="/Account/Index" class="account__link">Return to Account Details</a>

                    <h2 class="account__header">Customer Address Book</h2>

                    <div class="account__group">
                        <%
                            var length = Model.CurrentCustomer.StoreCustomerAddresses.Count;
                            for (int i = 0; i < length; i++)
                            {
                                var address = Model.CurrentCustomer.StoreCustomerAddresses[i];
                        %>
                        <address class="account__copy">
                            <div><%=address.IsShipping.HasValue && address.IsShipping.Value ? "Shipping" : "Billing" %> Address</div>
                            <div><%=address.FirstName %>&nbsp;<%=address.LastName %></div>
                            <div class="account__address">
                                <%=address.Street %><br>
                                <%=!string.IsNullOrWhiteSpace(address.Street2) ? address.Street2 + "<br>" : string.Empty %>
                                <%=address.City %>,&nbsp;<%=address.State %>&nbsp;<%=address.Zip %><br>
                                <%=address.Country %>
                            </div>
                            <nav>
                                <a href="/Account/Profile?mode=editAddress&addressId=<%=address.StoreCustomerAddressID %>" class="button button--second button--contrast">Edit</a>
                                <a href="javascript:void(0);" data-addressid="<%=address.StoreCustomerAddressID %>" class="button button--second button--contrast removeAddress">Remove</a>
                            </nav>
                        </address>
                        <%
                            if (i != length - 1)
                            {
                        %>
                        <div class="account__divider divider-line"></div>
                        <%
                            }

                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <%
                break;
            }

            break;
        }
    %>

    <script type="text/javascript">
        (function () {

            var eles = document.getElementsByClassName("removeAddress");

            for (var i = 0; i < eles.length; i++) {
                eles[i].addEventListener("click", removeAddress);
            }

            function removeAddress() {
                var xhttp = new XMLHttpRequest();

                xhttp.onreadystatechange = function () {
                    if (this.readyState === 4) {
                        window.location = "/Account/Profile";
                    }
                }

                xhttp.open("POST", "/Profile/RemoveAddress", true);

                xhttp.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');

                xhttp.send("addressId=" + this.dataset.addressid);
            }

            
        })();
    </script>
</asp:Content>
