<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var productCode = ViewData["ProductCode"] as string ?? string.Empty;
    var tableNumber = ViewData["TableNumber"] as int? ?? 0;
    var ui = ViewData["UI"] as string ?? "ModalLink";
    var isModalLink = ui == "ModalLink";

    if (isModalLink)
    {
        var dynamicAttributes = @"href=""{0}"" data-caption=""{1}""";
        var staticAttributes = string.Format(@"id=""table-content-link-{0}"" data-fancybox=""table-content-images-{1}""", tableNumber, productCode);

        var outputHTML = @"<a {0} {1}>How to Measure</a>";
        var output = string.Empty;

        switch (productCode)
        {
            case "GDQ_SLEEVES":
                switch (tableNumber)
                {
                    case 1:
                        dynamicAttributes = string.Format(dynamicAttributes, "https://idvcfs.dtmstage.com/images/products/GDQ_SLEEVES/FREEDOM-KNEE-SIZING-GUIDE.jpg", "FIT: Measure the circumference of your left or right knee cap in a standing position and refer to size chart. USE: Position the middle of the sleeve over the knee. You may need to adjust the sleeve position a few inches up or down to get desired compression and comfort.");
                        break;

                    case 2:
                        dynamicAttributes = string.Format(dynamicAttributes, "https://idvcfs.dtmstage.com/images/products/GDQ_SLEEVES/FREEDOM-ELBOW-SIZING-GUIDE.jpg", "FIT: Measure the circumference of your left or right elbow, and refer to that size chart. USE: Position the middle of the sleeve over the elbow. You may need to adjust the sleeve position a few inches up or down to get desired compression and comfort.");
                        break;
                }

                output = string.Format(outputHTML, staticAttributes, dynamicAttributes);
                break;
        }

        %>
        <%= output %>
        <%
    }

%>