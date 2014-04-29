'use strict'

angular.module('movistarApp')
  .controller 'AdminCtrl', ($rootScope, $scope, Auth, $location, RolesData) ->
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
          else
            $scope.categories = {}
            $rootScope.$emit 'loadCategoryShow', null

    _load()

  .controller 'CategoryShowCtrl', ($scope, CategoryFactory, $rootScope, CategoryParams) ->
    $scope.category = {}
    $scope.errors = {}

    $rootScope.$on 'loadCategoryShow', (e, id) ->
      if id
        _load(id)
      else
        $scope.category = null

    if CategoryParams?.id?
      _load(CategoryParams.id)

    $scope.EditCategory = (id) ->
      CategoryParams.id = id
      $rootScope.$emit 'showModals', { modal: 'updateCategory', id: id}

    $scope.remove = (id) ->
      console.log id
      CategoryFactory.remove id, (err) ->
        if err
          $scope.errors = err
        else
          $rootScope.$emit 'reloadCategories', ''

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
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ucurrido un error al actualizar la clasificación.
                       """
          else
            $rootScope.$emit 'reloadCategories', category
            $scope.$emit 'hideModals', true
            $rootScope.alert =
              type: 'success'
              content: """
                          La categoría #{ category.name } se actualizo correctamente.
                       """

    $scope.create = (form) ->
      if form.$valid
        CategoryFactory.save $scope.category, (err, category) ->
          if err
            $scope.errors = err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ucurrido un error al crear la clasificación.
                       """
          else
            $rootScope.$emit 'updateCategory', category
            $scope.$emit 'hideModals', true
            $rootScope.alert =
              type: 'success'
              content: """
                          La categoría #{ category.name } se a creado correctamente.
                       """

    $scope.closeModal = () ->
      $scope.$emit 'hideModals', true
