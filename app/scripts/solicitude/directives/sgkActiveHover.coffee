'use strict'

angular.module('movistarApp')
  .directive 'sgkActiveHover', ($timeout) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      class_name = attrs.sgkActiveHover || 'active'

      element.hover (e) ->
        $el = element.parent()
        $el.toggleClass class_name
