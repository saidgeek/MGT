'use strict'

angular.module('movistarApp')
  .directive 'sgkFilter', ($rootScope, $timeout, IO) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      
      IO.on 'solicitude.filter.change', (data) ->
        query = "li[data-id='#{ data.id[$rootScope.currentUser.role] }'] span.round.light"
        $el = element.find(query)
        $el.html(parseInt($el.html()) + 1) if data.operation is '+'
        $el.html(parseInt($el.html()) - 1) if data.operation is '-'
      