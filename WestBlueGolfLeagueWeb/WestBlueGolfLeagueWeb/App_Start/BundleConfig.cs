﻿using HtmlBundling;
using System.Web;
using System.Web.Optimization;

namespace WestBlueGolfLeagueWeb
{
    public class BundleConfig
    {
        // For more information on bundling, visit http://go.microsoft.com/fwlink/?LinkId=301862
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new ScriptBundle("~/bundles/lib").Include(
                        "~/Scripts/lib/jquery/jquery-{version}.js",
                        //"~/Scripts/lib/jquery/jquery.validate*",
                        "~/Scripts/lib/bootstrap/bootstrap.js",
                        "~/Scripts/lib/lodash.min.js",
                        "~/Scripts/lib/moment/moment.js",
                        "~/Scripts/lib/angular/angular-{version}.js",
                        "~/Scripts/lib/angular/angular-*",
                        "~/Scripts/lib/angular-ui-router-{version}.js",
                        "~/Scripts/lib/ui-bootstrap-tpls-{version}.js",
                        "~/Scripts/lib/bootstrap/gm.datepickerMultiSelect.js"));

            bundles.Add(new ScriptBundle("~/bundles/jqueryval").Include(
                        "~/Scripts/lib/jquery/jquery.validate*"));

            // Use the development version of Modernizr to develop with and learn from. Then, when you're
            // ready for production, use the build tool at http://modernizr.com to pick only the tests you need.
            bundles.Add(new ScriptBundle("~/bundles/modernizr").Include(
                        "~/Scripts/modernizr-*"));

            bundles.Add(new ScriptBundle("~/bundles/app")
                .Include("~/Scripts/main/*.js")
                .Include("~/Scripts/player/playerList.js", "~/Scripts/player/*.js")
                .Include("~/Scripts/player/teamList.js", "~/Scripts/team/*.js")
                .Include("~/Scripts/schedule/schedule.js", "~/Scripts/schedule/*.js")
                .Include("~/Scripts/admin/userManagement.js", "~/Scripts/admin/*.js")
                .Include("~/Scripts/leaderBoards/leaderBoards.js", "~/Scripts/leaderBoards/*.js")
				.Include("~/Scripts/layout/*.js"));

            bundles.Add(new AngularJsHtmlBundle("~/bundles/app/html").IncludeDirectory("~/Scripts", "*.tpl.html", true));

            // TODO: possibly change this path to make fonts work correctly?
            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/bootstrap.css",
					  //"~/Content/bootstrap-theme.css",
                      "~/Content/fontawesome/font-awesome.css",
                      "~/Content/Site.css"));

            //BundleTable.EnableOptimizations = true;
        }
    }
}
