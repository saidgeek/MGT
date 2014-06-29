'use strict'

angular.module('movistarApp')
  .directive 'sgkResumeParagraphs', ($timeout) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      origin_text = attrs.sgkResumeParagraphs

      content_div = element.css 'width'
      length = (parseInt(content_div.split('px')[0]) / 5) - 15
      origin_length = origin_text.length

      
      return element.html "#{origin_text.substr( 0, length)}..." if origin_length > length
      return element.html origin_text