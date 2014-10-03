'use strict'

angular.module('movistarApp')
  .directive 'sgkMedidaResize', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    link: ($scope, $element, $attrs) =>

      $_resize = () =>
        altR = $element.parents('#right').height()
        altFirst = $element.height()
        medida = altR - altFirst
        $element.parent().find('.medida').height(medida)

      $timeout () =>
        $timeout () =>
          $_resize()
          if !$scope.user.profile?.avatar? or $scope.user.profile.avatar is ''
            $element
              .find('.t-c.img-user img')
              .attr 'src', 'images/avatar-user.png'
        , 0
      , 0
