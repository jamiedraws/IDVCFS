<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    Html.RenderPartial("ResourceManager", new ViewDataDictionary { { "preload", true } });
    Html.RenderPartial("ResourceManager");
    Html.RenderPartial("ResourceManager", new ViewDataDictionary { { "defer", true } });
%>