(function (global) {
	if ("app" in global) {
		app.require(["defer"], function () {
			const carousel = app.createContext(app.defer);

			carousel.addProperties({
				hasSlide: function () {
					return "Slide" in global;
				},
				handleNavButtons: function (self) {
					const sum = self.countChildren();

					if (self.nextButton) {
						self.nextButton.addEventListener("click", function () {
							self.index += self.steps;

							if (self.index >= sum) {
								self.index = 0;
							}

							self.goto(self.index);
						});
					}

					if (self.prevButton) {
						self.prevButton.addEventListener("click", function () {
							self.index -= self.steps;

							if (self.index < 0) {
								self.index = sum - self.steps;
							}

							self.goto(self.index);
						});
					}
				},
				handleThumbnails: function (self) {
					if (self.thumbnails) {
						const thumbnailList = self.thumbnails.querySelectorAll(
							".slide__thumbnail"
						);

						carousel.listen(thumbnailList, function (event) {
							event.preventDefault();
							const index = self.getCurrentIndex.call(this);
							self.goto(index);
						});
					}
				},
				handleBreakpoints: function (self, config) {
					const hasSteps = carousel.isObject(config) && config.steps;

					if (hasSteps) {
						carousel.breakpoint(
							"(min-width: 1201px)",
							self.updateSteps.bind(self, 4)
						);

						carousel.breakpoint(
							"(min-width: 801px) and (max-width: 1200px)",
							self.updateSteps.bind(self, 3)
						);

						carousel.breakpoint(
							"(min-width: 421px) and (max-width: 800px)",
							self.updateSteps.bind(self, 2)
						);

						carousel.breakpoint(
							"(max-width: 420px)",
							self.updateSteps.bind(self, 1)
						);
					}
				},
				notify: function (self) {
					self.watch(function (index) {
						if (self.steps === 1) {
							self.index = index;
						}

						self.selectThumbnail(index);

						const slide = self.children.item(index);
						if (slide) {
							app.require(["lazy"], function () {
								carousel.lazy(slide);
							});
						}

						self.updateSlideVisibility(index);
						self.observeLiveRegion();
					});
				},
				breakpoint: function (mediaQuery, success, fail) {
					const mql = global.matchMedia(mediaQuery);
					const response = function (evt) {
						if (evt.matches) {
							if (carousel.isFunction(success)) {
								success();
							}
						} else {
							if (carousel.isFunction(fail)) {
								fail();
							}
						}
					};
					response(mql);
					mql.addListener(response);
				}
			});

			if (carousel.hasSlide()) {
				Slide.proto({
					getCurrentIndex: function () {
						return parseInt(this.dataset.slideIndex);
					},
					playOnscreen: function () {
						const self = this;
						const id = self.parent.id;

						if (carousel.isString(id)) {
							let observer;

							app.require(["observer"], function () {
								app.observer.watch({
									selector: "#" + id,
									inRange: function () {
										observer = setTimeout(
											self.play.bind(self),
											self.getDelay()
										);
									},
									outRange: function () {
										clearTimeout(observer);
										self.pause();
									},
									unObserve: hasIntersectionObserver(),
									options: {
										threshold: 0.5
									}
								});
							});
						}
					},
					updateConfig: function (options) {
						const config = this.parent.dataset.slideConfig;
						if (config) {
							const configJSON = JSON.parse(config);
							if (carousel.isObject(configJSON)) {
								Object.keys(options).forEach(function (option) {
									configJSON[option] = options[option];
								});
							}
							const configString = JSON.stringify(configJSON);
							this.parent.dataset.slideConfig = configString;
						}
					},
					extendConfig: function () {
						const config = this.parent.dataset.slideConfig;
						if (config) {
							const configJSON = JSON.parse(config);
							if (carousel.isObject(configJSON)) {
								if (configJSON.delay) {
									this.setDelay(configJSON.delay);
								}

								if (configJSON.auto) {
									this.playOnscreen();
								}

								if (configJSON.steps) {
									this.steps = configJSON.steps;
								}

								return configJSON;
							}
						}
						return false;
					},
					updateSteps: function (steps) {
						this.updateConfig({ steps: steps });
						this.extendConfig();
					}
				});
			}

			const hasIntersectionObserver = function () {
				return "IntersectionObserver" in window ? false : true;
			};

			carousel
				.toArray(document.querySelectorAll(".slide--fade"))
				.forEach(function (carouselItem) {
					const into = carouselItem.querySelector(".slide__into");
					Slide.into(
						into,
						{
							currentState: "slide__item--current"
						},
						function () {
							const self = this;
							this.extendConfig();

							self.handleRotation(false);
							self.setShim(true);
							self.watch(function (currentIndex, prevIndex) {
								if (self.isAuto()) {
									const prevSlide = this.children.item(
											prevIndex
										),
										currentSlide = this.children.item(
											currentIndex
										);

									prevSlide.classList.remove(
										self.currentState
									);
									currentSlide.classList.add(
										self.currentState
									);
								}
							});
						}
					);
				});

			carousel
				.toArray(document.querySelectorAll(".slide"))
				.forEach(function (slide) {
					app.require(["observer"], function () {
						const into = slide.querySelector(".slide__into"),
							id = "#" + into.id;

						app.observer.watch({
							selector: id,
							inRange: function () {
								Slide.into(
									into,
									{
										container: slide,
										prevButton: slide.querySelector(
											".slide__prev"
										),
										nextButton: slide.querySelector(
											".slide__next"
										),
										thumbnails: slide.querySelector(
											".slide__thumbnails"
										)
									},
									function () {
										const self = this;
										const config = this.extendConfig();

										self.index = 0;
										self.steps = self.steps || 1;

										self.container.classList.add(
											"slide--is-ready"
										);

										carousel.handleNavButtons(self);
										carousel.handleThumbnails(self);
										global.gotoSlide = function (index) {
											self.goto(index);
										};
										carousel.notify(self);
										carousel.handleBreakpoints(
											self,
											config
										);
									}
								);
							}
						});
					});
				});
		});
	}
})(window);
