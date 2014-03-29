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
      console.log modal
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

  .controller 'CategoryCtrl', ($scope, CategoryFactory, $rootScope, CategoryParams) ->
    $scope.categories = []
    $scope.errors = {}

    $rootScope.$on 'reloadCategories', (e, category) ->
      _load()

    $rootScope.$on 'updateCategory', (e, category) ->
      $scope.categories.push category

    $scope.loadCategory = (id) ->
      $rootScope.$emit 'loadCategoryShow', id

    _load = () ->
      CategoryFactory.index (err, categories) ->
        if err
          $scope.errors = err
        else
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
      console.log id
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

    console.log CategoryParams.id

    if CategoryParams?.id?
      CategoryFactory.show CategoryParams.id, (err, category) ->
        if err
          $scope.errors = err
        else
          $scope.category = category

    $scope.update = (form) ->
      if form.$valid
        if typeof $scope.category.tags isnt 'object'
          $scope.category.tags = $scope.category.tags.split(',')
        CategoryFactory.update CategoryParams.id, $scope.category, (err, category) ->
          if err
            $scope.errors = err
          else
            $rootScope.$emit 'reloadCategories', category
            $scope.$emit 'hideModals', true

    $scope.create = (form) ->
      if form.$valid
        $scope.category.tags = $scope.category.tags.split(',')
        CategoryFactory.save $scope.category, (err, category) ->
          if err
            $scope.errors = err
          else
            $rootScope.$emit 'updateCategory', category
            $scope.$emit 'hideModals', true

    $scope.closeModal = () ->
      $scope.$emit 'hideModals', true







