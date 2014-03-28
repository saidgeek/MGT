'use strict'

angular.module('movistarApp')
  .controller 'AdminCtrl', ($rootScope, $scope, Auth, $location, RolesData) ->
    $rootScope.cssInclude = [
      'styles/admin.css', 
      'styles/jquery.mCustomScrollbar.css', 
      'styles/adminFonts.css'
    ]

    $scope.roles = RolesData.getArray()

    switch $location.$$path
      when '/admin/category'
        $scope.module = 'category'
      else
        $scope.module = ''

    $scope.isActiveLink = (path) ->
      path is $location.$$path


    $scope.showModals = (modal) ->
      _showModals(modal)
    
    $rootScope.$on 'showModals', (e, args) ->
      _showModals(args.modal)
    $scope.$on 'hideModals', (e, args) ->
      $scope.modals = ''

    _showModals = (modal) ->
      $scope.modals = modal

  .controller 'UserCtrl', ($scope, UserFactory, $rootScope) ->
    $scope.users = []
    $scope.errors = {}

    $rootScope.$on 'reloadUsers', (e, user) ->
      _loadUsers()
    $rootScope.$on 'updateUsers', (e, user) ->
      $scope.users.push user

    $scope.loadUser = (id) ->
      $rootScope.$emit 'loadUserShow', id

    _loadUsers = () ->
      UserFactory.index (err, users) ->
        if err
          $scope.errors = err
        else

          $rootScope.$emit 'loadUserShow', users[0]._id
          $scope.users = users

    _loadUsers()

  .controller 'UserShowCtrl', ($scope, UserFactory, $rootScope, UserParams) ->
    $scope.user = {}
    $scope.errors = {}

    $rootScope.$on 'loadUserShow', (e, id) ->
      _loadUser(id)
    if UserUpdateParams?.id?
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
          $scope.user = user

  .controller 'UserSaveCtrl', ($scope, UserFactory, $rootScope, UserParams) ->
    $scope.user = {}
    $scope.errors = {}

    if UserParams?.id?
      UserFactory.show UserParams.id, (err, user) ->
        if err
          $scope.errors = err
        else
          $scope.user = user

    $scope.update = (form) ->
      if form.$valid
        UserFactory.update UserParams.id, $scope.user, (err, user) ->
          if err
            $scope.errors = err
          else
            if $rootScope.currentUser.id is user._id
              $rootScope.currentUser.avatar = user.profile.avatar
              $rootScope.currentUser.name = user.profile.firstName+' '+user.profile.lastName
              $rootScope.currentUser.role = user.role
            $rootScope.$emit 'reloadUsers', user
            $scope.$emit 'hideModals', true

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







