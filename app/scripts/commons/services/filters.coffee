'use strict'

angular.module("movistarApp")
  .filter "AttReferer", (RolesData) ->
    return (key) ->
      return 'Comentarios' if key is 'comments'
      return 'Tareas' if key is 'tasks'

  .filter "RoleName", (RolesData) ->
    return (key) ->
      RolesData.get(key)

  .filter 'DateFrom', ($interval) ->
    (start, end) ->
      _start = moment(start)
      _end = moment(Date.now())
      $interval () =>
        return _end.from(_start)
      , 1000


  .filter 'DateFormat', ->
    (date) ->
      moment(date).format('DD-MM-YYYY HH:mm')

  .filter 'StateSolicitude', (StateData) ->
    (key) ->
      data = StateData.get(key)
      data.name

  .filter 'StateIcons', (StateData) ->
    (key) ->
      data = StateData.get(key)
      data.icon

  .filter 'PriorityIcons', (PriorityIconData) ->
    (key) ->
      PriorityIconData.get(key)

  .filter 'InvolvedRole', ->
    (key) ->
      role =
        ROOT: 'Cliente interno'
        ADMIN: 'Cliente interno'
        CLIENT: 'Cliente interno'
        EDITOR: 'Editor'
        CONTENT_MANAGER: 'Gestor de contenido'
        PROVIDER: 'Proveedor'

      role[key]

  .filter 'Priority', ->
    (key) ->
      priority =
        CRITIQUE: 'Crítica'
        HIGH: 'Alta'
        AVERAGE: 'Media'
        DECLINE: 'Baja'

      priority[key]

  .filter 'SegmentArray', ->
    (array) ->
      segments =
        PEOPLE: 'Personas'
        BUSINESS: 'Negocios'
        COMPANIES: 'Empresas'
      _segments = []
      for a in array
        _segments.push segments[a]

      _segments.join(', ')

  .filter 'Section', ->
    (key) ->
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

      sections[key]

  .filter 'Notification', ->
    (key) ->
      notifications =
        QUEUE_VALIDATION: 'Ha enviado nueva solicitud'
        QUEUE_ALLOCATION: 'Ha asignado una solicitud'
        QUEUE_PROVIDER: 'Ha asignado una solicitud'

      notifications[key]

  .filter 'RemoveThis', ->
    (arr, id) ->
      newArr = []
      for a in arr
        if a._id isnt id
          newArr.push a

      newArr

  .filter 'toMB', ->
    (number) ->
      Math.round((number / 1024), 2)
