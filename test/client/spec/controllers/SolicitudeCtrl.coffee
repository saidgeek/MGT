'use strict'

describe 'Controller: SolicitudeCtrl', () ->

  beforeEach module 'movistarApp'

  SolicitudeCtrl = null
  $timeout = null
  $rootScope = null
  $scope = null
  $controller = null

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

    SolicitudeCtrl = $controller 'SolicitudeCtrl', {
      '$scope': $scope
    }

  it 'El scope solicitudes deberia tener items', () ->
    expect(typeof $scope.solicitudes).not.toBe 'undefined'
    $timeout () ->
      expect($scope.solicitudes).toBeGreaterThan 1
    , 1

  it 'Al invocar el metodo del scope showModals deberia scope modals valer "newSolicitude"', () ->
    $scope.showModals('newSolicitude')
    expect($scope.modals).toBe 'newSolicitude'

  it 'Al invocar el $emit showModals el scope modals deberia valer "newSolicitude"', () ->
    $rootScope.$emit 'showModals', {modal:'newSolicitude'}
    expect($scope.modals).toBe 'newSolicitude'

  it 'Al invocar el $emit hideModals el scope modals deberia valer ""', () ->
    $rootScope.$emit 'hideModals'
    expect($scope.modals).toEqual null

  it 'Al invocar el $emit reloadSolicitudes el scope solicitude deberia tener mas de un item', () ->
    $rootScope.$emit 'reloadSolicitude', '','','',''
    $timeout () ->
      expect($scope.solicitudes).toBeGreaterThan 1
    , 1

  it 'Al invocar el $emit uploadSolicitudes el scope solicitude deberia tener mas de un item', () ->
    $rootScope.$emit 'uploadSolicitudes', '','','',''
    $timeout () ->
      expect($scope.solicitudes).toBeGreaterThan 1
    , 1
