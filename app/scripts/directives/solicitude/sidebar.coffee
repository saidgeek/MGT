'use strict'

angular.module('movistarApp')
  .directive 'sgkSolicitudeSidebar', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    link: ($scope, $element, $attrs) ->
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
        $overflow.mCustomScrollbar "scrollTo", "top"
      
      $timeout () =>
        $timeout () =>
          $_resize()
        , 0
      , 0