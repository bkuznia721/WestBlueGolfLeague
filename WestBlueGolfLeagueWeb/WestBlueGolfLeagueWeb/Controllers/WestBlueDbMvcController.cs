﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using WestBlueGolfLeagueWeb.Models.Entities;

namespace WestBlueGolfLeagueWeb.Controllers
{
    public class WestBlueDbMvcController : Controller
    {
		private WestBlue db = null;

		protected WestBlueDbMvcController(bool needWriteAccess = false)
		{
			this.db = new WestBlue(needWriteAccess);
            this.ControllerHelper = new ControllerHelper();
		}

		public WestBlue Db { get { return this.db; } }

        protected ControllerHelper ControllerHelper { get; private set; }

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                db.Dispose();
            }
            base.Dispose(disposing);
        }
    }
}