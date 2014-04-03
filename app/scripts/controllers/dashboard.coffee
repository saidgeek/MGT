'use strict'

angular.module('movistarApp')
  .controller 'DashboardCtrl', ($rootScope, $scope, Auth, $location, RolesData) ->
    $rootScope.cssInclude = [
      'styles/jquery.mCustomScrollbar.css',
      'styles/styles.css',
      'styles/ie.css',
      'styles/adminFonts.css'
    ]
