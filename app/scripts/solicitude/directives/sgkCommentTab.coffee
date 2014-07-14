'use strict'

angular.module('movistarApp')
  .directive 'sgkCommentTab', ($rootScope, $timeout, Comment, IO) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      type = attrs.sgkCommentTab

      $areaform = angular.element('#comment-form form textarea')
      placeholder = 
        pm: 'Escribe aquí tu comentario a PM'
        internal: 'Escribe aquí tu comentario interno'
        provider: 'Escribe aquí tu comentario a proveedor'
        client: 'Escribe aquí tu comentario'

      $timeout () ->
        if element.hasClass 'active'
          
          if $rootScope.currentUser.role is 'CLIENT'
            $areaform.attr 'placeholder', placeholder.client
          else
            $areaform.attr 'placeholder', placeholder[type]
          
          $rootScope.$emit 'loadComments', type, scope.comment[type]
      , 0

      element.on 'click', 'a', (e) ->
        e.preventDefault()
        $el = angular.element(e.target)
        $tabs = $el.parents('ul#comment-tabs') 
        type = $el.parent().data('sgkCommentTab')
        $tabs.find('li').removeClass 'active'
        $el.parent().addClass 'active'
        $areaform.attr 'placeholder', placeholder[type]
        $rootScope.$emit 'loadComments', type, scope.comment[type]
        return false