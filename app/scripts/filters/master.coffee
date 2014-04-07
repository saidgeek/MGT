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
