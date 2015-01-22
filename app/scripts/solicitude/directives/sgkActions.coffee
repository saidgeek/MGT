'use strict'

angular.module('movistarApp')
  .directive 'sgkActions', ($window, $rootScope, $timeout, $compile, ActionsFactory) ->
    restrict: 'A'
    link: ($scope, $element, $attrs) ->
      _state = $attrs.sgkActions.toLowerCase()

      $element
        .on 'click', 'ul.acciones li.aceptar a, ul.acciones li.rechazar a, ul.acciones li.pause a', (e) ->
          e.preventDefault()
          $el = angular.element(e.target)
          _section = $el.data('section').toLowerCase()
          if $el.data('rejected-state')
            $scope.rejectedState = $el.data('rejected-state')

          $el.parents('ul').css 'display', 'none'
          $_loadSection(_section)

          return false

      $element
        .on 'click', 'ul.acciones li.aceptar input, ul.acciones li.rechazar input', (e) =>
          $el = angular.element(e.target)
          $el.parents('ul').css 'display', 'none'

      if ActionsFactory.permission(_state, $rootScope.currentUser.role)
        ActionsFactory.action(_state).success (data) ->
          $el = angular.element(data)
          $element.html $el
          $scope['role'] = $rootScope.currentUser.role
          $compile($element.contents())($scope)
        
          if $element.find('[data-role]').length > 0
            if ['ROOT', 'ADMIN'].indexOf($rootScope.currentUser.role) < 0
              $element.find('[data-role]')
                .not("[data-role='#{$rootScope.currentUser.role}']")
                .parent()
                .remove()

          if _state is 'proccess' and ['PROVIDER', 'ROOT', 'ADMIN'].indexOf($rootScope.currentUser.role) > -1
            if moment($scope.solicitude.endedAt) < moment(Date.now())
              $element
                .find('ul.acciones li.pause')
                .remove()

          if $element.find('li.pause').length > 1
            $element.find('li.pause')[0].remove()

      $_loadSection = (section) =>
        $el = $element.parents('.row')

        # $el.next().remove() 
        ActionsFactory.section(section).success (data) =>
          $row = angular.element("<div class='row form'>#{ data }</div>")
          $el.after $row
          $row.on 'click', '[data-cancel]', (e) ->
            angular.element(e.target).parents('.row.form').remove()
            $element.find('ul').css 'display', 'block'

          $row.on 'click', 'form [type="submit"]', (e) ->
            $row.hide()
            ActionsFactory.section('loader').success (data) =>
              $loader = angular.element(data)
              $el.after $loader
          $compile($el.parent().find('.row.form').contents())($scope)

          if section is 'queue_validation'
            $_triggersTag()
            # $_triggersCheck()

          $el.parents('.overflow').mCustomScrollbar 'update'
        
        return false

      $_triggersTag = () =>
        $element
          .parents('.detalle')
          .find('.row.form .odd .Tag input.Tag').on 'keypress', (e) =>
            if e.keyCode is 13
              e.preventDefault()
              $scope.tags.push $scope.solicitude.tag
              $scope.solicitude.ticket.tags = $scope.tags
              $scope.solicitude.tag = ''
              return false
        $element
          .parents('.detalle')
          .on 'click', '.odd .Tag .tags .tag.round a.cerrar', (e) =>
            e.preventDefault()
            $el = angular.element(e.target).parent()
            _index = $scope.tags.indexOf $el.data('value')
            if _index > -1
              $scope.tags.splice _index, 1
              $scope.solicitude.ticket.tags = $scope.tags
              $el.remove()

          return false

      $_triggersCheck = () =>
        $element
          .parents('.detalle')
          .on 'click', 'ul li.lab', (e) =>
            e.preventDefault()

            console.log 'angular.element(e.target):', angular.element(e.target)

            $el = angular.element(e.target)
            $el = angular.element($el[0])

            $el.toggleClass 'active'
            $el.find('label span.opt-check').toggleClass 'active'

            if $el.find('label span.opt-check').hasClass 'active'
              $scope.solicitude.ticket[$el.data('type')].push $el.data 'value'
            else
              console.log '$scope.solicitude.ticket:', $scope.solicitude.ticket, $el.data('type'), $el
              _index = $scope.solicitude.ticket[$el.data('type')].indexOf $el.data('value')
              $scope.solicitude.ticket[$el.data('type')].splice _index, 1

            return false
