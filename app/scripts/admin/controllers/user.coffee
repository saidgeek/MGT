'use strict'

angular.module('movistarApp')
  .controller 'UsersGroupsCtrl', ($scope, _users_groups, RolesData) ->
    _makeGroups = (groups) ->
      result = {}
      _total = 0
      for g in groups
        result[g._id] = g.count
        _total += g.count
      result['total'] = _total
      result

    $scope.groups = _makeGroups _users_groups
    $scope.roles = RolesData.getArray()

  .controller 'UserCtrl', ($scope, $window, _users, $stateParams, $state) ->
      $scope.users = _users

      $scope.isActive = (id, index) ->
        return true if !$stateParams.id? and index is 0
        return true if $stateParams.id is id
        return false

      $scope.show = (id) ->
        $state.transitionTo 'users_show', { id: id }, { reload: true }

  .controller 'UserShowCtrl', ($scope, _user, _user_solicitudes) ->
    $scope.user = _user
    $scope.solicitudes = _user_solicitudes.resources

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
