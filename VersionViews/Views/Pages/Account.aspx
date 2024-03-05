<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<ClientSiteViewData>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <%-- 4. My Account --%>
    <main aria-labelledby="account-title" class=" view defer defer--from-top main section">
        <div id="account" class="view__anchor"></div>
        <div class=" view__in section__in defer__progress">
            <div class="section__block checkout account">
                <h1 id="story-title" class="account__banner">My Account</h1>
                <div class="account__contain account__space account__copy">
                    <h2 class="account__header">Order History</h2>
                    <div id="myAccountContent" class="orderHistoryTable">
                        <% 
                            try
                            {
                                var customerOrders = Model.CustomerOrders.Where(c => c.CampaignOfferVersionID == DtmContext.VersionId
                                && (c.OrderStatusId == 3 || c.OrderStatusId == 2)).ToList();
                                if (customerOrders.Any())
                                {
                        %>
                        <div class="chart chart--grid chart--order">
                        <table id="orderHistoryTable">
                            <thead>
                                <tr>
                                    <th data-id="OrderId" scope="col">Order #</th>
                                    <th  scope="col">Date</th>
                                    <th  scope="col">Description</th>
                                    <th  scope="col">Quantity</th>
                                    <th  scope="col">Price</th>
                                    <th  scope="col">Shipping</th>
                                    <th  scope="col">Total</th>
                                </tr>
                            </thead>

                            <% 
                                foreach (var order in customerOrders)
                                {
                            %>
                            <tr class="orderLeft chart__header">
                                <td data-header="Order #" colspan="1"><%= order.OrderID %></td>
                                <td data-header="Date" colspan="1"><%= order.OrderDate.ToString("MM/dd/yyyy") %></td>
                                <td class="chart__remove-on-stack" colspan="5">&nbsp;</td>
                            </tr>
                            <% 
                                foreach (var oi in order.OrderItems)
                                {
                            %>
                            <tr class="orderLeft">
                                <td class="chart__remove-on-stack">&nbsp;</td>
                                <td class="chart__remove-on-stack">&nbsp;</td>
                                <td data-header="Description">
                                    <%= oi.Description %>
                                </td>
                                <td data-header="Quantity">
                                    <%= oi.Quantity %>
                                </td>
                                <td data-header="Price">
                                    <%= oi.Price.ToString("C") %>
                                </td>
                                <td data-header="Shipping">
                                    <%= oi.Shipping.ToString("C") %>
                                </td>
                                <td data-header="Total">
                                    <%= ((oi.Price + oi.Shipping)*oi.Quantity).ToString("C") %>
                                </td>
                            </tr>
                            <% 
                                }
                            %>
                                <tr class="orderTotal chart__footer">
                                    <td colspan="6" class="chart__remove-on-stack">&nbsp;</td>
                                    <td data-header="Total for Order # <%= order.OrderID %>:">
                                        <%= order.OrderTotal.ToString("C") %>
                                    </td>
                                </tr>
                            <% 
                                }
                            %>
                        </table>
                            </div>
                        <%
                            }
                            else
                            {
                        %>
                        <p>You haven't placed any orders yet.</p>
                        <%
                                }
                            }
                            catch (Exception ex)
                            {
                                new SiteExceptionHandler(ex);
                        %>
                        <p>You haven't placed any orders yet.</p>
                        <% 
                            }
                        %>
                    </div>

                    <h2 class="account__header">Account Details</h2>
                    <address class="account__copy">
                        <div><%=Model.CurrentCustomer.FirstName %> <%=Model.CurrentCustomer.LastName %></div>
                        <% var address = Model.CurrentCustomer.StoreCustomerAddresses.FirstOrDefault(s => s.IsDefault.HasValue && s.IsDefault.Value)
                                    ?? Model.CurrentCustomer.StoreCustomerAddresses.OrderBy(s => s.AddDate).FirstOrDefault()
                                    ?? new StoreCustomerAddress();
                            if (address != null)
                            {
                        %>
                        <div class="account__address">
                            <%=address.Street %><br>
                            <%=!string.IsNullOrWhiteSpace(address.Street2) ? address.Street2 + "<br>" : string.Empty %>
                            <%=address.City %>, <%=address.State %> <%=address.Zip %><br>
                            <%=address.Country %>
                        </div>
                        <%
                            }
                        %>

                        <div><%=Model.CurrentCustomer.Phone %></div>
                    </address>

                    <a href="/Account/Profile" class="button button--second account__button">View Addresses <span class="account__address-quantity">(<%=Model.CurrentCustomer.StoreCustomerAddresses.Count %>)</span></a>
                    <a href="/Account/LogOut" class="button button--second account__button">Log Out</a>
                </div>
            </div>
        </div>
    </main>
</asp:Content>
