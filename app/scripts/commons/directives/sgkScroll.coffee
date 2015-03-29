'use strict'

angular.module('movistarApp')
  .directive 'sgkScroll', ($timeout) ->
    restrict: 'A'
    link: (scope, element, attrs) ->

      $_add_scroll = () ->
        if element.find('.mCustomScrollBox').length is 0
          element.mCustomScrollbar
            scrollInertia: 2000
            advanced:
              autoScrollOnFocus: false
            scrollButtons:
              enable: false

      scope.$watch 'solicitudes', () =>
        $timeout () =>
          $timeout () =>
            $_add_scroll()
            element.mCustomScrollbar 'update'
            $timeout () =>
              element.mCustomScrollbar "scrollTo","top"
            , 1000
          , 0
        , 0
