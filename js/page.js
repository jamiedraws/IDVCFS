(function (global) {
    if ("app" in global) {
        const defer = app.createContext(app);

        defer.addProperties({
            updateContainer: function (placeholder, element, state) {
                let operation = state === true ? "add" : "remove";

                if (
                    this.elementExists(placeholder) &&
                    this.elementExists(element)
                ) {
                    placeholder.classList[operation]("defer--success");
                    element.classList[operation]("defer__success");
                }
            },
            setContainer: function (placeholder) {
                const element = placeholder.querySelector(".defer__progress");

                return Object.create(
                    {},
                    {
                        show: {
                            value: this.updateContainer.bind(
                                this,
                                placeholder,
                                element,
                                true
                            )
                        },
                        hide: {
                            value: this.updateContainer.bind(
                                this,
                                placeholder,
                                element,
                                false
                            )
                        }
                    }
                );
            },
            isAvailable: function (selector, response) {
                let result = response || false;
                if (this.isString(selector)) {
                    const element = document.querySelector(selector);
                    if (this.elementExists(element)) {
                        result = element;
                    }
                }
                return result;
            },
            viewElement: function (config, inRangeCallback, outRangeCallback) {
                if (this.isObject(config)) {
                    let element = this.isAvailable(config.selector);

                    if (element && this.isString(config.state)) {
                        element = this.isAvailable(config.neighbor, element);

                        if (this.require(["observer"])) {
                            const func = function () {},
                                inRange = inRangeCallback || func,
                                outRange = outRangeCallback || func;

                            this.observer.watch({
                                selector: config.selector,
                                inRange: inRange.bind(element, config),
                                outRange: outRange.bind(element, config),
                                unObserve: false
                            });
                        }
                    }
                }
            }
        });

        app.require(["observer"], function () {
            app.require(["lazy"], function () {
                app.observer.watch({
                    selector: "[data-src-img]",
                    inRange: function (loadItem) {
                        defer.lazy(loadItem);
                    }
                });

                app.observer.watch({
                    selector: "#instagram-pictures",
                    inRange: function () {
                        app.requestResource(
                            "/js/instagram-gallery.js",
                            "script",
                            { defer: true }
                        );
                    }
                });

                app.observer.watch({
                    selector: "[data-src-iframe]",
                    inRange: function (record) {
                        defer.lazy(record, {
                            tag: "iframe",
                            src: "data-src-iframe",
                            ondemand: true
                        });
                    }
                });
            });

            app.observer.watch({
                selector: ".view--remove-nav",
                inRange: function () {
                    if (app.require(["nav"])) {
                        app.nav.hide();
                    }
                },
                outRange: function () {
                    if (app.require(["nav"])) {
                        app.nav.show();
                    }
                },
                unObserve: false,
                options: {
                    threshold: 1.0
                }
            });
        });

        defer.lock();
        app.addProperty("defer", defer);

        addEventListener("DOMContentLoaded", function () {
            const placeholders = app.toArray(
                document.querySelectorAll(".defer")
            );
            placeholders.forEach(function (placeholder) {
                const defer = app.defer.setContainer(placeholder);
                defer.show();
            });
        });

        app.listen(
            document.querySelectorAll(".expando > .expando__toggle"),
            function () {
                this.classList.toggle("expando--is-selected");
            }
        );

        const toast = app.createContext(app);

        toast.addProperties({
            hide: function () {
                if (this.require(["element"])) {
                    this.element.classList.add("toast--hidden");
                }
            },
            show: function () {
                if (this.require(["element"])) {
                    this.element.classList.remove("toast--hidden");
                }
            },
            handleCloseButton: function (element) {
                const close = element.querySelector(".toast__close");
                if (this.elementExists(close)) {
                    this.listen(close, this.hide.bind(this));
                }
            },
            register: function (id) {
                let element = false;

                if (this.isString(id)) {
                    element = document.getElementById(id);
                    if (this.elementExists(element)) {
                        this.addProperty("element", element);
                        element.classList.add("toast--is-ready");
                        this.handleCloseButton(element);
                    }
                }

                return this.publicInterface(element);
            },
            publicInterface: function (element) {
                return Object.create(
                    {},
                    {
                        element: {
                            value: element
                        },
                        show: {
                            value: this.show.bind(this)
                        },
                        hide: {
                            value: this.hide.bind(this)
                        }
                    }
                );
            }
        });

        app.addProperty("toast", toast.register.bind(toast));

        addEventListener("DOMContentLoaded", function () {
            const m = modal({
                modal: {
                    value: document.querySelector(".modal")
                },
                text: {
                    value: document.querySelector(".modal__text")
                },
                stateClass: {
                    value: "modal--is-visible"
                },
                focusElement: {
                    value: document.querySelector(".modal__button")
                }
            });

            // apply modal
            addEventListener("beforeunload", m.show.bind(m));
            addEventListener("submit", m.show.bind(m));

            if (app.elementExists(m.focusElement)) {
                m.focusElement.addEventListener("click", m.hide.bind(m));
            }
        });
    }
})(window);
