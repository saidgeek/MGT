'use strict'

angular.module('movistarApp')
  .directive 'sgkAccordion', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    link: ($scope, $element, $attrs) =>

      $element.on 'click', 'div.note-right, div.note-right h3', (e) =>
        e.preventDefault()

        if e.toElement.nodeName is 'H3'
          $_this = angular.element(e.target).parent()
        else
          $_this = angular.element(e.target)

        $_this
          .find('h3')
          .toggleClass 'active'
        $_this
          .find('ul.lista-estados')
          .slideToggle 300

        return false
