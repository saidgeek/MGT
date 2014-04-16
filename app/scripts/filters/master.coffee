'use strict'

angular.module("movistarApp")
  .filter "RoleName", (RolesData) ->
    return (key) ->
      RolesData.get(key)

  .filter 'DateFormat', ->
    (date) ->
      moment(date).format('DD-MM-YYYY')

  .filter 'StateSolicitude', (StateData) ->
    (key) ->
      StateData.get(key)

  .filter 'StateIcons', (StateIconsData) ->
    (key) ->
      StateIconsData.get(key)

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
