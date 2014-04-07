"use strict"

angular.module("movistarApp")
  .factory "SolicitudeFactory", (SolicitudeService, $rootScope) ->
    _clientToken = $rootScope.currentUser.access.clientToken
    _accessToken = $rootScope.currentUser.access.accessToken

    _index = (cb) ->
      SolicitudeService.index(
        clientToken: _clientToken
        accessToken: _accessToken
      , (solicitudes) ->
        cb null, solicitudes
      , (err) ->
        cb err.data
      ).$premise

    _show = (id, cb) ->
      SolicitudeService.show(
        clientToken: _clientToken
        accessToken: _accessToken
        id: id
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    _create = (data, cb) ->
      SolicitudeService.create(
        clientToken: _clientToken
        accessToken: _accessToken
        solicitude: data
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    _update = (id, data, cb) ->
      SolicitudeService(
        clientToken: _clientToken
        accessToken: _accessToken
        id: id
        solicitude: data
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    return {
      index: (cb) ->
        _index(cb)
      show: (id, cb) ->
        _show(id, cb)
      create: (data, cb) ->
        _create(data, cb)
      update: (id, data, cb) ->
        _update(id, data, cb)
    }
