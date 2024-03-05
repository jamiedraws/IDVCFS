using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Dtm.Framework.ClientSites.Web;

namespace IDVCFS.Models
{
    public class NavigationProductCollection : NavigationItem
    {
        public List<NavigationItem> List;

        public NavigationProductCollection ()
        {
            List = new List<NavigationItem>
            {
                new NavigationItem {
                    Id = "energy", 
                    Name = "Energy",
                    Link = FormatSearchQuery("energy")
                },
                //new NavigationItem
                //{
                //    Id = "balance",
                //    Name = "Balance",
                //    Link = FormatSearchQuery("balance")
                //},
                new NavigationItem
                {
                    Id = "ice",
                    Name = "Ice",
                    Link = FormatSearchQuery("ice")
                },
                new NavigationItem
                {
                    Id = "rapid-relief",
                    Name = "Rapid Relief",
                    Link = FormatSearchQuery("rapid relief")
                },
                new NavigationItem
                {
                    Id = "guardwell",
                    Name = "Guardwell",
                    Link = FormatSearchQuery("guardwell")
                },
                new NavigationItem
                {
                    Id = "compression",
                    Name = "Compression",
                    Link = FormatSearchQuery("compression")
                },
                new NavigationItem
                {
                    Id = "apparel",
                    Name = "Apparel",
                    Link = FormatSearchQuery("apparel")
                }
            };

            if (!DtmContext.IsStage)
            {
                List = List.Where(x => x.IsLive).ToList();
            }

            List = List.OrderBy(x => x.Name).ToList();
        }
    }
}