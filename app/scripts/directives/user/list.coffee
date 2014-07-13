'use strict'

angular.module('movistarApp')
  .directive 'sgkUserList', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/user/list'
    controller: 'UserCtrl'
    link: ($scope, $element, $attrs) =>
      selectId = null

      $_activateFirstElement = () =>
        $element
          .find('.note.round')
          .first()
          .addClass('active')
          # .find('ul.lista-estados')
          # .first()
          # .css('display', 'block')
        # $element
        #   .find('.note.round')
        #   .first()
        #   .find('.note-right h3')
        #   .addClass 'active'
        $rootScope.$emit 'loadUserShow', $element.find('.note.round').first().data 'id'

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

      $_activeUser = (id, activeFirst) =>
        $el = $element.find("[data-id='#{id}']")
        ms = if activeFirst then 300 else 0

        unless $el.hasClass 'active'
          $_disableActiveAllElements() if activeFirst
          $_hideAllAccordions() if activeFirst

          $el
            .addClass('active')
            .find('ul.lista-estados')
            .slideDown ms
          $el
            .find('.note-right h3')
            .addClass 'active'

          $rootScope.$emit 'loadUserShow', id

      $_triggers = () ->
        $element
          .find('.note.round').on 'click', (e) =>
            e.preventDefault()
            $el = angular.element(e.target).parents '.note.round'
            _id = $el.data 'id'

            $_activeUser(_id, true)

            return false

      $rootScope.$on 'reloadUser', (e, user) =>
        selectId = user._id
        $scope.reload()

      $scope.$watch 'users', (value) ->
        $rootScope.resize = true
        $timeout () =>
          $timeout () =>
            if selectId is null
              $_activateFirstElement()
            else
              $_activeUser(selectId)
            $_triggers()


            if $element.find('.overflow .mCustomScrollBox').length is 0
              $element.find('.overflow').mCustomScrollbar
                scrollButtons:
                    enable:false
            $element.find('.overflow').mCustomScrollbar "update"
            $element.find('.overflow').mCustomScrollbar "scrollTo", ".note.round.active"

          , 0
        , 0
