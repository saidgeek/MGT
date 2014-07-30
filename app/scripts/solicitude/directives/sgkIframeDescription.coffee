'use strict'

angular.module('movistarApp')
  .directive 'sgkIframeDescription', ($timeout)->
    restrict: 'A'
    link: (scope, element, attrs) ->
      body = attrs.sgkIframeDescription

      $timeout () ->
        $body = angular.element(element).contents().find('body');
        $body.html body
        element.css 'height', "#{$body.height()+20}px"
      , 200