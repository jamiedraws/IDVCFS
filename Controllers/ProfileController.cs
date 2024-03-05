using Dtm.Framework.Base.Attributes;
using Dtm.Framework.Base.Configuration;
using Dtm.Framework.Base.Controllers;
using Dtm.Framework.ClientSites.Controllers;
using Dtm.Framework.ClientSites.Web;
using Dtm.Framework.ClientSites.Web.ModelValidation;
using Dtm.Framework.Models.Ecommerce;
using Dtm.Framework.Models.Ecommerce.Repositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace IDVCFS.Controllers
{
    public class ProfileController : AccountController
    {

        private readonly StoreCustomerRepository _storeCustomerRepository;

        public ProfileController()
        {
            _storeCustomerRepository = new StoreCustomerRepository(Context);
        }

        [AcceptVerbs(HttpVerbs.Post), NoCacheResponse]
        [Authorize]
        public ActionResult EditAddress(OrderPageViewData model)
        {
            var address = Model.CurrentCustomer.StoreCustomerAddresses
                .FirstOrDefault(a => a.StoreCustomerAddressID == model.BillingAddress.AddressId);

            if (address != null)
            {
                var isShippingParam = Request.Form["IsShipping"] ?? string.Empty;
                bool isShipping;
                bool.TryParse(isShippingParam, out isShipping);

                var isDefaultParam = Request.Form["IsDefault"] ?? string.Empty;
                bool isDefault;
                bool.TryParse(isDefaultParam, out isDefault);


                address.FirstName = model.BillingFirstName;
                address.LastName = model.BillingLastName;
                address.Street = model.BillingAddress.Street;
                address.Street2 = model.BillingAddress.Street2;
                address.City = model.BillingAddress.City;
                address.State = model.BillingAddress.State;
                address.Zip = model.BillingAddress.Zip;
                address.Country = model.BillingAddress.Country;
                address.IsShipping = isShipping;
                address.IsDefault = isDefault;
                address.ChangeDate = DateTime.Now;
                address.ChangeUser = FrameworkCommon.USER_NAME;


                new CustomerAddressValidator().ValidateModel(address, ModelState);

                if (ModelState.IsValid)
                {
                    if (address.IsDefault.HasValue && address.IsDefault.Value)
                    {
                        SetAddressDefault(isShipping, address.StoreCustomerAddressID);
                    }

                    Model.CurrentCustomer.ChangeDate = DateTime.Now;
                    Model.CurrentCustomer.ChangeUser = FrameworkCommon.USER_NAME;

                    _storeCustomerRepository.Update(Model.CurrentCustomer);
                    UpdateVisitorSession();
                }
            }
            return RedirectToAction("Profile", "Account");
        }

        [AcceptVerbs(HttpVerbs.Post), NoCacheResponse]
        [Authorize]
        public ActionResult AddAddress(OrderPageViewData model)
        {
            var isShippingParam = Request.Form["IsShipping"] ?? string.Empty;
            bool isShipping;
            bool.TryParse(isShippingParam, out isShipping);

            var isDefaultParam = Request.Form["IsDefault"] ?? string.Empty;
            bool isDefault;
            bool.TryParse(isDefaultParam, out isDefault);

            var address = new StoreCustomerAddress
            {
                StoreCustomerID = model.CurrentCustomer.StoreCustomerID,
                FirstName = model.BillingFirstName,
                LastName = model.BillingLastName,
                Street = model.BillingAddress.Street,
                Street2 = model.BillingAddress.Street2,
                City = model.BillingAddress.City,
                State = model.BillingAddress.State,
                Zip = model.BillingAddress.Zip,
                Country = model.BillingAddress.Country,
                IsShipping = isShipping,
                IsDefault = isDefault,
                AddUser = FrameworkCommon.USER_NAME,
                AddDate = DateTime.Now,
                ChangeUser = FrameworkCommon.USER_NAME,
                ChangeDate = DateTime.Now,
                StoreCustomerAddressID = Guid.NewGuid()
            };

            new CustomerAddressValidator().ValidateModel(address, ModelState);

            if (ModelState.IsValid)
            {
                if (address.IsDefault.HasValue && address.IsDefault.Value)
                {
                    SetAddressDefault(isShipping, address.StoreCustomerAddressID);
                }

                Model.CurrentCustomer.ChangeDate = DateTime.Now;
                Model.CurrentCustomer.ChangeUser = FrameworkCommon.USER_NAME;

                Model.CurrentCustomer.StoreCustomerAddresses.Add(address);

                _storeCustomerRepository.Update(Model.CurrentCustomer);
                UpdateVisitorSession();
            }
            else
            {
                return RedirectToAction("Profile", "Account", new { mode = "addAddress" });
            }

            return RedirectToAction("Profile", "Account");
        }

        [AcceptVerbs(HttpVerbs.Post), NoCacheResponse]
        [Authorize]
        public JsonResult DeleteAddress()
        {
            var addressIdParam = Request.Form["addressId"] ?? string.Empty;
            Guid addressId;
            Guid.TryParse(addressIdParam, out addressId);

            var address = Model.CurrentCustomer.StoreCustomerAddresses
               .FirstOrDefault(a => a.StoreCustomerAddressID == addressId);

            if(address != null)
            {

                Context.GetTable<StoreCustomerAddress>().DeleteOnSubmit(address);
                Model.CurrentCustomer.StoreCustomerAddresses.Remove(address);
                _storeCustomerRepository.Update(Model.CurrentCustomer);
                UpdateVisitorSession();
            }

            return new JsonResult() { JsonRequestBehavior = JsonRequestBehavior.DenyGet };
        }

        private void SetAddressDefault(bool isShipping, Guid addressId)
        {
            List<StoreCustomerAddress> addresses;
            if (addressId == Guid.Empty)
            {
                addresses = Model.CurrentCustomer.StoreCustomerAddresses.Where(a =>
                ((!a.IsShipping.HasValue && !isShipping)
                || (a.IsShipping.HasValue && (!a.IsShipping.Value && !isShipping))
                || (a.IsShipping.HasValue && a.IsShipping.Value && isShipping))
                && a.IsDefault.HasValue
                && a.IsDefault.Value
                ).ToList();
            }
            else
            {
                addresses = Model.CurrentCustomer.StoreCustomerAddresses.Where(a =>
                a.StoreCustomerAddressID != addressId
                && ((!a.IsShipping.HasValue && !isShipping)
                || (a.IsShipping.HasValue && (!a.IsShipping.Value && !isShipping))
                || (a.IsShipping.HasValue && a.IsShipping.Value && isShipping))
                && a.IsDefault.HasValue
                && a.IsDefault.Value
                ).ToList();
            }

            foreach (var address in addresses)
            {
                address.IsDefault = false;
            }
        }
    }
}