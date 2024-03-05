<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>

<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

    <div id="index" data-poid-section class="orderHistory">
        <div class="product-title">
            <h1>Order History</h1>
        </div>

        <div id="myAccountContent" class="orderHistoryTable">
            <% try
               { %>
            <table id="orderHistoryTable" class="orderItemsTable">
                <thead>
                    <tr>
                        <th>Order #</th>
                        <th>Description</th>
                        <th>Quantity</th>
                        <th>Price</th>
                        <th>Shipping</th>
                        <th>Total</th>
                    </tr>
                </thead>
                <% if (Model.CustomerOrders.Any())
                   { %>
                <% foreach (var order in Model.CustomerOrders)
                   { %>
                <tr class="orderLeft">
                    <td colspan="6"><%= order.OrderID %></td>
                </tr>
                <% foreach (var oi in order.OrderItems)
                   { %>
                <tr class="orderLeft">
                    <td>&nbsp;</td>
                    <td>
                        <%= oi.Description %>
                    </td>
                    <td>
                        <%= oi.Quantity %>
                    </td>
                    <td>
                        <%= oi.Price.ToString("C") %>
                    </td>
                    <td>
                        <%= oi.Shipping.ToString("C") %>
                    </td>
                    <td>
                        <%= ((oi.Price + oi.Shipping)*oi.Quantity).ToString("C") %>
                    </td>
                </tr>
                <% } %>
                <tr class="orderTotal">
                    <td colspan="5">&nbsp;</td>
                    <td>
                        <%= order.OrderTotal.ToString("C") %>
                    </td>
                </tr>
                <% }
                   }
                   else
                   {
                %>
                <td colspan="6">No Order History</td>
                <% } %>
            </table>
            <% }
               catch (Exception ex)
               {
                   new SiteExceptionHandler(ex);
            %>
            No Order History Found.
               <% }%>
        </div>

        <div class="clearer">
        </div>
    </div>

</asp:Content>
