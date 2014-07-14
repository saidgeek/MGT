'use strict'

angular.module('movistarApp')
  .controller 'SolicitudesCtrl', ($scope, $rootScope, IO, Solicitude, $state, _solicitudes, Comment) ->
    $scope.solicitudes = _solicitudes
    $scope.role = $rootScope.currentUser.role
    _target = null
    _filter = null

    $scope.show_comments = (id) ->
      false
      # Comment.index id, (err, comments) ->
      #   return false if err
      #   return true if comments.length > 0
      #   return false
    
    IO.on 'solicitude.new', (data) ->
      Solicitude.show data.id, (err, solicitude) ->
        if !err
          $scope.solicitudes.unshift solicitude

    # Solicitude.index _target, _filter, (err, solicitudes) ->
    #   if err
    #     $scope.errors = err
    #   else
    #     if solicitudes.length > 0
    #       $scope.solicitudes = solicitudes
    #       console.log '$scope.solicitudes:', $scope.solicitudes
    #     else
    #       $scope.solicitudes = null
