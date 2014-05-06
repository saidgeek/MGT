'use strict'

angular.module('movistarApp')
  .directive 'sgkCategoriesFilter', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'partials/solicitude/filters/categories'
    controller: ($scope, $rootScope, CategoryFactory) ->
      $scope.categories = null

      CategoryFactory.index (err, categories) ->
        if !err
          $scope.categories = categories