﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class DataByYear
    {
        public List<PlayerResponse> PlayersForYear { get; set; }
        public List<LeaderBoardDataResponse> LeaderboardDataForYear { get; set; }
        public List<TeamResponse> TeamsForYear { get; set; }
        public List<LeaderBoardResponse> Leaderboards { get; set; }
        public List<TeamMatchupResponse> TeamMatchups { get; set; }
        public List<CourseResponse> Courses { get; set; }

        public List<WeekResponse> Weeks { get; set; }

        public List<pairing> Pairings { get; set; }
    }
}