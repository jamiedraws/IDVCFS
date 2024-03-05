<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>

<a class="animate button fancyboxme" href="#forgotmypassword" onclick="$('.fmp_email').val(''); $('.fmp_email_message').html('');">Forgot my password</a>

<style>
    #forgotmypassword { max-width: 400px; } 
    .fancybox-lock .fmp_email { 
        -webkit-box-sizing: border-box; -moz-box-sizing: border-box; box-sizing: border-box; width: 100%; 
        
    }
    .fancybox-lock .fmp_email_message { display: block; padding: 0.5em 0 0; text-align: center; }
</style>
<section id="forgotmypassword" style="display: none;">
    <fieldset>
        <legend class="FormHeadlineL">Forgot Password<br /><small>Please enter your email address</small></legend>
        <input type="email" class="fmp_email" placeholder="Email" />
        <label class="fmp_email_message label"></label>
        <br />
        <a class="animate button" href="javascript:void(0);" onclick="fmp_handleSubmit(this);">Submit</a>
    </fieldset>
</section>
