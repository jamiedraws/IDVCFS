<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<ClientSiteViewData>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <% 
        if (Request["resettoken"] != null)
        {
    %>
    <main aria-labelledby="account-title" class=" view defer defer--from-top main section">
        <div id="account" class="view__anchor"></div>
        <div class="view__in section__in defer__progress">
            <div class="section__block checkout account">
                <h1 id="account-title" class="account__banner">Account</h1>
                <div class="checkout__banner">
                    <span>Reset Your Password</span>
                </div>
                <div class="account__contain">
                    <div class="account__group">
                        <% 
                            using (Html.BeginForm("AccountRecovery", "Account", new { resettoken = Request["resettoken"] }, FormMethod.Post, new { @class = "account__copy account__form form message" }))
                            {
                        %>
                        <%= Html.Hidden("Token", Request["resettoken"]) %>
                        <div class="form__error">
                            <%= Html.ValidationSummary("The following errors have occured") %>
                        </div>
                        <div class="form__field-label">
                            <input id="Login" type="email" name="Login" placeholder="Email Address" data-required="true" data-pattern="^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$" class="form__field" required>
                            <label for="Login" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Email Address</span>
                                <span class="message__invalid">Please enter an email address.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input id="Password" maxlength="50" name="Password" type="password" placeholder="Password" data-required="true" class="form__field" required>
                            <label for="Password" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Password</span>
                                <span class="message__invalid">Please enter a password.</span>
                            </label>
                        </div>
                        <button type="submit" id="customerLogin" name="customerLogin" class="button button--contrast button--second">Reset</button>
                        <%= Html.HiddenFor(m => m.ReturnUrl) %>
                        <%

                            }
                        %>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <% 
        }
        else if (Request["forgotPassword"] != null)
        {
    %>
    <%-- 2. Forgot Password --%>
    <main aria-labelledby="account-title" class="defer defer--from-top view main section">
        <div id="account" class="view__anchor"></div>
        <div class="defer__progress view__in section__in">
            <div class="section__block checkout account">
                <h1 id="account-title" class="account__banner">Account</h1>
                <div class="account__contain">
                    <div class="account__group">
                        <div class="account__copy account__form form message">
                            <div class="checkout__banner">
                                <span>Returning Customer</span>
                            </div>
                            <p>We will send you an email to reset your password.</p>
                            <div class="form__field-label">
                                <input type="email" id="Email" placeholder="Email Address" required class="form__field">
                                <label class="message__group" aria-live="assertive">
                                    <span class="message__label"><span class="form__error">* </span>Email Address</span>
                                    <span class="message__invalid">Please enter an email address.</span>
                                    <span class="message__valid">Password Recovery Email has been sent!</span>
                                </label>
                            </div>
                            <nav class="account__nav">
                                <div class="account__group">
                                    <button type="button" onclick="submitFp()" class="button button--contrast button--second">Submit</button>
                                    or
                                <a href="/Account/Index" class="account__link">Cancel</a>
                                </div>
                            </nav>

                        </div>
                        <div class="account__divider divider-line">
                            <span class="burst">Or</span>
                        </div>
                        <aside class="account__sidebar account__copy">
                            <div class="checkout__banner">
                                <span>New Customer</span>
                            </div>
                            <p>Register with us for a faster checkout, to track the status of your order and more.</p>
                            <a href="<%= Url.Action("Register", "Account", new {returnUrl = ViewData["returnUrl"]}) %>" class="button button--second">Create an account</a>
                        </aside>
                    </div>
                </div>
            </div>
        </div>
    </main>
    <div id="submitModal" class="modal" role="dialog" aria-labelledby="modal-text">
        <div class="modal__load-state"></div>
        <div id="submitModalText" class="modal__text">Submitting</div>
    </div>
    <script>
        let submitting;
        addEventListener("DOMContentLoaded", function () {
            submitting = modal({
                modal: {
                    value: document.getElementById("submitModal")
                },
                text: {
                    value: document.getElementById("submitModalText")
                },
                stateClass: {
                    value: "modal--is-visible"
                }
            });
        });

        function setMessageToValid(element) {
            if (!element) return false;
            element.classList.add("message__is-valid");
            element.classList.remove("message__is-invalid");
        }

        function setMessageToInvalid(element) {
            if (!element) return false;
            element.classList.add("message__is-invalid");
            element.classList.remove("message__is-valid");
        }

        function removeMessages(element) {
            if (!element) return false;
            element.classList.remove("message__is-valid");
            element.classList.remove("message__is-invalid");
        }

        function submitFp() {
            const emailElement = document.getElementById("Email");
            if (emailElement) {
                var email = emailElement.value;
                if (validEmail(email)) {
                    removeMessages(emailElement);
                    submitting.show();
                    var xhttp = new XMLHttpRequest();

                    xhttp.addEventListener("error", function () {
                        setMessageToInvalid(emailElement);
                    });

                    xhttp.addEventListener("loadend", function () {
                        submitting.hide();
                    });

                    xhttp.onload = function () {
                        setMessageToValid(emailElement);
                    };


                    xhttp.open("POST", "/Cart/ForgotMyPassword?email=" + email, true);
                    xhttp.send();
                } else {
                    setMessageToInvalid(emailElement);
                }
            }
        }

        function validEmail(value) {
            let emailReg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
            if (value === undefined || value === null && value.trim() === "") {
                return false;
            } else if (!emailReg.test(value)) {
                return false;
            }
            return true;
        }
    </script>
    <%
        }
        else
        {


    %>
    <%-- 1. Login / Login Fail --%>
    <main aria-labelledby="account-title" class=" view defer defer--from-top main section">
        <div id="account" class="view__anchor"></div>
        <div class="view__in section__in defer__progress">
            <div class="section__block checkout account">
                <h1 id="account-title" class="account__banner">Account</h1>
                <div class="account__contain">
                    <div class="account__group">
                        <% 
                            using (Html.BeginForm("Login", "Account", FormMethod.Post, new { @class = "account__copy account__form form message" }))
                            {
                        %>
                        <div class="checkout__banner">
                            <span>Returning Customer</span>
                        </div>
                        <div class="form__error">
                            <%= Html.ValidationSummary("The following errors have occured") %>
                        </div>
                        <div class="form__field-label">
                            <input id="Login" type="email" name="Login" placeholder="Email Address" data-required="true" data-pattern="^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$" class="form__field" required>
                            <label for="Login" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Email Address</span>
                                <span class="message__invalid">Please enter an email address.</span>
                            </label>
                        </div>
                        <div class="form__field-label">
                            <input id="Password" maxlength="50" name="Password" type="password" data-required="true" placeholder="Password" class="form__field" required>
                            <label for="Password" class="message__group" aria-live="assertive">
                                <span class="message__label"><span class="form__error">* </span>Password</span>
                                <span class="message__invalid">Please enter a password.</span>
                            </label>
                        </div>
                        <button type="submit" id="customerLogin" name="customerLogin" class="button button--contrast button--second form_validation_required">Login</button>
                        <a href="/Account/Login?forgotPassword=1" class="account__link">Forgot your password?</a>
                        <%= Html.HiddenFor(m => m.ReturnUrl) %>
                        <%

                            }
                        %>
                        <div class="account__divider divider-line">
                            <span class="burst">Or</span>
                        </div>
                        <aside class="account__sidebar account__copy">
                            <div class="checkout__banner">
                                <span>New Customer</span>
                            </div>
                            <p>Register with us for a faster checkout, to track the status of your order and more.</p>
                            <a href="<%= Url.Action("Register", "Account", new {returnUrl = ViewData["returnUrl"]}) %>" class="button button--second">Create an account</a>

                        </aside>

                    </div>
                </div>
            </div>
        </div>
    </main>
    <% 

        }
    %>
</asp:Content>
