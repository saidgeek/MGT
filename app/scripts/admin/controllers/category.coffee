'use strict'

angular.module('movistarApp')
  .controller 'CategoryCtrl', ($scope, _categories, $stateParams, $state) ->
    $scope.categories = _categories

    $scope.isActive = (id, index) ->
      return true if !$stateParams.id? and index is 0
      return true if $stateParams.id is id
      return false

    $scope.show = (id) ->
      $state.go 'categories_show', { id: id }

  .controller 'CategoryShowCtrl', ($scope, _category) ->
    $scope.category = _category

  .controller 'CategorySaveCtrl', ($scope, $rootScope, Category, $state) ->
    $scope.title = 'Crear nueva clacificación'
    $scope.category = {}
    $scope.errors = {}

    $scope.$watch 'id', (id) ->
      if id?
        Category.show id, (err, category) ->
          if err
            $scope.errors = err
          else
            $scope.category = category
            $scope.title = "#{category.name}"

    $scope.update = (form) ->
      if form.$valid
        Category.update $scope.category._id, $scope.category, (err, category) ->
          if err
            $scope.errors = err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ucurrido un error al actualizar la clasificación.
                       """
          else
            $state.go 'categories_show', { id: category._id }, { reload: true }
            $scope.$emit 'close', true
            $rootScope.alert =
              type: 'success'
              content: """
                          La categoría #{ category.name } se actualizo correctamente.
                       """

    $scope.create = (form) ->
      if form.$valid
        Category.save $scope.category, (err, category) ->
          if err
            $scope.errors = err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ucurrido un error al crear la clasificación.
                       """
          else
            $state.go 'categories_show', { id: category._id }, { reload: true }
            $scope.$emit 'close', true
            $scope.category = {}
            $rootScope.alert =
              type: 'success'
              content: """
                          La categoría #{ category.name } se a creado correctamente.
                       """

    $scope.remove = (form) ->
      if form.$valid
        Category.remove $scope.category._id, $scope.category, (err, category) ->
          if err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ucurrido un error al intentar eliminar la clasificación.
                       """
          else
            $state.go 'categories'
            $scope.$emit 'close', true
            $rootScope.alert =
              type: 'success'
              content: """
                          La categoría #{ category.name } se a eliminado con exito.
                       """
