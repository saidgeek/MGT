'use strict'

describe 'Controller: CategoryCtrl', () ->

  beforeEach module 'movistarApp'

  CategoryCtrl = null
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

    CategoryCtrl = $controller 'CategoryCtrl', {
      '$scope': $scope
    }

  it 'El scope categories deberia estar con 0 elementos', () ->
    expect($scope.categories).not.toBeUndefined()
    expect($scope.categories.length).toBe 0

  it 'El scope categories se deberia cargar con mas de un elemento', () ->
    expect($scope.categories).not.toBeUndefined()
    $timeout () ->
      expect($scope.categories.length).toBeGreaterThan 1
    , 1

  it 'El scope categories se carga con mas de un elemento despues de invokar el evento $emit "reloadCategories"', () ->
    expect($scope.categories).not.toBeUndefined()
    $rootScope.$emit 'reloadCategories', ''
    $timeout () ->
      expect($scope.categories.length).toBeGreaterThan 1
    , 1

  it 'El scope categories se carga con mas de un elemento despues de invokar el evento $emit "reloadCategories" con role "ROOT"', () ->
    expect($scope.categories).not.toBeUndefined()
    $rootScope.$emit 'reloadCategories', 'ROOT'
    $timeout () ->
      expect($scope.categories.length).toBeGreaterThan 1
    , 1

  it 'El scope categories se carga con mas de un elemento despues de invokar el evento $emit "updateCategories"', () ->
    expect($scope.categories).not.toBeUndefined()
    $rootScope.$emit 'updateCategories', ''
    $timeout () ->
      expect($scope.categories.length).toBeGreaterThan 1
    , 1

  it 'El scope categories se carga con mas de un elemento despues de invokar el evento $emit "updateCategories" con role "ROOT"', () ->
    expect($scope.categories).not.toBeUndefined()
    $rootScope.$emit 'updateCategories', 'ROOT'
    $timeout () ->
      expect($scope.categories.length).toBeGreaterThan 1
    , 1
