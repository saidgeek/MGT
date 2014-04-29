'use strict'

angular.module('movistarApp')
  .controller 'UserCtrl', ($scope, UserFactory, $rootScope) ->
    $scope.users = []
    $scope.errors = {}

    $rootScope.$on 'reloadUsers', (e, role) ->
      _loadUsers(role)

    $rootScope.$on 'updateUsers', (e) ->
      _loadUsers('')
      $rootScope.$emit 'reloadGroups'

    $scope.loadUser = (id) ->
      $rootScope.$emit 'loadUserShow', id

    _loadUsers = (role) ->
      UserFactory.index role, (err, users) ->
        if err
          $scope.errors = err
        else
          if users.length > 0
            $rootScope.$emit 'loadUserShow', users[0]._id
            $scope.users = users

    _loadUsers('')

  .controller 'UserShowCtrl', ($scope, UserFactory, $rootScope, UserParams) ->
    $scope.user = {}
    $scope.errors = {}

    $rootScope.$on 'loadUserShow', (e, id) ->
      _loadUser(id)
    if UserParams?.id?
      _loadUser(UserUpdateParams.id)

    $scope.EditUser = (id) ->
      UserParams.id = id
      $rootScope.$emit 'showModals', { modal: 'updateUser', id: id}

    _loadUser = (id) ->
      $scope.user = ''
      UserFactory.show id, (err, user) ->
        if err
          $scope.errors = err
        else
          if !user.profile?.avatar? or user.profile.avatar is ''
            user.profile.avatar = 'images/avatar-user.png'
          $scope.user = user

  .controller 'UserSaveCtrl', ($scope, UserFactory, $rootScope, UserParams, RolesData) ->
    $scope.user = {}
    $scope.errors = {}
    $scope.roles = RolesData.getArray()

    if UserParams?.id?
      UserFactory.show UserParams.id, (err, user) ->
        if err
          $scope.errors = err
        else
          $scope.user = user
          UserParams.id = null

    $scope.update = (form) ->
      if form.$valid
        UserFactory.update $scope.user._id, $scope.user, (err, user) ->
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
            $rootScope.$emit 'reloadUsers', ''
            $scope.$emit 'hideModals', true
            $rootScope.alert =
              type: 'success'
              content: """
                          El usuario #{ user.profile.firstName } #{ user.profile.lastName } se a actualizado correctamente.
                       """

    $scope.create = (form) ->
      if form.$valid
        UserFactory.save $scope.user, (err, user) ->
          if err
            $scope.errors = err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ocurrido un error al crear el usuario.
                       """
          else
            $rootScope.$emit 'updateUsers'
            $scope.$emit 'hideModals', true
            $rootScope.alert =
              type: 'success'
              content: """
                          El usuario #{ user.profile.firstName } #{ user.profile.lastName } se a agregado correctamente.
                       """

    $scope.closeModal = () ->
      $scope.$emit 'hideModals', true
