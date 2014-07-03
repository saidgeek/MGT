'use strict'

angular.module('movistarApp')
  .directive 'sgkTasks', ($timeout, IO) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      id = attrs.sgkTasks
      
      element.find('a.add').on 'click' , (e) ->
        query = "##{id}"
        $el = angular.element(query)
        if $el.css('display') is 'none'
          element.find('.header a').html '-'
          $el.fadeIn 300
        else
          element.find('.header a').html '+'
          $el.fadeOut 300
        element.parents('.overflow').mCustomScrollbar 'update'

      element.find('form input.boton1').on 'click', (e) ->
        query = "##{id}"
        $el = angular.element(query)
        element.find('.header a').html '+'
        $el.fadeOut 300

      element.on 'click', ''

