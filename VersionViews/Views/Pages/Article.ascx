<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Models.Ecommerce.BlogPost>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>



<!-- // Blog Post -->
<div class="" id="">
    <h1><%=Model.Title %></h1>

    <p><%=Model.Description %></p>

    <a href="/Stories.dtm">Back to previous page</a>
</div>


