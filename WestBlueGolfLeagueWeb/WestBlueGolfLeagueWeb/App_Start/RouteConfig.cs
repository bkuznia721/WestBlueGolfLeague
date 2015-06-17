﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Routing;

namespace WestBlueGolfLeagueWeb
{
    public class RouteConfig
    {
        public static void RegisterRoutes(RouteCollection routes)
        {
            routes.IgnoreRoute("{resource}.axd/{*pathInfo}");

            routes.MapRoute(name: "Root", url: "", defaults: new { controller = "Home", action = "AngularMain" });

            routes.MapRoute(name: "PlayerPage", 
                url: "Player/{*catchall}", defaults: new { controller = "Player", action = "Index" });

            routes.MapRoute(name: "TeamPage",
                url: "Team/{*catchall}", defaults: new { controller = "Team", action = "Index" });

            routes.MapRoute(name: "LeaderBoards",
                url: "LeaderBoards/{*catchall}", defaults: new { controller = "Home", action = "AngularMain" });

	        routes.MapRoute("AddPlayer", "Admin/AddPlayer", new { controller = "Admin", action = "AddPlayer" });

            routes.MapRoute(name: "Admin",
                url: "Admin/{*catchall}", defaults: new { controller = "Admin", action = "Index" });

            routes.MapRoute(name: "AngularMain",
                url: "AngularTest/{*catchall}", defaults: new { controller = "Home", action = "AngularMain" });

            routes.MapRoute(
                name: "Default",
                url: "{controller}/{action}/{id}",
                defaults: new { controller = "Home", action = "AngularMain", id = UrlParameter.Optional }
            );
        }
    }
}
