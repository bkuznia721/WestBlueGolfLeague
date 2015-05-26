﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Models.ScoreEntry
{
    public interface ILeaderBoard<T>
    {
        LeaderBoardFormat Format { get; set; }
        string LeaderBoardKey { get; set; }
        string LeaderBoardName { get; set; }
        bool Ascending { get; set; }
        double? DoCalculation(T t, year year, IEnumerable<result> results);
        bool IsPlayerBoard { get; }
        int Priority { get; }
    }

    public class LeaderBoardFormat
    {
        private FormatFunc formatFunc;
        private delegate string FormatFunc(double val);

        private LeaderBoardFormat(int persistedKey, FormatFunc func)
        {
            this.PersistedKey = persistedKey;
            this.formatFunc = func;
        }

        public int PersistedKey { get; private set; }

        public string FormatValue(double? val)
        {
            if (!val.HasValue) { return null; }

            return this.formatFunc(val.Value);
        }

        public static readonly LeaderBoardFormat Default = new LeaderBoardFormat(0, x => string.Format("{0:0.##}", x));

        public static readonly LeaderBoardFormat Ratio = new LeaderBoardFormat(1, x => string.Format("{0:0.000}", x));

        public static readonly LeaderBoardFormat Net = new LeaderBoardFormat(2, x => string.Format("{0:+0.##;-0.##}", x));
    }
}
