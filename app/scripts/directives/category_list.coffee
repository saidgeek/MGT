'use strict'

angular.module('movistarApp')
  .directive 'sgkCategoryList', ($window, $rootScope, $timeout, SolicitudeFactory, StateData) ->
    restrict: 'A'
    templateUrl: 'partials/admin/categoryList'
    controller: ($scope, $element) ->

      $scope.$watch 'categories', (value) ->
        $rootScope.resize = true
        $timeout () =>
          $timeout () =>
            $timeout () =>
              if $element.find('.overflow .mCustomScrollBox').length is 0
                $element.find('.overflow').mCustomScrollbar
                  scrollButtons:
                      enable:false
              $element.find('.overflow').mCustomScrollbar "update"
              $element.find('.overflow').mCustomScrollbar "scrollTo", "top"
            , 1000
          , 0
        , 0
