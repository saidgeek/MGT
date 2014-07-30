'use strict'

angular.module('movistarApp')
  .directive 'sgkCkeditor', ($rootScope) ->
    restrict: 'A'
    require: '?ngModel'
    link: (scope, element, attrs, ngModel) ->
      _height = attrs.sgkCkeditorHeight || null
      _width = attrs.sgkCkeditorWidth || null

      CKEDITOR.config.toolbar = 'Full'

      CKEDITOR.config.toolbar_Full = [
        { name: 'styles', items : [ 'Styles','Format','Font','FontSize' ] },
        { name: 'colors', items : [ 'TextColor','BGColor' ] },
        { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
        { name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv',
        '-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
        { name: 'links', items : [ 'Link','Unlink' ] },
      ]

      # CKEDITOR.config.skin = 'moono'
      # CKEDITOR.config.uiColor = '#DFDFDF'

      # CKEDITOR.config.fullPage = true;
      CKEDITOR.config.language = 'es';

      if _width?
        CKEDITOR.config.width = "#{ _height }px"

      if _height?
        CKEDITOR.config.height = "#{ _height }px"

      ck = CKEDITOR.replace element[0]

      ck.on 'pasteState', () ->
        scope.$apply () ->
          ngModel.$setViewValue ck.getData()

      ngModel.$render = (value) ->
        ck.setData ngModel.$modelValue

      $rootScope.$on 'resetCkeditor', (e) ->
        ck.setData ''

