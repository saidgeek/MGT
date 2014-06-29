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

    Solicitude.index _target, _filter, (err, solicitudes) ->
      if err
        $scope.errors = err
      else
        if solicitudes.length > 0
          $scope.solicitudes = solicitudes
          console.log '$scope.solicitudes:', $scope.solicitudes
        else
          $scope.solicitudes = null
