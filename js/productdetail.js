function updateButtonQuantity(element) {
    let quantityId = $(element).attr("data-quantity-id");
    let quantityModifier = $(element).attr("data-exp");
    let currentQuantity = parseInt($("#" + quantityId).val());
    let newQuantity = currentQuantity;
    let maxQuantity = parseInt($("#" + quantityId).attr("data-max"));

    switch (quantityModifier) {
        case "add":
            newQuantity++;
            break;
        case "min":
            newQuantity--;
            break;
    }

    if (newQuantity < 0) {
        newQuantity = 0;
    }
    else if (newQuantity > maxQuantity) {
        newQuantity = maxQuantity;
    }

    if (newQuantity === 0) {
        newQuantity = 1;
    }

    $("#" + quantityId).val(newQuantity);
    toggleQuantitySelector(quantityId, newQuantity);
}

function toggleQuantitySelector(dataQuantityId, quantity) {
    $("button[data-quantity-id=" + dataQuantityId + "]").each(function (index, value) {

        $("input[id=" + dataQuantityId + "]").prop("disabled", true);
        $("input[id=" + dataQuantityId + "]").closest(".inc-input").removeClass("inc-input--is-text-mode");
    });
}

function validateInput(element) {
    let value = $(element).val();
    let maxQauntity = parseInt($(element).attr("max")); 
    let minQuantity = parseInt($(element).attr("min")); 
    let valueInt = parseInt(value);
    let newValue = 0;

    if (valueInt > maxQauntity) {
        newValue = maxQauntity;
    }
    else if (isNaN(valueInt) || valueInt <= 0) {
        newValue = minQuantity;
    }
    else {
        newValue = valueInt;
    }

    $(element).val(newValue);
}

addEventListener("DOMContentLoaded", function () {
    $("#GDX_MC_option1").on("change", oosProducts);
    $("#GDX_MC_option2").on("change", oosProducts);

    oosProducts();
    $("#GDX_MQZ_option1").on("change", oosProducts);
    $("#GDX_MQZ_option2").on("change", oosProducts);

    function oosProducts() {
        //Mens Crew T Shirt OOS
        var mcOptionColor = $("#GDX_MC_option1").val();
        var mcOptionSize = $("#GDX_MC_option2").val();
        var mcOption = mcOptionColor + mcOptionSize;
        var tShirtAddToCartButton = $("a[name='GDX_MC_add']");

        if (mcOption == "MCBM" || mcOption == "MCBX" || mcOption == "MCGL" || mcOption == "MCGX" ) {
            tShirtAddToCartButton.css("pointer-events", "none").css("touch-action", "auto");
            tShirtAddToCartButton.html("Sold Out");
        } else {
            tShirtAddToCartButton.css("pointer-events", "auto");
            tShirtAddToCartButton.html("Add To Cart");
        }

        //Mens Quarter Zip OOS
        var qzOptionColor = $("#GDX_MQZ_option1").val();
        var qzOptionSize = $("#GDX_MQZ_option2").val();
        var qzOption = qzOptionColor + qzOptionSize;
        var quarterZipAddToCart = $("a[name='GDX_MQZ_add']");

        if (qzOption == "MQZBS") {
            quarterZipAddToCart.css("pointer-events", "none").css("touch-action", "none");
            quarterZipAddToCart.html("Sold Out");
        }
        else {
            quarterZipAddToCart.css("pointer-events", "auto").css("touch-action", "auto");
            quarterZipAddToCart.html("Add To Cart");
        }
    }
});


function updateProductQuantity(element) {
    let buttonName = $(element).attr("name");
    let productCode = $("[data-dropdown-group=" + buttonName + "]").val();
    let itemCurrentQuantity = getItemQuantity(productCode);
    let newQuantity = itemCurrentQuantity + parseInt($("#" + buttonName + "_Qty").val());
    if (productCode === '') {
        showError("Please ensure an item is selected", buttonName);
    }else if (itemCurrentQuantity <= 1) {
        handleCartChange(productCode, newQuantity);
        showError("Item added to the cart successfully!", buttonName);

        registerEvent("CartChange", function () {
            var href = $('#shoppingCart').attr('href');
            window.location.href = href;
        });

    } else {
        showError("Item has a max quantity of 2", buttonName);
    }
}

function addGDX(itemCode, event) {
    var initialOption = $('#' + itemCode + '_option1').val();
    var secondaryOption = $('#' + itemCode + '_option2').val();
    var qty = parseInt($('#' + itemCode + '_Qty').val());

    var productCode = initialOption + secondaryOption;
    handleCartChange(productCode, qty, null, null, null, event);

    makeToast("form-response", "Item Added to Cart");

    registerEvent("CartChange", function () {
        var href = $('#shoppingCart').attr('href');
        window.location.href = href;
    });

}

function showError(message, buttonName) {
    const toast = makeToast("form-response", message);

    if (!toast) {
        // fallback option if no toast is available
        $('.vse_' + buttonName + '').show();
        $('.vse_' + buttonName + '').text(message);
        $('.vse_' + buttonName + '').fadeOut(2000);
    }

}


function getItemQuantity(productCode) {
    let itemQuantity = 0;
    let cartItems = getItems();
    let cartItemCount = cartItems.length;

    if (cartItemCount > 0) {
        for (let i = 0; i < cartItemCount; i++) {
            if (cartItems[i].id === productCode) {
                if (itemQuantity === 0) {
                    itemQuantity = cartItems[i].qty;
                }
            }
        }
    }

    return itemQuantity;
}

function itemIsInCart(productCode) {
    let hasItem = false;
    let cartItems = getItems();
    let cartItemCount = cartItems.length;

    if (cartItemCount > 0) {
        for (let i = 0; i < cartItemCount; i++) {
            if (cartItems[i].id === productCode) {
                hasItem = true;
            }
        }
    }

    return hasItem;
}

const makeToast = (function () {
    let toast;

    if ("app" in window) {
        toast = app.createContext(app);

        toast.addProperties({
            store: [],
            hasToast: function () {
                return app.require(["toast"]);
            },
            registerTemplates: function () {
                const templates = this.toArray(document.querySelectorAll(".toast"));

                templates.forEach(function (template) {
                    toast.store.push({
                        id: template.id,
                        api: app.toast(template.id)
                    });
                });
            },
            getTemplateById: function (id) {
                let result = false;

                this.store.forEach(function (template) {
                    if (template.id === id) {
                        result = template;
                    }
                })
                
                return result;
            },
            show: function (id) {
                const template = this.getTemplateById(id);
                if (template) {
                    template.api.show();
                }
            },
            getTemplateAPI: function (id) {
                const template = this.getTemplateById(id);
                return template.api;
            },
            updateMessage: function (id, message) {
                const template = this.getTemplateById(id);

                if (template) {
                    const element = template.api.element;
                    const title = element.querySelector("#" + template.id + "-title");
                    title.textContent = message;
                }
            },
            processTask: function () {
                if (this.hasToast()) {
                    this.registerTemplates();
                }
            }
        });

        toast.processTask();
    }

    return function (id, message) {
        let response = false;

        if (toast && toast.hasToast()) {
            toast.updateMessage(id, message);
            toast.show(id);
            response = toast.getTemplateAPI(id);
        }

        return response;
    }
})();