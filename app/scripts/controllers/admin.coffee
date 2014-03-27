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
        $rootScope.$emit 'loadUserShow', users[0]._id
        $scope.users = users

    $rootScope.$on 'updateUsers', (e, user) ->
      $scope.users.push user

    $scope.loadUser = (id) ->
      $rootScope.$emit 'loadUserShow', id

  .controller 'UserShowCtrl', ($scope, UserFactory, $rootScope, UserUpdateParams) ->
    $scope.user = {}
    $scope.errors = {}

    $rootScope.$on 'loadUserShow', (e, id) ->
      loadUser(id)
    if UserUpdateParams?.id?
      loadUser(UserUpdateParams.id)

    loadUser = (id) ->
      $scope.user = ''
      UserFactory.show id, (err, user) ->
        if err
          $scope.errors = err
        else
          $scope.user = user
          console.log $scope.user

  .controller 'UserSaveCtrl', ($scope, UserFactory, $rootScope) ->
    $scope.user = {}
    $scope.errors = {}

    $scope.create = (form) ->
      if form.$valid
        console.log $scope.user
        UserFactory.save $scope.user, (err, user) ->
          if err
            $scope.errors = err
          else
            $rootScope.$emit 'updateUsers', user
            $scope.$emit 'hideModals', true

    $scope.closeModal = () ->
      $scope.$emit 'hideModals', true







