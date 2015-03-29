'use strict'

angular.module('movistarApp')
  .directive 'sgkResizeMenu', ($timeout) ->
    restrict: 'A'
    scope: {}
    link: (scope, element, attrs) =>
      
      $_resize = =>
        thetable = angular.element('.thetable').height()
        altperfil = angular.element('.therowAlt').height()

        altmenu = angular.element('#side .therow .thecell').height()
        if altmenu is 0
          altmenu = thetable - altperfil
        altrelativo = altmenu
        angular.element('#side .therow .thecell').css 'height', altrelativo

      $timeout () ->
        $timeout () ->
          $_resize()
        , 0
      , 0
