'use strict'

angular.module('movistarApp')
  .controller 'CssCtrl', ($rootScope, $scope, $location, IO) ->
    $rootScope.title = "Gestor de tareas"
    $scope.masterModals = null
    $rootScope.alert = {}
    $scope.notifications = null

    if $rootScope.currentUser && !$rootScope.currentUser.confirmAt
      $location.path '/change/password'

    _showModals = (modal) ->
      $scope.masterModals = modal

    $rootScope.$on 'showModals', (e, modal) ->
      _showModals(modal)

    $rootScope.$on 'hideModals', (e) ->
      $scope.masterModals = ''

    $scope.isActive = (path) ->
      path is $location.$$path

  .controller 'NotificationsCtrl', ($rootScope, $scope, NotificationFactory, IO) ->
    $scope.notification = null

    IO.emit 'register.notifications', id: $rootScope.currentUser.id
    IO.on 'reload.notifications', () => _load()

    _load = () ->
      NotificationFactory.index (err, notifications) ->
        if !err
          $scope.notifications = notifications

    _load()

  .controller 'OptionsCtrl', ($rootScope, $scope, Auth, $location) ->

    $scope.showModals = (modal) ->
      $rootScope.$emit 'showModals', modal

    $scope.logout = ->
      Auth.logout().then ->
        $location.path "/login"

  .controller 'ProfileEditCtrl', ($scope, UserFactory, $rootScope, UserParams) ->
    $scope.user = {}
    $scope.errors = {}

    UserFactory.show $rootScope.currentUser.id, (err, user) ->
      if err
        $scope.errors = err
      else
        $scope.user = user
        $scope.title = "#{$scope.user.profile.firstName} #{$scope.user.profile.lastName}"

    $scope.update = (form) ->
      if form.$valid
        UserFactory.update $scope.user._id, $scope.user, (err, user) ->
          if err
            $scope.errors = err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ocurrido un error al actualizar su perfil.
                       """
          else
            if $rootScope.currentUser.id is user._id
              $rootScope.currentUser.avatar = user.profile.avatar
              $rootScope.currentUser.name = user.profile.firstName+' '+user.profile.lastName
            $scope.$emit 'close', true
