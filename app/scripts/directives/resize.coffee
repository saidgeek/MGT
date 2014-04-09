'use strict'

angular.module('movistarApp')
  .directive 'sgkOverflow', ($timeout) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      $timeout () ->
        $timeout () ->
          angular.element( ".overflow" ).mCustomScrollbar
            scrollButtons:
                enable:false
        , 1000
      , 0

  .directive 'sgkResize', ($window, $timeout) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      _maxWidth = attrs.maxWidth || 55
      _minWidth = attrs.minWidth || 36
      _leftDefaultWidth = attrs.leftWidth || null
      _type = attrs.type
      init = () ->

        alto = angular.element($window).height()
        total_width = angular.element('#wrap').width()
        sidebar = angular.element('#side').width()
        medida = total_width - sidebar

        if _leftDefaultWidth?
          angular.element('#left .relativo').css 'width', _leftDefaultWidth
          angular.element('#right').css 'width', total_width - _leftDefaultWidth

        maxAncho = medida / 100 * _maxWidth
        minAncho = medida / 100 * _minWidth

        angular.element('#main').width(medida)

        angular.element('#main .wrap, #side').height(alto)

        resize_other = (event, ui) ->
          width = angular.element('#left .relativo').width()
          total_width = angular.element('#main').width()
          if width > total_width
            width = total_width
            angular.element('#left').css 'width', width
          angular.element('#right').css 'width', total_width - width
          angular.element('.ui-resizable-handle').css 'left', width

          if (width < 460 and _type is 'solicitude') or (width < 450 and _type is 'users')
            angular.element('div.ico, span.ico').parent().find('p, span.text').css 'display', 'none'
            angular.element('.t-c.verde ul li, .t-c.rojo ul li, .t-c.amarillo ul li').css 'width', 'auto'
            if _type is 'users'
              angular.element('div.ico, span.ico').parent().find('span.right').css 'float', 'none'
          else
            angular.element('div.ico, span.ico').parent().find('p, span.text').css 'display', 'inline'
            angular.element('.t-c.verde ul li, .t-c.rojo ul li, .t-c.amarillo ul li').css 'width', '30%'
            if _type is 'users'
              angular.element('div.ico, span.ico').parent().find('span.right').css 'float', 'right'

          if width < 525
            angular.element('#left .relativo div.botones ul li a div.ico').parent().find('span.text').css 'display', 'none'
          else
            angular.element('#left .relativo div.botones ul li a div.ico').parent().find('span.text').css 'display', 'inline'

        resize_right = (event, ui) ->
          right = angular.element('#right').width()
          if right < 600
              angular.element('.menu-middle p, .tools ul li p').css 'display', 'none'
              angular.element('.edit-user ul li a').css {'textIndent':'-9999px', 'overflow':'hidden'}
          else
              angular.element('.menu-middle p, .tools ul li p').css 'display', 'inline'
              angular.element('.edit-user ul li a').css {'textIndent':0, 'overflow':'auto'}



        angular.element('#left .relativo').resizable(
          maxWidth: maxAncho
          minWidth: minAncho
          containment: '#main'
          handles: "ew"
          grid: [ 0, 0 ]
        ).bind 'resize', resize_other, resize_right

        angular.element($window).on 'resize', resize_other
        angular.element('#right').on 'resize', resize_right

        full = angular.element('.full-heigth').height();
        angular.element('.half-a').css('height', (angular.element('.full-heigth').height() / 2) - 21)
        $('.half-b').css('height', (full / 2) - 21)

      $timeout () ->
        $timeout init, 0
      , 0
