'use strict'

describe 'Controller: SidebarUsersCtrl', () ->

  beforeEach module 'movistarApp'

  SidebarUsersCtrl = null
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

    SidebarUsersCtrl = $controller 'SidebarUsersCtrl', {
      '$scope': $scope
    }

  it 'El scope groups deberia estar null', () ->
    expect(typeof $scope.groups).not.toBe 'undefined'
    expect($scope.groups).toBe null

  it 'El scope roles deberia estar definido y con tener 6 elementos', () ->
    expect(typeof $scope.roles).not.toBe 'undefined'
    expect($scope.roles.length).toBe 6

  it 'El scope groups deberia tener mas de un elemento',  () ->
    $timeout () ->
      expect($scope.groups).toBeGreaterThan 1
    , 1

  it 'El scope groups deberia tener mas de un elemento despues de invokar el $emit "reloadGroups"', () ->
    $rootScope.$emit 'reloadGroups'
    $timeout () ->
      expect($scope.groups).toBeGreaterThan 1
    , 1
