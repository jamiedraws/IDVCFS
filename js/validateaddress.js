function acceptClick(e) {
    e.preventDefault();
    validateForm(e);
    qasValidateAddress();
}

var __isShippingValid = false;
var __c = false;
var __cType;
var disableAvsUpdateAddress = false;
var __OnlyValidateWhenDifferent = false;
var __IgnoreAddress2 = false;

function qasValidateAddress(refinement, refinementtype) {
    var isShippingValidatable = $('#ShippingIsDifferentThanBilling').is(':checked');

    if (isShippingValidatable && !__isShippingValid) {
        val_Address(refinement, refinementtype, 'Shipping');
    } else if (!__OnlyValidateWhenDifferent) {
        val_Address(refinement, refinementtype, 'Billing');
    } else {
        val_onComplete(true);
    }
}

function val_onComplete (executeClose) {

    $.facebox.close();

    triggerEvent('FORM_SUBMIT');

    $('form').submit();
};

function val_Address(refinement, refinementtype, addrType) {
    __ctype = addrType;
    if (refinement != undefined) {
        $('#' + addrType + refinementtype).val(refinement);
    }

    if (typeof __faceboxBillingMessageOverride == "string" && addrType == 'Billing') {
        $.facebox('<h1>' + __faceboxBillingMessageOverride + '</h1>');
    } else if (typeof __faceboxShippingMessageOverride == "string" && addrType == 'Shipping') {
        $.facebox('<h1>' + __faceboxShippingMessageOverride + '</h1>');
    } else {
        $.facebox('<h1>Verifying ' + addrType + ' address...</h1>');
    }

    try {
        $.ajax({
            type: "POST",
            url: '/Shared/Services/AddressVerificationService.ashx',
            data: {
                addr1: $('#' + addrType + 'Street').val(),
                addr2: $('#' + addrType + 'Street2').val(),
                city: $('#' + addrType + 'City').val(),
                state: $('#' + addrType + 'StateId').length > 0 ? $('#' + addrType + 'StateId').val() : $('#' + addrType + 'State').val(),
                country: $('#' + addrType + 'CountryId').length > 0 ? $('#' + addrType + 'CountryId').val() : $('#' + addrType + 'Country').val(),
                zip: $('#' + addrType + 'Zip').val(),
                refine: refinement,
                refinetype: refinementtype,
                addrType: addrType,
                c: __c ? 'C' : '',
                timestamp: new Date().getTime(),
                data: $('form').serialize()
            },
            success: function (data) {
                if (!data.Address) {
                    data = JSON.parse(data);
                }

                if (!disableAvsUpdateAddress) {
                    $('#' + data.AddrType + 'Zip').val(data.Address.Zip5);
                    $('#' + data.AddrType + 'City').val(data.Address.City);
                    $('#' + data.AddrType + 'Street').val(data.Address.Address2);
                    $('#' + data.AddrType + 'Street2').val(data.Address.Address1);
                    if ($('#' + data.AddrType + 'StateId').length > 0) {
                        $('#' + data.AddrType + 'StateId').val(data.Address.State);
                    } else {
                        $('#' + data.AddrType + 'State').val(data.Address.State);
                    }
                }

                $('#avsCP').hide();

                if (([7].indexOf(data.ValiadtionState) > -1) || (__IgnoreAddress2 &&  data.ValiadtionState == 5)) {
                    if (data.AddrType == 'Billing') {
                        val_onComplete(false);
                        return true;
                    } else {

	                    	if (!__OnlyValidateWhenDifferent) {
	                        __isShippingValid = true;
	                        __c = false;
	                        val_Address(null, null, 'Billing');
		                    }
		                    else{
		                    	val_onComplete(false);
		                    }
                    }
                }
                else if ([6].indexOf(data.ValiadtionState) > -1) {
                    $.facebox(data.Html);

                    $('#Refinement').val(data.RefineTarget);
                    $('#avsError').html(data.ErrorMessage);
                    $('#avsfieldtype').val(data.Field);

                    if (typeof __displayAvsTypeLabel == "undefined" || __displayAvsTypeLabel) {
                        $('#avstypelabel').html(__ctype);
                    }

                    _ValidationRunning = false;
                }
                else if ([4, 3, 2, 1].indexOf(data.ValiadtionState) > -1 || (!__IgnoreAddress2 && data.ValiadtionState == 5)) {
                    $.facebox(data.Html);
                    $('#Refinement').val(data.RefineTarget);
                    $('#avsError').html(data.ErrorMessage);
                    $('#avsfieldtype').val(data.Field);

                    if (typeof __displayAvsTypeLabel == "undefined" || __displayAvsTypeLabel) {
                        $('#avstypelabel').html(__ctype);
                    }

                    if (data.Field == 'State') {
                        $('#avsrefineContainer').html('<select id="Refinement" name="Refinement"></select>');
                        $('#Refinement').html($('#' + __ctype + 'State').html());
                    }
                    _ValidationRunning = false;
                    return false;
                }

            },
            error: function () {
                val_onComplete(true);
                return true;
            }
        });
    }
    catch (e) {
        val_onComplete(true);
        return true;
    }
}

function isEmptyValue(fieldvalue) {
    var str = fieldvalue.replace(/^\s\s*/, '').replace(/\s\s*$/, '');
    return str.length == 0;
}