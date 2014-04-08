'use strict'

describe 'Controller: AdminCtrl', () ->

  # load the controller's module
  beforeEach module 'movistarApp'

  AdminCtrl = {}
  $location = null
  $rootScope = {}
  $scope = {}
  $controlelr = null
  $timeout = null

  # Initialize the controller and a mock scope
  beforeEach inject ($injector) ->
    $location = $injector.get '$location'
    $timeout = $injector.get '$timeout'
    $rootScope = $injector.get '$rootScope'
    $scope = $rootScope.$new()
    $controller = $injector.get '$controller'
    AdminCtrl = $controller 'AdminCtrl', {
      '$scope': $scope
    }

  it 'El rootScope title debería decir "Administración"', () ->
    expect($rootScope.title).toEqual 'Administración'

  it 'isActiveLink debería dar verdadero si el path es "/admin"', () ->
    $location.path '/admin'
    expect($location.path()).toBe '/admin'
    expect($scope.isActiveLink('/admin')).toBe true
    expect($scope.isActiveLink('/')).toBe false

  it 'El scope modals no deberia estar definido al inicio', () ->
    expect(typeof $scope.modals).toBe 'undefined'

  it 'El scope modals deberia estar definido y con valor "updateUser" despues de invocar el $emit del evento "showModals"', () ->
    expect(typeof $scope.modals).toBe 'undefined'
    $scope.$emit 'showModals', { modal: 'updateUser' }
    expect(typeof $scope.modals).not.toBe 'undefined'
    expect($scope.modals).toBe 'updateUser'

  it 'El scope de modals deberia tener un valor "" despues de invocar el $emit del evento "hideModals"', () ->
    expect(typeof $scope.modals).toBe 'undefined'
    $scope.$emit 'hideModals'
    expect(typeof $scope.modals).not.toBe 'undefined'
    expect($scope.modals).toBe ''

  it 'Si el path de la url es "/admin" el scope module deberia estar vacio', () ->
    expect(typeof $scope.module).not.toBe 'undefined'
    $location.path '/admin'
    expect($scope.module).toBe ''

  it 'Si el path de la url es "/admin/category" el scope module deberia ser "category"', () ->
    expect(typeof $scope.module).not.toBe 'undefined'
    $location.path '/admin/category'
    $timeout () ->
      expect($scope.module).toBe 'category'
    , 1
