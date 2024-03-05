(function (global) {
    global.requestIdleCallback =
    global.requestIdleCallback ||
    function (cb) {
        var start = Date.now();
        return setTimeout(function () {
            cb({
                didTimeout: false,
                timeRemaining: function () {
                    return Math.max(0, 50 - (Date.now() - start));
                }
            });
        }, 1);
    }

    global.cancelIdleCallback =
    global.cancelIdleCallback ||
    function (id) {
        clearTimeout(id);
    }

    if (!String.prototype.includes) {
        String.prototype.includes = function(search, start) {
            "use strict";
      
            if (search instanceof RegExp) {
                throw TypeError("first argument must not be a RegExp");
            }
            if (start === undefined) { start = 0; }
            return this.indexOf(search, start) !== -1;
        };
    }

    const create = Object.create(
        {
            addProperty: function (property, value) {
                Object.defineProperty(this, property, {
                    enumerable: true,
                    value: value
                });
            },
            addProperties: function (properties) {
                const access = this;
                Object.keys(properties).forEach(function (property) {
                    access.addProperty(property, properties[property]);
                });
            },
            createContext: function (inherit) {
                return Object.create(
                    inherit || Object.getPrototypeOf(this),
                    {}
                );
            },
            lock: function () {
                Object.freeze(this);
            }
        },
        {}
    );

    if (typeof global.app !== "object") {
        Object.defineProperty(global, "app", {
            value: create,
            writable: false,
            configurable: false
        });
    }

    app.addProperties({
        isString: function (data) {
            return typeof data === "string" && data !== "";
        },
        isArray: function (data) {
            return Array.isArray(data);
        },
        isFunction: function (data) {
            return typeof data === "function";
        },
        isObject: function (data) {
            return typeof data === "object" && !this.isArray(data);
        },
        elementExists: function (element) {
            let result = false;
            if (element) {
                let length = element.length;
                if (length !== undefined) {
                    result = length;
                } else {
                    result = document.body.contains(element);
                }
            }
            return result;
        },
        toArray: function (collection) {
            let ar = [];
            if (collection !== null && typeof collection !== "undefined") {
                ar = ar.slice.call(collection);
            }
            return ar;
        },
        listen: function (eles, method, e) {
            if (this.elementExists(eles)) {
                const elements = this.toArray(eles),
                    event = e || "click";
                if (elements.length > 0) {
                    elements.forEach(function (ele) {
                        ele.addEventListener(event, method);
                    });
                } else {
                    eles.addEventListener(event, method);
                }
            }
        },
        require: function (properties, callback) {
            let status = true;
            const access = this;

            if (this.isArray(properties)) {
                properties.forEach(function (property) {
                    if (!access.hasOwnProperty(property)) {
                        status = false;
                    }
                });
                if (status && this.isFunction(callback)) {
                    callback();
                }
            }

            return status;
        },
        createElement: function (tag, attributes) {
            const element = document.createElement(tag);
            if (typeof attributes === "object") {
                Object.keys(attributes).forEach(function (attribute) {
                    element.setAttribute(attribute, attributes[attribute]);
                });
            }
            return element;
        },
        appendElement: function (tag, attributes) {
            const element = this.createElement(tag, attributes);
            document.body.appendChild(element);
            return element;
        },
        requestResource: function (src, tag, attributes) {
            if (typeof src !== "string") {
                console.warn("Cannot request a resource without a valid URL");
                return false;
            }
    
            if (typeof tag !== "string") {
                console.warn("Cannot request a resource without a valid element");
                return false;
            }
    
            if (typeof attributes === "object") {
                if (tag === "link") {
                    attributes.href = src;
                } else {
                    attributes.src = src;
                }
            } else {
                if (tag === "link") {
                    attributes = { href: src };
                } else {
                    attributes = { src: src };
                }
            }
    
            try {
                return this.appendElement(tag, attributes);
            } catch (error) {
                console.log(error);
                return false;
            }
        }
    });
})(window);
