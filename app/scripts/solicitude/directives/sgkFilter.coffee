'use strict'

angular.module('movistarApp')
  .directive 'sgkFilter', ($timeout, IO) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      
      IO.on 'solicitude.filter.change', (data) ->
        query = "li[data-id='#{ data.id }'] span.round.light"
        $el = element.find(query)
        $el.html(parseInt($el.html()) + 1) if data.operation is '+'
        $el.html(parseInt($el.html()) - 1) if data.operation is '-'
      