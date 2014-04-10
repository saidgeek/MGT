'use strict'

angular.module('movistarApp')
  .directive 'sgkActive', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      el.on 'click', (e) ->
        angular.element('.note.round').removeClass 'active'
        angular.element(this).addClass 'active'
        angular.element('.note.round.active span').css {'display':'block'}

  .directive 'sgkActiveSolicitude', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      el.on 'click', (e) ->
        angular.element('.note.round').removeClass 'active'
        angular.element(this).addClass 'active'

  .directive 'sgkSubmenuNotifications', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      el.on 'click', (e) ->
        _notifications = angular.element('#submenu.notifications')
        _options = angular.element('#submenu.options')
        if _options.css('display') is 'block'
          _options.slideToggle 200
        _notifications.slideToggle 200

  .directive 'sgkSubmenuOptions', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      _notifications = angular.element('#submenu.notifications')
      _options = angular.element('#submenu.options')
      el.on 'click', (e) ->
        if _notifications.css('display') is 'block'
          _notifications.slideToggle 200
        _options.slideToggle 200
      el.parent().find('a.t-c').on 'click', (e) ->
        _options.slideToggle 200

  .directive 'sgkCheck', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      el.on 'click', (e) ->
        el.parent().find('.hide').trigger('click')
        el.toggleClass 'active'

  .directive 'sgkDownModal', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.on 'click', (e) ->
        e.preventDefault()
        angular.element(this).find('span.down').toggleClass 'up'
        angular.element('.esconder').slideToggle(0);
        angular.element('#nueva-solicitud').toggleClass 'auto'
        false

  .directive 'sgkAlerts', ($rootScope, $timeout) ->
    restrict: 'A'
    templateUrl: 'partials/_alerts'
    replace: true
    controller: ($scope, $element) ->

      $element.find('a.cerrar').on 'click', (e) ->
        $element.slideToggle(400)

      $rootScope.$watch 'alert', () ->
        if $rootScope.alert?.content?
          $scope.content = $rootScope.alert.content
          $element.slideToggle(400)
          $timeout () ->
            if $element.css('display') is 'block'
              $element.slideToggle(400)
              $rootScope.alert = {}
          , 5000


  .directive 'sgkFileUploadUser', (filepickerApi, $timeout) ->
    restrict: 'A'
    templateUrl: 'partials/_userUploader'
    require: 'ngModel'
    link: (scope, el, attrs, ngModel) ->
      el.find('input[type="file"]').on 'change', (e) ->
        el.find('.edit-avatar-user').css 'display', 'none'
        el.find('#loader').css 'display', 'block'
        input = angular.element(e.target)
        filepickerApi.storeConvert input[0].files[0], { width: 80, height: 80, fit: 'scale', align: 'face' }, (err, res) ->
          ngModel.$setViewValue(res.url)
          scope.$apply () ->
            $timeout () ->
              el.find('#loader').css 'display', 'none'
              el.find('.edit-avatar-user').css 'display', 'block'
            , 600

  .directive 'sgkPermission', ($rootScope) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      _permission = attrs.sgkPermission
      _value = attrs.permissionValue || null
      if _value?
        _value = _value.toUpperCase()
      console.log typeof $rootScope.currentUser.permissions[_permission] isnt 'undefined'
      return element.remove() if typeof $rootScope.currentUser.permissions[_permission] is 'undefined' and !_value?
      return element.remove() if _value? and !~$rootScope.currentUser.permissions[_permission].indexOf _value
      return false

  .directive 'sgkToggleAccordion', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      element.on 'click', (e) ->
        element.parent().parent().find('.docu').slideToggle 400

  .directive 'sgkShortParagraph', ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      _maxLength = attrs.sgkShortParagraph || 1500

      _btnClick = (e) ->
        if element.hasClass('short')
          _showContent()
          element.find("a").bind 'click', _btnClick
        else
          _hideContent()
          element.find("a").bind 'click', _btnClick

      _hideContent = () ->
        text = scope.solicitude.ticket.description.substring 0, _maxLength
        index = text.lastIndexOf(' ')
        text = text.substring 0, index
        text += "...<br /><a href='javascript:{}'>Ver mas</a>"
        element.addClass('short').html(text)

      _showContent = () ->
        text = scope.solicitude.ticket.description
        text += "<br /><a href='javascript:{}'>Ocultar</a>"
        element.removeClass('short').html(text)

      if scope.solicitude.ticket.description.length > _maxLength
        _hideContent()
        element.find("a").bind 'click', _btnClick
