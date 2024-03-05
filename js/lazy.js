(function (global) {
    if ("app" in global) {
        const lazy = app.createContext(app);

        lazy.addProperties({
            setDefault: function (args) {
                lazy.setItem(args.elem, args.attributes, args);
                args.elem.setAttribute("src", args.source);
            },
            handleError: function (args) {
                args.placeholder.classList.add("load-item--failure");
                console.warn("Cound not load the resource", args.elem.target);
            },
            addAttributes: function (elem, attributes) {
                for (var attribute in attributes) {
                    elem.setAttribute(attribute, attributes[attribute]);
                }
            },
            setItem: function (elem, attributes, args) {
                lazy.preloadItem(elem, args);
                lazy.addAttributes(elem, attributes);
            },
            insertItem: function (elem, args) {
                lazy.drawItem(function () {
                    args.placeholder.classList.add("load-item--success");
                    elem.classList.add("load-item__success");
                }, 2);
            },
            preloadItem: function (elem, args) {
                elem.classList.add("load-item__progress");
                args.placeholder.appendChild(elem);

                elem[args.onloadname] = lazy.insertItem.bind(lazy, elem, args);
                elem[args.onerrorname] = lazy.handleError.bind(lazy, args);
            },
            drawItem: (function () {
                let i = 0;

                return function (callback, count) {
                    if (i === count) {
                        callback();
                    } else {
                        i += 1;
                        requestAnimationFrame(lazy.drawItem.bind(lazy, callback, count));
                    }
                };
            })(),
            processItem: function (args) {
                args.placeholder.classList.add("load-item");

                if (args.tagsGroup) {
                    Object.keys(args.tagsGroup).forEach(function (tags) {
                        const tag = args.tagsGroup[tags];
                        if (tag.length > 0) {
                            tag.forEach(function (attributes) {
                                let elem = document.createElement(tags);
                                lazy.setItem(elem, attributes, args);
                            });
                        }
                    });
                } else {
                    lazy.setDefault(args);
                }
            },
            init: function (placeholder, options) {
                if (!lazy.elementExists(placeholder)) {
                    console.warn("A placeholder DOM element must be provided.");
                    return false;
                } else if (placeholder.classList.contains("load-item")) {
                    return false;
                }

                const args = options || {};
                args.placeholder = placeholder;
                args.tag = args.tag || "img";
                args.src = args.src || "data-src-img";
                args.onloadname = args.onloadname || "onload";
                args.onerrorname = args.onerrorname || "onerror";
                args.ondemand = "ondemand" in args ? args.ondemand : false;
                args.elem = document.createElement(args.tag);
                args.source = placeholder.getAttribute(args.src);
                args.attributes = JSON.parse(args.placeholder.getAttribute("data-attr"));
                args.tagsGroup = JSON.parse(args.placeholder.getAttribute("data-tag"));
                args.isPicture = false;

                if (!args.source) {
                    return false;
                }

                lazy.processItem(args);
            },
        });

        lazy.lock();
        app.addProperty("lazy", lazy.init);
    }
})(window);
