namespace WestBlueGolfLeagueWeb.Models.Entities
{
    using System;
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity.Spatial;

    [Table("westbluegolf.pairing")]
    public partial class pairing
    {
        public pairing()
        {
            weeks = new HashSet<week>();
        }

        public int id { get; set; }

        [StringLength(45)]
        public string pairingText { get; set; }

        public virtual ICollection<week> weeks { get; set; }
    }
}
