'use strict'

angular.module('movistarApp')
  .directive 'sgkSolicitudeDetail', ($window, $rootScope, $timeout, $http, $compile) ->
    restrict: 'A'
    scope: {}
    templateUrl: 'directives/solicitude/detail'
    controller: 'SolicitudeShowCtrl'
    link: ($scope, $element, $attrs) ->

      tpls =
        action: {}
        section: {}
        tab: {}

      $_loadTpls = () =>
        # ACTIONS
        $http.get("/partials/solicitude/actions/queue_validation").success (data) =>
          tpls.action['queue_validation'] = data
        $http.get("/partials/solicitude/actions/assigned_to_manager").success (data) =>
          tpls.action['assigned_to_manager'] = data
        $http.get("/partials/solicitude/actions/assigned_to_provider").success (data) =>
          tpls.action['assigned_to_provider'] = data
        $http.get("/partials/solicitude/actions/proccess").success (data) =>
          tpls.action['proccess'] = data
        $http.get("/partials/solicitude/actions/paused").success (data) =>
          tpls.action['paused'] = data
        $http.get("/partials/solicitude/actions/queue_validation_manager").success (data) =>
          tpls.action['queue_validation_manager'] = data
        $http.get("/partials/solicitude/actions/queue_validation_client").success (data) =>
          tpls.action['queue_validation_client'] = data
        $http.get("/partials/solicitude/actions/accepted_by_client").success (data) =>
          tpls.action['accepted_by_client'] = data
        $http.get("/partials/solicitude/actions/queue_publich").success (data) =>
          tpls.action['queue_publich'] = data
        $http.get("/partials/solicitude/actions/publich").success (data) =>
          tpls.action['publich'] = data
        # SECTIONS
        $http.get("/partials/solicitude/sections/solicitude").success (data) =>
          tpls.section['solicitude'] = data
        $http.get("/partials/solicitude/sections/rejected").success (data) =>
          tpls.section['rejected'] = data
        $http.get("/partials/solicitude/sections/queue_validation").success (data) =>
          tpls.section['queue_validation'] = data
        $http.get("/partials/solicitude/sections/assigned_to_manager").success (data) =>
          tpls.section['assigned_to_manager'] = data
        $http.get("/partials/solicitude/sections/assigned_to_provider").success (data) =>
          tpls.section['assigned_to_provider'] = data
        # TABS
        $http.get("/partials/solicitude/sections/tabs/todo").success (data) =>
          tpls.tab['todo'] = data
        $http.get("/partials/solicitude/sections/tabs/comments").success (data) =>
          tpls.tab['comments'] = data
        $http.get("/partials/solicitude/sections/tabs/documents").success (data) =>
          tpls.tab['documents'] = data
        $http.get("/partials/solicitude/sections/tabs/involved").success (data) =>
          tpls.tab['involved'] = data
        $http.get("/partials/solicitude/sections/tabs/tasks").success (data) =>
          tpls.tab['tasks'] = data

      $_resize = () ->
        $element.find('.half-a p').css
          'text-align': 'justify'
          'white-space': 'pre-line'
        right_height = $element.parents('#right').height()
        menu_height = $element.find('.menu-middle').height()
        medida = right_height - menu_height
        $element.find('.full-heigth').css 'height', medida
        $_overflow()

      $_overflow = () =>
        if $element.find('.overflow .mCustomScrollBox').length is 0
          $element.find('.overflow').mCustomScrollbar
            scrollButtons:
                enable:false
        $element.find('.overflow').mCustomScrollbar "update"
        $element.find('.overflow').mCustomScrollbar "scrollTo", ".note.round.active"

      $_loadActions = (state) =>
        $el = $element.find('.relativo .contenedor-filtros .half[data-action]')
        $el.html tpls.action[state] || ''
        $compile($el.contents())($scope)
        $_triggersActions()

      $_loadSection = (section) =>
        $el = $element.find('.relativo .contenedor-filtros')

        $el.next().remove() 
        $el.after tpls.section[section]

        if section is 'solicitude'
          $_loadTabs('todo')
          $_triggersSection()

        if section is 'queue_validation'
          $_triggersTag()
        
        $compile($el.next().contents())($scope)
        $scope.$digest()
        $_resize()

      $_loadTabs = (tab) =>
        $el = $element.find('.full-heigth .half-a')

        $el.html tpls.tab[tab]
        $compile($el.contents())($scope)
        $scope.$digest()
        $_resize()

      $_triggersTag = () =>
        $element
          .find('.odd .Tag input.Tag').on 'keypress', (e) =>
            console.log '$_triggersTag:', e.keyCode
            if e.keyCode is 13
              e.preventDefault()
              $scope.tags.push $scope.solicitude.tag
              $scope.solicitude.ticket.tags = $scope.tags
              $scope.solicitude.tag = ''
              return false
        $element
          .on 'click', '.odd .Tag .tags .tag.round a.cerrar', (e) =>
            console.log 'entro'
            e.preventDefault()
            $el = angular.element(e.target).parent()
            _index = $scope.tags.indexOf $el.data('value')
            if _index > -1
              $scope.tags.splice _index, 1
              $scope.solicitude.ticket.tags = $scope.tags
              $el.remove()

          return false

      $_triggersActions = () =>
        $element
          .find('ul.acciones li.aceptar a, ul.acciones li.rechazar a').on 'click', (e) =>
            e.preventDefault()
            $el = angular.element(e.target)
            _section = $el.data('section').toLowerCase()
            if $el.data('rejected-state')
              $scope.rejectedState = $el.data('rejected-state')

            $_loadSection(_section)

            $el.parents('ul').css 'display', 'none'

            return false

      $_triggersSection = () =>
        $element
          .find('.menu-middle ul li').on 'click', (e) =>
            $el = angular.element(e.target).parents('li').find('a')
            $element.find('.menu-middle ul li a').removeClass 'active'
            $el.addClass 'active'
            _tab = $el.data 'tab'

            $_loadTabs(_tab)

      $_loadTpls()

      $scope.$watch 'solicitude', (value) ->
        if value
          $rootScope.resize = true
          $_loadActions(value.state[$scope.role].toLowerCase())
          $timeout () =>
            $timeout () =>
              $_loadSection('solicitude')

              $_overflow()

            , 0
          , 0