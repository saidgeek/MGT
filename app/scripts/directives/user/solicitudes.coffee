'use strict'

angular.module('movistarApp')
  .directive 'sgkUserSolicitudes', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/user/solicitudes'
    controller: 'UserSolicitudesCtrl'
    link: ($scope, $element, $attrs) =>
      $scope.id = $attrs.sgkUserSolicitudes || null

      $scope.$watch 'solicitudes', (value) ->
        $rootScope.resize = true
        $timeout () =>
          $timeout () =>
            if $element.find('.overflow .mCustomScrollBox').length is 0
              $element.find('.overflow').mCustomScrollbar
                scrollButtons:
                    enable:false
            $element.find('.overflow').mCustomScrollbar "update"
            $element.find('.overflow').mCustomScrollbar "scrollTo", ".note.round.active"

          , 0
        , 0