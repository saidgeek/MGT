'use strict'

angular.module('movistarApp')
  .directive 'sgkIframeDescription', ($timeout)->
    restrict: 'A'
    link: (scope, element, attrs) ->
      body = attrs.sgkIframeDescription

      console.log 'body:', body

      $timeout () ->
        $body = angular.element(element).contents().find('body');
        console.log '$body:', $body
        $body.html body
        element.css 'height', "#{$body.height()+100}px"
      , 200