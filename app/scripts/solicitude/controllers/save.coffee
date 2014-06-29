'use strict'

angular.module('movistarApp')
  .controller 'SolicitudeSaveCtrl', ($scope, $rootScope, Solicitude, SolicitudeParams) ->
    $scope.title = 'Crear nueva Solicitud'
    $scope.solicitude = {}
    $scope.errors = {}

    $scope.create = (form) ->
      if form.$valid
        Solicitude.create $scope.solicitude, (err, solicitude) ->
          if err
            $scope.errors = err
            $rootScope.alert =
              type: 'error'
              content: """
                          Ha ocurrido un error al crear la solicitud.
                       """
          else
            $rootScope.$emit 'reloadSolicitude', solicitude
            $scope.$emit 'close', true
            $scope.solicitude = {}
            $rootScope.$emit 'reloadStateFilter'
            $scope.submitted = false
            $scope.form = null
            $rootScope.alert =
              type: 'success'
              content: """
                          La solicitude #{ solicitude.code } se creo correctamente.
                       """
