<%@ Page Language="C#" MasterPageFile="~/VersionViews/Views/Layouts/InternalLayout.master" Inherits="System.Web.Mvc.ViewPage<OrderPageViewData>" %>

<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server"></asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="MainContent" runat="server">

<%
    var productName = SettingsManager.ContextSettings["Label.ProductName", string.Empty];    
%>

<section aria-labelledby="benefits-main-title" class="view section fwp fwp--reverse fwp--flip">
  <div id="benefits-main" class="view__anchor"></div>
    <picture class="contain contain--photo-bar" data-src-img="/images/Benefits/Hero-1.jpg" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "/images/Benefits/Hero-1.jpg" }, { "media" : "(min-width: 600px)", "srcset" : "/images/Benefits/Hero-1.jpg" }], "img" : [{ "src" : "/images/Benefits/Hero-1.jpg" }]}'>
      <noscript>
          <img src="/images/Benefits/Hero-1.jpg" alt="Doing crunches with Copper Fit Socks">
      </noscript>
    </picture>
    <div class="fwp__overlay fwp__stage">
      <div class="fwp__content card card--headline">
          <h1 id="benefits-main-title" class="fwp__small-title">Copper Fit<sup>&reg;</sup><br />
              Benefits</h1>
          <div class="card__item">
            <h2><small>Copper Two Ways. Superior Protection.</small> Guaranteed.</h2>
            <p>When it comes to copper, we don't mess around. We knit our Copper Yarn into our fabrics and then we infuse the fabric with even more copper. You get 100% of the benefit of copper in two ways:  Copper Yarn that lives in the garment forever, and copper-infused to kill odor causing bacteria in the fabric.</p>
          </div>
      </div>
    </div>
</section>

<div class="defer defer--from-top">
    <div class="defer__progress">
        <section aria-labelledby="our-technologies-title" class="view section">
            <div id="our-technologies" class="view__anchor"></div>
            <div class="view__in section__in">
                <div class="section__block article section__contain-article">
                    <div class="title">
                        <h2 id="our-technologies-title" class="title__text">NEW TECHNOLOGIES. NEW MATERIALS. NEW WAYS OF IMPROVING PERFORMANCE.</h2>
                    </div>

                    <p>We are constantly innovating and bringing to market the latest technologies, materials, and fabrics &ndash; all designed to support aching joints and sore muscles that aid in recovery. We are always aiming higher - so you can too.</p>
                </div>

                <div class="section__block section__contain-article card card--icon-caption">
                  <div class="card__group">
                    <figure class="card__item">
                        <div class="card__group">
                        <picture class="contain contain--square" data-src-img="/images/symbols/copper-infused.svg"></picture>
                          <figcaption>
                            <span class="card__title">Copper Infused</span>
                            <p>
                              Manufactured with copper ions bound at the fiber level during the manufacturing process, our copper infusion process will not easily wash out or quickly wear away, and has been tested to remain effective for wash after wash.
                            </p>
                          </figcaption>
                        </div>
                    </figure>
                    <figure class="card__item">
                        <div class="card__group">
                            <picture class="contain contain--square" data-src-img="/images/symbols/compression.svg"></picture>
                          <figcaption>
                            <span class="card__title">Compression</span>
                            <p>
                              Our compression technology provides specific, targeted support for muscles and is designed to alleviate soreness and reduce recovery time so you can get more out of every workout or activity.
                            </p>
                          </figcaption>
                        </div>
                    </figure>
                    <figure class="card__item">
                        <div class="card__group">
                          <picture class="contain contain--square" data-src-img="/images/symbols/odor-reducing.svg"></picture>
                          <figcaption>
                            <span class="card__title">Odor Reducing</span>
                            <p>
                              Copper's natural properties provide protection against bacteria that can cause stains and odors
                            </p>
                          </figcaption>
                        </div>
                    </figure>
                    <figure class="card__item">
                        <div class="card__group">
                            <picture class="contain contain--square" data-src-img="/images/symbols/motion-activated.svg"></picture>
                            <figcaption>
                            <span class="card__title">Motion Activated</span>
                            <p>
                                Motion-Activated is the process by which friction, created through your action and movement, wears down, breaks, and releases a micro-encapsulated technology.
                            </p>
                            </figcaption>
                        </div>
                    </figure>
                    <figure class="card__item">
                        <div class="card__group">
                            <picture class="contain contain--square" data-src-img="/images/symbols/wicking.svg"></picture>
                            <figcaption>
                            <span class="card__title">Wicking</span>
                            <p>
                                Our material wicks sweat away from the body to help keep you dry and comfortable.
                            </p>
                            </figcaption>
                        </div>
                    </figure>
                    <figure class="card__item">
                        <div class="card__group">
                            <picture class="contain contain--square" data-src-img="/images/symbols/venting.svg"></picture>
                            <figcaption>
                            <span class="card__title">Venting</span>
                            <p>
                                Our Venting technology is a purposeful design element that creates a small window, an escape route, for the build-up of body heat.
                            </p>
                            </figcaption>
                        </div>
                    </figure>
                    <figure class="card__item">
                        <div class="card__group">
                              <picture class="contain contain--square" data-src-img="/images/symbols/heat-cell.svg"></picture>
                              <figcaption>
                                <span class="card__title">Heat Cell</span>
                                <p>
                                  A proprietary thermal-regulating fabric finish designed to help dissipate body heat while speeding up the evaporation of sweat and providing a comfortable, all-day wear.
                                </p>
                              </figcaption>
                        </div>
                    </figure>
                    <figure class="card__item">
                        <div class="card__group">
                            <picture class="contain contain--square" data-src-img="/images/symbols/micro-encapsulated.svg"></picture>
                              <figcaption>
                                <span class="card__title">Micro-Encapsulated</span>
                                <p>
                                    A patented technology in which an active health and wellness ingredient is individually encapsulated at a micro-level to produce thousands of beads that are then infused into our yarn.
                                </p>
                              </figcaption>
                        </div>
                    </figure>
                    <figure class="card__item">
                        <div class="card__group">
                            <picture class="contain contain--square" data-src-img="/images/symbols/cooling.svg"></picture>
                            <figcaption>
                            <span class="card__title">Cooling</span>
                            <p>
                                Our cooling technology is a fabric finish that helps keep the product consistently cool to the touch.
                            </p>
                            </figcaption>
                        </div>
                    </figure>
                    <figure class="card__item">
                        <div class="card__group">
                            <picture class="contain contain--square" data-src-img="/images/symbols/shock-absorbing.svg"></picture>
                          <figcaption>
                            <span class="card__title">Shock Absorbing</span>
                            <p>
                              A technology or design element that will provide added cushioning to aid in the absorption of impact. Used primarily in footwear such as socks, insoles, and shoes.
                            </p>
                          </figcaption>
                        </div>
                    </figure>
                  </div>
                </div>
            </div>
        </section>

        <section aria-labelledby="benefits-banner-title" class="view section fwp fwp--reverse">
          <div id="benefits-banner" class="view__anchor"></div>
            <picture class="contain contain--photo-bar-thin" data-src-img="/images/Benefits/Hero-2.jpg" data-tag='{ "source" : [{ "media" : "(max-width: 600px)", "srcset" : "/images/Benefits/Hero-2.jpg" }, { "media" : "(min-width: 600px)", "srcset" : "/images/Benefits/Hero-2.jpg" }], "img" : [{ "src" : "/images/Benefits/Hero-2.jpg" }]}'>
              <noscript>
                  <img src="/images/Benefits/Hero-2.jpg" alt="Doing yoga and stretching">
              </noscript>
            </picture>
            <div class="fwp__overlay fwp__stage">
              <div class="fwp__content">
                  <h1 id="benefits-banner-title" class="fwp__small-title">Copper Fit<sup>&reg;</sup> <br>LIVE LIMITLESS</h1>
              </div>
            </div>
        </section>

        <section aria-labelledby="copper-compression-title" class="view section">
            <div id="copper-compression" class="view__anchor"></div>
            <div class="view__in section__in">
                <div class="section__block section__contain-article article">
                    <p id="copper-compression-title">Millions of people, from extreme athletes to everyday people, have already benefited from Copper Fit&reg; products. We are motivated by the idea of living in a world with less pain and increased mobility.</p>
                </div>

                <div class="section__block section__contain-article card card--dropdown">
                  <div class="card__group">
                    <div class="card__item expando dropdown">
                        <button type="button" class="dropdown__toggle expando__toggle">
                            <div class="card__title dropdown__title">
                                <span>Copper</span>
                                <span class="dropdown__icon expando__icon"></span>
                            </div>
                        </button>
                        <div class="dropdown__content card__content expando__content">
                            <div class="dropdown__copy card__copy expando__copy">
                                <p>For thousands of years people have appreciated copper's many natural properties. Ancient Egyptians, Romans, and Aztecs used copper for many purposes[1], and it is known to possess properties that protect against odors and other benefits.</p>
                                <ul>
                                    <li>Copper's natural properties provide protection against bacteria that can cause stains, odors and deterioration of the product. Copper is more effective than stainless steel or silver containing coatings</li>
                                    <li>Essential nutrient for the human body</li>
                                    <li>Non-sensitizing, and non-irritating to the skin; not harmful to people or the environment</li>
                                </ul>
                                <small><sup>1</sup>Gregor Grass, Christopher Rensing, and Marc Solioz, Metallic Copper as an Antimicrobial Surface, Applied Environmental Microbiology, 2011 March; 77(5): 1541-1547 and <a target="_blank" href="http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3067274/" id="benefits-copper-ncbi">http://www.ncbi.nlm.nih.gov/pmc/articles/PMC3067274/</a></small>
                            </div>
                        </div>
                    </div>
                    <div class="card__item expando dropdown">
                        <button type="button" class="dropdown__toggle expando__toggle">
                            <div class="card__title dropdown__title">
                                <span>Compression</span>
                                <span class="dropdown__icon expando__icon"></span>
                            </div>
                        </button>
                        <div class="dropdown__content card__content expando__content">
                            <div class="dropdown__copy card__copy expando__copy">
                                <p>Compression garments have long been known for providing muscle and circulatory support. Doctors often prescribe compression garments to help treat varicose veins, to avoid dangerous clots and thrombosis, to avoid blood pooling in the extremities, and to treat low blood pressure. Some studies indicate athletes can run longer with less pain, and recover faster. Many athletes and celebrities swear by their compression sleeves- claiming they have more energy, their muscles work more efficiently, and they avoid injury while exercising.<sup>2, 3, 4, 5, 6, 7</sup></p>
                                <p>Our compression garments may help</p>
                                <ul>
                                    <li>Provide support for muscle stiffness, soreness, and pain</li>
                                    <li>Reduce recovery time of muscles</li>
                                    <li>Support improved circulation and oxygenation of working muscles</li>
                                    <li>Prevent strain and fatigue by keeping muscles warm</li>
                                </ul>
                                <p>Compression garments are only effective when they are being worn and properly sized.</p>
                                <div class="footnote">
			                        <small><sup>2</sup> Born D.P., Sperlich B., Holmberg H.C., Bringing Light into the Dark: Effects of Compression Clothing on Performance and Recovery, International Journal of Sports Physiology and Performance, 2013 Jan;8(1):4-18</small>
			                        <small><sup>3</sup> Trenell M.I., Rooney K.B., Sue C.M,, Thompson C.H., Compression Garments and Recovery from Eccentric Exercise: A 31P-MRS Study, Journal of Sports Science and Medicine (2006) 5, 106-114, published March 2006
			                        </small>
                                    <small><sup>4</sup> Duffield R, Edge J, Merrells R, Hawke E, Barnes M, Simcock D, Gill N., The Effects of Compression Garments on Intermittent Exercise Performance and Recovery on Consecutive Days, International Journal of Medicine and Sports Physiology and Performance, 2008, 3, 454-468</small>
			                        <small><sup>5</sup> Driller M.W., Halson S.L., (2013), The effects of lower-body compression garments on recovery between exercise bouts in highly-trained cyclists, Journal of Science and Cycling, 1(2): 45-50</small>
			                        <small><sup>6</sup> Kraemer W.J., Volek J.S., Bush J.A., Gotshalk L.A., Wagner P.R., Mazzetti S.A., Selle B.J., Influence of compression hosiery on physiological responses to standing fatigue in women, Medicine &amp; Science in Sports &amp; Exercise (2000) 2, 0195-9131/00/3211-1849/0, 1849-1858</small>
			                        <small><sup>7</sup> Jakeman, J.R., C. Byrne, R.G. Eston. 2010. &ldquo;Lower limb compression garment improves recovery from exercise- induced muscle damage in young, active females.&rdquo; European Journal of Applied Physiology, 109(6):1137-44.</small>
		                        </div>
                            </div>
                        </div>
                    </div>
                  </div>
                </div>
            </div>
        </section>

        <section aria-labelledby="real-customer-stories-title" class="view section bg bg--image bg--dark">
            <picture class="bg__image" data-src-img="/images/section-bg-blue.jpg"></picture>
            <div class="view__in section__in">
                <div class="section__block carousel carousel--expand slide slide--no-scrollbar">
                    <nav aria-label="Previous and next slides for more Copper Fit benefits" class="carousel__nav slide__nav">
                        <button
                            id="benefit-quotes-slide-prev"
                            aria-label="Select the previous slide"
                            class="slide__prev"
                            type="button">
                            <svg class="icon icon--chevron">
                                <use href="#icon-chevron"></use></svg>
                        </button>
                        <button
                            id="benefit-quotes-slide-next"
                            aria-label="Select the next slide"
                            class="slide__next"
                            type="button">
                            <svg class="icon icon--chevron">
                                <use href="#icon-chevron"></use></svg>
                        </button>
                    </nav>
                    <div id="benefit-quotes-carousel" class="carousel__into slide__into">
                        <div class="carousel__item slide__item">
                            <blockquote class="carousel__view quote">
                                <p>"It doesn't matter if you're hurt or not, you got to get through the aches and the pains and something like compression can be the difference. There's no reason why not to give it a try. It's revolutionary."</p>
                            </blockquote>
                        </div>
                        <div class="carousel__item slide__item">
                            <blockquote class="carousel__view quote">
                                <p>"If <%= productName %> can help you reach your next goal, why not? Because it's here to help you and it will. It's remarkable!"</p>
                            </blockquote>
                        </div>
                        <div class="carousel__item slide__item">
                            <blockquote class="carousel__view quote">
                                <p>"I don't work without it. I rely on it. I'm wearing <%= productName %> knee sleeves because it works for me and I need that."</p>
                            </blockquote>
                        </div>
                        <div class="carousel__item slide__item">
                            <blockquote class="carousel__view quote">
                                <p>"The more I move it feels better and better. I haven't experienced anything like this."</p>
                            </blockquote>
                        </div>
                        <div class="carousel__item slide__item">
                            <blockquote class="carousel__view quote">
                                <p>"When you put it on, wow, the compression. It's great to find something that actually works. I haven't felt this good in years! You can't ask for anything better than that."</p>
                            </blockquote>
                        </div>
                        <div class="carousel__item slide__item">
                            <blockquote class="carousel__view quote">
                                <p>"It holds your head and neck in an aligned position so you can have a good nights rest all night long."</p>
                            </blockquote>
                        </div>
                        <div class="carousel__item slide__item">
                            <blockquote class="carousel__view quote">
                                <p>"You spend a third of your life laying your head on a pillow. So why would you not have the best pillow you can possibly get?"</p>
                            </blockquote>
                        </div>
                        <div class="carousel__item slide__item">
                            <blockquote class="carousel__view quote">
                                <p>"You need total control of your hands when you are doing anything with construction. Your hands are your livelihood. The <%= productName %> gloves are great! The grip is outstanding with the different ribs. Makes my hands a lot more useable. It just feels like you're ready to start the job!"</p>
                            </blockquote>
                        </div>
                        <div class="carousel__item slide__item">
                            <blockquote class="carousel__view quote">
                                <p>"The gloves have been a game changer for me. They help with flexibility, pain and soreness. They allow me to do my job even better!"</p>
                            </blockquote>
                        </div>
                        <div class="carousel__item slide__item">
                            <blockquote class="carousel__view quote">
                                <p>"Being a SWAT commander, we train to win. The <%= productName %> Energy Socks, they didn't feel like other compression socks. It totally exceeded my expectations."</p>
                            </blockquote>
                        </div>
                    </div>
                </div>
            </div>
        </section>

        <section aria-labelledby="backed-by-science-title" class="view section">
            <div id="backed-by-science" class="view__anchor"></div>
            <div class="view__in section__in section__in--small">
                <div class="section__block title">
                    <picture class="title__picture contain contain--logo" data-src-img="/images/logos/swoosh.svg"></picture>
                    <h2 id="backed-by-science-title">Backed By Science</h2>
                </div>

                <div class="section__block card card--excerpt section__contain-article">
                  <div class="card__group">
                    <article class="card__item">
                      <span id="study-title-1" class="card__title">Metallic Copper as an Antimicrobial Surface.</span>
                      <span class="card__source">Applied Environmental Microbiology</span>
                      <p>&ldquo;Bacteria, yeasts, and viruses are rapidly killed on metallic copper surfaces, and the term &ldquo;contact killing&rdquo; has been coined for this process.&rdquo; <a id="study-1" target="_blank" aria-labelledby="study-title-1" href="/documents/Metalic Copper as an Antimicrobial.pdf">Read More</a></p>
                    </article>
                    <article class="card__item">
                      <span id="study-title-2" class="card__title">Bringing Light into the Dark.</span>
                      <span class="card__source">Journal of Sports Physiology & Performance</span>
                      <p>&ldquo;To assess original research addressing the effect of the application of compression clothing on sport performance and recovery after exercise, a computer-based literature research was performed during July 2011 using the electronic databases PubMed, MEDLINE, SPORTDiscus and Web of Science.&rdquo; <a id="study-2" target="_blank" aria-labelledby="study-title-2" href="/documents/Bringing Light into the Dark_Effects of Compression.pdf">Read More</a></p>
                    </article>
                    <article class="card__item">
                      <span id="study-title-3" class="card__title">Compression Garments & Recovery from Eccentric Exercise.</span>
                      <span class="card__source">Journal of Sports Science & Medicine</span>
                      <p>&ldquo;The low oxidative demand and muscular adaptations accompanying eccentric exercise hold benefits for both healthy and clinical populations.&rdquo; <a id="study-3" target="_blank" aria-labelledby="study-title-3" href="/documents/Compression and Recovery from Exercise_downhill walking.pdf">Read More</a></p>
                    </article>
                    <article class="card__item">
                      <span id="study-title-4" class="card__title">The Effects of Compression Garments on Intermittent Exercise Performance & Recovery on Consecutive Days.</span>
                      <span class="card__source">Journal of Medicine, Sports Physiology & Performance</span>
                      <p>&ldquo;The aim of this study was to determine whether compression garments improve intermittent-sprint performance and aid performance or self-reported recovery from high-intensity efforts on consecutive days.&rdquo; <a id="study-4" aria-labelledby="study-title-4" target="_blank" href="/documents/Compression and Recovery_Intermittent Exercise.pdf">Read More</a></p>
                    </article>
                    <article class="card__item">
                      <span id="study-title-5" class="card__title">The Effects of Lower-Body Compression Garments on Recovery Between Exercise bouts in Highly-Trained Cyclists.</span>
                      <span class="card__source">Journal of Science & Cycling</span>
                      <p>&ldquo;The use of compression garments as a recovery strategy has become popular amongst athletes.&rdquo; <a id="study-5" aria-labelledby="study-title-5" target="_blank" href="/documents/Lower Body Compression_Recovery.pdf">Read More</a></p>
                    </article>
                    <article class="card__item">
                      <span id="study-title-6" class="card__title">Influence of Compression Hosiery on Physiological Responses To Standing Fatigue in Women.</span>
                      <span class="card__source">Medicine & Science in Sports & Exercise </span>
                      <p>&ldquo;Influence of compression hosiery on physiological responses to standing fatigue in women.&rdquo; <a id="study-6" aria-labelledby="study-title-6" target="_blank" href="/documents/Compression-Influence_Standing Fatigue.pdf">Read More</a></p>
                    </article>
                  </div>
                </div>
            </div>
        </section>

    </div>
</div>

</asp:Content>
