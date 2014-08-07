'use strict'

angular.module('movistarApp')
  .directive 'sgkFilter', ($rootScope, $timeout, IO) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      
      IO.on 'solicitude.filter.change', (data) ->
        query = "li[data-id='#{ data.id[$rootScope.currentUser.role] }'] span.round.light"
        $el = element.find(query)

        number = parseInt($el.html())
        counter = 0

        switch data.operation
          when '+'
            counter = number + 1
            if counter < 0
              counter = 0
          when '-'
            counter = number - 1
            if counter < 0
              counter = 0
        $el.html(counter)
      