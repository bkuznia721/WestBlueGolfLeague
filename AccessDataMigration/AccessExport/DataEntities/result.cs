namespace AccessExport.DataEntities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.result")]
    public partial class result
    {
        public int id { get; set; }

        public int priorHandicap { get; set; }

        public int score { get; set; }

        public int points { get; set; }

        public int teamId { get; set; }

        public int playerId { get; set; }

        public int matchupId { get; set; }

        public int yearId { get; set; }

        public virtual matchup matchup { get; set; }

        public virtual player player { get; set; }

        public virtual team team { get; set; }

        public virtual year year { get; set; }
    }
}
