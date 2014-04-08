'use strict'

describe 'Controller: CategoryShowCtrl', () ->

  beforeEach module 'movistarApp'

  CategoryShowCtrl = null
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

    _id = "533b959c3b642c708c3f0cbc"

    CategoryShowCtrl = $controller 'CategoryShowCtrl', {
      '$scope': $scope
    }

  it 'El scope category deberia estar vacio', () ->
    expect($scope.category).not.toBeUndefined()
    expect($scope.category).toEqual { }

  it 'El scope category deberia contenet un elemento al consultarle un id despues de invocar el evento $emit "loadCategoryShow"', () ->
    expect($scope.category).not.toBeUndefined()
    $rootScope.$emit 'loadCategoryShow', _id
    $timeout () ->
      expect($scope.category._id).toEqual _id
    , 1
