'use strict'

angular.module('movistarApp')
  .directive 'sgkSidebar', ($timeout, IO, Solicitude) ->
    restrict: 'A'
    link: ($scope, $element, $attrs) ->

      # IO.on 'solicitude.new', (data) ->
      #   Solicitude.show data.id, (err, solicitude) ->
      #     if !err
      #       $all = $element.find('[data-id="all"] span.round.light')
      #       $all.html parseInt($all.html()) + 1
      #       state_query = "[data-id='#{ solicitude.state.type }'] span.round.light"
      #       $state = $element.find(state_query)
      #       $state.html parseInt($state.html()) + 1

      $_resize = () =>
        altperfil = angular.element('.therowAlt').height()
        altmenu = angular.element('#side .therow .thecell').height()
        altrelativo = altmenu - altperfil
        angular.element('#side .therow .thecell .relativo').css 'height', altrelativo
      
      angular.element('#side .relativo .overflow').bind 'DOMNodeInserted DOMNodeRemoved', (e) =>
        $overflow = angular.element('#side .relativo .overflow')
        if $overflow.find('.mCustomScrollBox').length is 0
          $overflow.mCustomScrollbar
            scrollButtons:
                enable:false
        $overflow.mCustomScrollbar "update"
        $timeout () =>
          $overflow.mCustomScrollbar "scrollTo", "top"
        , 1000
      
      $timeout () =>
        $timeout () =>
          $_resize()
        , 0
      , 0