"use-strict";

(function (global) {
    if ("app" in global) {
        const observer = app.createContext(app);

        observer.addProperties({
            watch: function (conf) {
                var conf = conf || {},
                options = conf.options || {},
                selector = conf.selector || "[data-observe]",
                inRange = conf.inRange || function() {},
                outRange = conf.outRange || function() {},
                unObserve = typeof conf.unObserve === "boolean" ? conf.unObserve : true,
                loadItems = [].slice.call(document.querySelectorAll(selector)),
                active = false;
        
                if ("IntersectionObserver" in window) {
                    var loadItemObserver = new IntersectionObserver(function(entries) {
                        entries.forEach(function(entry) {
                            if (entry.intersectionRatio > 0 && entry.isIntersecting) {
                                inRange(entry.target, entry);
                                if (unObserve) {
                                    loadItemObserver.unobserve(entry.target);
                                }
                            } else {
                                outRange(entry.target);
                            }
                        });
                    }, options);
            
                    loadItems.forEach(function(loadItem) {
                        loadItemObserver.observe(loadItem);
                    });
                } else {
                    var inView = function (loadItem) {
                        return loadItem.getBoundingClientRect().top <= window.innerHeight &&
                            loadItem.getBoundingClientRect().bottom >= 0;
                    };
            
                    var lazyLoad = function() {
                        if (active === false) {
                            active = true;
            
                            setTimeout(function() {
                                loadItems.forEach(function(loadItem) {
                                    if (inView(loadItem)) {
                                        inRange(loadItem);
            
                                        if (unObserve) {
                                            loadItems = loadItems.filter(function(image) {
                                                return image !== loadItem;
                                            });
            
                                            if (loadItems.length === 0) {
                                                document.removeEventListener(
                                                    "scroll",
                                                    lazyLoad
                                                );
                                                window.removeEventListener("resize", lazyLoad);
                                                window.removeEventListener(
                                                    "orientationchange",
                                                    lazyLoad
                                                );
                                            }
                                        }
                                    } else {
                                        outRange(loadItem);
                                    }
                                });
            
                                active = false;
                            }, 200);
                        }
                    };
            
                    document.addEventListener("scroll", lazyLoad);
                    window.addEventListener("resize", lazyLoad);
                    window.addEventListener("orientationchange", lazyLoad);
                    window.addEventListener("DOMContentLoaded", lazyLoad);
                }
            }
        });

        observer.lock();

        app.addProperty("observer", observer);
    }
}(window));