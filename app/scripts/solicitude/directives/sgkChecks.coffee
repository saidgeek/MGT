'use strict'

angular.module('movistarApp')
  .directive 'sgkChecks', ($timeout, IO) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      type = attrs.sgkChecks

      element.on 'click', 'li.lab', (e) ->
        $el = angular.element e.target
        if !$el.hasClass 'active'
          $el.addClass 'active'
          scope.solicitude.ticket[type].push $el.data 'value'
        else
          $el.removeClass 'active'
          _index = scope.solicitude.ticket[type].indexOf $el.data('value')
          scope.solicitude.ticket[type].splice _index, 1

      element.on 'click', 'li.lab label span', (e) ->
        $el = angular.element(e.target).parents('li')

        if !$el.hasClass 'active'
          $el.addClass 'active'
          scope.solicitude.ticket[type].push $el.data 'value'
        else
          $el.removeClass 'active'
          _index = scope.solicitude.ticket[type].indexOf $el.data('value')
          scope.solicitude.ticket[type].splice _index, 1
      
      # element.on 'click', 'li.lab label span', (e) ->
      #   $el = angular.element(e.target).parent().parent()
      #   if !$el.find('label span.opt-check').hasClass 'active'
      #     $el.addClass 'active'
      #     $el.find('label span.opt-check').addClass 'active'
      #     scope.solicitude.ticket[$el.data('type')].push $el.data 'value'
      #   else
      #     $el.removeClass 'active'
      #     $el.find('label span.opt-check').removeClass 'active'
      #     _index = scope.solicitude.ticket[$el.data('type')].indexOf $el.data('value')
      #     scope.solicitude.ticket[$el.data('type')].splice _index, 1

      
      # $_triggersCheck = () =>
      #   $element
      #     .parents('.detalle')
      #     .on 'click', 'ul li.lab', (e) =>
      #       e.preventDefault()

      #       console.log 'angular.element(e.target):', angular.element(e.target)

      #       $el = angular.element(e.target)
      #       $el = angular.element($el[0])

      #       $el.toggleClass 'active'
      #       $el.find('label span.opt-check').toggleClass 'active'

      #       if $el.find('label span.opt-check').hasClass 'active'
      #         $scope.solicitude.ticket[$el.data('type')].push $el.data 'value'
      #       else
      #         console.log '$scope.solicitude.ticket:', $scope.solicitude.ticket, $el.data('type'), $el
      #         _index = $scope.solicitude.ticket[$el.data('type')].indexOf $el.data('value')
      #         $scope.solicitude.ticket[$el.data('type')].splice _index, 1

      #       return false
