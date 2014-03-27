'use strict'

angular.module('movistarApp')
  .directive 'sgkResize', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      _window = angular.element($window)
      _main = angular.element('#main')
      _side = angular.element('#side')
      _left_relativo = angular.element('#left .relativo')
      _left = angular.element('#left')
      _right = angular.element('#right')

      alto = _window.height()
      total_width = _main.width()
      sidebar = _side.width()
      medida = total_width - sidebar
      maxAncho = medida / 100 * 75
      minAncho = medida / 100 * 25

      angular.element(".overflow").mCustomScrollbar
        scrollButtons:
          enable: false

      _left_relativo.resizable(
        maxWidth: maxAncho
        minWidth: minAncho
        containment: '#main'
        handles: "ew"
        grid: [ 0, 0 ]
      ).bind "resize", resizeOther

      _window.on 'resize', resizeOther
      
      resizeOther = (e, ui) ->
        _width = _left_relativo.width()
        console.log 'width', _width
        total_width = _main.width()
        console.log 'total_width', total_width

        console.log 'result', (total_width - _width)

        if width > total_width
          _width = total_width
          _left.css 'width', _width

        _right.css 'width', (total_width - _width)
        angular.element('.ui-resizable-handle').css 'left', _width

      _right.on 'resize', resize_right

      resize_right = (e, ui) ->
          right = _right.width()

          if right < 535
            angular.element('.menu-middle p').css 'display', 'none'
          else
            angular.element('.menu-middle p').css 'display', 'inline'









