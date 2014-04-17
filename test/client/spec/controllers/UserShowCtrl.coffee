'use strict'

describe 'Controller: UserShowCtrl', () ->

  beforeEach module 'movistarApp'

  UserShowCtrl = null
  $timeout = null
  $rootScope = null
  $scope = null
  $controller = null
  _id = null

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

    _id = "533b959c3b642c708c3f0cbc"

    UserShowCtrl = $controller 'UserShowCtrl', {
      '$scope': $scope
    }

  it 'El scope user deberia estar vacio', () ->
    expect($scope.user).not.toBeUndefined()
    expect($scope.user).toEqual { }

  it 'El scope user deberia contenet un elemento al consultarle un id despues de invocar el evento $emit "loaduserShow"', () ->
    expect($scope.user).not.toBeUndefined()
    $rootScope.$emit 'loadUserEmit', _id
    $timeout () ->
      expect($scope.user._id).toEqual _id
    , 1
