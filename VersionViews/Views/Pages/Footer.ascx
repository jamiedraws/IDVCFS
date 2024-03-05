<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    var isIndex = DtmContext.PageCode == "Index";
    var isExplore = DtmContext.PageCode == "Explore";
    var isPaymentPage = DtmContext.PageCode == "PaymentForm" || DtmContext.PageCode == "ProcessPayment";
    var isFrontPage = DtmContext.Page.IsStartPageType && !isPaymentPage;
    var isUpsell = DtmContext.Page.PageType.Equals("Upsell", StringComparison.InvariantCultureIgnoreCase);

    var ext = DtmContext.ApplicationExtension;
    var cov = String.Format("/{0}/{1}/", DtmContext.OfferCode, DtmContext.Version);

    var csPhone = SettingsManager.ContextSettings["CustomerService.PhoneNumber", "1-855-818-8300"];

    var instagramLink = "https://www.instagram.com/copperfit/";
%>

<footer aria-labelledby="footer-title" class="view footer section bg bg--dark @print-only-hide">
    <div id="footer" class="view__anchor"></div>
    <div class="view__in section__in">
        <div class="section__block title">
            <h2 id="footer-title" class="title__text">Connect. Follow. Discover. <small class="title__light"><a href="<%= instagramLink %>" id="instragram-handle-link" title="Check Out Copper Fit On Instagram" target="_blank">@copperfit</a></small></h2>
        </div>

        <div class="section__block footer__pictures slide footer footer--carousel">
            <div id="instagram-pictures" class="footer__group slide__into footer__into">
                <a href="<%= instagramLink %>" target="_blank" class="contain contain--square slide__item footer__item" data-instagram-img-src="/images/instagram/copper-fit-1.jpg" title="View this post on Instagram">
                </a>
                <a href="<%= instagramLink %>" target="_blank" class="contain contain--square slide__item footer__item" data-instagram-img-src="/images/instagram/copper-fit-2.jpg" title="View this post on Instagram">
                </a>
                <a href="<%= instagramLink %>" target="_blank" class="contain contain--square slide__item footer__item" data-instagram-img-src="/images/instagram/copper-fit-3.jpg" title="View this post on Instagram">
                </a>
                <a href="<%= instagramLink %>" target="_blank" class="contain contain--square slide__item footer__item" data-instagram-img-src="/images/instagram/copper-fit-4.jpg" title="View this post on Instagram">
                </a>
                <a href="<%= instagramLink %>" target="_blank" class="contain contain--square slide__item footer__item" data-instagram-img-src="/images/instagram/copper-fit-5.jpg" title="View this post on Instagram">
                </a>
            </div>
        </div>

        <div class="section__block footer__content">
            <div class="footer__group">
                <div class="form form--contrast">
                    <div class="form__title">Be the first to know about<br />new products and special offers!</div>
                    <fieldset class="form__contain form__field-button footer__form">
                        <input type="email" placeholder="Email" id="discountEmail" name="discountEmail" class="form__field">
                        <button type="button" class="button" onclick="return saveEmailOptIn(this);">Sign me up!</button>
                    </fieldset>
                    <div id="subscribeMessage" class="subscribe-msg"></div>
                </div>
                <nav class="footer__nav footer__content">
                    <div class="footer__group">
                        <div class="footer__list">
                            <h3>Help</h3>
                            <%
                                var linkCustomerService = String.Format("{0}Customer-Service{1}", cov, ext);
                                var linkReturnPolicy = String.Format("{0}Return-Policy{1}", cov, ext);
                                var linkSitemap = String.Format("{0}Sitemap{1}", cov, ext);
                            %>
                            <ul class="list list--block">
                                <li><a href="tel:<%= csPhone %>"><%= csPhone %></a></li>
                                <li><a href="mailto:ideavillage@customerstatus.com">ideavillage@customerstatus.com</a></li>
                                <li><a href="<%= linkReturnPolicy %>">Returns/Exchange</a></li>
                                <li><a href="<%= linkCustomerService %>">Customer Care</a></li>
                                <li><a href="<%= linkSitemap %>">Sitemap</a></li>
                            </ul>
                        </div>
                        <% if (isFrontPage) { %>
                        <div class="footer__list">
                            <h3>Shop</h3>
                            <%
                                var hashShop = "#shop-copper-fit";
                                var linkShop = String.Format("{0}Index{1}{2}", cov, ext, hashShop);
                                var hashBestSellers = "#best-sellers";
                                var linkBestSellers = String.Format("{0}Index{1}{2}", cov, ext, hashBestSellers);
                            %>
                            <ul class="list list--block">
                                <li><a href="<%= linkBestSellers %>">Best Sellers</a></li>
                                <li><a href="<%= linkShop %>">Collections</a></li>
                            </ul>
                        </div>
                        <div class="footer__list">
                            <h3>Explore</h3>
                            <%
                                var linkExplore = String.Format("{0}Explore{1}", cov, ext);
                                var hashCFStories = "#copper-fit-stories";
                                var linkCFStories = isExplore ? hashCFStories : String.Format("{0}Explore{1}{2}", cov, ext, hashCFStories);
                                var linkCare = String.Format("{0}Care{1}", cov, ext);
                                var hashVideos = "#copper-fit-videos";
                                var linkVideos = isExplore ? hashVideos : String.Format("{0}Explore{1}{2}", cov, ext, hashVideos);
                            %>
                            <ul class="list list--block">
                                <li><a href="<%= linkVideos %>">Videos</a></li>
                                <li><a href="<%= linkCFStories %>">CF Stories</a></li>
                                <!-- hiding until we have page content
                                <li><a href="<%= linkCare %>">Copper Fit Cares</a></li> -->
                            </ul>
                        </div>
                        <div class="footer__list">
                            <h3>About Us</h3>
                            <%
                                var linkStory = String.Format("{0}Story{1}", cov, ext);
                                var linkBenefits = String.Format("{0}Benefits{1}", cov, ext);
                                var linkFAQ = String.Format("{0}FAQ{1}", cov, ext);
                                var linkContact = String.Format("{0}Contact{1}", cov, ext);
                            %>
                            <ul class="list list--block">
                                <li><a href="<%= linkStory %>">Our Story</a></li>
                                <li><a href="<%= linkBenefits %>">Benefits</a></li>
                                <li><a href="<%= linkFAQ %>">FAQs</a></li>
                                <!-- hiding until we have page content
                                <li><a href="<%= linkContact %>">Contact</a></li> -->
                            </ul>
                        </div>
                        <% } %>
                    </div>
                </nav>
            </div>
        </div>

        <div class="section__block footer__social">
            <nav class="footer__group">
                <a href="https://www.facebook.com/CopperFit/" target="_blank">
                    <picture class="contain contain--square social--facebook" data-src-img="/images/social/facebook.svg"></picture>
                </a>
                <a href="https://twitter.com/CopperFit" target="_blank">
                    <picture class="contain contain--square social--twitter" data-src-img="/images/social/twitter.svg"></picture>
                </a>
                <a href="https://www.pinterest.com/CopperFit/_created/" target="_blank">
                    <picture class="contain contain--square social--pinterest" data-src-img="/images/social/pinterest.svg"></picture>
                </a>
                <a href="https://www.instagram.com/copperfit/" target="_blank">
                    <picture class="contain contain--square social--instagram" data-src-img="/images/social/instagram.svg"></picture>
                </a>
            </nav>
        </div>

        <div class="section__block">
            <address class="footer__address">
                <%
                    var linkPrivacyPolicy = String.Format("{0}Privacy-Policy{1}", cov, ext);
                    var linkSecurityPolicy = String.Format("{0}Security-Policy{1}", cov, ext);
                %>
                &copy; <% Html.RenderPartial("Year", Model); %> Ideavillage Products Corp.
                <a href="<%= linkPrivacyPolicy %>">Privacy</a>
                <a href="<%= linkSecurityPolicy %>">Security</a>
                <a href="mailto:affmanager@digitaltargetmarketing.com?subject=Affiliate Program Inquiry&body=I'd like to learn more about your affiliate program!" title="Join Our Affiliate Program" class="c-list__link">Join Our Affiliate Program</a>

            </address>
        </div>
    </div>
</footer>