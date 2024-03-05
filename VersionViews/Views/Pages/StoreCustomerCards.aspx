<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>

<%@ Import Namespace="Dtm.Framework.Extensions" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <section id="index" data-poid-section class="payment">
        <div class="product-title">
            <h1>Payment Information</h1>
        </div>

        <div id="myAccountContent">
            <% if (Model.Action == "AddCard")
               { %>
            <% if (Model.CustomerCards.Any())
               { %>
            <div class="product-title">
                <h3>Manage Your Credit Cards</h3>
                <p class="subheadline">Your credit cards on this account are below.</p>
                <i class="fa fa-cc-visa"></i>
                <i class="fa fa-cc-mastercard"></i>
                <i class="fa fa-cc-discover"></i>
                <i class="fa fa-cc-amex"></i>
            </div>
            <table id="manageCardTable" class="ccardTable orderItemsTable">
                <thead>
                    <tr>
                        <th>Name On Card</th>
                        <th>Last 4 Of Card</th>
                        <th>Card Type</th>
                        <th>Expiration</th>
                        <th>&nbsp;</th>
                    </tr>
                </thead>
                <tbody>
                    <% foreach (var customerCard in Model.CustomerCards)
                       { %>
                    <tr>
                        <td>
                            <%=string.Format("{0} {1}", customerCard.NameOnCard, customerCard.IsDefault ? "(Default)" : "")%>
                        </td>
                        <td>
                            <%=string.Format("...{0}", customerCard.CardNumber.Right(4))%>
                        </td>
                        <td>
                            <%=string.Format("{0}", customerCard.CardType)%>
                        </td>
                        <td>
                            <%=string.Format("{0}/{1}", customerCard.CardExpiration.Substring(0, 2), customerCard.CardExpiration.Substring(2))%>
                        </td>
                        <td nowrap="nowrap">
                            <a href="/Account/EditCard/<%=customerCard.StoreCustomerCardID %>">Edit</a>
                            <a href="#" onclick="if(confirm('Are you sure you want to delete?')){window.location.href = '/Account/DeleteCard/<%=customerCard.StoreCustomerCardID %>';}">Delete</a>
                        </td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
            <%  } %>
            <%  } %>
            <div class="clearer"></div>

            <% using (Html.BeginForm(Model.Action, "Account"))
               { %>
            <div class="product-title">
                <h3><%=string.Format(Model.Action == "AddCard" ? "Add New" : "Edit")%> Credit Card</h3>
            </div>

            <%=Html.ValidationSummary("The following errors have occured")  %>
            <%=Html.HiddenFor(m => m.StoreCustomerCardID)%>
            <table id="modifyCardTable" class="ccardTable orderItemsTable">
                <thead>
                    <tr>
                        <% if (Model.Action != "AddCard")
                           { %>
                        <th>Is Default</th>
                        <% } %>
                        <th>Name On Card</th>
                        <th>Number</th>
                        <th>Card Type</th>
                        <th>Exp. Month</th>
                        <th>Exp. Year</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <% if (Model.Action != "AddCard")
                           { %>
                        <td>
                            <%= Html.CheckBox("IsDefault", Model.IsDefault ?? false) %>
                        </td>
                        <% } %>
                        <td>
                            <%=Html.TextBoxFor(m => m.NameOnCard, new { maxlength = "50" })%>
                        </td>
                        <td>
                            <%=Html.TextBoxFor(m => m.CardNumber, new { maxlength = "20" })%>
                        </td>
                        <td>
                            <%=Html.DropDownListFor(m => m.CardType, Model.CardTypes)%>
                        </td>
                        <td>
                            <%=Html.CardExpirationMonth("ExpirationMonth")%>
                        </td>
                        <td>
                            <%=Html.NumericDropDown("ExpirationYear", DateTime.Now.Year, DateTime.Now.Year + 10)%>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="<%=Model.Action != "AddCard"? "6" :"5" %>">
                            <input class="animate button" type="submit" id="AddCard" value="<%=string.Format(Model.Action == "AddCard" ? "Add Card" : "Save")%>" onclick="return validateNewCard(event);">
                        </td>
                    </tr>
                </tbody>
            </table>
            <% }%>
        </div>
        <div class="clearer"></div>
    </section>
    <script type="text/javascript">

        function validateNewCard() {
            var cardNumber = $.trim(document.getElementById('CardNumber').value);
            var cardExpiryMonth = document.getElementById('ExpirationMonth').value;
            var cardExpiryYear = document.getElementById('ExpirationYear').value;
            var nameOnCard = document.getElementById('NameOnCard').value;
            var cardType = document.getElementById('CardType').value;
            return validate(cardNumber, cardExpiryMonth, cardExpiryYear, nameOnCard, cardType);
        }

        function validate(cardNumber, cardExpiryMonth, cardExpiryYear, nameOnCard, cardType) {
            var cleanExit = false;
            var messages = "";
            try {
                if (cardNumber.length == 0) {
                    messages += "\tCredit card number is required\n";
                }
                else {
                    //if (CheckCardNum(cardNumber) == 0)
                    //    messages += "\tCredit card number is invalid\n";
                }

                if (cardType /*!= GetCardType(cardNumber)*/) {
                    //                                    messages += "\tCard Type does not match card number entered\n";
                }
                //if (cardExpiryMonth.length > 0) {
                //    if (!IsValidCreditCardDate(cardExpiryMonth, cardExpiryYear))
                //        messages += "\tCredit Card Expiration Date is not valid\n";
                //}

                if (nameOnCard.length == 0)
                    messages += "\tName On Card is required\n";
            }
            catch (err) {
                alert(err);
                return false;
            }
            if (messages.length == 0)
                cleanExit = true;
            if (messages.length > 0) {
                messages = "Please correct the following issues:\n" + messages;
                alert(messages);
                return false;
            }

            return cleanExit;
        }
    </script>

</asp:Content>
