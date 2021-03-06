﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using System.Threading.Tasks;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Extensions
{
    public static class WestBlueExtensions
    {
        public static async Task<IEnumerable<Tuple<player, team>>> GetPlayersWithTeamsForYear(this WestBlue westBlue, int year, bool includeInvalidPlayers = false)
        {
            var playerData = await westBlue.playeryeardatas
                        .Include(p => p.player)
                        .Include(p => p.team)
                        .AsNoTracking()
                        .Where(x => x.year.value == year)
                        .ToListAsync();

            return playerData.Where(x => includeInvalidPlayers || x.player.validPlayer).Select(x => Tuple.Create(x.player, x.team));
        }

        public static async Task<IEnumerable<player>> GetPlayersForYear(this WestBlue westBlue, int year)
        {
            return (await westBlue.playeryeardatas.Include(x => x.player).Where(x => x.year.value == year).ToListAsync()).Select(x => x.player);
        }

        public static IEnumerable<team> GetTeamsForYear(this WestBlue westBlue, int year, bool includeInvalidTeams = false)
        {
            return westBlue.teams
                        .AsNoTracking()
                        .Where(x => (includeInvalidTeams || x.validTeam) && x.teamyeardata.Any(y => y.year.value == year))
                        .ToList();
        }

        public static IEnumerable<team> TeamsForYear(this WestBlue westBlue, int year, bool includeInvalidTeams = false)
        {
            return westBlue.teams
                        .Where(x => (includeInvalidTeams || x.validTeam) && x.teamyeardata.Any(y => y.year.value == year))
                        .ToList();
        }

        public static async Task<List<player>> AllPlayersForYearAsync(this WestBlue westBlue, year year, bool includeResults = false, bool includeInvalidPlayers = false)
        {
            IQueryable<player> playersSet = westBlue.players;

            if (includeResults) 
            {
                playersSet = playersSet.Include(x => x.results);
            }
                
            return await playersSet.Where(x => x.playeryeardatas.Any(y => y.year.id == year.id) && (includeInvalidPlayers || x.validPlayer)).ToListAsync();
        }

        public static List<player> AllPlayersForYear(this WestBlue westBlue, year year, bool includeResults = false, bool includeInvalidPlayers = false)
        {
            IQueryable<player> playersSet = westBlue.players;

            if (includeResults)
            {
                playersSet = playersSet.Include(x => x.results);
            }

            return playersSet.Where(x => x.playeryeardatas.Any(y => y.year.id == year.id) && (includeInvalidPlayers || x.validPlayer)).ToList();
        }

        public static async Task<List<week>> GetSchedule(this WestBlue westBlue, int year, bool includeMatches = false)
        {
            var weeks = westBlue.weeks
                .Include(x => x.pairing)
                .Include(x => x.course);

            if (includeMatches)
            {
                weeks.Include(x => x.teammatchups.Select(tm => tm.matches.Select(m => m.results)));
            }
            else
            {
                weeks.Include(x => x.teammatchups.Select(tm => tm.teams));
            }

            /*
            Current model is this:
            week
                |
                teammatchup
                    |
                    matches
                        |
                        results
                    |
                    teams
                        |
                        players

            Need something flat like this on the match level:
            weekId, result1 infos..., result2 infos..., matchOrder, teamMatchup order, teamMatchup id, team1 info, team2 info?

            */

            return await weeks.Where(x => x.year.value == year)
                .OrderBy(x => x.date).ToListAsync();
        }

        public static async Task<IEnumerable<week>> GetWeeksWithMatchUpsForYearAsync(this WestBlue westBlue, int year)
        {
            var weeks = await westBlue.weeks
                .Include(x => x.teammatchups)
                .Include("teammatchups.teams")
                .Include(x => x.pairing)
                .Include(x => x.course)
                .Where(x => x.year.value == year)
                .OrderBy(x => x.date).ToListAsync();

            return weeks;
        }

        public static IEnumerable<leaderboarddata> GetCurrentTeamRankingForYear(this WestBlue westBlue, int year)
        {
            return westBlue.leaderboarddatas.Include(x => x.leaderboard).Where(x => x.year.value == year).ToList().OrderBy(x => x.rank);
        }

        public static bool IsComplete(this match r)
        {
            return r.results != null && r.results.All(x => x != null && x.IsComplete());
        }

        public static int PointsForYear(this team t, IEnumerable<result> resultsForYear)
        {
            int sum = 0;
            foreach (var result in resultsForYear)
            {
                if (!result.IsComplete()) { continue; }
                sum += result.points.Value;
            }

            return sum;
        }
    }
}