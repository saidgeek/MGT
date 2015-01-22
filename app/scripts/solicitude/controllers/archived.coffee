'use strict'

angular.module('movistarApp')
  .controller 'ArchivedCtrl', ($scope, $rootScope, $state, _archived) ->
    $scope.solicitudes = _archived
    $scope.currentPage = 0;
    $scope.role = $rootScope.currentUser.role

    $scope.$watch 'currentPage', (value) ->
      _page = value - 1
      if _page > -1
        Solicitude.index _target, _filter, 15, _page, (err, solicitudes) ->
          if !err
            $scope.solicitudes = solicitudes

    $scope.go = (id) ->
      if $scope.isGo
        $state.go 'solicitude', { id: id }

    $scope.archivedShow = (state) ->
      ['COMPLETED', 'CANCELED'].indexOf(state.type) > -1
