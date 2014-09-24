'use strict'

angular.module('movistarApp')
  .directive 'sgkIframeDescription', ($timeout)->
    restrict: 'A'
    link: (scope, element, attrs) ->
      body = attrs.sgkIframeDescription

      $timeout () ->
        $body = angular.element(element).contents().find('body');
        $body.html body
        $p = angular.element(element).contents().find('p');
        $other = angular.element(element).contents().find('li, h1, h2, h3, pre, i');
        element.css 'height', "#{$body.height()+50}px"
        $other.css 'color', "#5D657A"
        $other.css 'font-family', "arial"
        $p.css 'color', "#5D657A"
        $p.css 'font-family', "arial"
        $p.css 'font-size', "14px"
      , 200
