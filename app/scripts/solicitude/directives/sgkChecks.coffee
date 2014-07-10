'use strict'

angular.module('movistarApp')
  .directive 'sgkChecks', ($timeout, IO) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      type = attrs.sgkChecks

      findAndAddSection = (type, value) ->
        angular.element.each scope.solicitude.ticket.segments, (index, result) ->
          if typeof(result) isnt 'undefined' and result['type'] is type
            scope.solicitude.ticket.segments[index].sections.push value

      findAndRemoveSection = (type, value) ->
        angular.element.each scope.solicitude.ticket.segments, (index, result) ->
          if typeof(result) isnt 'undefined' and result['type'] is type
            _index = scope.solicitude.ticket.segments[index].sections.indexOf value
            scope.solicitude.ticket.segments[index].sections.splice _index, 1

      findAndRemove = (value) ->
        angular.element.each scope.solicitude.ticket.segments, (index, result) ->
          console.log 'result:', result
          if typeof(result) isnt 'undefined' and result['type'] is value
            scope.solicitude.ticket.segments.splice index, 1

      element.on 'click', 'ul.segments li label.segment', (e) ->
        e.preventDefault()

        $el = angular.element e.target
        if !$el.parent().hasClass 'active'
          $el.parent().addClass 'active'
          $el.parent().find('ul.sections').removeClass 'hide'
          scope.solicitude.ticket.segments.push { type: $el.parent().data('segment'), sections: [] }
        else
          $el.parent().removeClass 'active'
          $el.parent().find('ul.sections').addClass 'hide'
          findAndRemove $el.parent().data('segment')

        return false

      element.on 'click', 'ul.segments li label.segment span', (e) ->
        e.preventDefault()
        $el = angular.element(e.target).parents('li')

        if !$el.hasClass 'active'
          $el.addClass 'active'
          $el.find('ul.sections').removeClass 'hide'
          scope.solicitude.ticket.segments.push { type: $el.data('segment'), sections: [] }
        else
          $el.removeClass 'active'
          $el.find('ul.sections').addClass 'hide'
          findAndRemove $el.data('segment')

        return false

      element.on 'click', 'ul.sections li label.section', (e) ->
        e.preventDefault()

        $el = angular.element e.target
        if !$el.parent().hasClass 'active'
          $el.parent().addClass 'active'
          $el.parent().find('ul.sections').removeClass 'hide'
          
          findAndAddSection $el.parents('ul.sections').parent().data('segment'), $el.parent().data('section')

        else
          $el.parent().removeClass 'active'
          $el.parent().find('ul.sections').addClass 'hide'
          
          findAndRemoveSection $el.parents('ul.sections').parent().data('segment'), $el.parent().data('section')

        return false

      element.on 'click', 'ul.sections li label.section span', (e) ->
        e.preventDefault()

        $el = angular.element(e.target).parent().parent()

        if !$el.hasClass 'active'
          $el.addClass 'active'
          $el.find('ul.sections').removeClass 'hide'
          
          findAndAddSection $el.parents('ul.sections').parent().data('segment'), $el.data('section')

        else
          $el.removeClass 'active'
          $el.find('ul.sections').addClass 'hide'
          
          findAndRemoveSection $el.parents('ul.sections').parent().data('segment'), $el.data('section')

        return false
      