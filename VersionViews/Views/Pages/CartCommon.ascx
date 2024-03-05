<%@ Control Language="C#" Inherits="System.Web.Mvc.ViewUserControl<Dtm.Framework.Base.Models.BaseClientViewData>" %>
<%@ Import Namespace="Dtm.Framework.ClientSites" %>
<%
    var enableAuthentication = SettingsManager.ContextSettings["Authentication.Enable", true];
%>

<%if (enableAuthentication)
  { %>

<script type="text/javascript">



    var ShoppingCart = function () {
        var self = this;
        var cf = { duration: 150, easing: "swing" }

        var customer = function (firstname, lastname, email) {
            var _self = this;
            this.FirstName = firstname;
            this.LastName = lastname;
            this.Email = email;
            this.HasAddresses = false;
            this.FullName = function () {
                return _self.FirstName + " " + _self.LastName;
            };
        };

        this.DefaultClearMessageTimeInMilliSeconds = 15 * 1000;
        this.Customer = null;

        this.tryEvent = function (dafunc, data) {
            if (dafunc != null && typeof dafunc == "function") {
                dafunc(data);
            }
        };

        this.Login = function (email, password, onLogin) {
            if (password == '' || email == '' || !(/^.*?[@].*?[.].*?$/g.test(email))) {
                updateMessage('.login_message', 'Please fill in your email and password.');
            } else {
                $.post('/Cart/Login/<%=DtmContext.PageCode%>',
                    { email: email, password: password, covid: '<%=DtmContext.VersionId%>' },
                    function (response) {
                        if (response.success) {
                            self.Customer = new customer(response.customer.firstName, response.customer.lastName, response.customer.email);
                        } else {
                            self.Customer = new customer('', '', '');
                        }

                        updateMessage('.login_message', response.message);
                        self.tryEvent(onLogin, response);
                    }, 'json');
            }
        };

        this.Logout = function (onLogout) {
            $.post('/Cart/Logout/<%=DtmContext.PageCode%>',
                { covid: '<%=DtmContext.VersionId%>' },
                function (response) {
                    if (response.success) {
                        self.Customer = null;
                    }

                    updateMessage('.logout_message', response.message);
                    self.tryEvent(onLogout, response);
                    self.tryEvent(self.onLoggedOut, response);
                }, 'json');
        };

        this.Register = function (firstname, lastname, phone, email, password, onRegister, onLogin) {
            if (firstname == '' || lastname == '' || phone == '' || password == '' || email == '' || !(/^.*?[@].*?[.].*?$/g.test(email))) {
                var errors = '';
                if (firstname == '') {
                    errors += 'First Name is missing.<br/>';
                }
                if (lastname == '') {
                    errors += 'Last Name is missing.<br/>';
                }
                if (phone == '' || !(/^(\d+[-])+$/g.test(phone))) {
                    errors += 'Phone Number is missing or invalid.<br/>';
                }
                if (password == '') {
                    errors += 'Password is missing.<br/>';
                }
                if (email == '' || !(/^.*?[@].*?[.].*?$/g.test(email))) {
                    errors += 'Email is missing or invalid.<br/>';
                }
                updateMessage('.register_message', errors);
            } else {
                $.post('/Cart/Register/<%=DtmContext.PageCode%>',
                    { firstname: firstname, lastname: lastname, phone: phone, email: email, password: password, covid: '<%=DtmContext.VersionId%>' },
                    function (response) {
                        if (response.success) {
                            self.Login(email, password, onLogin);
                        } else {
                            self.Customer = null;
                        }

                        updateMessage('.register_message', response.message);
                        self.tryEvent(onRegister, response);
                    }, 'json');
            }
        };
        <%--
        this.ViewAccount = function () {
            $('.account_edit').hide();
            $.post('/Cart/ViewAccount/<%=DtmContext.PageCode%>',
              { covid: '<%=DtmContext.VersionId%>' },
               function (response) {
                   if (response.success) {
                       $('.account_edit #account_firstName').val(response.customer.FirstName);
                       $('.account_edit #account_lastName').val(response.customer.LastName);
                       $('.account_edit #account_phone').val(response.customer.Phone);
                       if (response.customer.Gender)
                           $('.account_edit #account_gender').val(response.customer.Gender);
                       if (response.customer.DateOfBirth)
                           $('.account_edit #account_dob').val(response.customer.DateOfBirth);
                       if (response.customer.Title)
                           $('.account_edit #account_title').val(response.customer.Title);

                       $('.account_edit').show();
                       $('.account_update_form').show();
                   } else {
                       self.Init();
                   }
               }, 'json');
        };
    --%>
        <%--
        this.ViewSubscriptions = function () {
            $.post('/Cart/ViewSubscriptions/<%=DtmContext.PageCode%>',
             { covid: '<%=DtmContext.VersionId%>' },
               function (response) {
                   if (response.success) {

                   } else {

                   }
               }, 'json');
        };
    --%>

        this.ViewOrderHistory = function () {
            $('.account_order_history').hide();
            $.post('/Cart/ViewOrderHistory/<%=DtmContext.PageCode%>',
                { covid: '<%=DtmContext.VersionId%>' },
                function (response) {
                    var html = '';
                    $('.account_order_history tbody').html(html);
                    $('.account_order_history .total').html(html);
                    if (response.success) {
                        for (var i = 0; i < response.customerOrders.length; i++) {
                            var order = response.customerOrders[i];
                            html += '<tr>' +
                                '<td>' + order.date + '</td>' +
                                '<td>' + order.id + '</td>' +
                                '<td>' + order.totalC + '</td>' +
                                '<td class="' + order.id + 'Column"><button type="button" onclick="_shoppingCart.ViewOrder("' + order.id + '");">View Details</button></td>' +
                                '</tr>';
                        }
                        $('.account_order_history tbody').html(html);
                        $('.account_order_history .total').html(response.customerTotalSpentC);
                        $('.account_order_history').show();
                    } else {
                        self.Init();
                    }
                }, 'json');
        };

        <%--
        this.UpdateAccount = function () {
            var firstName = $('#account_firstName').val(),
                lastName = $('#account_lastName').val(),
                phone = $('#account_phone').val();
            //gender = $('#account_gender option:selected').val(),
            //dob = $('#account_dob').val(),
            //title = $('#account_title').val();

            $.post('/Cart/UpdateAccount/<%=DtmContext.PageCode%>',
               {
                   firstName: firstName,
                   lastName: lastName,
                   phone: phone,
                   //gender: gender,
                   //dob: dob,
                   //title: title,
                   covid: '<%=DtmContext.VersionId%>'
               },
                function (response) {
                    if (response.success) {
                        $('.account_edit').hide();
                    } else {
                        self.Init();
                    }
                }, 'json');
        };
    --%>
        this.ViewAddresses = function (onAddressLoaded) {
            $('.account_addresses').hide();
            $.post('/Cart/ViewAddresses/<%=DtmContext.PageCode%>',
                { covid: '<%=DtmContext.VersionId%>' },
                function (response) {
                    var html = '';
                    $('.account_addresses tbody').html(html);
                    if (response.success) {

                        if (response.customerBillingAddresses.length > 0) {
                            for (var i = 0; i < response.customerBillingAddresses.length; i++) {
                                var item = response.customerBillingAddresses[i];
                                html += '<tr>' +
                                    '<td><label for="' + item.Id + '">Billing</label></td>' +
                                    '<td>' +
                                    '<label for="' + item.Id + '" class="' + item.Id + '" style="line-height: initial;" >' +
                                    '<strong>' +
                                    response.firstName +
                                    ' ' +
                                    response.lastName +
                                    '</strong><br/> ' +
                                    response.phone +
                                    '<br/> ' +
                                    response.email +
                                    '<hr/> <i>' +
                                    item.Street +
                                    ' ' +
                                    item.Street2 +
                                    '<br/> ' +
                                    item.City +
                                    ', ' +
                                    item.State +
                                    ' ' +
                                    item.Zip +
                                    ' ' +
                                    item.Country +
                                    '</i></label>' +
                                    '<label class="' + item.Id + '" style="display: none;">' +
                                    '<p class="account_address_Billing_message"></p><label>' +
                                    '<input id="BillingFirstName" name="BillingFirstName" placeholder="*First Name:" type="text" value="' + response.firstName + '">' +
                                    '<input id="BillingLastName" name="BillingLastName" placeholder="*Last Name:" type="text" value="' + response.lastName + '">' +
                                    '<input id="Phone" name="Phone" placeholder="*Phone:" type="text" value="' + response.phone + '">' +
                                    '<input id="Email" name="Email" placeholder="*Email:" type="hidden" value="' + response.email + '">' +
                                    '<input id="BillingStreet" name="BillingStreet" placeholder="*Address:" type="text" value="' + item.Street + '">' +
                                    '<input id="BillingStreet2" name="BillingStreet2" placeholder="*Address 2:" type="text" value="' + item.Street2 + '">' +
                                    '<input id="BillingCity" name="BillingCity" placeholder="*City:" type="text" value="' + item.City + '">' +
                                    '<select id="BillingState" name="BillingState">' + _generateSelectOptions(states, item.State, 'Select State') + '</select>' +
                                    '<input id="BillingZip" name="BillingZip" placeholder="*Zip:" type="text" value="' + item.Zip + '">' +
                                    '<select id="BillingCountry" name="BillingCountry">' + _generateSelectOptions(countries, item.Country, 'Select Country') + '</select>' +
                                    '</label>' +
                                    '</td>' +
                                    '<td>' +
                                    '<a href="javascript:void(0);" onclick="$(\'.' + item.Id + '\').toggle();" class="' + item.Id + ' payment-btn payment-btn-update">Update</a>' +
                                    '<a href="javascript:void(0);" onclick="_shoppingCart.Address(\'U\', \'' + item.Id + '\', \'Billing\');" class="' + item.Id + ' payment-btn payment-btn-save" style="display: none;">Save</a><span class="' + item.Id + '" style="display: none;"> | </span>' +
                                    '<a href="javascript:void(0);" onclick="$(\'.' + item.Id + '\').toggle();" class="' + item.Id + ' payment-btn payment-btn-cancel" style="display: none;">Cancel</a>' +
                                    '</td>' +
                                    '</tr>';
                            }
                        } else {
                            html += '<tr>' +
                                '<td>Billing</td>' +
                                '<td>' +
                                '<p class="account_address_Billing_message"></p><label>' +
                                '<input id="BillingFirstName" name="BillingFirstName" placeholder="*First Name:" type="text" value="' + response.firstName + '">' +
                                '<input id="BillingLastName" name="BillingLastName" placeholder="*Last Name:" type="text" value="' + response.lastName + '">' +
                                '<input id="Phone" name="Phone" placeholder="*Phone:" type="text" value="' + response.phone + '">' +
                                '<input id="Email" name="Email" placeholder="*Email:" type="hidden" value="' + response.email + '">' +
                                '<input id="BillingStreet" name="BillingStreet" placeholder="*Address:" type="text" >' +
                                '<input id="BillingStreet2" name="BillingStreet2" placeholder="*Address 2:" type="text" >' +
                                '<input id="BillingCity" name="BillingCity" placeholder="*City:" type="text" >' +
                                '<select id="BillingState" name="BillingState">' + _generateSelectOptions(states, "", 'Select State') + '</select>' +
                                '<input id="BillingZip" name="BillingZip" placeholder="*Zip:" type="text" >' +
                                '<select id="BillingCountry" name="BillingCountry">' + _generateSelectOptions(countries, "", 'Select Country') + '</select>' +
                                '</label>  <hr/>' +
                                '<div>' +
                                '<input id="ShippingIsDifferentThanBilling" name="ShippingIsDifferentThanBilling" onchange="if(this.checked){$(\'.ShippingFields\').show();}else{$(\'.ShippingFields\').hide();}" type="checkbox" value="true" /> Ship to a different Address' +
                                '</div>' +
                                '</td>' +
                                '<td>' +
                                '<a href="javascript:void(0);" class="payment-btn payment-btn-save" onclick="_shoppingCart.Address(\'C\', null, \'Billing\');" >Save</a>' +
                                '</td>' +
                                '</tr>';
                        }

                        if (response.customerShippingAddresses.length > 0) {
                            for (var i = 0; i < response.customerShippingAddresses.length; i++) {
                                var item = response.customerShippingAddresses[i];
                                html += '<tr>' +
                                    '<td><label for="' + item.Id + '">Shipping</label></td>' +
                                    '<td>' +
                                    '<label for="' + item.Id + '" class="' + item.Id + '" style="line-height: initial;" ><i>' +
                                    item.Street +
                                    ' ' +
                                    item.Street2 +
                                    '<br/> ' +
                                    item.City +
                                    ', ' +
                                    item.State +
                                    ' ' +
                                    item.Zip +
                                    ' ' +
                                    item.Country +
                                    '</i></label>' +
                                    '<p class="account_address_Shipping_message"></p><label class="' + item.Id + '" style="display: none;">' +
                                    '<input id="ShippingFirstName" name="ShippingFirstName" placeholder="*First Name:" type="hidden" value="' + response.firstName + '">' +
                                    '<input id="ShippingLastName" name="ShippingLastName" placeholder="*Last Name:" type="hidden" value="' + response.lastName + '">' +
                                    '<input id="ShippingIsDifferentThanBilling" name="ShippingIsDifferentThanBilling" type="hidden" value="true">' +
                                    '<input id="ShippingStreet" name="ShippingStreet" placeholder="*Address:" type="text" value="' + item.Street + '">' +
                                    '<input id="ShippingStreet2" name="ShippingStreet2" placeholder="*Address 2:" type="text" value="' + item.Street2 + '">' +
                                    '<input id="ShippingCity" name="ShippingCity" placeholder="*City:" type="text" value="' + item.City + '">' +
                                    '<select id="ShippingState" name="ShippingState">' + _generateSelectOptions(states, item.State, 'Select State') + '</select>' +
                                    '<input id="ShippingZip" name="ShippingZip" placeholder="*Zip:" type="text" value="' + item.Zip + '">' +
                                    '<select id="ShippingCountry" name="ShippingCountry">' + _generateSelectOptions(countries, item.Country, 'Select Country') + '</select>' +
                                    '</label>' +
                                    '</td>' +
                                    '<td>' +
                                    '<a href="javascript:void(0);" onclick="$(\'.' + item.Id + '\').toggle();" class="' + item.Id + ' payment-btn payment-btn-update">Update</a>' +
                                    '<a href="javascript:void(0);" onclick="_shoppingCart.Address(\'U\', \'' + item.Id + '\', \'Shipping\');" class="' + item.Id + ' payment-btn payment-btn-save" style="display: none;">Save</a><span class="' + item.Id + '" style="display: none;"> | </span>' +
                                    '<a href="javascript:void(0);" onclick="$(\'.' + item.Id + '\').toggle();" class="' + item.Id + ' payment-btn payment-btn-cancel" style="display: none;">Cancel</a>' +
                                    '</td>' +
                                    '</tr>';
                            }

                            if (response.customerBillingAddresses.length > 0 && response.customerShippingAddresses.length > 0) {
                                self.Customer.HasAddresses = true;
                            } else {
                                self.Customer.HasAddresses = false;
                            }
                        } else {
                            html += '<tr class="ShippingFields" style="display:none;">' +
                                '<td>Shipping</td>' +
                                '<td>' +
                                '<p class="account_address_Shipping_message"></p><label>' +
                                '<input id="ShippingStreet" name="BillingStreet" placeholder="*Address:" type="text" >' +
                                '<input id="ShippingStreet2" name="BillingStreet2" placeholder="*Address 2:" type="text" >' +
                                '<input id="ShippingCity" name="BillingCity" placeholder="*City:" type="text" >' +
                                '<select id="ShippingState" name="BillingState">' + _generateSelectOptions(states, "", 'Select State') + '</select>' +
                                '<input id="ShippingZip" name="BillingZip" placeholder="*Zip:" type="text" >' +
                                '<select id="ShippingCountry" name="BillingCountry">' + _generateSelectOptions(countries, "", 'Select Country') + '</select>' +
                                '</label>' +
                                '</td>' +
                                '<td>' +
                                //'<a href="javascript:void(0);" onclick="_shoppingCart.Address(\'C\', null, \'Shipping\');" >Save</a>' +
                                '</td>' +
                                '</tr>';
                        }

                        $('.account_addresses tbody').html(html);
                        $('.account_addresses').show();

                        self.tryEvent(onAddressLoaded, response);
                    } else {
                        self.Init();
                    }
                }, 'json');
        };

        this.ViewCards = function () {
            $('.account_cards').hide();
            $.post('/Cart/ViewPaymentOptions/<%=DtmContext.PageCode%>',
                { covid: '<%=DtmContext.VersionId%>' },
                function (response) {
                    var html = '';
                    $('.account_cards tbody').html(html);
                    if (response.success) {
                        var defaultItem = null;
                        for (var i = 0; i < response.customerPaymentOptions.length; i++) {
                            var item = response.customerPaymentOptions[i];
                            html += '<tr>' +
                                '<td style="cursor: pointer;">' +
                                '<input type="radio" name="account_card" ' +
                                'id="' + item.Id + '" ' +
                                'value="' + item.Id + '" ' +
                                'data-CardType="' + item.CardType + '" ' +
                                'data-CardNumber="' + item.CardNumber + '" ' +
                                'data-CardExpirationMonth="' + item.ExpMonth + '" ' +
                                'data-CardExpirationYear="' + item.ExpYear + '" ' +
                                'data-CardCvv2="' + item.CardCvv2 + '" ' +
                                'onclick="_shoppingCart.SetPaymentOption(this);" ' +
                                (item.IsDefault ? ' checked="checked" ' : '') + '/>' +
                                (item.IsDefault ? ' (Default) ' : '') +
                                '</td>' +
                                '<td><label for="' + item.Id + '">' + item.CardType + '</label></td>' +
                                '<td><label for="' + item.Id + '">...' + item.CardNumber.slice(-4) + '</label></td>' +
                                '<td><label for="' + item.Id + '">' + item.ExpMonth + '/' + item.ExpYear + '</label></td>' +
                                '</tr>';
                            if (item.IsDefault) {
                                defaultItem = item;
                            }
                        }
                        $('.account_cards tbody').html(html);
                        if (response.customerPaymentOptions.length > 0) {
                            $('.account_add_card_form').hide();
                            $('.account_add_other_card').show();
                        }
                        $('.account_cards').show();
                        if (defaultItem != null) {
                            self.SetPaymentOption(document.getElementById(defaultItem.Id), false);
                        }
                    } else {
                        self.Init();
                    }
                }, 'json');
        };

        this.SetPaymentOption = function (ele, update) {
            $('#CardType').val($(ele).attr('data-CardType'));
            $('#CardNumber').val($(ele).attr('data-CardNumber'));
            $('#CardExpirationMonth').val($(ele).attr('data-CardExpirationMonth'));
            $('#CardExpirationYear').val($(ele).attr('data-CardExpirationYear'));
            $('#CardCvv2').val($(ele).attr('data-CardCvv2'));

            if (typeof update == "undefined" || update == null || update) {
                self.Card('SD', ele.id);
            }
        };

        this.Address = function (action, id, type, onSuccessfulAdd) {
            var payload = { action: action, id: id, covid: '<%=DtmContext.VersionId%>' };

            payload["type"] = type == "Shipping" ? "S" : "B";
            payload["firstname"] = $('#BillingFirstName').val();
            payload["lastname"] = $('#BillingLastName').val();
            payload["phone"] = $('#Phone').val();
            payload["email"] = $('#Email').val();
            payload["street"] = $('#' + type + 'Street').val();
            payload["street2"] = $('#' + type + 'Street2').val();
            payload["city"] = $('#' + type + 'City').val();
            payload["state"] = $('#' + type + 'State').val();
            payload["zip"] = $('#' + type + 'Zip').val();
            payload["country"] = $('#' + type + 'Country').val();


            if (action == 'C') {
                payload["ShippingIsDifferentThanBilling"] = $('#ShippingIsDifferentThanBilling').is(':checked');

                if ($('#ShippingIsDifferentThanBilling').is(':checked')) {
                    payload["shipToStreet"] = $('#ShippingStreet').val();
                    payload["shipToStreet2"] = $('#ShippingStreet2').val();
                    payload["shipToCity"] = $('#ShippingCity').val();
                    payload["shipToState"] = $('#ShippingState').val();
                    payload["shipToZip"] = $('#ShippingZip').val();
                    payload["shipToCountry"] = $('#ShippingCountry').val();

                    if (payload["shipToState"] == '') {
                        errors += 'Please select a shipping state.<br/>';
                    }

                    if (payload["shipToCountry"] == '') {
                        errors += 'Please select a shipping country.<br/>';
                    }
                } else {
                    payload["shipToStreet"] = payload["street"];
                    payload["shipToStreet2"] = payload["street2"];
                    payload["shipToCity"] = payload["city"];
                    payload["shipToState"] = payload["state"];
                    payload["shipToZip"] = payload["zip"];
                    payload["shipToCountry"] = payload["country"];
                }

                if (payload["shipToState"] == '') {
                    errors += 'Please select a billing state.<br/>';
                }

                if (payload["shipToCountry"] == '') {
                    errors += 'Please select a billing country.<br/>';
                }
            }

            var errors = '';
            if (payload["state"] == '') {
                errors += 'Please select a state.<br/>';
            }

            if (payload["country"] == '') {
                errors += 'Please select a country.<br/>';
            }

            if (errors.length > 0) {
                updateMessage('.account_address_' + type + '_message', errors, false);
            } else {
                $.post('/Cart/CustomerAddress/<%=DtmContext.PageCode%>',
                    payload,
                    function (response) {
                        if (response.success) {
                            self.ViewAddresses(onSuccessfulAdd);
                        } else {
                            updateMessage('.account_address_' + type + '_message', response.message);
                            self.Init();
                        }
                    }, 'json');
            }
        };

        this.Card = function (action, id, onAction) {
            var payload = { action: action, id: id, covid: '<%=DtmContext.VersionId%>' };

            if (action == 'C') {
                payload["nameoncard"] = $('#account_card_nameoncard').val();
                payload["number"] = $('#account_card_number').val();
                payload["cvv"] = $('#account_card_cvv').val();
                payload["month"] = $('#account_card_expirationMonth option:selected').val();
                payload["year"] = $('#account_card_expirationYear option:selected').val();
            }

            $.post('/Cart/Card/<%=DtmContext.PageCode%>',
                payload,
                function (response) {
                    if (response.success) {
                        if (action = 'C') {
                            $('#account_card_nameoncard').val('');
                            $('#account_card_number').val('');
                            $('#account_card_cvv').val('');
                            $('#account_card_expirationMonth option:selected').val('');
                            $('#account_card_expirationYear option:selected').val('');
                        }
                        self.ViewCards();
                    } else {
                        updateMessage('.account_card_message', response.message);
                        self.Init();
                    }
                    self.tryEvent(onAction, response);
                }, 'json');
        };
        <%--

        this.ViewChangePassword = function () {
            // show change password form
        };

        this.ViewChangeEmail = function () {
            // show change email form
        };

        this.ChangePassword = function (newPassword, confirmPassword, currentPassword) {
            $.post('/Cart/ChangePassword/<%=DtmContext.PageCode%>',
               {
                   newPassword: newPassword,
                   confirmPassword: confirmPassword,
                   currentPassword: currentPassword,
                   covid: '<%=DtmContext.VersionId%>'
               },
               function (response) {
                   if (response.success) {

                   } else {

                   }
               }, 'json');
        };

        this.ChangeEmail = function (newEmail, confirmEmail, currentEmail) {
            $.post('/Cart/ChangeEmail/<%=DtmContext.PageCode%>',
               {
                   newEmail: newEmail,
                   confirmEmail: confirmEmail,
                   currentEmail: currentEmail,
                   covid: '<%=DtmContext.VersionId%>'
               },
               function (response) {
                   if (response.success) {

                   } else {

                   }
               }, 'json');
        };

        this.UpdateSubscription = function (id) {
            $.post('/Cart/UpdateSubscription/<%=DtmContext.PageCode%>',
             {
                 id: id,
                 covid: '<%=DtmContext.VersionId%>'
             },
               function (response) {
                   if (response.success) {

                   } else {

                   }
               }, 'json');
        };

        this.ViewOrder = function (id) {
            $.post('/Cart/ViewOrder/<%=DtmContext.PageCode%>',
             {
                 id: id,
                 covid: '<%=DtmContext.VersionId%>'
             },
               function (response) {
                   if (response.success) {

                   } else {

                   }
               }, 'json');
        };
    --%>

        this.Init = function (onInit) {
            $.post('/Cart/AuthCheck/<%=DtmContext.PageCode%>',
                { covid: '<%=DtmContext.VersionId%>' },
                function (response) {
                    if (response.success) {
                        $('.logout_form').show();
                        $('.account_profile').show();
                        $('.login_form').hide();
                        $('.register_form').hide();
                        self.Customer = new customer('', '', '');
                    } else {
                        $('.logout_form').hide();
                        $('.account_profile').hide();

                        if ($("#loginAccountWrap").is(':visible')) {
                            showLoginForm();
                        } else {
                            $('.login_form').show();
                            $('.register_form').show();
                        }
                    }
                    self.tryEvent(onInit, response);
                }, 'json');
        };

        function updateMessage(target, message, postInit) {
            var enableSlide = !$(target).parent().is(':visible');
            if (enableSlide) {
                $(target).parent().slideDown(cf.duration, cf.easing);
            }
            if ($(target).length > 0) {
                $(target).html(message);
                setTimeout(function () {
                    $(target).html('');
                    if (enableSlide) {
                        $(target).parent().slideUp(cf.duration, cf.easing);
                    }
                }, self.DefaultClearMessageTimeInMilliSeconds);
                if (typeof postInit == "undefined" || postInit == null || postInit == true) {
                    self.Init();
                }
            } else {
                console.log(target + ': ' + message);
            }
        }

        var countries = new Array();
        <% foreach (var countryView in Model.Countries)
           {%>
        countries[countries.length] = { value: "<%=countryView.CountryCode %>", text: "<%=countryView.CountryName %>" };
        <% } %>
        var states = new Array();
        <% foreach (var stateView in Model.States)
           {%>
        states[states.length] = { country: "<%=stateView.CountryCode %>", value: "<%=stateView.StateCode %>", text: "<%=stateView.StateName %>" };
        <% } %>

        function _generateSelectOptions(array, selectedValue, defaultOption) {
            var optionHtml = '<option value="">' + defaultOption + '</option>';

            for (var i = 0; i < array.length; i++) {
                var item = array[i];
                if (item.value == selectedValue) {
                    optionHtml += '<option selected="selected" value="' + item.value + '">' + item.text + '</option>';
                } else {
                    optionHtml += '<option value="' + item.value + '">' + item.text + '</option>';
                }
            }
            return optionHtml;
        }
    };

    var _shoppingCart = new ShoppingCart();

</script>

<%-- 
    <form class="login_form" style="display: none;" onsubmit="event.preventDefault(); _shoppingCart.Login($('#LoginEmail').val(), $('#LoginPassword').val());">
        <input type="email" id="LoginEmail" required placeholder="Email" />
        <input type="password" id="LoginPassword" required placeholder="Password" />
        <p class="login_message"></p>
        <button type="submit">Login</button>
    </form>

    <form class="register_form" style="display: none;" onsubmit="event.preventDefault(); _shoppingCart.Register($('#RegisterFirstName').val(), $('#RegisterLastName').val(),$('#RegisterEmail').val(), $('#RegisterPassword').val());">
        <input type="text" id="RegisterFirstName" required placeholder="First Name" />
        <input type="text" id="RegisterLastName" required placeholder="Last Name" />
        <input type="text" id="RegisterEmail" required placeholder="Email" />
        <input type="password" id="RegisterPassword" required placeholder="Password" />
        <p class="register_message"></p>
        <button type="submit">Register</button>
    </form>

    <form class="logout_form" style="display: none;" onsubmit="event.preventDefault(); _shoppingCart.Logout();">
        <p class="logout_message"></p>
        <button type="submit">Logout</button>
    </form>

    <div class="account_profile" style="display: none;">
        <button type="button" onclick="_shoppingCart.ViewAccount();">Manage Account</button>
        <button type="button" onclick="_shoppingCart.ViewSubscriptions();">Manage Subscriptions</button>
        <button type="button" onclick="_shoppingCart.ViewOrderHistory();">View Order History</button>

        <div class="account_edit" style="display: none;">
            <form class="account_update_form" style="display: none;" onsubmit="event.preventDefault(); _shoppingCart.UpdateAccount();">
                <input type="text" id="account_firstName" required placeholder="First Name" />
                <input type="text" id="account_lastName" required placeholder="Last Name" />
                <input type="tel" id="account_phone" required placeholder="Phone" />
                <!--<select id="account_gender">
                    <option selected="selected">Select Gender</option>
                    <option value="M">Male</option>
                    <option value="F">Female</option>
                </select>
                <input type="date" id="account_dob" />
                <input type="text" id="account_title" placeholder="Title" />-->
                <button type="submit">Update</button>
            </form>

            <button type="button" onclick="_shoppingCart.ViewAddresses();">Manage Addresses</button>
            <button type="button" onclick="_shoppingCart.ViewCards();">Manage Cards</button>
            <button type="button" onclick="_shoppingCart.ViewChangePassword();">Change Password</button>
            <button type="button" onclick="_shoppingCart.ViewChangeEmail();">Change Email</button>

            <form class="account_add_address_form" style="display: none;" onsubmit="event.preventDefault(); _shoppingCart.AddAddress();">
            </form>
            <form class="account_edit_address_form" style="display: none;" onsubmit="event.preventDefault(); _shoppingCart.EditAddress();">
            </form>
            <form class="account_delete_address_form" style="display: none;" onsubmit="event.preventDefault(); _shoppingCart.DeleteAddress();">
            </form>
            <div class="account_addresses" style="display: none;">
                <table class="orderItemsTable">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <th>Address</th>
                            <th>Type</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>

            <div class="account_cards" style="display: none;">
                <form class="account_add_card_form" onsubmit="event.preventDefault(); _shoppingCart.Card('C');">
                    <input type="text" id="account_card_nameoncard" required placeholder="Name on Card" />
                    <input type="number" id="account_card_number" required placeholder="Card Number" />
                    <input type="number" id="account_card_cvv" required placeholder="Cvv" />
                    <select id="account_card_expirationMonth">
                        <option selected="selected">Select Month</option>
                        <option value="1">Jan</option>
                        <option value="2">Feb</option>
                        <option value="3">Mar</option>
                        <option value="4">Apr</option>
                        <option value="5">May</option>
                        <option value="6">Jun</option>
                        <option value="7">Jul</option>
                        <option value="8">Aug</option>
                        <option value="9">Sep</option>
                        <option value="10">Oct</option>
                        <option value="11">Nov</option>
                        <option value="12">Dec</option>
                    </select>
                    <select id="account_card_expirationYear">
                        <option selected="selected">Select Year</option>
                        <% foreach (var i in Enumerable.Range(DateTime.Now.Year, 10))
                           { %>
                        <option><%=i %></option>
                        <% } %>
                    </select>
                    <button type="submit">Add</button>
                </form>
                <table class="orderItemsTable">
                    <thead>
                        <tr>
                            <th>Name On Card</th>
                            <th>Number</th>
                            <th>Card Type</th>
                            <th>Expiration</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody></tbody>
                </table>
            </div>

            <form class="account_change_password_form" style="display: none;" onsubmit="event.preventDefault(); _shoppingCart.ChangePassword();">
            </form>
            <form class="account_change_email_form" style="display: none;" onsubmit="event.preventDefault(); _shoppingCart.ChangeEmail();">
            </form>
        </div>

        <div class="account_subscriptions" style="display: none;">
            <table class="orderItemsTable">
                <thead>
                    <tr>
                        <th>Subscription</th>
                        <th>Internval</th>
                        <th>Next Date</th>
                        <th>State</th>
                    </tr>
                </thead>
                <tbody>
                    <!-- 
                        <tr>
                        <td>[#ProductName#]</td>
                        <td>[#IntervalDetails#]</td>
                        <td>[#NextDate#]</td>
                        <td>[#State#] <button type="button" onclick="_shoppingCart.UpdateSubscription([#PauseOrUnPause#]);">Pause or Unpause</button></a></td>
                        </tr>
                        -->
                </tbody>
            </table>
        </div>

        <div class="account_order_history" style="display: none;">
            <table>
                <thead>
                    <tr>
                        <th>Order Date</th>
                        <th>Order Id</th>
                        <th>Order Total</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody></tbody>
                <tfoot>
                    <tr>
                        <th colspan="2">Total</th>
                        <th class="total"></th>
                    </tr>
                </tfoot>
            </table>
        </div>


    </div>--%>
<%} %>