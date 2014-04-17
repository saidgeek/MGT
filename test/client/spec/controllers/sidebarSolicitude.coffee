'use strict'

describe 'Controller: SidebarCtrl', () ->

  beforeEach module 'movistarApp'

  SidebarCtrl = null
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

    SidebarCtrl = $controller 'SidebarCtrl', {
      '$scope': $scope
    }

  it 'El scope statesGroups deberia tener items', () ->
    expect(typeof $scope.statesGroups).not.toBe 'undefined'
    $timeout () ->
      expect($scope.statesGroups).toBeGreaterThan 1
    , 1

  it 'El scope priorityGroups deberia tener items', () ->
    expect(typeof $scope.priorityGroups).not.toBe 'undefined'
    $timeout () ->
      expect($scope.priorityGroups).toBeGreaterThan 1
    , 1

  it 'El scope states deberia tener items', () ->
    expect(typeof $scope.states).not.toBe 'undefined'
    $timeout () ->
      expect($scope.states).toBeGreaterThan 1
    , 1

  it 'El scope priorities deberia tener items', () ->
    expect(typeof $scope.priorities).not.toBe 'undefined'
    $timeout () ->
      expect($scope.priorities).toBeGreaterThan 1
    , 1

  it 'El scope categories deberia tener items', () ->
    expect(typeof $scope.categories).not.toBe 'undefined'
    $timeout () ->
      expect($scope.categories).toBeGreaterThan 1
    , 1

  it 'El scope users deberia tener items', () ->
    expect(typeof $scope.users).not.toBe 'undefined'
    $timeout () ->
      expect($scope.users).toBeGreaterThan 1
    , 1

  it 'Al invocar el $emit reloadStates deberia recargar los statesGroups y priorityGroup', () ->
    $rootScope.$emit 'reloadStates'
    $timeout () ->
      expect(typeof $scope.statesGroups).not.toBe 'undefined'
      expect(typeof $scope.priorityGroups).not.toBe 'undefined'
      expect($scope.statesGroups).toBeGreaterThan 1
      expect($scope.priorityGroups).toBeGreaterThan 1
    , 1
