'use strict'

angular.module('movistarApp')
  .directive 'sgkCkeditor', ->
    restrict: 'A'
    require: '?ngModel'
    link: (scope, element, attrs, ngModel) ->

      CKEDITOR.config.toolbar = 'Full'

      CKEDITOR.config.toolbar_Full = [
        { name: 'styles', items : [ 'Styles','Format','Font','FontSize' ] },
        { name: 'colors', items : [ 'TextColor','BGColor' ] },
        { name: 'basicstyles', items : [ 'Bold','Italic','Underline','Strike','Subscript','Superscript','-','RemoveFormat' ] },
        { name: 'paragraph', items : [ 'NumberedList','BulletedList','-','Outdent','Indent','-','Blockquote','CreateDiv',
        '-','JustifyLeft','JustifyCenter','JustifyRight','JustifyBlock','-','BidiLtr','BidiRtl' ] },
        { name: 'links', items : [ 'Link','Unlink' ] },
      ]

      ck = CKEDITOR.replace element[0]

      ck.on 'pasteState', () ->
        scope.$apply () ->
          ngModel.$setViewValue ck.getData()

      ngModel.$render = (value) ->
        ck.setData ngModel.$modelValue

