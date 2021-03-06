﻿angular
    .module('admin')
    .config(['$stateProvider', function ($stateProvider) {
        $stateProvider
            .state('admin.scoreEntry', {
                abstract: true,
                url: 'scoreEntry',
                templateUrl: '/Scripts/admin/tpl/scoreEntry/scoreEntryContainer.tpl.html',
                controller: 'ScoreEntry as scoreEntry',
                resolve: {
                    scoreEntrySvc: 'scoreEntry',
                    scoreEntryData: ['scoreEntrySvc', function (scoreEntry) {
                    	return scoreEntry.getWeeks().then(function (data) {

                    		// post process the players to get the structure we need
                    		// (super super super hacky, fix the model coming back from the DB)
		                    scoreEntry.postProcessData(data.data);

                            return data.data;
                        });
                    }]
                }
            })
            .state('admin.scoreEntry.currentWeek', {
                url: '',
                controller: ['$stateParams', '$state', 'scoreEntryData', '$location', '$timeout', function ($stateParams, $state, scoreEntryData, $location, $timeout) {
                    // super hack
                    $timeout(function () {
                        $location.path('/scoreEntry/' + scoreEntryData.currentWeek.id).replace();
                    }, 0, true);
                    //$state.go('admin.scoreEntry.week', { weekId: weekEntry }, { location: 'replace' });
                }]
            })
            .state('admin.scoreEntry.week', {
                url: '/:weekId',
                templateUrl: '/Scripts/admin/tpl/scoreEntry/week.tpl.html',
                controller: 'CurrentWeek as currentWeek'
            })
            // Probably don't need this state anymore
            .state('admin.scoreEntry.week.matchup', {
                abstract: true,
                controller: 'Matchup as matchupCtrl',
                templateUrl: '/Scripts/admin/tpl/scoreEntry/matchupContainer.tpl.html',
               
            })
            .state('admin.scoreEntry.week.matchup.edit', {
                url: '/:matchupId',
                templateUrl: '/Scripts/admin/tpl/scoreEntry/matchupEdit.tpl.html',
                controller: 'MatchupEdit as matchupEdit',
                resolve: {
                    TeamMatchup: 'TeamMatchup',
                    resolvedTeamMatchup: ['TeamMatchup', '$stateParams', function (TeamMatchup, $stateParams) {
                        return new TeamMatchup($stateParams.weekId, $stateParams.matchupId).$promise;
                    }]
                }
            })
    }])
    .run(['$rootScope', '$state', function ($rootScope, $state) {
        $rootScope.$on('$stateChangeSuccess', function (e, toState, toParams, fromState, fromParams) {
            console.log(toState.name);
        });
    }])
    .factory('scoreEntry', ['$http', function ($http) {
        return {
            getWeeks: function () {
                return $http({
                    method: 'GET',
                    url: '/api/scoreEntry'
                });
            },
        	// This is really just so we make our ngOptions stuff easier later :\
        	postProcessData: function(data) {

        		var teamsLookup = {};

		        _.each(data.teams, function(item) {
			        teamsLookup[item.id] = item;
		        });

		        _.each(data.teamIdToPlayer, function(playerArray, teamId) {
					for (var i = 0; i < playerArray.length; i++) {
						playerArray[i].teamName = teamId == 1 ? 'Sub/No Show' : teamsLookup[teamId].name;
					}
		        });
        	},
			getOtherTeamPlayers: function(teamIdNotToFetch, lookup) {
				return _.flatten(_.filter(lookup, function(item, key) {
					return key != teamIdNotToFetch && key != 1;
				}));
			}
        }
    }])

    .factory('TeamMatchup', ['$http', '$q', function($http, $q) {

        return function teamMatchup(weekId, matchupId) {

            var self = this;

            // Makes sure there are always 4 matches
            function extendMatches() {
                if (!self.teamMatchup.matches) { self.teamMatchup.matches = []; }

                for (var i = self.teamMatchup.matches.length; i < 4; i++) {
                    self.teamMatchup.matches.push({});
                }
            };

            this.$promise = $http({
                method: 'GET',
                url: '/api/scoreEntry/matchup/' + weekId + '/' + matchupId
            }).then(function (response) {
                _.extend(self, response.data);
                
                extendMatches();

                return self;
            });

            this.save = function () {
                return $http({
                    method: 'PUT',
                    url: '/api/scoreEntry/matchup/' + weekId + '/' + matchupId,
                    data: self.teamMatchup
                }).catch(function (data) {
                    var errorCode = data.status == 500 ? "error" : "invalidScoreEntry";
                    return $q.reject({ errorCode: errorCode, errors: data.data && data.data.errors ? data.data.errors : ['Unspecified error occurred when saving scores'] });
                });
            };
        };
    }])

    .filter('scoreEntryErrorMessage', function () {

        return function (input) {
            if (input === 'error') {
                return 'There was an error saving scores:';
            }
            else {
                return 'Please fix the following issues with your score entry to continue:';
            }
        };
    })

    .controller('MatchupEdit', ['$stateParams', 'resolvedTeamMatchup', 'scoreEntryData', 'scoreEntry',
		function ($stateParams, resolvedTeamMatchup, scoreEntryData, scoreEntry) {

		    var self = this;

		    self.team1 = resolvedTeamMatchup.teamMatchup.team1;
		    self.team2 = resolvedTeamMatchup.teamMatchup.team2;
		
		    self.matches = resolvedTeamMatchup.teamMatchup.matches;

		    var dummyTeam = scoreEntryData.teamIdToPlayer[1]; // dummy team is #1 in the db, and should always be?

		    var team1players = scoreEntryData.teamIdToPlayer[this.team1.id] || [];

		    self.team1PlayerList = team1players.concat(dummyTeam, scoreEntry.getOtherTeamPlayers(this.team1.id, scoreEntryData.teamIdToPlayer));

            var team2players = scoreEntryData.teamIdToPlayer[this.team2.id] || [];

		    self.team2PlayerList = team2players.concat(dummyTeam, scoreEntry.getOtherTeamPlayers(this.team2.id, scoreEntryData.teamIdToPlayer));

		    self.toggleInputState = function (playerId, match, prop) {
		        if (playerId < 3) {
		            match[prop].points = 0;
		            match[prop].score = match[prop].equitableScore = 99;
		        }
		    };

		    self.error = null;

		    this.saveMatchup = function () {
		        self.disabled = true;
		        self.error = null;
		        self.successMessage = null;

		        resolvedTeamMatchup.save().then(function () {
		            self.disabled = false;
		            self.successMessage = 'Successfully saved scores!';
		        }).catch(function (err) {
		            self.disabled = false;

		            self.error = err;
		        });
		    };
	}])
    .controller('Matchup', ['$stateParams', 'scoreEntryData', function ($stateParams, scoreEntryData) {
    	var selectedWeek = _.find(scoreEntryData.schedule.weeks, function (x) {
            return x.id == $stateParams.weekId;
        });

        this.weekId = $stateParams.weekId;
        this.matchups = selectedWeek.teamMatchups;
    }])
    .controller('CurrentWeek', ['$stateParams', 'scoreEntryData', function ($stateParams, scoreEntryData) {
    	var selectedWeek = _.find(scoreEntryData.schedule.weeks, function (x) {
            return x.id == $stateParams.weekId;
        });

        this.selectedWeek = selectedWeek;
        this.matchups = selectedWeek.teamMatchups;
    }])
    .controller('ScoreEntry', ['scoreEntryData', function (scoreEntryData) {
        this.weeks = scoreEntryData.schedule.weeks;
    }]);