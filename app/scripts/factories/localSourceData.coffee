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

  .factory 'AllStateData', ($rootScope) ->
    states =
      QUEUE_VALIDATION:
        ROOT: 'QUEUE_VALIDATION'
        ADMIN: 'QUEUE_VALIDATION'
        CLIENT: 'QUEUE_VALIDATION'
        EDITOR: 'QUEUE_VALIDATION'
      CANCELED:
        ROOT: 'CANCELED'
        ADMIN: 'CANCELED'
        CLIENT: 'CANCELED'
        EDITOR: 'CANCELED'
      ASSIGNED_TO_MANAGER:
        ROOT: 'ASSIGNED_TO_MANAGER'
        ADMIN: 'ASSIGNED_TO_MANAGER'
        CLIENT: 'ACCEPTED'
        EDITOR: 'ASSIGNED'
        CONTENT_MANAGER: 'ASSIGNED'
      ASSIGNED_TO_PROVIDER:
        ROOT: 'ASSIGNED_TO_PROVIDER'
        ADMIN: 'ASSIGNED_TO_PROVIDER'
        CLIENT: 'ACCEPTED'
        EDITOR: 'ASSIGNED_TO_PROVIDER'
        CONTENT_MANAGER: 'QUEUE_PROVIDER'
        PROVIDER: 'ASSIGNED'
      PROCCESS:
        ROOT: 'PROCCESS'
        ADMIN: 'PROCCESS'
        CLIENT: 'PROCCESS'
        EDITOR: 'PROCCESS'
        CONTENT_MANAGER: 'PROCCESS'
        PROVIDER: 'PROCCESS'
      PAUSED:
        ROOT: 'PAUSED'
        ADMIN: 'PAUSED'
        CLIENT: 'PAUSED'
        EDITOR: 'PAUSED'
        CONTENT_MANAGER: 'PAUSED'
        PROVIDER: 'PAUSED'
      QUEUE_VALIDATION_MANAGER:
        ROOT: 'QUEUE_VALIDATION_MANAGER'
        ADMIN: 'QUEUE_VALIDATION_MANAGER'
        CLIENT: 'PROCCESS'
        EDITOR: 'PROCCESS'
        CONTENT_MANAGER: 'FOR_VALIDATION'
        PROVIDER: 'QUEUE_VALIDATION'
      ACCEPTED_BY_MANAGER:
        ROOT: 'ACCEPTED_BY_MANAGER'
        ADMIN: 'ACCEPTED_BY_MANAGER'
        CLIENT: 'FOR_VALIDATION'
        EDITOR: 'PROCCESS'
        CONTENT_MANAGER: 'QUEUE_VALIDATION'
        PROVIDER: 'QUEUE_VALIDATION'
      REJECTED_BY_MANAGER:
        ROOT: 'REJECTED_BY_MANAGER'
        ADMIN: 'REJECTED_BY_MANAGER'
        CLIENT: 'PROCCESS'
        EDITOR: 'PROCCESS'
        CONTENT_MANAGER: 'QUEUE_CHANGE'
        PROVIDER: 'FOR_CHANGE'
      QUEUE_VALIDATION_CLIENT:
        ROOT: 'QUEUE_VALIDATION_CLIENT'
        ADMIN: 'QUEUE_VALIDATION_CLIENT'
        CLIENT: 'FOR_VALIDATION'
        EDITOR: 'PROCCESS'
        CONTENT_MANAGER: 'QUEUE_VALIDATION'
        PROVIDER: 'QUEUE_VALIDATION'
      ACCEPTED_BY_CLIENT:
        ROOT: 'ACCEPTED_BY_CLIENT'
        ADMIN: 'ACCEPTED_BY_CLIENT'
        CLIENT: 'ACCEPTED'
        EDITOR: 'PROCCESS'
        CONTENT_MANAGER: 'ACCEPTED'
        PROVIDER: 'ACCEPTED'
      REJECTED_BY_CLIENT:
        ROOT: 'REJECTED_BY_CLIENT'
        ADMIN: 'REJECTED_BY_CLIENT'
        CLIENT: 'REJECTED'
        EDITOR: 'PROCCESS'
        CONTENT_MANAGER: 'REJECTED'
      COMPLETED:
        ROOT: 'COMPLETED'
        ADMIN: 'COMPLETED'
        CLIENT: 'COMPLETED'
        EDITOR: 'COMPLETED'
        CONTENT_MANAGER: 'COMPLETED'
        PROVIDER: 'COMPLETED'

    _getAll = () ->
      _states = []
      for k,v of states
        _states.push { id: k, name: v[$rootScope.currentUser.role] }
      _states

    return {
      getAll: () ->
        _getAll()
    }

  .factory "StateData", ->
    states =
      ASSIGNED_TO_MANAGER:
        name: 'Asignado a gestor'
        icon: 'asi'
      ASSIGNED_TO_PROVIDER:
        name: 'Asignado a proveedor'
        icon: 'asi'
      QUEUE_VALIDATION_MANAGER:
        name: 'Espera validacion gestor'
        icon: 'valg'
      ACCEPTED_BY_MANAGER:
        name: 'Aceptada por gestor'
        icon: 'aceg'
      REJECTED_BY_MANAGER:
        name: 'Rechazada por gestor'
        icon: 'recg'
      QUEUE_VALIDATION_CLIENT:
        name: 'Espera validacion cliente'
        icon: 'valc'
      ACCEPTED_BY_CLIENT:
        name: 'Aceptada por cliente'
        icon: 'acec'
      REJECTED_BY_CLIENT:
        name: 'Rechazada por cliente'
        icon: 'recc'
      QUEUE_VALIDATION:
        name: 'Espera validacion'
        icon: 'val'
      CANCELED:
        name: 'Cancelada'
        icon: 'can'
      ACCEPTED:
        name: 'Aceptada'
        icon: 'aceg'
      ASSIGNED:
        name: 'Asignada'
        icon: 'asi'
      QUEUE_PROVIDER:
        name: 'Espera de proveedor'
        icon: 'epr'
      PROCCESS:
        name: 'En proceso'
        icon: 'pro'
      PAUSED:
        name: 'Pausada'
        icon: 'pau'
      FOR_VALIDATION:
        name: 'Por validacion'
        icon: 'valg'
      QUEUE_CHANGE:
        name: 'Espera cambios'
        icon: 'valg'
      FOR_CHANGE:
        name: 'Por cambios'
        icon: 'valg'
      REJECTED:
        name: 'Rechazada'
        icon: 'recg'
      QUEUE_PUBLISH:
        name: 'Espera publicación'
        icon: 'valg'
      PUBLISH:
        name: 'Publicada'
        icon: 'aceg'
      COMPLETED:
        name: 'Completada'
        icon: 'fin'
      REACTIVATED:
        name: 'Reactivado'
        icon: 'val'

    _makeArray = () ->
      _states = []
      for k,v of states
        _states.push { id: k, name: v.name, icon: v.icon }
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

  .factory 'PriorityIconData', ->
    icons =
      CRITIQUE: 'cri'
      HIGH: 'alt'
      AVERAGE: 'med'
      DECLINE: 'baj'

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
      HOME: 'Home'
      DEALS_LIKES: 'Ofertas que le gustan'
      FOOTER: 'Footer'

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
