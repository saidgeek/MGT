'use strict'

angular.module('movistarApp')
  .directive 'sgkSolicitudeList', ($window, $rootScope, $timeout, SolicitudeFactory, StateData) ->
    restrict: 'A'
    templateUrl: 'partials/solicitude/solicitudeList'
    controller: ($scope, $element) ->

      $scope.$watch 'solicitudes', (value) ->
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
