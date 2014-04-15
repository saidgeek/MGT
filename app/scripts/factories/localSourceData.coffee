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
      QUEUE_VALIDATION: "Por validar" # esperando a que el editor lo valide
      QUEUE_ALLOCATION: "Por asignar" # esperando a que el gestor de contenido lo asigne a un proveedor
      CANCEL: "Cancelada" # el editor puede rechazar la solicitud
      QUEUE_PROVIDER: "Espera de proveedor"
      PROCCESS: "En proceso"
      QUEUE_VALIDATION_MANAGER: "Por validar (Gestor Contenido)"
      PAUSE: "Pausada"
      REJECTED_BY_MANAGER: "Rechazada (Gestor Contenido)"
      OK_BY_MANAGER: "Aceptada (Gestor Contenido)"
      QUEUE_VALIDATION_CLIENT: "Por validar (Cliente)"
      REJECTED_BY_CLIENT: "Rechazada (Cliente)"
      OK_BY_CLIENT: "Aceptada (Cliente)"

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
      QUEUE_VALIDATION_MANAGER: "valg"
      PAUSE: "pau"
      REJECTED_BY_MANAGER: "recg"
      OK_BY_MANAGER: "ceg"
      QUEUE_VALIDATION_CLIENT: "valc"
      REJECTED_BY_CLIENT: "recc"
      OK_BY_CLIENT: "acec"

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

  .factory 'PriorityData', ->
    priority =
      CRITIQUE: 'Crítica'
      HIGH: 'Alta'
      AVERAGE: 'Media'
      DECLINE: 'Baja'

    _makeArray = () ->
      _priority = []
      for k,v of priority
        _priority.push { id: k, name: v }
      _priority

    _get = (key) ->
      priority[key]

    _getAll = () ->
      priority

    return {
      getArray: () ->
        _makeArray()
      get: (key) ->
        _get(key)
      getAll: () ->
        _getAll()
    }

  .factory 'SegmentsData', ->
    segments =
      PEOPLE: 'Personas'
      BUSINESS: 'Negocios'
      COMPANIES: 'Empresas'

    _makeArray = () ->
      _segments = []
      for k,v of segments
        _segments.push { id: k, name: v }
      _segments

    _get = (key) ->
      segments[key]

    _getAll = () ->
      segments

    return {
      getArray: () ->
        _makeArray()
      get: (key) ->
        _get(key)
      getAll: () ->
        _getAll()
    }

  .factory 'SectionsData', ->
    sections =
      CELL_PHONE: 'Tel. Movil'
      DUOS_TRIOS: 'Duos y Trios'
      HOME_PHONE: 'Tel. Hogar'
      CLUB_MOVISTAR: 'Club Movistar'
      INTERNET: 'Internet'
      HARDWARE: 'Equipos'
      CEN_HELP: 'Cen. de Ayuda'
      SUC_VIRTUAL: 'Suc. Virtual'
      TV: 'Televisión'

    _makeArray = () ->
      _sections = []
      for k,v of sections
        _sections.push { id: k, name: v }
      _sections

    _get = (key) ->
      sections[key]

    _getAll = () ->
      sections

    return {
      getArray: () ->
        _makeArray()
      get: (key) ->
        _get(key)
      getAll: () ->
        _getAll()
    }
