'use strict'

angular.module('movistarApp')
  .directive 'sgkSolicitudeList', ($window, $rootScope, $timeout, IO) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/solicitude/list'
    controller: 'SolicitudeCtrl'
    link: ($scope, $element, $attrs) =>
      selectedId = null

      IO.on 'solicitude.change.sla', (data) => $_changeSLA(data.id, data.state)
      IO.on 'solicitude.remove.sla', (data) => $_removeSLA(data.id)

      $_changeSLA = (id, sla) =>
        query = "[data-id='#{id}'] .t-c.round"
        $el = $element.find(query)
        
        if $el.hasClass 'GREEN'
          $el.removeClass 'GREEN'
        
        if $el.hasClass 'YELLOW'
          $el.removeClass 'YELLOW'
        
        $el.addClass sla.toString()

        if sla is 'RED'
          query = "#right .relativo[data-id='#{id}'] .half ul.acciones li.pause"
          angular.element(query).remove()
        
        
      $_removeSLA = (id) =>
        query = "[data-id='#{id}'] .t-c.round"
        $el = $element.find(query)
        if $el.hasClass 'GREEN'
          $el.removeClass 'GREEN'
        if $el.hasClass 'YELLOW'
          $el.removeClass 'YELLOW'
        if $el.hasClass 'RED'
          $el.removeClass 'RED'

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
