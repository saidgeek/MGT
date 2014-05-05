'use strict'

angular.module('movistarApp')
	.controller 'CategoryCtrl', ($scope, $rootScope, CategoryFactory) =>
    $scope.categories = []

    $scope.reload = () =>
      CategoryFactory.index (err, categories) ->
        if !err
          if categories.length > 0
            $scope.categories = categories
          else
            $scope.categories = {}

    $scope.reload()

  .controller 'CategoryShowCtrl', ($scope, $rootScope, CategoryFactory) ->
    $scope.category = {}

    $rootScope.$on 'loadCategoryShow', (e, id) =>
      if typeof id isnt 'undefined'
        CategoryFactory.show id, (err, category) ->
          if !err
            $scope.category = category

  .controller 'CategorySaveCtrl', ($scope, $rootScope, CategoryFactory) ->
    $scope.title = 'Crear nueva clacificación'
    $scope.category = {}
    $scope.errors = {}
    $scope.categories = []

    CategoryFactory.index (err, categories) ->
      if err
        $scope.errors = err
      else
        $scope.categories = categories

    $scope.$watch 'id', (id) =>
      CategoryFactory.show id, (err, category) ->
        if err
          $scope.errors = err
        else
          $scope.category = category
          $scope.title = "#{category.name}"

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
            $rootScope.$emit 'reloadCategory', category
            $scope.$emit 'close', true
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
            $rootScope.$emit 'reloadCategory', category
            $scope.$emit 'close', true
            $scope.category = {}
            $rootScope.alert =
              type: 'success'
              content: """
                          La categoría #{ category.name } se a creado correctamente.
                       """

    $scope.remove = (form) ->
      if form.$valid
        CategoryFactory.remove $scope.category._id, $scope.category, (err, category) ->
          if err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ucurrido un error al intentar eliminar la clasificación.
                       """
          else
            $rootScope.$emit 'reloadCategory', category
            $scope.$emit 'close', true
            $rootScope.alert =
              type: 'success'
              content: """
                          La categoría #{ category.name } se a eliminado con exito.
                       """