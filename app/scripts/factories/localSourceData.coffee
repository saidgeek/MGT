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

  .factory "StateData", ->
    states =
      QUEUE_VALIDATION: "Espera de validación"
      QUEUE_ALLOCATION: "Espere de asignación"
      CANCEL: "Cancelada"
      QUEUE_PROVIDER: "Espera de proveedor"
      PROCCESS: "En proceso"
      QUEUE_VALIDATION_MANAGER: "Espera de validación del Gestor de contenido"
      PAUSE: "Pausada"
      REJECTED_BY_MANAGER: "Rechazada por el Gestor de contenido"
      OK_BY_MANAGER: "Aceptada por el Gestor de contenido"
      QUEUE_VALIDATION_CLIENT: "Espera de validación del cliente"
      REJECTED_BY_CLIENT: "Rechazado por Cliente"
      OK_BY_CLIENT: "Aceptado por Cliente"

    _makeArray = () ->
      _states = []
      for k,v of states
        _states.push { id: k, name: v }
      _states

    _get = (key) ->
      states[key]

    _getAll = () ->
      states

    return {
      getArray: () ->
        _makeArray()
      get: (key) ->
        _get(key)
      getAll: () ->
        _getAll()
    }

  .factory 'StateIconsData', ->
    icons =
      QUEUE_VALIDATION: "val"
      QUEUE_ALLOCATION: "esp"
      CANCEL: ""
      QUEUE_PROVIDER: "epr"
      PROCCESS: "pro"
      QUEUE_VALIDATION_MANAGER: "esp"
      PAUSE: "pau"
      REJECTED_BY_MANAGER: "atr"
      OK_BY_MANAGER: "fin"
      QUEUE_VALIDATION_CLIENT: "esp"
      REJECTED_BY_CLIENT: "atr"
      OK_BY_CLIENT: "fin"

    _get = (key) ->
      icons[key]

    _getAll = () ->
      icons

    return {
      get: (key) ->
        _get(key)
      getAll: () ->
        _getAll()
    }
