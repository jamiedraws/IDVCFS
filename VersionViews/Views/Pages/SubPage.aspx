<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<main aria-label="<%= DtmContext.PageCode %>" class="view defer defer--from-top article section">
    <div id="main" class="view__anchor"></div>
    <article class="view__in section__in defer__progress">
        <div class="section__block section__contain-article article__copy">
        <% 
            var title = Model.UpsellTitle ?? string.Empty;
            var text = Model.UpsellText ?? string.Empty;
            var hasTitle = !String.IsNullOrEmpty(title);
            var hasText = !String.IsNullOrEmpty(text);

            if (hasTitle)
            {
                %>
                <h2><%= title %></h2>
                <%
            } else
            {
                Html.RenderSnippet("SUBPAGE-TITLE-" + DtmContext.PageCode);
            }

            if (hasText)
            {
                %>
                <%= text %>
                <%
            } else
            {
                Html.RenderSubPageContent(DtmContext.PageCode);
            }
        %>
        </div>
    </article>
</main>

</asp:Content>