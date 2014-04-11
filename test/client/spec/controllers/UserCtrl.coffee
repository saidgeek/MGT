'use strict'

describe 'Controller: UserCtrl', () ->

  beforeEach module 'movistarApp'

  UserCtrl = null
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

    UserCtrl = $controller 'UserCtrl', {
      '$scope': $scope
    }

  it 'El scope users deberia estar con 0 elementos', () ->
    expect($scope.users).not.toBeUndefined()
    expect($scope.users.length).toBe 0

  it 'El scope users se deberia cargar con mas de un elemento', () ->
    expect($scope.users).not.toBeUndefined()
    $timeout () ->
      expect($scope.users.length).toBeGreaterThan 1
    , 1

  it 'El scope users se carga con mas de un elemento despues de invokar el evento $emit "reloadUsers"', () ->
    expect($scope.users).not.toBeUndefined()
    $rootScope.$emit 'reloadUsers', ''
    $timeout () ->
      expect($scope.users.length).toBeGreaterThan 1
    , 1

  it 'El scope users se carga con mas de un elemento despues de invokar el evento $emit "reloadUsers" con role "ROOT"', () ->
    expect($scope.users).not.toBeUndefined()
    $rootScope.$emit 'reloadUsers', 'ROOT'
    $timeout () ->
      expect($scope.users.length).toBeGreaterThan 1
    , 1

  it 'El scope users se carga con mas de un elemento despues de invokar el evento $emit "updateUsers"', () ->
    expect($scope.users).not.toBeUndefined()
    $rootScope.$emit 'updateUsers', ''
    $timeout () ->
      expect($scope.users.length).toBeGreaterThan 1
    , 1

  it 'El scope users se carga con mas de un elemento despues de invokar el evento $emit "updateUsers" con role "ROOT"', () ->
    expect($scope.users).not.toBeUndefined()
    $rootScope.$emit 'updateUsers', 'ROOT'
    $timeout () ->
      expect($scope.users.length).toBeGreaterThan 1
    , 1
