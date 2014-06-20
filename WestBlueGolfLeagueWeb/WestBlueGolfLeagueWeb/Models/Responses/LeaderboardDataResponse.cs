﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Responses
{
    public class LeaderBoardDataResponse
    {
        public static LeaderBoardDataResponse From(leaderboarddata lbd)
        {
            return new LeaderBoardDataResponse
            {
                Id = lbd.id,
                IsP = lbd.isPlayer,
                LbId = lbd.leaderBoardId,
                PId = lbd.playerId,
                V = lbd.value,
                TId = lbd.teamId,
                // Year = lbd.yearId // This is really implied based on the API.
                R = lbd.rank,
                Det = lbd.detail
            };
        }

        public int Id { get; set; }

        /// <summary>
        /// Is player?
        /// </summary>
        public bool IsP { get; set; }

        /// <summary>
        /// Leaderboard ID
        /// </summary>
        public int LbId { get; set; }

        /// <summary>
        /// Player id
        /// </summary>
        public int? PId { get; set; }

        /// <summary>
        /// Team ID
        /// </summary>
        public int? TId { get; set; }

        /// <summary>
        /// Rank
        /// </summary>
        public int R { get; set; }

        /// <summary>
        /// Details
        /// </summary>
        public string Det { get; set; }

        /// <summary>
        /// Value
        /// </summary>
        public double V { get; set; }
    }
}