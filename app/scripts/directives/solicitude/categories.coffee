'use strict'

angular.module('movistarApp')
  .directive 'sgkCategoriesFilter', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'partials/solicitude/filters/categories'
    controller: ($scope, $rootScope, CategoryFactory) ->
      $scope.categories = null

      $scope.filter = (value) =>
        value = null unless value?
        if $rootScope.filters?.solicitude?.category?
          $rootScope.filters.solicitude.category = value
        else
          $rootScope.filters = 
            solicitude:
              category: value

      CategoryFactory.index (err, categories) ->
        if !err
          $scope.categories = categories