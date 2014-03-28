'use strict'

angular.module("movistarApp")
  .filter "RoleName", (RolesData) ->
    return (key) ->
      RolesData.get(key)