﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Data.Entity;
using System.Threading.Tasks;
using System.Web.Http;
using System.Web.Http.Description;
using WestBlueGolfLeagueWeb.Models.Admin;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.Responses.Player;
using WestBlueGolfLeagueWeb.Models.ViewModels;
using WestBlueGolfLeagueWeb.Models.Extensions;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class PlayerApiController : WestBlueDbApiController
    {
        [ResponseType(typeof(PlayerListViewModel))]
        public async Task<IHttpActionResult> GetPlayersList()
        {
            int year = this.SelectedYear;

            var playersForYear = await this.Db.GetPlayersWithTeamsForYear(year);

            return Ok(new PlayerListViewModel
            {
                PlayersForYear =
                        playersForYear.Select(
                            x =>
                                new { Name = x.Item1.name, CH = x.Item1.currentHandicap, TeamName = x.Item2.teamName, Id = x.Item1.id })
            });
        }


        [ResponseType(typeof(PlayerProfileData))]
        public async Task<IHttpActionResult> GetProfileData(int id)
        {
            var p = this.Db.players.FindAsync(id);

            var player = await p;

            if (player == null)
            {
                return NotFound();
            }

            int year = this.SelectedYear;

            // get leaderboards for player.
            var boardData = this.Db
                .leaderboarddatas
                .Include(x => x.leaderboard)
                .Where(
                    x => x.playerId == player.id &&
                        (x.leaderboard.key == "player_handicap" ||
                        x.leaderboard.key == "player_best_score" ||
                        x.leaderboard.key == "player_avg_points" ||
                        x.leaderboard.key == "player_net_best_score" ||
                        x.leaderboard.key == "player_season_improvement") &&
                        x.year.value == year).ToListAsync();

            var results =
                this.Db
                    .results
                    .Include(x => x.match)
                    .Include(x => x.match.teammatchup.week)
                    .Include(x => x.match.results)
                    .Include(x => x.match.teammatchup.teams)
                    .Include(x => x.player)
                    .Where(
                        x =>
                            x.playerId == player.id &&
                            x.year.value == year
                    ).ToListAsync();
                   
            IEnumerable<leaderboarddata> leaderBoardDatas = await boardData;
            IEnumerable<result> resultsForYear = await results;

            var keyToBoardData = leaderBoardDatas.ToDictionary(x => x.leaderboard.key);
            var boardHandicap = TryGetFormattedValue(keyToBoardData, "player_handicap");

            // Display the player's handicap when the boards are down
            if (string.IsNullOrEmpty(boardHandicap))
            {
                // This may be prone to being incorrect for prior years, but the boards shouldn't be down for those
                boardHandicap = player.currentHandicap.ToString();
            }

            return Ok(
                new PlayerProfileData 
                { 
                    PlayerName = player.name,
					AveragePoints = TryGetFormattedValue(keyToBoardData, "player_avg_points"), 
                    Handicap = boardHandicap, 
                    Improved = TryGetFormattedValue(keyToBoardData, "player_season_improvement"), 
                    LowNet = TryGetFormattedValue(keyToBoardData, "player_net_best_score"), 
                    LowScore = TryGetFormattedValue(keyToBoardData, "player_best_score"),
                    ResultsForYear = resultsForYear.Select(x => new PlayerProfileResult(player, x)),
                    CompleteResultsForYear = resultsForYear.Where(x => x.match.teammatchup.matchComplete).Select(x => new PlayerProfileResult(player, x)),
                    IncompleteResultsForYear = resultsForYear.Where(x => x.match.teammatchup.matchComplete == false).Select(x => new PlayerProfileResult(player, x))
                });
        }

		private string TryGetFormattedValue(Dictionary<string, leaderboarddata> dictionary, string leaderboardName)
		{
			leaderboarddata leaderboarddata = null;

			if (dictionary.TryGetValue(leaderboardName, out leaderboarddata))
			{
				return leaderboarddata.formattedValue;
			}

			return string.Empty;
		}
    }
}