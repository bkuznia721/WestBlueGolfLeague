﻿using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.Admin
{
    public class AddPlayerRequest
    {
		[Required(ErrorMessage = "Player name is required.")]
		[MinLength(5, ErrorMessage = "Must be at least 5 characters.")]
		[Display(Name = "Player Name")]
        public string PlayerName { get; set; }

		[Required(ErrorMessage = "Handicap is required.")]
		[Display(Name = "Player Handicap")]
        [Range(-5, 20, ErrorMessage = "Handicap must be between -5 and 20 (inclusive)")]
        public int Handicap { get; set; }
		
		[Required(ErrorMessage = "Must select a team!")]
		[Display(Name = "Team")]
        public int TeamId { get; set; }

        [Display(Name = "Rookie", Description = "Should this player be treated as a rookie?")]
        public bool IsRookie { get; set; }

		public IEnumerable<team> Teams { get; set; }
    }
}