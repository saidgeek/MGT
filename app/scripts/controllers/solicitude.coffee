'use strict'

angular.module('movistarApp')
  .controller 'SolicitudeCtrl', ($rootScope, $scope, Auth, $location, RolesData) ->
    $rootScope.cssInclude = [
      'styles/jquery.mCustomScrollbar.css',
      'styles/styles.css',
      'styles/adminFonts.css'
    ]
