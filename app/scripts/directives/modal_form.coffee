'use strict'

angular.module('movistarApp')
  .directive 'sgkModalForm', ($window, $rootScope, $timeout, $http, $compile) ->
    restrict: 'A'
    scope: {}
    controller: '@'
    name: 'sgkCtrl'
    link: ($scope, $element, attrs, sgkCtrl) =>
      $template = null
      $element.on 'click', (e) =>
        e.preventDefault()

        if angular.element('div[data-type="modal"]').length is 0

          if attrs.sgkId?
            $scope.id = attrs.sgkId

          $http.get("/partials/modalForm").success (data) =>
            angular.element('body').append data

            $el = angular.element('div[data-type="modal"]')

            $el.on 'click', '.close a, [data-cancel]', (e) =>
              e.preventDefault()

              $el.remove()

              return false

            $scope.$on 'close', (e) =>
              $el.remove()

            $el.on 'click', '.hideshow', (e) =>
              e.preventDefault()

              $el.find('span.down').toggleClass 'up'
              $el.find('.esconder').slideToggle 0
              $el.toggleClass 'auto'

              return false

            $http.get("/#{attrs.sgkTpl}").success (data) =>
              $el.find('.overflow div').html data
              $compile($el.contents())($scope)
              $el.css 'display', 'block'


        return false
