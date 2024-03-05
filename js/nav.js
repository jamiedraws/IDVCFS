(function (global) {
    if ("app" in global) {
        app.require(["defer"], function () {
            const nav = app.createContext(app.defer);

            nav.addProperties({
                element: document.querySelector(".nav"),
                show: function () {
                    if (this.elementExists(this.element)) {
                        this.element.classList.remove("nav--is-hidden");
                    }
                },
                hide: function () {
                    if (this.elementExists(this.element)) {
                        this.element.classList.add("nav--is-hidden");
                    }
                },
                slidePanel: function (toggle) {
                    if (typeof toggle === "object") {
                        const setToggleEvent = function (elements) {
                            nav.listen(elements, setToggle);
                        };

                        const setToggle = function () {
                            try {
                                toggle.checked = false;
                            } catch (e) {
                                console.warn(e.message);
                                return false;
                            }
                        };

                        return setToggleEvent;
                    } else {
                        return false;
                    }
                },
                setAriaExpanded: function () {
                    let isExpanded = JSON.parse(this.getAttribute("aria-expanded"));
                    let setState = isExpanded ? false : true;
                    this.setAttribute("aria-expanded", setState);
                },
            });

            app.addProperty("nav", nav);

            nav.viewElement(
                {
                    selector: ".header",
                    state: "nav--is-fixed",
                    neighbor: ".nav",
                    ready: "nav--is-primed",
                },
                function (config) {
                    this.classList.remove(config.state);
                },
                function (config) {
                    this.classList.add(config.state);

                    if (!this.classList.contains(config.ready)) {
                        this.classList.add(config.ready);
                    }
                }
            );

            const slide = nav.slidePanel(document.querySelector("#nav__toggle"));
            if (slide) {
                slide(document.querySelectorAll(".nav a[href^='#']"));
                slide(document.querySelectorAll(".nav__underlay--for-drawer"));
            }

            nav.listen(document.querySelectorAll(".nav [aria-haspopup]"), nav.setAriaExpanded);
        });
    }
})(window);
