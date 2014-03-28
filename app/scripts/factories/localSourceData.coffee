'use strict'

angular.module("movistarApp")
  .factory "RolesData", ->
    roles = 
      ROOT: 'Super administrador'
      ADMIN: 'Administrador'
      EDITOR: 'Editor'
      CONTENT_MANAGER: 'Gestor de contenido'
      PROVIDER: 'Proveedor'
      CLIENT: 'Cliente'

    _makeArray = () ->
      _roles = []
      for k,v of roles
        _roles.push { id: k, name: v }
      _roles

    _get = (key) ->
      roles[key]

    _getAll = () ->
      roles

    return {
      getArray: () ->
        _makeArray()
      get: (key) ->
        _get(key)
      getAll: () ->
        _getAll()
    }