﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AccessExport
{
    class Week
    {
        public DateTime Date { get; set; }
        public int Id { get; set; }
        public Course Course { get; set; }
        public int SeasonIndex { get; set; }
    }
}
