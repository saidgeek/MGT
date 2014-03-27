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

    $scope.showModals = (modal) ->
      $scope.modals = modal
    $scope.$on 'hideModals', (e, args) ->
      $scope.modals = ''

  .controller 'UserCtrl', ($scope, UserFactory, $rootScope) ->
    $scope.users = []
    $scope.errors = {}

    UserFactory.index (err, users) ->
      if err
        $scope.errors = err
      else
        $scope.users = users

    $rootScope.$on 'updateUsers', (e, user) ->
      console.log user
      $scope.users.unshift user

  .controller 'UserSaveCtrl', ($scope, UserFactory, $rootScope) ->
    $scope.user = {}
    $scope.errors = {}

    $scope.create = (form) ->
      if form.$valid
        UserFactory.save $scope.user, (err, user) ->
          if err
            $scope.errors = err
          else
            $rootScope.$emit 'updateUsers', user
            $scope.$emit 'hideModals', true

    $scope.closeModal = () ->
      $scope.$emit 'hideModals', true







