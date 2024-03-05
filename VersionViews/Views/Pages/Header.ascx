<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%@ Import Namespace="IDVCFS.Models" %>
<%
    var version = DtmContext.Version;
    var isIndex = DtmContext.PageCode == "Index";
    var isExplore = DtmContext.PageCode == "Explore";
    var isMobile = DtmContext.IsMobile;
    var isDesktop = !isMobile;
    var isStartPage = DtmContext.Page.IsStartPageType && DtmContext.PageCode != "PaymentForm";
    var isPaymentPage = DtmContext.PageCode == "PaymentForm" || DtmContext.PageCode == "ProcessPayment";
    var productAttributeName = SettingsManager.ContextSettings["Label.ProductName"];
    var productName = productAttributeName;
        var cartQuantity = DtmContext.ShoppingCart.Where(sc => sc.CampaignProduct.PropertyIndexer["ExcludeFromCartCount"] != "true").Sum(sc => sc.Quantity);
 
 
    var ext = DtmContext.ApplicationExtension;
    var cov = String.Format("/{0}/{1}/", DtmContext.OfferCode, DtmContext.Version);
 
    var hashHome = "#main";
    var hashCFStories = "#copper-fit-stories";
    var queryShop = "SearchResults?query=copper%20fit";
 
    var linkHome = isIndex ? hashHome : String.Format("{0}Index{1}{2}", cov, ext, hashHome);
    var linkShop = String.Format("{0}{1}", cov, queryShop);
    var linkBenefits = String.Format("{0}Benefits{1}", cov, ext);
    var linkExplore = String.Format("{0}Explore{1}", cov, ext);
    var linkCFStories = isExplore ? hashCFStories : String.Format("{0}{1}", linkExplore, hashCFStories);
    var linkAbout = String.Format("{0}Story{1}", cov, ext);
 
    var displayBanner = false;
    var logoClasses = "nav__logo";
    if (!isStartPage)
    {
        logoClasses = String.Format("{0} nav__standalone", logoClasses);
    }
 
    var logo = String.Format(@"
        <a href=""{0}"" id=""header-logo"" class=""{2}"" aria-label=""{1}"">
            <div class=""nav__logo logo"">
                <picture class=""contain contain--cf"">
                    <img src=""/images/logos/copper-fit.svg"" alt=""Copper Fit"">
                </picture>
                <picture class=""contain contain--ll"">
                    <img src=""/images/logos/live-limitless.svg"" alt=""Live Limitless"">
                </picture>
            </div>
        </a>
        ",
    linkHome, productAttributeName, logoClasses);
 
    var renderDropdown = true;
%>
 
<header class="view nav section @print-only-hide">
    <div class="banner nav__banner">We're currently shipping from the <abbr title="United States">US</abbr> with no disruptions</div>
    <div class="nav__group nav__in section__contain">
        <% logo = logo.Replace("header-logo", "nav-logo"); %>
        <%= logo %>
 
        <% if (isStartPage) { %>
        <input class="nav__toggle" type="checkbox" id="nav__toggle" aria-label="Toggle Menu">
        <label class="nav__label" for="nav__toggle" aria-label="Toggle Menu">
            <span></span>
        </label>
        <div class="nav__underlay nav__underlay--for-drawer" role="presentation" aria-label="Hide Menu"></div>
 
        <nav aria-label="Website page links" class="nav__pane">
            <div class="nav__group">
                <% if (displayBanner)
                { %>
                <div class="nav__promo">
        
                </div>
                <% } %>
                <div class="nav__list nav__tier-first">
                    <% logo = logo.Replace("nav-logo", "nav-list-logo"); %>
                    <%= logo %>
 
                    <div class="nav__drop nav__drop--stack nav__tier-first nav__drop--tier-first">
                        <button type="button" aria-haspopup="true" aria-expanded="false" class="nav__drop__toggle nav__link">
                            <span>Shop</span>
                        </button>
                        <div hidden class="nav__group nav__drop__group bg">
                            <div class="nav__menu nav__menu--stack">
                                <div class="nav__list">
                                    <a class="nav__drop__link" href="SearchResults?n=1&query=best" id="nav-best-sellers" aria-label="Best Sellers">
                                        <span>Shop Best Sellers</span>
                                    </a>
                                    <div class="nav__drop nav__drop--grid nav__drop--tier-second">
                                        <button type="button" aria-haspopup="true" aria-expanded="false" class="nav__drop__toggle nav__drop__link">
                                            <span>Shop Collections</span>
                                        </button>
                                        <div hidden class="nav__group nav__drop__group">
                                            <div class="nav__menu nav__menu--stack">
                                                <div class="nav__list">
                                                <%
                                                    var productCollection = new NavigationProductCollection();
 
                                                    foreach (var product in productCollection.List)
                                                    {
                                                        %>
                                                        <a href="<%= product.Link %>" class="nav__drop__link">                                  <picture class="contain contain--nav-thumbnail" data-src-img="/images/navigation/collections/<%= product.Id %>.jpg"></picture>
                                                            <span><%= product.Name %></span>
                                                        </a>
                                                        <%
                                                    }
                                                %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <% if (renderDropdown) { %>
                                    <div class="nav__drop nav__drop--grid nav__drop--tier-second">
                                        <button type="button" aria-haspopup="true" aria-expanded="false" class="nav__drop__toggle nav__drop__link">
                                            <span>Shop Products</span>
                                        </button>
                                        <div hidden class="nav__group nav__drop__group">
                                            <div class="nav__menu nav__menu--stack">
                                                <div class="nav__list">
                                                    <%
                                                    var productTypes = new NavigationProductType();
                                                    
                                                    foreach (var type in productTypes.List)
                                                    {
                                                        %>
                                                        <a href="<%= type.Link %>" class="nav__drop__link">
                                                            <picture class="contain contain--nav-thumbnail" data-src-img="/images/navigation/type/<%= type.Id %>.svg"></picture>
                                                            <span><%= type.Name %></span>
                                                        </a>
                                                        <%
                                                    }
                                                %>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                    <% } %>
                                </div>
                            </div>
                        </div>
                    </div>
                    <a class="nav__link" href="<%= linkBenefits %>" id="nav-benefits" aria-label="Benefits">
                        <span>Benefits</span>
                    </a>
                    <a class="nav__link" href="<%= linkExplore %>" id="nav-explore" aria-label="Explore">
                        <span>Explore</span>
                    </a>
                    <a class="nav__link" href="<%= linkCFStories %>" id="nav-cf-stories" aria-label="Copper Fit Stories">
                        <span>CF Stories</span>
                    </a>
                    <a class="nav__link" href="<%= linkAbout %>" id="nav-about" aria-label="About Copper Fit">
                        <span>About Us</span>
                    </a>
                </div>
            </div>
        </nav>
 
        <nav aria-label="Search for products, account profile and checkout" class="nav__profile">
            <div class="nav__profile">
                <input id="nav__search" type="checkbox" class="nav__toggle" aria-label="Toggle Search"/>
                <label class="circular toggle-icons" for="nav__search">
                    <picture class="toggle-icons__overlay contain contain--icon-search">
                        <img src="/images/icons/search.svg">
                    </picture>
                    <span class="toggle-icons__underlay nav__label nav__label--is-selected">
                        <span></span>
                    </span>
                </label>
                <div class="nav__underlay nav__underlay--for-form">
                    <form action="/Search" data-processing-message="Searching" method="post" onsubmit="return document.getElementById('text').value.replace(/^\s+|\s+$/,'').length != 0;" class="nav__form form form--search">
                        <fieldset class="form__contain form__field-icon">
                             <input id="text" name="text" type="hidden" value="">
                            <input id="versionNumber" name="versionNumber" type="hidden" value="<%=DtmContext.Version.ToString("N4") %>">
                            <input type="text" placeholder="Search..." id="textS" name="textS" onkeyup="document.getElementById('text').value = this.value;" pattern="^[a-zA-Z0-9_ ]*$" class="form__field">
                            <button class="circular"  id="searchSubmit" type="submit">
                                <picture class="contain contain--icon-search">
                                    <img src="/images/icons/search.svg">
                                </picture>
                            </button>        
                        </fieldset>
                    </form>
                </div>
            </div>
            <a href="/Account/Index" class="circular">
                <picture class="contain contain--icon-person">
                    <img src="/images/icons/person.svg">
                </picture>
            </a>
            <a id="shoppingCart" href="/<%=DtmContext.OfferCode %>/<%=DtmContext.Version %>/ShoppingCart<%= DtmContext.ApplicationExtension %>" class="circular">
                <picture class="contain contain--icon-bag">
                    <img src="/images/icons/bag.svg">
                </picture>
                <span class="nav__qty__text cartTotalQtyNumbersOnly">
                    <% if (cartQuantity > 0) { %>
                            <%= cartQuantity%>
                        <% } %>
			    </span>
            </a>
        </nav>
        <% } %>
    </div>
</header>
