'use strict'

describe 'Controller: UserSaveCtrl', () ->

  beforeEach module 'movistarApp'

  UserSaveCtrl = null
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

    _id = "533b959c3b642c708c3f0cbc"

    _form =
      '$validate': true

    UserSaveCtrl = $controller 'UserSaveCtrl', {
      '$scope': $scope
    }

  it 'El scope user deberia estar vacio', () ->
    expect($scope.user).not.toBeUndefined()
    expect($scope.user).toEqual { }

  it 'El scope roles deberia tener 6 elementos', () ->
    expect($scope.roles).not.toBeUndefined()
    $timeout () ->
      expect($scope.roles.length).toBe 6
    , 1

  it 'El scope user se deberia llenar despues de crear un usueario', () ->
    expect($scope.user).not.toBeUndefined()
    $scope.create(_form)
    $timeout () ->
      expect($scope.user.length).toBe 1
    , 1

  it 'El scope user deberia llenarse con los datos del usaurio encontrado con el id', () ->
    expect($scope.user).not.toBeUndefined()
    UserParams =
      id: _id
    $timeout () ->
      expect($scope.user.length).toBe 1
      expect($scope.user._id).toBe _id
    , 1

  it 'El scope user deberia llenarse con los datos del usaurio actualizado', () ->
    expect($scope.user).not.toBeUndefined()
    UserParams =
      id: _id
    $timeout () ->
      $scope.user.profile.firstName = 'Pepe'
      $scope.update(_form)
      expect($scope.user.length).toBe 1
      expect($scope.user._id).toBe _id
      expect($scope.user.profile.firstName).toBe 'Pepe'
    , 1
