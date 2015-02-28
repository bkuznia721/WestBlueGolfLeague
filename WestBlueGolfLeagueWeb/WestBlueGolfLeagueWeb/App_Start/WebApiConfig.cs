﻿using Newtonsoft.Json.Serialization;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Formatting;
using System.Web.Http;

namespace WestBlueGolfLeagueWeb
{
    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {
            // Web API configuration and services

            // Web API routes
            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(name: "DataByYear", routeTemplate: "api/v1/data/{year}", defaults: new { controller = "DataByYear", action = "GetDataForYear" });

            config.Routes.MapHttpRoute(name: "AvailableYears", routeTemplate: "api/v1/availableYears", defaults: new { controller = "DataByYear", action = "GetAvailableYears" });

            config.Routes.MapHttpRoute(name: "AvailableLeaderBoards", routeTemplate: "api/v1/leaderboards", defaults: new { controller = "LeaderBoardApi", action = "GetAvailableLeaderBoards" });

            config.Routes.MapHttpRoute(name: "GetLeaderBoardByKey", routeTemplate: "api/v1/leaderboards/{key}", defaults: new { controller = "LeaderBoardApi", action = "GetLeaderBoard" });

            config.Routes.MapHttpRoute(name: "GetPlayerProfile", routeTemplate: "api/v1/playerProfile/{id}", defaults: new { controller = "PlayerApi", action = "GetProfileData" });

            config.Routes.MapHttpRoute(name: "GetTeamProfile", routeTemplate: "api/v1/teamProfile/{id}", defaults: new { controller = "TeamApi", action = "GetProfileData" });

            config.Routes.MapHttpRoute(
                name: "DefaultApi",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
            );

            var jsonFormatter = config.Formatters.OfType<JsonMediaTypeFormatter>().First();
            jsonFormatter.SerializerSettings.ContractResolver = new CamelCasePropertyNamesContractResolver();
        }
    }
}
