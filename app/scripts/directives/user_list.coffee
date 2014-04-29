'use strict'

angular.module('movistarApp')
  .directive 'sgkUserList', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'partials/admin/userList'
    controller: ($scope, $element, UserFactory) ->
      $scope.users = []
      role = ''

      UserFactory.index role, (err, users) ->
        if err
          $scope.errors = err
        else
          if users.length > 0
            $scope.users = users

    link: ($scope, $element, $attrs) =>

      $_activateFirstElement = () =>
        $element
          .find('.note.round')
          .first()
          .addClass('active')
          .find('ul.lista-estados')
          .first()
          .css('display', 'block')
        $element
          .find('.note.round')
          .first()
          .find('.note-right h3')
          .addClass 'active'

      $_disableActiveAllElements = () =>
        $element
          .find('.note.round')
          .removeClass('active')
        $element
          .find('.note-right h3')
          .removeClass 'active'

      $_hideAllAccordions = () =>
        $element
          .find('ul.lista-estados')
          .slideUp 300

      $_triggers = () ->
        $element
          .find('.note.round').on 'click', (e) =>
            e.preventDefault()
            $el = angular.element(e.target).parents '.note.round'

            unless $el.hasClass 'active'

              $_disableActiveAllElements()
              $_hideAllAccordions()

              $el
                .addClass('active')
                .find('ul.lista-estados')
                .slideDown 300
              $el
                .find('.note-right h3')
                .addClass 'active'


            return false


      $scope.$watch 'users', (value) ->
        $rootScope.resize = true
        $timeout () =>
          $timeout () =>

            $_activateFirstElement()
            $_triggers()


            if $element.find('.overflow .mCustomScrollBox').length is 0
              $element.find('.overflow').mCustomScrollbar
                scrollButtons:
                    enable:false
            $element.find('.overflow').mCustomScrollbar "update"
            $element.find('.overflow').mCustomScrollbar "scrollTo", "top"

          , 0
        , 0
