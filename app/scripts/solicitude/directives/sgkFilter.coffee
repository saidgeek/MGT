'use strict'

angular.module('movistarApp')
  .directive 'sgkFilter', ($rootScope, $timeout, IO) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      
      IO.on 'solicitude.filter.change', (data) ->
        query_all = "li[data-id='all'] span.round.light"
        query = "li[data-id='#{ data.id[$rootScope.currentUser.role] }'] span.round.light"
        $el = element.find(query)
        $el_all = element.find(query_all)

        number = parseInt($el.html())
        number_all = parseInt($el_all.html())
        counter = 0
        counter_all = 0

        switch data.operation
          when '+'
            counter = number + 1
            if counter < 0
              counter = 0
            counter_all = number_all + 1
            if counter_all < 0
              counter_all = 0

          when '-'
            counter = number - 1
            if counter < 0
              counter = 0
            counter_all = number_all - 1
            if counter_all < 0
              counter_all = 0
        $el.html(counter)
        $el_all.html(counter_all)
      