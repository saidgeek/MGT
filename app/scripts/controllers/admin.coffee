'use strict'

angular.module('movistarApp')
  .controller 'AdminCtrl', ($rootScope, $scope, Auth, $location) ->
    $rootScope.cssInclude = [
      'styles/admin.css', 
      'styles/jquery.mCustomScrollbar.css', 
      'styles/adminFonts.css'
    ]

    switch $location.$$path
      when '/admin/category'
        $scope.module = 'category'
      else
        $scope.module = ''

  .controller 'UserCtrl', ($scope, UserFactory) ->
    $scope.users = []
    $scope.errors = {}

    UserFactory.index (err, users) ->
      if err
        $scope.errors = err
      else
        $scope.users = users