﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Data.Entity;
using WestBlueGolfLeagueWeb.Models.ViewModels;
using System.Threading.Tasks;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class HomeController : WestBlueDbMvcController
    {
        public async Task<ViewResult> Index()
        {
            int selectedYear = this.SelectedYear;
            
            var rankingValuesForYear = this.Db.leaderboarddatas.Where(x => x.year.value == selectedYear && x.leaderboard.key == "team_ranking").OrderBy(x => x.rank).ToList();
            var year = this.Db.years.Where(x => x.value == selectedYear).ToList().First();

            var latestNote = await this.Db.notes.OrderByDescending(x => x.date).FirstOrDefaultAsync();

            return View(new HomeViewModel { Information = latestNote, TeamRankingDataForYear = rankingValuesForYear, ScheduleYear = year, SelectedYear = selectedYear });
        }

        public ActionResult AngularMain()
        {
            return View("AngularView");
        }
    }
}