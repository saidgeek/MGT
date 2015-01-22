'use strict'

angular.module('movistarApp')
  .controller 'SolicitudesCtrl', ($scope, $rootScope, IO, Solicitude, $state, _solicitudes, Comment) ->
    $scope.solicitudes = _solicitudes
    $scope.currentPage = 0;
    $scope.role = $rootScope.currentUser.role
    _target = null
    _filter = null

    $scope.show_comments = (id) ->
      false
      # Comment.index id, (err, comments) ->
      #   return false if err
      #   return true if comments.length > 0
      #   return false

    IO.on 'solicitude.change.state', (data) ->
      if $state.params.target is 'state' and $state.params.filter is data.state
        $state.transitionTo $state.current, $state.params, { reload: true, inherit: false, notify: true }

    IO.on 'solicitude.new', (data) ->
      Solicitude.show data.id, (err, solicitude) ->
        if !err
          $scope.solicitudes.solicitudes.unshift solicitude

    IO.on 'solicitude.archived', (data) ->
      $scope.isGo = true
      _find = "li[data-id='#{data.id}']"
      $el = angular.element('div.lista').find(_find)
      $el.remove()

    $scope.$watch 'currentPage', (value) ->
      _page = value - 1
      if _page > -1
        Solicitude.index _target, _filter, 15, _page, (err, solicitudes) ->
          if !err
            $scope.solicitudes = solicitudes

    $scope.isGo = true

    $scope.go = (id) ->
      if $scope.isGo
        $state.go 'solicitude', { id: id }
        $scope.isGo = true

    $scope.archived = (id) =>
      $scope.isGo = false
      console.log 'archived:', id
      Solicitude.resource.archived({ id: id }).$promise
      return false

    $scope.archivedShow = (state) ->
      ['COMPLETED', 'CANCELED'].indexOf(state.type) > -1

    # Solicitude.index _target, _filter, (err, solicitudes) ->
    #   if err
    #     $scope.errors = err
    #   else
    #     if solicitudes.length > 0
    #       $scope.solicitudes = solicitudes
    #       console.log '$scope.solicitudes:', $scope.solicitudes
    #     else
    #       $scope.solicitudes = null
