'use strict'

angular.module('movistarApp')
  .directive 'sgkSolicitudeList', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/solicitude/list'
    controller: 'SolicitudeCtrl'
    link: ($scope, $element, $attrs) =>
      selectedId = null

      $_activeFirstElement = () =>
        $element
          .find('.note.round')
          .first()
          .addClass 'active'
        $rootScope.$emit 'loadSolicitudeShow', $element.find('.note.round').first().data 'id'

      $_disableActiveAllElements = () =>
        $element
          .find('.note.round')
          .removeClass 'active'

      $_activeSolicitude = (id, activeFirst) =>
        $el = $element.find("[data-id='#{id}']")

        unless $el.hasClass 'active'
          $_disableActiveAllElements() if activeFirst
          $el.addClass 'active'
          $rootScope.$emit 'loadSolicitudeShow', $el.data('id')

      $_triggers = () ->
        $element
          .find('.note.round').on 'click', (e) =>
            e.preventDefault()
            $el = angular.element(e.target).parents '.note.round'
            _id = $el.data 'id'

            $_activeSolicitude _id, true

            return false

      $rootScope.$on 'reloadSolicitude', (e, solicitude) =>
        selectedId = solicitude._id
        $scope.reload('','','','')

      $scope.$watch 'solicitudes', (value) ->
        $rootScope.resize = true
        $timeout () =>
          $timeout () =>
            if selectedId is null
              $_activeFirstElement()
            else
              $_activeSolicitude(selectedId)
            $_triggers()

            if $element.find('.overflow .mCustomScrollBox').length is 0
              $element.find('.overflow').mCustomScrollbar
                scrollButtons:
                    enable:false
            $element.find('.overflow').mCustomScrollbar "update"
            $element.find('.overflow').mCustomScrollbar "scrollTo", '.note.round.active'

          , 0
        , 0
