'use strict'

angular.module('movistarApp')
  .controller 'SolicitudeCtrl', ($rootScope, $scope, Auth, $location, RolesData) ->
    $rootScope.title = "Administración"

    # switch $location.$$path
    #   when '/solicitude'
    #     $scope.module = 'category'
    #   else
    #     $scope.module = ''

    $scope.isActiveLink = (path) ->
      path is $location.$$path

    $scope.showModals = (modal) ->
      _showModals(modal)

    $rootScope.$on 'showModals', (e, args) ->
      _showModals(args.modal)

    $scope.$on 'hideModals', (e, args) ->
      $scope.modals = ''

    _showModals = (modal) ->
      $scope.modals = modal
