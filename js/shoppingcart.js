registerEvent("CartChange", function () {
    updateSubTotal();
});

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

function updateProductQuantity(element) {
    let productCode = $(element).attr("data-product-code");
    let currentQuantity = getItemQuantity(productCode);
    let newQuantity = parseInt($("#" + productCode + "Qty").val());
    let maxQuantity = parseInt($(element).attr("data-max"));
    handleCartChange(productCode, newQuantity);

    if (newQuantity > currentQuantity || newQuantity < currentQuantity) {
        showError("Item quantity updated!", productCode);
    }
    else if (newQuantity === maxQuantity && currentQuantity === maxQuantity) {
        showError("Item has a max quantity of " + maxQuantity, productCode);
    }
}

function removeCartItem(productCode, index, url) {
    handleCartChange(productCode, 0);
    $("#" + productCode + "Qty").val("1");
    let html = "<div class=\"vse_" + productCode + " cart__content\"></div>";
    $("#itemIndex" + index).after(html);
    $("#itemIndex" + index).remove();
    let tableItems = 0;

    $("div[id^=itemIndex]").each(function (index, value) {
        tableItems++;
    }); 

    if (tableItems === 0) {
        showEmptyCartMessage(url);
    }
    else {
        showError("Item removed!", productCode);
    }
}

function showEmptyCartMessage(url) {
    let html = "<div class=\"account__space account__copy\">\n<h2 class=\"account__header\">Details</h2>\n<p>Your cart is currently empty.</p>\n<a href=\"" + url + "\" class=\"button button--second\" data-track=\"dtm-link2\">Continue Shopping</a>\n</div>";
    $("#cartContainer").html(html);
}

function updateSubTotal() {
    let subTotal = $("label.subtotal").text();
    $("#summarySubTotal").text(subTotal);
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