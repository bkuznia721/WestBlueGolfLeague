﻿

(function (team) {

    function TeamConfig($locationProvider, $urlRouterProvider, $stateProvider) {

        $stateProvider
            .state('teamList', {
                url: '/',
                templateUrl: '/Scripts/team/tpl/teamListWrapper.tpl.html',
            });

        $stateProvider
            .state('teamDetails', {
                abstract: true,
                templateUrl: '/Scripts/team/tpl/teamDetailsLayout.tpl.html',
                controller: 'TeamDetailsLayout'
            });

        $stateProvider
            .state('teamDetails.teamProfile', {
                url: '/:id',
                views: {
                    /*teamList: {
                        templateUrl: '/Scripts/team/tpl/teamList.tpl.html',
                        controller: 'TeamList as tList'
                    },*/
                    teamDetails: {
                        templateUrl: '/Scripts/team/tpl/teamDetails.tpl.html',
                        controller: 'TeamDetails as teamDetails'
                    },
                    'header.main@': {
                        template: '<a class="navbar-brand" ui-sref="teamList()" href="javascript:void();"><i class="fa fa-chevron-left"></i> Teams</a>'
                    }
                },
                resolve: {
                    profileData: ['resolvedTeamProfileService', '$stateParams', function (profileService, $stateParams) {
                        return profileService.getTeamData($stateParams.id);
                    }],
                    resolvedTeamProfileService: 'TeamProfileService'
                }
            });

        $locationProvider.html5Mode(true);
    };

    function TeamDetails(profileData) {
        this.profileData = profileData.data;
    };

    function TeamProfileService($http) {
        return {
            getTeamData: function (id) {
                return $http({
                    method: 'GET',
                    url: '/api/v1/teamProfile/' + id
                });
            }
        };
    };

    function TeamDetailsLayout() {

    };

    function TeamListDirective() {
        return {
            templateUrl: '/Scripts/team/tpl/teamList.tpl.html',
            controller: 'TeamList',
            controllerAs: 'tList',
            restrict: 'A',
            link: function () {

            }
        };
    };

    team
        .config(['$locationProvider', '$urlRouterProvider', '$stateProvider', TeamConfig])
        .controller('TeamDetails', ['profileData', TeamDetails])
        .controller('TeamDetailsLayout', TeamDetailsLayout)
        .factory('TeamProfileService', ['$http', TeamProfileService])
        .directive('teamList', TeamListDirective);

})(angular.module('team', ['app', 'ngAnimate', 'ui.router', 'teamList', 'leaderBoards']));

  