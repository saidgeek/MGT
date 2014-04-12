"use strict"

angular.module("movistarApp")
  .factory "SolicitudeFactory", (SolicitudeService, $rootScope) ->
    _clientToken = $rootScope.currentUser.access.clientToken
    _accessToken = $rootScope.currentUser.access.accessToken
    _states = $rootScope.currentUser.permissions.states

    _index = (state, category, priority, involved, cb) ->
      SolicitudeService.index(
        clientToken: _clientToken
        accessToken: _accessToken
        state: state || _states
        category: category
        priority: priority
        involved: involved
      , (solicitudes) ->
        cb null, solicitudes
      , (err) ->
        cb err.data
      ).$premise

    _makeGroups = (groups) ->
      result = {}
      _total = 0
      for g in groups
        result[g._id] = g.count
        _total += g.count
      result['total'] = _total
      result

    _groups = (cb) ->
      SolicitudeService.groups(
        clientToken: _clientToken
        accessToken: _accessToken
        states: _states
      , (groups) ->
        groups = _makeGroups(groups)
        cb null, groups
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
      SolicitudeService.update(
        clientToken: _clientToken
        accessToken: _accessToken
        id: id
        solicitude: data
      , (solicitude) ->
        cb null, solicitude
      , (err) ->
        cb err.data
      ).$promise

    _addComments = (id, comment, cb) ->
      SolicitudeService.addComments(
        clientToken: _clientToken
        accessToken: _accessToken
        id: id
        comment: comment
      , (solicitude) ->
        cb()
      , (err) ->
        cb err.data
      ).$promise

    return {
      index: (state, category, priority, involved, cb) ->
        _index(state, category, priority, involved, cb)
      groups: (cb) ->
        _groups(cb)
      show: (id, cb) ->
        _show(id, cb)
      create: (data, cb) ->
        _create(data, cb)
      update: (id, data, cb) ->
        _update(id, data, cb)
      addComments: (id, comment, cb) ->
        _addComments(id, comment, cb)
    }
