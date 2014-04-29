'use strict'

angular.module('movistarApp')
  .directive 'sgkSolicitudeDetail', ($window, $rootScope, $timeout, SolicitudeFactory, StateData) ->
    restrict: 'A'
    templateUrl: 'partials/solicitude/solicitudeDetail'
    controller: ($scope, $element) ->
      $scope.tabs = ''
      $scope.options = ''

      _resize = () ->
        $element.find('.half-a p').css
          'text-align': 'justify'
          'white-space': 'pre-line'
        right_height = $element.parents('#right').height()
        menu_height = $element.find('.menu-middle').height()
        medida = right_height - menu_height
        $element.find('.full-heigth').css 'height', medida
        if $element.find('.overflow .mCustomScrollBox').length is 0
          $element.find('.overflow').mCustomScrollbar
            scrollButtons:
                enable:false

      $scope.showOption = (option) ->
        if option is 'PAUSED'
          ~['ROOT', 'ADMIN', 'CONTENT_MANAGER'].indexOf($rootScope.currentUser.role)

      $scope.changeOptions = (option) ->
        $scope.options = option

      $scope.changeTabs = (tab) ->
        $scope.tabs = tab

      $scope.activeTab = (tab) ->
        $scope.tabs is tab

      $scope.changeSection = (section, nextState) ->
        $scope.rejectedState = nextState
        $scope.section = section

      $scope.$watch 'solicitude', (value) ->
        $rootScope.resize = true
        $scope.section = ''
        $scope.changeOptions(value.state[$rootScope.currentUser.role])
        $timeout () =>
          _resize()
          $timeout () =>
            data = StateData.get $scope.solicitude.state[$rootScope.currentUser.role]
            $element.find('.menu-tarea-top #state.ico').addClass data.icon
            $element.find('.overflow').mCustomScrollbar "update"
            $element.find('.overflow').mCustomScrollbar "scrollTo", "top"
          , 0
        , 0
