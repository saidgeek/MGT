'use strict'

angular.module('movistarApp')
  .directive 'sgkResizeB', ($window, $timeout, $rootScope) ->
    restrict: 'A'
    link: ($scope, $element, $attrs) ->
      w = angular.element($window)
      alto = null
      total_width = null
      sidebar = null
      medida = null
      maxAncho = null
      minAncho = null

      $scope.getWDimensions = () =>
        return { 
          h: w.height()
          w: w.width() 
        }

      init = (wWidth, wHeight) =>

        alto = wHeight
        total_width = angular.element('#wrap').width()
        sidebar = angular.element('#side').width()
        medida = total_width - sidebar

        maxAncho = medida / 100 * 60
        minAncho = medida / 100 * 34

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

        resize_right = (event, ui) ->
          right = angular.element('#right').width()
          
        
        angular.element('#left .relativo').resizable(
          maxWidth: maxAncho
          minWidth: minAncho
          containment: '#main'
          handles: "ew"
          grid: [ 0, 0 ]
        ).bind 'resize', resize_other, resize_right

        angular.element($window).on 'resize', resize_other
        angular.element('#right').on 'resize', resize_right

      $scope.$watch $scope.getWDimensions, (newValue, oldValue) =>

        init(oldValue.w, oldValue.h)

      , true

      w.bind 'resize', (e) =>
        $scope.$apply()

      init(w.height(), w.width())

  .directive 'sgkResizeLeft', ($window, $timeout, $rootScope) ->
    restrict: 'A'
    link: ($scope, $element, $attrs) ->
      w = angular.element($window)
      medida = $attrs.sgkResizeLeft

      $scope.get_LW_Dimensions = () =>
        return { 
          h: w.height()
          w: w.width() 
        }

      $scope.getWLeft = () =>
        return { 
          w: $element.width()
        }

      $scope.$watch $scope.get_LW_Dimensions, (newValue, oldValue) =>

        side = angular.element('#side').width()
        # top = angular.element('#top').height()
        # manu_admin = angular.element('#menu-admin').height()

        wleft = ((oldValue.w-side)/100)*medida
        # hLeft = oldValue.h-(top+manu_admin+44)

        $element
          .css 
            'width': "#{if wleft < '250' then '250' : wleft}px"
            'height': "100%"
      , true

      $scope.$watch $scope.getWLeft, (newValue, oldValue) =>
        if oldValue.w < 555
          $element.find('div.ico, span.ico').parent().find('p, span.text').css 'display', 'none'
          $element.find('.t-c.verde ul li, .t-c.rojo ul li, .t-c.amarillo ul li').css 'width', 'auto'
          # if _type is 'users'
          $element.find('div.ico, span.ico').parent().find('span.right').css 'float', 'none'
          $element.find('.relativo div.botones ul li a div.ico').parent().find('span.text').css 'display', 'none'
        else
          $element.find('div.ico, span.ico').parent().find('p, span.text').css 'display', 'inline'
          $element.find('.t-c.verde ul li, .t-c.rojo ul li, .t-c.amarillo ul li').css 'width', '30%'
          # if _type is 'users'
          $element.find('div.ico, span.ico').parent().find('span.right').css 'float', 'right'
          $element.find('#left .relativo div.botones ul li a div.ico').parent().find('span.text').css 'display', 'inline'
      , true

  .directive 'sgkResizeRight', ($window, $timeout, $rootScope) ->
    restrict: 'A'
    link: ($scope, $element, $attrs) ->
      w = angular.element($window)
      medida = $attrs.sgkResizeRight

      $scope.get_RW_Dimensions = () =>
        return { 
          h: w.height()
          w: w.width() 
        }

      $scope.getWRight = () =>
        return { 
          w: $element.width()
        }

      $scope.$watch $scope.get_RW_Dimensions, (newValue, oldValue) =>

        side = angular.element('#side').width()
        # top = angular.element('#top').height()
        # manu_admin = angular.element('#menu-admin').height()

        wright = ((oldValue.w-side)/100)*medida
        # hLeft = oldValue.h-(top+manu_admin+44)

        

        $element
          .css 
            'width': "#{wright}px"
            'height': "100%"
      , true

      $scope.$watch $scope.getWRight, (newValue, oldValue) =>
        if oldValue.w < 567
          angular.element('#right .menu-middle p, #right .tools ul li p').css 'display', 'none'
          angular.element('#right .edit-user ul li a').css {'textIndent':'-9999px', 'overflow':'hidden'}
        else
          angular.element('#right .menu-middle p, #right .tools ul li p').css 'display', 'inline'
          angular.element('#right .edit-user ul li a').css {'textIndent':0, 'overflow':'auto'}
      , true


