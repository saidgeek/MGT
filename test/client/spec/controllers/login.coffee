'use strict'

describe 'Controller: LoginCtrl', () ->

  # load the controller's module
  beforeEach module 'movistarApp'

  MainCtrl = {}
  scope = {}

  # Initialize the controller and a mock scope
  beforeEach inject ($controller, $rootScope) ->
    scope = $rootScope.$new()
    MainCtrl = $controller 'LoginCtrl', {
      $scope: scope
    }

  it 'deberia estar el scope.user vacío', () ->
    expect(scope.user).toEqual { }

  it 'deberia estar el scope.errors vacío', () ->
    expect(scope.errors).toEqual { }    
