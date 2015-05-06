﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses.Schedule
{
    public class ScheduleWeek : WeekResponse
    {
        public ScheduleWeek(week w) : base(w)
        {
            this.TeamMatchups = w.teammatchups
                .Select(x => new ScheduleTeamMatchup(x)).OrderBy(x => x.MatchOrder).ToList();
            this.Course = CourseResponse.From(w.course);
            this.Pairing = w.pairing.pairingText;
        }

        public List<ScheduleTeamMatchup> TeamMatchups { get; set; }
        public CourseResponse Course { get; set; }
        public string Pairing { get; set; }
    }
}