(function (global) {
	if ("app" in global) {
		if (!String.prototype.trim) {
			String.prototype.trim = function () {
				return this.replace(/^[\s\uFEFF\xA0]+|[\s\uFEFF\xA0]+$/g, "");
			};
		}

		const validator = app.createContext(app);
		var errorArray = [];

		validator.addProperties({
			errorClass: "message__is-invalid",
			successClass: "message__is-valid",
			selectModifier: "-select",
			scrollElement: function () {
				return document.getElementsByClassName("error_scrollTo")[0];
			},
			isInView: function (ele) {
				var rect = ele.getBoundingClientRect();

				return (
					rect.top >= 0 &&
					rect.left >= 0 &&
					rect.bottom <=
						(window.innerHeight ||
							document.documentElement
								.clientHeight) /* or $(window).height() */ &&
					rect.right <=
						(window.innerWidth ||
							document.documentElement
								.clientWidth) /* or $(window).width() */
				);
			},
			showError: function (ele) {
				if (ele.nodeName === "SELECT") {
					this.showErrorSelect(ele);
				} else {
					ele.classList.remove(this.successClass);
					ele.classList.add(this.errorClass);
				}
			},
			hideError: function (ele) {
				if (ele.nodeName === "SELECT") {
					this.hideErrorSelect(ele);
				} else {
					ele.classList.remove(this.errorClass);
					ele.classList.add(this.successClass);
				}
			},
			showErrorSelect: function (ele) {
				let parent = document.getElementById(ele.dataset["parent"]);
				if (parent) {
					parent.classList.remove(
						this.successClass + this.selectModifier
					);
					parent.classList.add(this.errorClass + this.selectModifier);
				}
			},
			hideErrorSelect: function (ele) {
				let parent = document.getElementById(ele.dataset["parent"]);
				if (parent) {
					parent.classList.remove(
						this.errorClass + this.selectModifier
					);
					parent.classList.add(
						this.successClass + this.selectModifier
					);
				}
			},
			getForms: function () {
				return document.getElementsByClassName(
					"form_validation_required"
				);
			},
			isEmpty: function (value) {
				if (
					value === undefined ||
					value === null ||
					value.trim() === ""
				) {
					return true;
				}
				return false;
			},
			validPhone: function (value) {
				let phone = value.replace(/[^0-9]/g, "");
				if (phone.length !== 10) {
					return false;
				} else {
					return true;
				}
			},
			validCard: function (value) {
				let valid = true;
				switch (CheckCardNum(value)) {
					case 0:
						valid = false;
						break;
					case 2:
						valid = false;
						break;
					case 3:
						valid = false;
						break;
				}

				return valid;
			},
			validExp: function () {
				let valid = true;
				let cmonth = document.getElementById("CardExpirationMonth");
				let cyear = document.getElementById("CardExpirationYear");

				if (this.elementExists(cmonth) && this.elementExists(cyear)) {
					if (!IsValidCreditCardDate(cmonth.value, cyear.value)) {
						valid = false;
					}
				}
				return valid;
			},
			validCvv: function (value) {
				let valid = true;
				let cardType = document.getElementById("CardType");
				if (this.elementExists(cardType)) {
					var cvvLength = value.length;
					switch (cardType.value.toLowerCase()) {
						case "v":
						case "m":
						case "d":
							if (cvvLength !== 3) {
								valid = false;
							}
							break;
						case "ax":
							if (cvvLength !== 4) {
								valid = false;
							}
							break;
					}
				}

				return valid;
			},
			isValid: function (value, regex, type) {
				let valid = true;
				if (this.isEmpty(value)) {
					valid = false;
				} else if (!this.isEmpty(regex)) {
					let reg = new RegExp(regex);
					if (!reg.test(value)) {
						valid = false;
					}
				} else if (type) {
					switch (type) {
						case "phone":
							valid = this.validPhone(value);
							break;
						case "card":
							valid = this.validCard(value);
							break;
						case "cardExp":
							valid = this.validExp();
							break;
						case "cvv":
							valid = this.validCvv(value);
							break;
						case "terms":
							valid = this.validTerms();
					}
				}
				return valid;
			},
			validTerms: function () {
				var isChecked = document.getElementById("TermsOfService")
					.checked;
				return isChecked;
			},
			validElement: function (ele) {
				let valid = true;
				if (
					(ele.nodeName === "INPUT" || ele.nodeName === "SELECT") &&
					ele.dataset["required"]
				) {
					if (
						this.isValid(
							ele.value,
							ele.dataset["pattern"],
							ele.dataset["validationtype"]
						)
					) {
						ele.setCustomValidity("");
						this.hideError(ele);
					} else {
						ele.setCustomValidity("Invalid");
						this.showError(ele);
						valid = false;
					}
				}
				return valid;
			},
			getErrorMessage: function (e) {
				var message = $('#' + e.id).parent().find('div').find('.message__invalid').text().replace("\n", "").trim();
				message = message.length > 0 ? message : $('#' + e.id).parent().find('label').find('.message__invalid').text().replace("\n", "").trim(); 
				message = message.length > 0 ? message : $('#CardExpirationMonth').parents('#CardExpirationCt').find('div').find('.message__invalid').text().replace("\n", "").trim();
				return message;
			},
			logErrors: function (a) {
				let errors = {};

				for (var i = 0; i < a.length; i++) {

					let message = a[i].replace('\t', '');

					errors["Error " + i] = message;

				}

				$.post('/shared/services/pixelservice.ashx?at=error', errors);
			},
			validateForm: function (e) {
				let validForm = true;
				let form = e.target.form;
				let card = document.getElementById("otCARD");
				let scrollEle;

				if (
					!this.elementExists(card) ||
					(this.elementExists(card) && card.checked)
				) {
					if (this.elementExists(form) && form.nodeName === "FORM") {
						let length = form.elements.length;
						for (var i = 0; i < length; i++) {
							let ele = form.elements[i];
							const notifyState = ele.getAttribute(
								"data-notify-validity"
							);

							if (!this.validElement(ele)) {

								let errMessage = this.getErrorMessage(ele);
								errorArray.push(errMessage);

								if (!ele.validity.valid && !notifyState) {
									ele.setAttribute(
										"data-notify-validity",
										true
									);
									ele.addEventListener(
										"input",
										this.validElement.bind(this, ele)
									);
									ele.addEventListener(
										"blur",
										this.validElement.bind(this, ele)
									);
								}

								if (!scrollEle) {
									scrollEle = ele;
									setTimeout(function () {
										scrollEle.focus();
										scrollEle.scrollIntoView({
											block: "center"
										});
									}, 10);
								}
								validForm = false;
							} else {
								if (ele.validity.valid && notifyState) {
									ele.setAttribute(
										"data-notify-validity",
										false
									);
									ele.removeEventListener(
										"input",
										this.validElement.bind(this, ele)
									);
									ele.removeEventListener(
										"blur",
										this.validElement.bind(this, ele)
									);
								}
							}
						}

						if (!validForm) {
							e.preventDefault();

							if (errorArray.length > 0) {
								this.logErrors(errorArray);
							}

							if (this.elementExists(scrollEle)) {
							}
						} else {
							if (typeof qasValidateAddress === "function") {
								e.preventDefault();
								qasValidateAddress();
							} else {
								triggerEvent("FORM_SUBMIT");
							}
						}
					}
				}
			}
		});

		document.addEventListener("DOMContentLoaded", function () {
			validator.listen(
				validator.getForms(),
				validator.validateForm.bind(validator),
				"click"
			);
		});
	}
})(window);
