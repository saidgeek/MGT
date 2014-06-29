'use strict'

angular.module('movistarApp')
  .controller 'UserCtrl', ($scope, $rootScope, $window, User) ->
      $scope.users = []

      $rootScope.$watch 'filters.user.role', () =>
        if $rootScope.filters?
          $scope.reload ($rootScope.filters.user.role)

      $scope.reportCSV = (id) =>
        $window.location = "/api/v1/log/#{id}/csv";
      

      $scope.reload = (role) =>
        User.index role, (err, users) ->
          if err
            $scope.errors = err
          else
            if users.length > 0
              $scope.users = users

      $scope.reload()

  .controller 'UserShowCtrl', ($scope, $rootScope, $element, User) =>
    $scope.user = {}

    $rootScope.$on 'loadUserShow', (e, id) =>
      if typeof id isnt 'undefined'
        User.show id, (err, user) =>
          if !err
            $scope.user = user

  .controller 'UserSaveCtrl', ($scope, $rootScope, User, RolesData) ->
    $scope.title = 'Crear nuevo usuario'
    $scope.user = {}
    $scope.errors = {}
    $scope.roles = RolesData.getArray()

    $scope.$watch 'id', (id) ->
      User.show id, (err, user) ->
        if err
          $scope.errors = err
        else
          $scope.user = user
          $scope.title = "#{user.profile.firstName} #{user.profile.lastName}"

    $scope.update = (form) ->
      if form.$valid
        User.update $scope.user._id, $scope.user, (err, user) ->
          if err
            $scope.errors = err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ocurrido un error al actualizar el usuario.
                       """
          else
            if $rootScope.currentUser.id is user._id
              $rootScope.currentUser.avatar = user.profile.avatar
              $rootScope.currentUser.name = user.profile.firstName+' '+user.profile.lastName
              $rootScope.currentUser.role = user.role
            $rootScope.$emit 'reloadUser', user
            $rootScope.$emit 'reloadUserSidebar'
            $scope.$emit 'close', true

            $rootScope.alert =
              type: 'success'
              content: """
                          El usuario #{ user.profile.firstName } #{ user.profile.lastName } se a actualizado correctamente.
                       """

    $scope.create = (form) ->
      if form.$valid
        User.save $scope.user, (err, user) ->
          if err
            $scope.errors = err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ocurrido un error al crear el usuario.
                       """
          else
            $rootScope.$emit 'reloadUser', user
            $rootScope.$emit 'reloadUserSidebar'
            $scope.$emit 'close', true
            $scope.user = {}
            $rootScope.alert =
              type: 'success'
              content: """
                          El usuario #{ user.profile.firstName } #{ user.profile.lastName } se a agregado correctamente.
                       """

  .controller 'UserSolicitudesCtrl', ($scope, $rootScope, Solicitude) ->
    $scope.solicitudes = null
    $scope.role = $rootScope.currentUser.role

    $scope.reload = (id, state) =>
      Solicitude.index null, state, '', '', '', (err, solicitudes) ->
        if err
          $scope.errors = err
        else
          if solicitudes.length > 0
            $scope.solicitudes = solicitudes
          else
            $scope.solicitudes = null

    $rootScope.$watch 'filters.user.solicitude.state', (state) =>
      console.log 'state:', state
      $scope.reload($scope.id, state)

    $scope.$watch 'id', (_id) =>
      $scope.reload($scope.id, state)