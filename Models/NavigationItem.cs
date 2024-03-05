using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace IDVCFS.Models
{
    public class NavigationItem
    {
        private const string SEARCHQUERY = "SearchResults?n=1&query={0}";

        public string Id { get; set; }
        public string Name { get; set; }
        public string Link { get; set; }
        public bool IsLive { get; set; }

        public NavigationItem ()
        {
            IsLive = true;
        }

        public string FormatSearchQuery (string url)
        {
            return string.Format(SEARCHQUERY, url.Replace(" ", "%20"));
        }
    }
}