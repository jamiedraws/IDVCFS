<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

 <%
  var customerServiceNumber = SettingsManager.ContextSettings["CustomerService.PhoneNumber", string.Empty];
  var customerServiceEmail = SettingsManager.ContextSettings["CustomerService.EmailAddress", string.Empty];
  var hoursOfService = SettingsManager.ContextSettings["CustomerService.HoursOfService", string.Empty];
  var refundDays = SettingsManager.ContextSettings["CustomerService.RefundDays", string.Empty];
  var productAttributeName = SettingsManager.ContextSettings["Label.ProductName", string.Empty];
  var productName = productAttributeName;
  var productNameHtmlEntity = "Copper Fit<sup>&reg;</sup>";
  var brandName = SettingsManager.ContextSettings["Label.BrandName", string.Empty];
%>

 <section aria-label="Frequently Asked Questions" class="view section defer">
    <div id="faq" class="view__anchor"></div>
    <div class="view__in section__in defer__progress">
        <div class="section__block title">
            <picture class="title__picture contain contain--logo bg__ignore-picture" data-src-img="/images/logos/swoosh.svg"></picture>
            <h2 id="faq-title" class="title__text">FAQ<span class="title__small">S</span></h2>
        </div>

        <div class="section__block section__contain-article card card--dropdown card--faq">
            <div class="card__group">
                <div class="card__item expando dropdown">
                    <button type="button" class="dropdown__toggle expando__toggle">
                        <div class="card__title dropdown__title">
                            <span>Is <%= productNameHtmlEntity %> right for me?</span>
                            <span class="dropdown__icon card__icon expando__icon"></span>
                        </div>
                    </button>
                    <div class="dropdown__content card__content expando__content">
                        <div class="dropdown__copy card__copy expando__copy">
                            <p><%= productName %> copper-infused compression sleeves are designed for the average person to the accomplished athlete. Anyone seeking support for muscle soreness, aches and pains, or support for improved circulation and recovery time of muscles can use <%= productName %>. They are comfortable and lightweight.</p>
                        </div>
                    </div>
                </div>

                <div class="card__item expando dropdown">
                    <button type="button" class="dropdown__toggle expando__toggle">
                        <div class="card__title dropdown__title">
                            <span>How quickly will I feel the benefits of wearing <%= productNameHtmlEntity %> compression sleeves?</span>
                            <span class="dropdown__icon card__icon expando__icon"></span>
                        </div>
                    </button>
                    <div class="dropdown__content card__content expando__content">
                        <div class="dropdown__copy card__copy expando__copy">
                            <p>Everyone is different and just like all injuries, soreness, and aches and pains vary in degree. How much time it takes to feel a benefit in wearing a <%= productName %> compression sleeve can range from almost immediately to a gradual improvement over an extended period of time. Remember, compression sleeves are only beneficial when they are worn and when properly sized. <%= productName %> compression sleeves offer the highest quality copper-infusion and comfort fit to allow for extended wear.</p>
                        </div>
                    </div>
                </div>

                <div class="card__item expando dropdown">
                    <button type="button" class="dropdown__toggle expando__toggle">
                        <div class="card__title dropdown__title">
                            <span>When should I wear a <%= productNameHtmlEntity %> compression sleeve?</span>
                            <span class="dropdown__icon card__icon expando__icon"></span>
                        </div>
                    </button>
                    <div class="dropdown__content card__content expando__content">
                        <div class="dropdown__copy card__copy expando__copy">
                            <p><%= productName %> compression sleeves can be worn anytime. The Knee Sleeve may be helpful when you are working out, running, walking, or standing for extended periods. The Elbow sleeve may be helpful when you are using your arms for lifting or repetitive movements. Wearing a compression sleeve when you're most active may help stabilize and support muscles and promote circulation. But <%= productName %> can be worn when inactive, too, as compression sleeves help keep your muscles warm and may help provide support for pain and soreness. Remember, compression products are only beneficial when they are being worn &ndash; and you can wear <%= productName %> anytime, anywhere.</p>
                        </div>
                    </div>
                </div>

                <div class="card__item expando dropdown">
                    <button type="button" class="dropdown__toggle expando__toggle">
                        <div class="card__title dropdown__title">
                            <span>What is <%= productNameHtmlEntity %>?</span>
                            <span class="dropdown__icon card__icon expando__icon"></span>
                        </div>
                    </button>
                    <div class="dropdown__content card__content expando__content">
                        <div class="dropdown__copy card__copy expando__copy">
                              <p><%= productName %> is a copper-infused compression garment designed to help stabilize and support muscles, provide support for pain, stiffness, and soreness, as well as aid in recovery and performance by supporting improved circulation and oxygenation. <%= productName %> is:</p>
                              <ul>
                                    <li>82% Polyester and 14% Spandex Jersey and 4% Copper Ion Fiber with high-wicking modacrylic fiber composition</li>
                                    <li>The natural properties of copper help protect the garment from bacteria which cause odors and stains</li>
                                    <li>Anti-static and Anti-pilling</li>
                              </ul>
                              <p>
                                <strong>CAUTION</strong> <br>
                                This product contains silicone on the inside of the upper elastic band, which may cause skin irritation. If you experience any irritation or discomfort, discontinue use.
                              </p>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
</section>