﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Data.Entity;
using System.Net.Http;
using System.Threading.Tasks;
using WestBlueGolfLeagueWeb.Models.Entities;
using WestBlueGolfLeagueWeb.Models.Responses;
using WestBlueGolfLeagueWeb.Models.Responses.Admin;
using WestBlueGolfLeagueWeb.Models.Admin;
using WestBlueGolfLeagueWeb.Models.ScoreEntry;
using System.Net;
using System.Web.Http;


namespace WestBlueGolfLeagueWeb.Controllers.Admin
{
    [Authorize(Roles = AdminRole.Admin.Name + "," + AdminRole.TeamCaptain.Name)]
    public class ScoreEntryController : WestBlueDbApiController
    {
        /// <summary>
        /// Get the overall schedule data
        /// </summary>
        /// <returns></returns>
        public async Task<IHttpActionResult> GetScoreEntryData()
        {
            var weeks = (await this.Db.GetWeeksWithMatchUpsForYearAsync(this.CurrentYear)).ToList();

	        var now = DateTimeOffset.UtcNow;

	        var currentWeek = weeks.FirstOrDefault(x => now < new DateTimeOffset(x.date)) ?? weeks.LastOrDefault();

	        Dictionary<int, IEnumerable<player>> lookup =
		        this.Db.GetPlayersWithTeamsForYear(this.CurrentYear, true)
			        .ToLookup(x => x.Item2.id, x => x.Item1)
			        .ToDictionary(x => x.Key, x => (IEnumerable<player>)x);
			
			// TODO: need to carry over dummy team to new year.
	        return Ok(new ScoreEntryDataResponse(currentWeek, weeks, lookup, this.Db.GetTeamsForYear(this.CurrentYear, true)));
        }

        /// <summary>
        /// Get data for a specific week
        /// </summary>
        /// <returns></returns>
        public async Task<IHttpActionResult> GetMatchup(int weekId, int matchupId)
        {
            var matchup = await this.Db.teammatchups
                            .Include(x => x.matches)
                            .Include("matches.results")
                            .Include("matches.results.player")
                            .AsNoTracking()
                            .FirstOrDefaultAsync(x => x.week.id == weekId && x.week.year.value == this.CurrentYear && x.id == matchupId);

            if (matchup == null)
            {
                return NotFound();
            }

            return Ok(new { teamMatchup = new TeamMatchupWithMatches(matchup) });
        }

        [HttpPut]
        public async Task<HttpResponseMessage> PutMatchup(int weekId, int matchupId, TeamMatchupWithMatches teamMatchup)
        {
            if (teamMatchup.Id != matchupId)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest);
            }

            var databaseTeamMatchup = await this.Db.teammatchups.Include(y => y.week).Include("week.year").FirstOrDefaultAsync(x => x.id == teamMatchup.Id);

            if (databaseTeamMatchup == null)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { errors = new string[] { "Couldn't find requested teammatchup." } });
            }

            ScoreEntry scoreEntry = new ScoreEntry(teamMatchup, databaseTeamMatchup.week);

            if (!scoreEntry.IsValid)
            {
                return Request.CreateResponse(HttpStatusCode.BadRequest, new { errors = scoreEntry.Errors });
            }

            try
            {
                await scoreEntry.SaveScoresAsync(this.Db);
            }
            catch (Exception e)
            {
                return Request.CreateResponse(HttpStatusCode.InternalServerError, new { errors = new string[] { "There was an error saving scores/matches: " + e.Message } });
            }

            try
            {
                // Crunch leaderboards/handicaps
            }
            catch (Exception e)
            {

            }

            return Request.CreateResponse(HttpStatusCode.OK);
        }
    }
}