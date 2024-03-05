<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<ClientSiteViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>

<%
    // figure out which type of banner we want to render
    var type = ViewData["type"] as string ?? string.Empty;

    // map to the hero image file using the type code
    var imageDirectory = String.Format("/images/products/{0}/hero", type);
    var landscapeImage = String.Format("{0}/banner-landscape.jpg", imageDirectory);
    var portraitImage = String.Format("{0}/banner-portrait.jpg", imageDirectory);
    var productLogo = String.Format("{0}/product-logo.png", imageDirectory);
%>

<section aria-labelledby="main-title" class="view section fwp hero bg bg--dark">
    <% var heroBreakpoint = "1200"; %>
    <picture class="contain contain--hero-banner hero__bg">
        <source media="(max-width: <%= heroBreakpoint %>px)" srcset="<%= portraitImage %>" />
        <source media="(min-width: <%= heroBreakpoint %>px)" srcset="<%= landscapeImage %>" />
        <img src="<%= landscapeImage %>" alt="">
    </picture>
    <div class="fwp__overlay fwp__stage">
        <div class="fwp__content hero__content">
            <%
                var isAngel = String.Equals(type, "GDQ_ANGEL", StringComparison.InvariantCultureIgnoreCase);
                var isBackPro = String.Equals(type, "GDQ_BACKPRO", StringComparison.InvariantCultureIgnoreCase);
                var isFacePro = String.Equals(type, "GDQ_FACEPRO", StringComparison.InvariantCultureIgnoreCase);
                var isGloves = String.Equals(type, "GDQ_GLOVES", StringComparison.InvariantCultureIgnoreCase);
                var isHandPro = String.Equals(type, "GDQ_HANDPRO", StringComparison.InvariantCultureIgnoreCase);
                var isIce = String.Equals(type, "GDQ_ICE", StringComparison.InvariantCultureIgnoreCase);
                var isPlusSocks = type.StartsWith("GDQ_PLUSSOCKS");
                var isRapidRelief = String.Equals(type, "GDQ_RAPIDRELIEF", StringComparison.InvariantCultureIgnoreCase);
                var isSleeves = String.Equals(type, "GDQ_SLEEVES", StringComparison.InvariantCultureIgnoreCase);
                var isSocks = String.Equals(type, "GDQ_SOCKS", StringComparison.InvariantCultureIgnoreCase);
                var isLostMask = type.StartsWith("GDQ_LOSTMASK");
                var isRRAnkle = type.StartsWith("GDQ_RRANKLE");
                var isRRKnee = type.StartsWith("GDQ_RRKNEE");
                var isRRShoulder = type.StartsWith("GDQ_RRSHOULDER");
                var isRRWrist = type.StartsWith("GDQ_RRWRIST");

                var isMensShortSleeve = String.Equals(type, "GDX_MC", StringComparison.InvariantCultureIgnoreCase);
                var isWomensShortSleeve = String.Equals(type, "GDX_WC", StringComparison.InvariantCultureIgnoreCase);
                var isWomensLeggings = String.Equals(type, "GDX_WL", StringComparison.InvariantCultureIgnoreCase);
                var isMensLongSleeve = String.Equals(type, "GDX_MLC", StringComparison.InvariantCultureIgnoreCase);
                var isMensPolo = String.Equals(type, "GDX_MP", StringComparison.InvariantCultureIgnoreCase);
                var isMensQuarter = String.Equals(type, "GDX_MQZ", StringComparison.InvariantCultureIgnoreCase);

                var productLogoClass = string.Format("contain--product-logo-{0}", type.Replace("_", "-").ToLower());

                if (productLogoClass.StartsWith("contain--product-logo-gdq-plussocks")) {
                    productLogoClass = "contain--product-logo-gdq-plussocks";
                }

                if (productLogoClass.StartsWith("contain--product-logo-gdq-lostmask")) {
                    productLogoClass = "contain--product-logo-gdq-lostmask";
                }

                var title = string.Empty;

                if (isAngel) {
                    title = string.Format(@"
                    <small>NEW POSTURE PILLOW<br>
                    FOR BACK AND SIDE SLEEPERS</small>
                    ");
                }

                if (isBackPro) {
                    title = string.Format(@"
                    <small>#1 Best Selling<br>
                    Compression <br />Back Support</small>
                    ");
                }

                if (isFacePro) {
                    title = string.Format(@"
                    <small>THE ULTIMATE<br>
                    CoPPER-INFUSED<br />FULL FACE PROTECTOR</small>
                    ");
                }

                if (isGloves) {
                    title = string.Format(@"
                    <small>DESIGNED TO SUPPORT
                    <br />WRIST, PALMS & FINGERS</small>
                    ");
                }

                if (isHandPro) {
                    title = string.Format(@"
                    <small>THE ULTIMATE<br>
                    CoPPER-INFUSED<br />HAND PROTECTOR</small>
                    ");
                }

                if (isIce) {
                    title = string.Format(@"
                    <small>INFUSED WITH
                    <br />MICRO-ENCAPSULATED<br>
                    MENTHOL & CoQ10</small>
                    ");
                }

                if (isPlusSocks || isSocks) {
                    title = string.Format(@"
                    <small>EASY ON/EASY OFF
                    <br>GRADUATED COMPRESSION SOCK
                    <br>PLUS HYDRATING
                    </small>
                    ");
                }

                if (isRapidRelief) {
                    title = string.Format(@"
                    <small>HOT+COLD THERAPY<br />WITH LUMBAR SUPPORT</small>
                    ");
                }

                if (isRRAnkle) {
                    title = string.Format(@"
                    <small>HOT+COLD THERAPY<br />TO KEEP YOU ON YOUR FEET</small>
                    ");
                }

                if (isRRKnee) {
                    title = string.Format(@"
                    <small>HOT+COLD THERAPY<br />FOR YOUR KNEE</small>
                    ");
                }

                if (isRRShoulder) {
                    title = string.Format(@"
                    <small>HOT+COLD THERAPY<br />FOR YOUR SHOULDER</small>
                    ");
                }

                if (isRRWrist) {
                    title = string.Format(@"
                    <small>HOT+COLD THERAPY<br />FOR YOUR WRIST</small>
                    ");
                }

                if (isSleeves) {
                    title = string.Format(@"
                    <small><br /></small>
                    ");
                }

                if (isLostMask) {
                    title = string.Format(@"
                    <small>NEVER LOSE YOUR<br /> FACE MASK AGAIN!</small>
                    ");
                }

                if (isMensShortSleeve) {
                    title = string.Format(@"
                    <small>ENERGY MEN'S DRY<br /> PERFORMANCE <br /> CREW T-SHIRT</small>
                    ");
                }

                if (isWomensShortSleeve) {
                    title = string.Format(@"
                    <small>ENERGY WOMEN'S<br /> SHORT SLEEVE <br /> CREW T-SHIRT</small>
                    ");
                }

                if (isWomensLeggings) {
                    title = string.Format(@"
                    <small>WOMEN'S FULL-LENGTH<br /> LEGGINGS FOR EVERYDAY,<br /> ALL ACTIVITY WEAR</small>
                    ");
                }

                if (isMensLongSleeve) {
                    title = string.Format(@"
                    <small>ENERGY MEN'S DRY<br /> PERFORMANCE LONG<br /> SLEEVE CREW</small>
                    ");
                }

                if (isMensPolo) {
                    title = string.Format(@"
                    <small>ENERGY MEN'S<br /> DRY PERFORMANCE<br /> GOLF POLO SHIRT</small>
                    ");
                }

                if (isMensQuarter) {
                    title = string.Format(@"
                    <small>ENERGY MEN'S DRY<br /> PERFORMANCE<br /> QUARTER ZIP</small>
                    ");
                }

                var isApparel = type.StartsWith("GDX"); 

                if (isApparel) { 
                    productLogo = "/images/logos/copper-fit-white.svg";
                    productLogoClass = "contain--logo-white"; 
                } 
            %>

           <picture class="contain <%= productLogoClass %> bg__ignore-picture hero__reveal-content" data-src-img="<%= productLogo %>">
            </picture>
            
            <hr />
            <h1 id="main-title" class="fwp__small-title hero__reveal-content">
                <%= title %>
            </h1>
        </div>
    </div>
</section>