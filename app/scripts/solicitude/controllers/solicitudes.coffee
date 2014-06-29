'use strict'

angular.module('movistarApp')
  .controller 'SolicitudesCtrl', ($scope, $rootScope, IO, Solicitude, $state) ->
    $scope.solicitudes = []
    $scope.role = $rootScope.currentUser.role
    _target = null
    _filter = null
    
    IO.emit 'register.solicitude.change.sla', {}
    IO.emit 'register.solicitude.remove.sla', {}

    console.log '$state.params:', $state.params
    if $state.params?.target? and $state.params?.filter?
      _target = $state.params.target
      _filter = $state.params.filter

    # state, category, priority, involved
    # reload = (state, category, priority, involved) ->
    Solicitude.index _target, _filter, (err, solicitudes) ->
      if err
        $scope.errors = err
      else
        if solicitudes.length > 0
          $scope.solicitudes = solicitudes
          console.log '$scope.solicitudes:', $scope.solicitudes
        else
          $scope.solicitudes = null
    $rootScope.$on 'reloadSolicitude', (e, solicitude) =>
      selectedId = solicitude._id
      reload('','','','')

    # reload('', '', '', '')

    $rootScope.$watchCollection '[filters.solicitude.state, filters.solicitude.category, filters.solicitude.priority, filters.solicitude.involved]', () =>
      state = if $rootScope.filters?.solicitude?.state? then $rootScope.filters.solicitude.state else ''
      category = if $rootScope.filters?.solicitude?.category? then $rootScope.filters.solicitude.category else ''
      priority = if $rootScope.filters?.solicitude?.priority? then $rootScope.filters.solicitude.priority else ''
      involved = if $rootScope.filters?.solicitude?.involved? then $rootScope.filters.solicitude.involved else ''
      reload(state, category, priority, involved) if state isnt '' or category isnt '' or priority isnt '' or involved isnt ''
