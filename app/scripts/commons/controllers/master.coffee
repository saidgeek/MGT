'use strict'

angular.module('movistarApp')
  .controller 'NotificationsCtrl', ($rootScope, $scope, Notification, IO, $state) ->
    $scope.notification = null

    IO.on 'reload.notifications', () => 
      _load()
      plapElement.play()

    plapElement = document.createElement 'audio'
    plapElement.setAttribute 'src', 'images/plap.mp3'

    _load = () ->
      Notification.index (err, notifications) ->
        if !err
          $scope.notifications = notifications


    $scope.read_all = () ->
      Notification.read_all (err) ->
        if !err
          _load()

    $scope.open = (id, item_id) ->
      Notification.read id, (err) ->
        if !err
          _load()
          $state.go 'solicitude', { id: item_id }, { reload: true }

    _load()

  .controller 'OptionsCtrl', ($rootScope, $scope, Auth, $window) ->

    $scope.showModals = (modal) ->
      $rootScope.$emit 'showModals', modal

    $scope.logout = ->
      Auth.logout().then ->
        $window.location = '/'

  .controller 'ProfileEditCtrl', ($scope, User, $rootScope, UserParams) ->
    $scope.user = {}
    $scope.errors = {}

    User.show $rootScope.currentUser.id, (err, user) ->
      if err
        $scope.errors = err
      else
        $scope.user = user
        $scope.title = "#{$scope.user.profile.firstName} #{$scope.user.profile.lastName}"

    $scope.update = (form) ->
      if form.$valid
        User.update $scope.user._id, $scope.user, (err, user) ->
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
