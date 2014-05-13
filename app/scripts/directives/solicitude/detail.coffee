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
        $http.get("/partials/solicitude/actions/queue_publish").success (data) =>
          tpls.action['queue_publish'] = data
        $http.get("/partials/solicitude/actions/publish").success (data) =>
          tpls.action['publish'] = data
        $http.get("/partials/solicitude/actions/rejected_by_client").success (data) =>
          tpls.action['rejected_by_client'] = data
        $http.get("/partials/solicitude/actions/rejected_by_manager").success (data) =>
          tpls.action['rejected_by_manager'] = data
        $http.get("/partials/solicitude/actions/reactivated").success (data) =>
          tpls.action['reactivated'] = data
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
        $http.get("/partials/solicitude/sections/rejected_by_manager").success (data) =>
          tpls.section['rejected_by_manager'] = data
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

      $_permissionsAction = (state) =>
        role = $rootScope.currentUser.role
        return true if ['queue_validation'].indexOf(state) > -1 and ['EDITOR', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['assigned_to_manager'].indexOf(state) > -1 and ['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['assigned_to_provider'].indexOf(state) > -1 and ['PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['proccess'].indexOf(state) > -1 and ['EDITOR', 'PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['queue_validation_manager'].indexOf(state) > -1 and ['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['queue_validation_client'].indexOf(state) > -1 and ['CLIENT', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['accepted_by_client'].indexOf(state) > -1 and ['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['queue_publish'].indexOf(state) > -1 and ['PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['publish'].indexOf(state) > -1 and ['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['rejected_by_client'].indexOf(state) > -1 and ['CONTENT_MANAGER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['rejected_by_manager'].indexOf(state) > -1 and ['PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['paused'].indexOf(state) > -1 and ['PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return true if ['reactivated'].indexOf(state) > -1 and ['PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) > -1
        return false

      $_loadActions = (state) =>
        $el = $element.find('.contenedor-filtros .half[data-action]')
        if $_permissionsAction(state)
          $el.html tpls.action[state] || ''
          
          if $el.find('[data-role]').length > 0
            if ['ROOT', 'ADMIN'].indexOf($rootScope.currentUser.role) < 0
              $el.find('[data-role]').not("[data-role='#{$rootScope.currentUser.role}']").parent().remove()

          if state is 'proccess' and ['PROVIDER', 'ROOT', 'ADMIN'].indexOf($rootScope.currentUser.role) > -1
            if moment($scope.solicitude.endedAt) < moment(Date.now())
              $el
                .find('ul.acciones li.pause').remove()

          $compile($el.contents())($scope)
          $_triggersActions()

      $_loadSection = (section) =>
        $el = $element.find('.contenedor-filtros')

        $el.next().remove() 
        $el.after tpls.section[section]

        if section is 'solicitude'
          $_loadTabs('todo')
          $_triggersSection()

        if section is 'queue_validation'
          $_triggersTag()
          $_triggersCheck()
        
        $compile($el.next().contents())($scope)
        $scope.$digest()
        $_resize()

      $_loadTabs = (tab) =>
        role = $rootScope.currentUser.role
        $el = $element.find('.full-heigth .half-a')

        $el.html tpls.tab[tab]

        if tab is 'tasks' and ['PROVIDER', 'ADMIN', 'ROOT'].indexOf(role) < 0
          $el.find('.note.input.shadowup').remove()
          $el.find('.t-c.che').remove()

        $compile($el.contents())($scope)
        $scope.$digest()
        $_resize()

      $_triggersTag = () =>
        $element
          .find('.odd .Tag input.Tag').on 'keypress', (e) =>
            if e.keyCode is 13
              e.preventDefault()
              $scope.tags.push $scope.solicitude.tag
              $scope.solicitude.ticket.tags = $scope.tags
              $scope.solicitude.tag = ''
              return false
        $element
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
        $element.on 'click', 'ul li.lab', (e) =>
          e.preventDefault()

          $el = angular.element(e.target).parents('li.lab')
          $el.toggleClass 'active'
          $el.find('label span.opt-check').toggleClass 'active'

          if $el.find('label span.opt-check').hasClass 'active'
            $scope.solicitude.ticket[$el.data('type')].push $el.data 'value'
          else
            _index = $scope.solicitude.ticket[$el.data('type')].indexOf $el.data('value')
            $scope.solicitude.ticket[$el.data('type')].splice _index, 1

          return false

      $_triggersActions = () =>
        $element
          .find('ul.acciones li.aceptar a, ul.acciones li.rechazar a, ul.acciones li.pause a').on 'click', (e) =>
            e.preventDefault()
            $el = angular.element(e.target)
            _section = $el.data('section').toLowerCase()
            if $el.data('rejected-state')
              $scope.rejectedState = $el.data('rejected-state')

            $el.parents('ul').css 'display', 'none'
            $_loadSection(_section)

            return false
        $element
          .find('ul.acciones li.aceptar input, ul.acciones li.rechazar input').on 'click', (e) =>
            $el = angular.element(e.target)
            $el.parents('ul').css 'display', 'none'

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
        console.log 'value:', value
        if value?
          $rootScope.resize = true
          $_loadActions(value.state.type.toLowerCase())
          $timeout () =>
            $timeout () =>
              $_loadSection('solicitude')

              $_overflow()

            , 0
          , 0