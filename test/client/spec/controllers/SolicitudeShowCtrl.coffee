'use strict'

describe 'Controller: SolicitudeShowCtrl', () ->

  beforeEach module 'movistarApp'

  SolicitudeShowCtrl = null
  $timeout = null
  $rootScope = null
  $scope = null
  $controller = null
  _form = null
  Solicitude = null
  _id = null
  _solicitude = null

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

    Solicitude = $injector.get 'Solicitude'

    _form =
      $valid = true

    _solicitude =
      ticket:
        title: 'test'
        description: 'test'

    Solicitude.create _solicitude, (err, solicitude) ->
      if !err
        _solicitude = solicitude

    SolicitudeShowCtrl = $controller 'SolicitudeShowCtrl', {
      '$scope': $scope
    }

  it 'El scope priorities deberia tener items', () ->
    expect(typeof $scope.priorities).not.toBe 'undefined'
    $timeout () ->
      expect($scope.priorities).toBeGreaterThan 1
    , 1

  it 'El scope segments deberia tener items', () ->
    expect(typeof $scope.segments).not.toBe 'undefined'
    $timeout () ->
      expect($scope.segments).toBeGreaterThan 1
    , 1

  it 'El scope sections deberia tener items', () ->
    expect(typeof $scope.sections).not.toBe 'undefined'
    $timeout () ->
      expect($scope.sections).toBeGreaterThan 1
    , 1

  it 'El scope categories deberia tener items', () ->
    expect(typeof $scope.categories).not.toBe 'undefined'
    $timeout () ->
      expect($scope.categories).toBeGreaterThan 1
    , 1

  it 'El scope provider deberia tener items', () ->
    expect(typeof $scope.provider).not.toBe 'undefined'
    $timeout () ->
      expect($scope.provider).toBeGreaterThan 1
    , 1

  it 'Al invocar el $emit loadSolicitudeShow el scopesolicitude no deberia estar vacio', () ->
    $rootScope.$emit 'loadSolicitudeShow', _solicitude._id
    $timeout () ->
      expect($scope.solicitude).not.toEqual { }
    , 1

  it 'Al invocar el metodo showTabs el scope tabs deberia valer "comments"', () ->
    $scope.showTabs 'comments'
    $timeout () ->
      expect($scope.tabs).toBe 'comments'
    , 1

  it 'Se deberia crear un comentario en la solicitud', () ->
    _solicitude.message = 'test'
    $scope.addComment(_form)
    $timeout () ->
      expect($scope.solicitude.comments.length).toBe 1
    , 1

  it 'El estado de la solicitude deberia cambiar a "QUEUE_ALLOCATION"', () ->
    $scope.update(_form)
    $timeout () ->
      expect($scope.solicitude.state).toBe 'QUEUE_ALLOCATION'
    , 1
