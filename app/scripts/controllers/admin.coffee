'use strict'

angular.module('movistarApp')
  .controller 'AdminCtrl', ($rootScope, $scope, Auth, $location, RolesData) ->
    $rootScope.cssInclude = [
      'styles/jquery.mCustomScrollbar.css',
      'styles/styles.css',
      'styles/ie.css',
      'styles/adminFonts.css'
    ]
    $rootScope.title = "Administración"
    $scope.groups = {}

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

  .controller 'SidebarUsersCtrl', ($scope, UserFactory, $rootScope, RolesData) ->
    $scope.groups = null
    $scope.errors = {}
    $scope.roles = RolesData.getArray()

    _load = () ->
      UserFactory.groups (err, groups) ->
        if err
          $scope.errors = err
        else
          $scope.groups = groups

    $rootScope.$on 'reloadGroups', (e) ->
      _load()

    $scope.filter = (role) ->
      $rootScope.$emit 'reloadUsers', role

    _load()

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

  .controller 'CategoryCtrl', ($scope, CategoryFactory, $rootScope, CategoryParams) ->
    $scope.categories = []
    $scope.errors = {}

    $rootScope.$on 'reloadCategories', (e, category) ->
      _load()

    $rootScope.$on 'updateCategory', (e, category) ->
      _load()

    $scope.loadCategory = (id) ->
      $rootScope.$emit 'loadCategoryShow', id

    _load = () ->
      CategoryFactory.index (err, categories) ->
        if err
          $scope.errors = err
        else
          if categories.length > 0
            $scope.categories = categories
            $rootScope.$emit 'loadCategoryShow', categories[0]._id

    _load()

  .controller 'CategoryShowCtrl', ($scope, CategoryFactory, $rootScope, CategoryParams) ->
    $scope.category = {}
    $scope.errors = {}

    $rootScope.$on 'loadCategoryShow', (e, id) ->
      _load(id)
    if CategoryParams?.id?
      _load(CategoryParams.id)

    $scope.EditCategory = (id) ->
      CategoryParams.id = id
      $rootScope.$emit 'showModals', { modal: 'updateCategory', id: id}

    _load = (id) ->
      $scope.category = ''
      CategoryFactory.show id, (err, category) ->
        if err
          $scope.errors = err
        else
          $scope.category = category

  .controller 'CategorySaveCtrl', ($scope, CategoryFactory, $rootScope, CategoryParams) ->
    $scope.category = {}
    $scope.errors = {}

    if CategoryParams?.id?
      CategoryFactory.show CategoryParams.id, (err, category) ->
        if err
          $scope.errors = err
        else
          $scope.category = category
          CategoryParams.id = null

    $scope.update = (form) ->
      if form.$valid
        CategoryFactory.update $scope.category._id, $scope.category, (err, category) ->
          if err
            $scope.errors = err
          else
            $rootScope.$emit 'reloadCategories', category
            $scope.$emit 'hideModals', true

    $scope.create = (form) ->
      if form.$valid
        CategoryFactory.save $scope.category, (err, category) ->
          if err
            $scope.errors = err
          else
            $rootScope.$emit 'updateCategory', category
            $scope.$emit 'hideModals', true

    $scope.closeModal = () ->
      $scope.$emit 'hideModals', true
