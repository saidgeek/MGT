'use strict'

describe 'Controller: CategorySaveCtrl', () ->

  beforeEach module 'movistarApp'

  CategorySaveCtrl = null
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

    _id = "533b959c3b642c708c3f0cbc"

    _form =
      '$validate': true

    CategorySaveCtrl = $controller 'CategorySaveCtrl', {
      '$scope': $scope
    }

  it 'El scope category deberia estar vacio', () ->
    expect($scope.category).not.toBeUndefined()
    expect($scope.category).toEqual { }

  it 'El scope category se deberia llenar despues de crear un usueario', () ->
    expect($scope.category).not.toBeUndefined()
    $scope.create(_form)
    $timeout () ->
      expect($scope.category.length).toBe 1
    , 1

  it 'El scope category deberia llenarse con los datos del usaurio encontrado con el id', () ->
    expect($scope.category).not.toBeUndefined()
    UserParams =
      id: _id
    $timeout () ->
      expect($scope.category.length).toBe 1
      expect($scope.category._id).toBe _id
    , 1

  it 'El scope category deberia llenarse con los datos del usaurio actualizado', () ->
    expect($scope.category).not.toBeUndefined()
    UserParams =
      id: _id
    $timeout () ->
      $scope.category.name = 'Unit test'
      $scope.update(_form)
      expect($scope.category.length).toBe 1
      expect($scope.category._id).toBe _id
      expect($scope.category.name).toBe 'Unit test'
    , 1
