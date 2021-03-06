'use strict'

angular.module('movistarApp')
  .directive 'sgkDuration', ($interval) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      _is = (parseInt(attrs.duration)/1000)

      element.text " 00:00:00"
      if parseInt(attrs.duration) > 0
        interval = setInterval () ->
          _is = _is - 1;
          s = Math.floor(_is%60)
          m = Math.floor(_is/60) % 60
          h = Math.floor(_is/3600)

          if s is 0 and m is 0 and h is 0
            element.text " 00:00:00"
            clearInterval interval

          if s.toString().length is 1
            s = "0#{s}"
          if m.toString().length is 1
            m = "0#{m}"
          if h.toString().length is 1
            h = "0#{h}"

          element.text " #{h}:#{m}:#{s}"

        , 1000

  .directive 'sgkMin', ($interval) ->
    restrict: 'A'
    link: (scope, element, attrs) ->

      element.text " #{Math.abs(moment(attrs.start).diff(attrs.end, 'milliseconds') / 60000)} min."

  .directive 'sgkMedidaDetail', ($window, $rootScope, $timeout) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      $timeout () ->
        $timeout () ->
          altR = el.height()
          altFirst = el.find('.altFirst').height()
          medida = altR - altFirst
          angular.element('#right .medida').height(medida)
          angular.element('#right .medida .ng-scope').height(medida)
        , 1000
      , 0

  .directive 'sgkActive', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      angular.element('ul.lista-estados').first().css 'display', 'block'
      el.on 'click', (e) ->
        angular.element('.note.round').removeClass 'active'
        angular.element(this).addClass 'active'
        angular.element('.note.round.active span.az').css {'display':'block'}
        angular.element('.note-right h3').removeClass 'active'
        angular.element('ul.lista-estados').slideUp 300
        el.find('.note-right h3').toggleClass 'active'
        el.parent().find('ul.lista-estados').slideToggle 300

  .directive 'sgkActiveSolicitude', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      el.on 'click', (e) ->
        angular.element('.note.round').removeClass 'active'
        angular.element(this).addClass 'active'

  .directive 'sgkSubmenuNotifications', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      angular.element(document).click () ->
        angular.element('#submenu.notifications').slideUp 200
      el.on 'click', (e) ->
        _notifications = angular.element('#submenu.notifications')
        _options = angular.element('#submenu.options')
        if _options.css('display') is 'block'
          _options.slideUp 200
        _notifications.slideToggle 200
        e.stopPropagation()

  .directive 'sgkSubmenuOptions', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      angular.element(document).click () ->
        angular.element('#submenu.options').slideUp 200
      _notifications = angular.element('#submenu.notifications')
      _options = angular.element('#submenu.options')
      el.on 'click', (e) ->
        if _notifications.css('display') is 'block'
          _notifications.slideUp 200
        _options.slideToggle 200
        e.stopPropagation()

  .directive 'sgkCheck', ($window, $rootScope) ->
    restrict: 'A'
    link: (scope, el, attrs) ->
      el.on 'click', (e) ->
        el.parent().find('.hide').trigger('click')
        el.toggleClass 'active'
        el.parent().parent().toggleClass 'active'
        el.parent().parent().parent().toggleClass 'active'

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
    templateUrl: 'directives/alerts'
    replace: true
    controller: ($scope, $element) ->

      $element.find('a.cerrar').on 'click', (e) ->
        $element.slideToggle(400)

      $rootScope.$watch 'alert', () ->
        if $rootScope.alert?.content?
          $scope.content = $rootScope.alert.content
          switch $rootScope.alert.type
            when 'success'
              $element.addClass('ok')
            when 'error'
              $element.addClass('error')
          $element.slideToggle(400)
          if $rootScope.alert.type is 'success'
            $timeout () ->
              if $element.css('display') is 'block'
                $element.slideToggle(400)
                $rootScope.alert = {}
            , 2000


  .directive 'sgkFileUploadUser', (filepickerApi, $timeout) ->
    restrict: 'A'
    templateUrl: 'directives/userUploader'
    require: 'ngModel'
    link: (scope, el, attrs, ngModel) ->
      el.find('input[type="file"]').on 'change', (e) ->
        el.find('.edit-avatar-user').css 'display', 'none'
        el.find('#loader').css
          'display': 'block'
          'position': 'absolute'
        input = angular.element(e.target)
        filepickerApi.storeConvert input[0].files[0], { width: 80, height: 80, fit: 'scale', align: 'face' }, (err, res) ->
          ngModel.$setViewValue(res.url)
          scope.$apply () ->
            $timeout () ->
              el.find('#loader').css 'display', 'none'
              el.find('.edit-avatar-user').css 'display', 'block'
            , 600

  .directive 'sgkUploadMulti', (filepickerApi, $timeout) ->
    restrict: 'A'
    require: 'ngModel'
    link: (scope, element, attrs, ngModel) ->
      attachments = []
      if ngModel.$viewValue instanceof Array and ngModel.$viewValue?
        attachments = ngModel.$viewValue
      element.find('input[type="file"]').on 'change', (e) ->
        MD5 = new Hashes.MD5
        input = angular.element(e.target)
        for file in input[0].files
          MD5 = new Hashes.MD5
          hash = MD5.hex file.lastModifiedDate+Date.now()
          opts =
            id: hash
            data: file
          name = opts.data.name
          if name.length > 100
            name = "#{ name.substr(0,10) }...#{ name.substr((name.length - 10), name.length) }"
          element.parents('form').find('ul.upload-list').append "<li id='#{ opts.id }'><img src='images/loader_30.GIF' /><span>#{ name }</span></li>"

          filepickerApi.storeAndThumbnail opts, (err, res) ->
            attachments.push res.data
            ngModel.$setViewValue attachments
            scope.$apply () ->
              query = "ul.upload-list li##{ res.hash } img"
              if typeof res.data.thumbnails._32x32_ isnt 'undefined'
                element.parents('form').find(query).attr 'src', res.data.thumbnails._32x32_
              else
                element.parents('form').find(query).attr 'src', ''

  .directive 'sgkPermission', ($rootScope) ->
    restrict: 'A'
    link: (scope, element, attrs) ->
      _permission = attrs.sgkPermission
      _value = attrs.permissionValue || null
      if _value?
        _value = _value.toUpperCase()
      return element.parent().remove() if typeof $rootScope.currentUser.permissions[_permission] is 'undefined' and !_value?
      return element.parent().remove() if _value? and !~$rootScope.currentUser.permissions[_permission].indexOf _value
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
