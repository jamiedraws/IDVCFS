(function (global) {
    if ("app" in global) {
        const expressCheckout = app.createContext(app);

        expressCheckout.addProperties({
            disclaimerText: document.querySelector("#disclaimerText"),
            acceptOffer: document.querySelector("#AcceptOfferButton"),
            getState: function (state) {
                return this.isString(state) ? state : "CARD";
            },
            isCardState: function (state) {
                return state === "CARD";
            },
            createCheckbox: function () {
                const checkbox = document.createElement("span");
                checkbox.classList.add("form__checkbox");
                return checkbox;
            },
            addCustomCheckbox: function (element) {
                const checkbox = this.createCheckbox();
                const label = element.querySelector("label");

                label.classList.add("form__label");
                label.insertAdjacentElement("afterbegin", checkbox);
            },
            registerOptions: function () {
                const self = this;
                this.options.forEach(function (option) {
                    option.classList.add("form__checkbox-label");
                    self.addCustomCheckbox(option);
                });
            },
            processTask: function () {
                this.addProperty(
                    "options", 
                    this.toArray(document.querySelectorAll(".checkout-option"))
                );

                this.registerOptions();
                this.handleOptions();
            },
            toggleDisclaimerByState: function (state) {
                if (!this.isCardState(state)) {
                   this.disclaimerText.classList.add("form__is-hidden");
                } else {
                    this.disclaimerText.classList.remove("form__is-hidden");
                }
            },
            createImage: function (state) {
                const image = this.createElement("img");

                if (!this.isCardState(state)) {
                    const src = this.acceptOffer.getAttribute("src");

                    if (this.isString(src)) {
                        image.setAttribute("src", src);
                        image.setAttribute("id", "image-" + state);
                        this.acceptOffer.appendChild(image);
                    }                
                }

                return image;
            },
            updateImageByState: function (state) {
                let image = this.acceptOffer.querySelector("#image-" + state);
                if (!this.elementExists(image)) {
                    image = this.createImage(state);
                }

                const prevImageState = this.acceptOffer.querySelector(".button__state");
                if (this.elementExists(prevImageState)) {
                    prevImageState.classList.remove("button__state");
                }

                image.classList.add("button__state");
            },
            updateButtonTextByState: function (state) {
                const types = this.acceptOffer.dataset.orderType;

                if (this.isString(types)) {
                    const dataset = JSON.parse(types);

                    if (this.isObject(dataset)) {
                        const type = dataset[state];

                        if (this.isString(type)) {
                            const text = this.acceptOffer.querySelector("span");
                            text.textContent = type;
                            this.acceptOffer.setAttribute("data-state", state.toLowerCase());
                        }
                    }
                }
            },
            handleOptions: function () {
                const self = this;

                addEventListener("PaymentOptionSelected", function (response) {
                    const state = self.getState(response.detail);
                    self.toggleDisclaimerByState(state);
                    self.updateButtonTextByState(state);
                    self.updateImageByState(state);
                });
            }
        });

        addEventListener("ECDrawFormComplete", expressCheckout.processTask.bind(expressCheckout));
    }
}(window));