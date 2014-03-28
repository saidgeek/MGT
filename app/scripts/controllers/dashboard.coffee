'use strict'

angular.module('movistarApp')
  .controller 'DashboardCtrl', ($rootScope, $scope, Auth, $location, RolesData) ->
    $rootScope.cssInclude = [
      'styles/admin.css', 
      'styles/jquery.mCustomScrollbar.css', 
      'styles/adminFonts.css'
    ]