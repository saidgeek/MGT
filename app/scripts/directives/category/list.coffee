'use strict'

angular.module('movistarApp')
  .directive 'sgkCategoryList', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/category/list'
    controller: 'CategoryCtrl'
    link: ($scope, $element, $attrs) =>
      selectId = null

      $_activateFirstElement = () =>
        $element
          .find('.note.round')
          .first()
          .addClass 'active'
        $rootScope.$emit 'loadCategoryShow', $element.find('.note.round').first().data 'id'

      $_disabledActiveAllElements = () =>
        $element
          .find('.note.round')
          .removeClass('active')

      $_activeCategory = (id, activeFirst) =>
        $el = $element.find "[data-id='#{id}']"
        ms = if activeFirst then 300 else 0
        
        unless $el.hasClass 'active'
          $_disabledActiveAllElements() if activeFirst

          $el
            .addClass 'active'
          $rootScope.$emit 'loadCategoryShow', id

      $_triggers = () =>
        $element
          .find('.note.round').on 'click', (e) =>
            e.preventDefault()
            $el = angular.element(e.target).parents '.note.round'
            _id = $el.data 'id'

            $_activeCategory(_id, true)

            return false

      $rootScope.$on 'reloadCategory', (e, category) =>
        selectId = category._id
        $scope.reload()

      $scope.$watch 'categories', (value) ->
        $rootScope.resize = true
        $timeout () =>
          $timeout () =>
            if selectId is null
              $_activateFirstElement()
            else
              $_activeCategory selectId
            $_triggers()

            if $element.find('.overflow .mCustomScrollBox').length is 0
              $element.find('.overflow').mCustomScrollbar
                scrollButtons:
                    enable:false
            $element.find('.overflow').mCustomScrollbar "update"
            $element.find('.overflow').mCustomScrollbar "scrollTo", ".note.round.active"
          , 0
        , 0
