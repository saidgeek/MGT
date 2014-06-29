'use strict'

angular.module('movistarApp')
  .directive 'sgkRemember', () ->
    conf =
      restrict: 'A'
      templateUrl: 'directives/remember'
      link: (scope, element, attrs) ->
        scope.text = attrs.text || ''

        element.addClass 'center'
        element.addClass 'check'

        element.find('a').on 'click', (e) ->
          e.preventDefault()
          angular.element(e.target).toggleClass 'checked'
          scope.user.remember = angular.element(e.target).hasClass 'checked'
          scope.$digest()
          false
    conf
