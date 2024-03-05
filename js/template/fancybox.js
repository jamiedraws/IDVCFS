(function (global) {
    if ("app" in global) {
        const dependencyManager = app.createContext(app);

        dependencyManager.addProperties({
            hasjQuery: function () {
                return "jQuery" in global;
            },
            hasFancybox: function () {
                return this.hasjQuery() && "fancybox" in global.jQuery;
            }
        });

        app.addProperty("dependencyManager", dependencyManager);

        const fancybox = app.createContext(app.dependencyManager);

        fancybox.addProperties({
            containsVimeo: function (fancybox) {
                return fancybox.src.includes("vimeo");
            },
            clearBackground: function (fancybox) {
                fancybox.$slide.addClass("fancybox-slide--is-transparent");
            },
            createFancybox: function () {
                const self = this;
                if (this.hasFancybox()) {
                    $("[data-fancybox]").fancybox({
                        touch: false,
                        beforeLoad: function (instance, fancybox) {
                            if (self.containsVimeo(fancybox)) {
                                self.clearBackground(fancybox);
                            }
                        }
                    });
                }
            },
            processTask: function () {
                addEventListener("DOMContentLoaded", this.createFancybox.bind(this));
            }
        });

        fancybox.processTask();
    }
}(window));