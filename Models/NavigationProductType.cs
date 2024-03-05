using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Dtm.Framework.ClientSites.Web;

namespace IDVCFS.Models
{
    public class NavigationProductType : NavigationItem
    {
        public List<NavigationItem> List;

        public NavigationProductType ()
        {
            List = new List<NavigationItem>
            {
                new NavigationItem
                {
                    Id = "all",
                    Name = "All",
                    Link = FormatSearchQuery("all")
                },
                new NavigationItem
                {
                    Id = "health",
                    Name = "Health",
                    Link = FormatSearchQuery("health")
                },
                new NavigationItem
                {
                    Id = "hands",
                    Name = "Hands",
                    Link = FormatSearchQuery("hands")
                },
                new NavigationItem
                {
                    Id = "arms",
                    Name = "Arms",
                    Link = FormatSearchQuery("arms")
                },
                new NavigationItem
                {
                    Id = "legs",
                    Name = "Legs",
                    Link = FormatSearchQuery("legs")
                },
                new NavigationItem
                {
                    Id = "back",
                    Name = "Back",
                    Link = FormatSearchQuery("back")
                },
                new NavigationItem
                {
                    Id = "apparel",
                    Name = "Apparel",
                    Link = FormatSearchQuery("apparel"),
                },
                new NavigationItem
                {
                    Id = "best",
                    Name = "Best",
                    Link = FormatSearchQuery("best")
                }
                //new NavigationItem
                //{
                //    Id = "balance",
                //    Name = "balance",
                //    Link = FormatSearchQuery("balance")
                //}
            };

            if (!DtmContext.IsStage)
            {
                List = List.Where(x => x.IsLive).ToList();
            }

            List = List.OrderBy(x => x.Name).ToList();
        }
    }
}