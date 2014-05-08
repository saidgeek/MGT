'use strict'

angular.module('movistarApp')
  .directive 'sgkUserDetail', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/user/detail'
    controller: 'UserShowCtrl'
    link: ($scope, $element, $attrs) =>

      $_resize = () =>
        altR = $element.parents('#right').height()
        altFirst = $element.find('.altFirst').height()
        medida = altR - altFirst
        $element.find('.medida').height(medida)
        $element.find('.medida .ng-scope').height(medida)
      

      $scope.$watch 'user', (value) ->
        $rootScope.resize = true
        $timeout () =>
          $timeout () =>
            $_resize()
            if !value.profile?.avatar? or value.profile.avatar is ''
              $element
                .find('.t-c.img-user img')
                .attr 'src', 'images/avatar-user.png'
          , 0
        , 0
