'use strict'

angular.module('movistarApp')
  .directive 'sgkCategoryDetail', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/category/detail'
    controller: 'CategoryShowCtrl'
    link: ($scope, $element, $attrs) =>
      
      $scope.$watch 'category', (value) =>
        $rootScope.resize = true
        # posiblemente mas adelante poner overflow
        # $timeout () => 
        #   $timeout () => 
            
        #   , 0
        # , 0
        
    