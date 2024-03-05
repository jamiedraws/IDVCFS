<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var type = ViewData["type"] as string ?? "technology";
    var isTechnology = type == "technology";
    var isAdvantage = type == "advantage";

    var title = "Copper Fit Technologies";
    var label = "Copper Fit Technologies";

    if (isAdvantage)
    {
        title = "Why It Works <small>The Copper Fit Advantage</small>";
        label = "Copper Fit Advantage";
    }
%>
<section aria-labelledby="copper-fit-technologies-title" class="view section bg bg--dark">
    <div id="copper-fit-technologies" class="view__anchor"></div>
    <div class="view__in section__in">
        <div class="section__block title">
            <picture class="title__picture contain contain--logo bg__ignore-picture" data-src-img="/images/logos/swoosh-white.svg">

            </picture>
            <h2 id="copper-fit-technologies-title" class="title__text"><%= title %></h2>
        </div>

        <%
            var technologyList = new SortedList<string, string>
            {
                { "compression", "Compression" },
                { "copper-infused", "Copper Infused" },
                { "odor-reducing", "Odor Reducing" },
                { "wicking", "Wicking" },
                { "motion-activated", "Motion Activated" },
                { "micro-encapsulated", "Micro Encapsulated" },
                { "venting", "Venting" },
                { "heat-cell", "Heat Cell" },
                { "cooling", "Cooling" },
                { "shock-absorbing", "Shock Absorbing "}
            };

            if (isAdvantage)
            {
                technologyList = new SortedList<string, string>
                {
                    { "copper-infused", "Copper Infused" },
                    { "odor-reducing", "Odor Reducing" },
                    { "wicking", "Wicking" },
                    { "heat-cell", "Heat Cell" },
                    { "cooling", "Cooling" },
                    { "micro-encapsulated", "Micro Encapsulated" },
                    { "motion-activated", "Motion Activated" },
                    { "venting", "Venting" },
                    { "compression", "Compression" },
                    { "shock-absorbing", "Shock Absorbing "}
                };
            }

            var id = label.Replace(" ", "-").ToLower();
        %>
        <div class="section__block slide icon-caption icon-caption--carousel">
            <nav aria-label="Previous and next slides for <%= label %>" class="icon-caption__nav slide__nav">
                <button
                    id="<%= id %>-slide-prev"
                    aria-label="Select the previous slide"
                    class="slide__prev"
                    type="button">
                    <svg class="icon icon--chevron">
                        <use href="#icon-chevron"></use></svg>
                </button>
                <button
                    id="<%= id %>-slide-next"
                    aria-label="Select the next slide"
                    class="slide__next"
                    type="button">
                    <svg class="icon icon--chevron">
                        <use href="#icon-chevron"></use></svg>
                </button>
            </nav>
            <div id="<%= id %>-collection" class="icon-caption__group slide__into icon-caption__into">
                <%
                    foreach (var technologyItem in technologyList)
                    {
                        var index = technologyList.IndexOfKey(technologyItem.Key);
                        var caption = technologyItem.Value.Replace(" ", "<br>");
                        %>
                        <figure id="<%= id %>-<%= index %>" class="slide__item icon-caption__item">
                            <picture class="contain contain--square" data-src-img="/images/symbols/<%= technologyItem.Key %>.svg">
                        </picture>
                            <figcaption><%= caption %></figcaption>
                        </figure>
                        <%
                    }    
                %>
            </div>
            <nav aria-label="<%= label %>__navigation" class="slide__thumbnails icon-caption__thumbnails">
                <%
                    foreach (var technologyItem in technologyList)
                    {
                        var index = technologyList.IndexOfKey(technologyItem.Key);
                        %>
                        <a href="#<%= id %>-<%= index %>" data-slide-index="<%= index %>" aria-label="View <%= technologyItem.Value %>" class="slide__dot slide__thumbnail"></a>
                        <%
                    }
                %>
            </nav>
        </div>
    </div>
</section>