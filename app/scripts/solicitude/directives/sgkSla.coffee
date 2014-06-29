'use strict'

angular.module('movistarApp')
  .directive 'sgkSla', ($window, $rootScope, $timeout, IO) ->
    restrict: 'A'
    link: ($scope, $element, $attrs) =>

      IO.on 'solicitude.init.sla', (data) => 
        query = "[data-id='#{data.id}']"
        $el = $element.find(query)
        $el.addClass 'GREEN'

      IO.on 'solicitude.change.sla', (data) => 
        query = "[data-id='#{data.id}']"
        $el = $element.find(query)
        
        if $el.hasClass 'GREEN'
          $el.removeClass 'GREEN'
        if $el.hasClass 'YELLOW'
          $el.removeClass 'YELLOW'
        $el.addClass data.state.toString()

      IO.on 'solicitude.remove.sla', (data) => 
        query = "[data-id='#{data.id}']"
        $el = $element.find(query)
        if $el.hasClass 'GREEN'
          $el.removeClass 'GREEN'
        if $el.hasClass 'YELLOW'
          $el.removeClass 'YELLOW'
        if $el.hasClass 'RED'
          $el.removeClass 'RED'