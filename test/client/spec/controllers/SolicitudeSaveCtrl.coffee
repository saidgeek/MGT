'use strict'

describe 'Controller: SolicitudeSaveCtrl', () ->

  beforeEach module 'movistarApp'

  SolicitudeSaveCtrl = null
  $timeout = null
  $rootScope = null
  $scope = null
  $controller = null
  _id = null
  _form = null

  beforeEach inject ($injector) ->
    $timeout = $injector.get '$timeout'
    $rootScope = $injector.get '$rootScope'
    $scope = $rootScope.$new()
    $controller = $injector.get '$controller'

    $rootScope.currentUser =
      access:
        accessToken: "1nQydcFIQvqzF1tnRbqS2A=="
        clientToken: "ZaYrezhysR4S5Ki3D+vLPw=="
      permissions:
        module: ['SOLICITUDE', 'ADMINISTRATION'],
        states: ['QUEUE_VALIDATION', 'QUEUE_ALLOCATION', 'CANCEL', 'QUEUE_PROVIDER', 'PROCCESS', 'QUEUE_VALIDATION_MANAGER', 'PAUSE', 'REJECTED_BY_MANAGER', 'OK_BY_MANAGER', 'QUEUE_VALIDATION_CLIENT', 'REJECTED_BY_CLIENT', 'OK_BY_CLIENT'],
        roles:  ['ROOT', 'ADMIN', 'EDITOR', 'CONTENT_MANAGER', 'PROVIDER', 'CLIENT'],
        solicitude: ['CREATE', 'UPDATE', 'DELETE'],
        administration: ['CREATE', 'UPDATE', 'DELETE']

    _form =
      '$validate': true

    SolicitudeSaveCtrl = $controller 'SolicitudeSaveCtrl', {
      '$scope': $scope
    }

  it 'El scope solicitude deberia estar vacio', () ->
    expect($scope.solicitude).not.toBeUndefined()
    expect($scope.solicitude).toEqual { }

  it 'Se deberia guardar la solicitud y el scope alert deberia ser de tipo "success"', () ->
    $scope.solicitude =
      ticket:
        title: 'test'
        description: 'test'
    $scope.create(_form)
    $timeout () ->
      expect(typeof $scope.alert.type).not.toBeUndefined()
      ecpect($scope.alert.type).toBe 'success'
    , 1
