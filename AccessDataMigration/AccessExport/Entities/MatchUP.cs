﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    class MatchUp
    {
        public int Id { get; set; }
        public TeamMatchup TeamMatchup { get; set; }
        public Player Player1 { get; set; }
        public Player Player2 { get; set; }
    }
}
