"use strict"

angular.module("movistarApp")
  .factory "Notification", ($resource, $rootScope) ->
    resource = $resource "", {},
      index:
        method: 'GET'
        params:
          userId: '@userId'
        url: '/api/v1/notifications'
        isArray: true

      read:
        method: 'PUT'
        params:
          id: '@id'
        url: '/api/v1/notifications/:id'

      read_all:
        method: 'PUT'
        params:
          userId: '@userId'
        url: '/api/v1/notifications/read_all'

    _index = (cb) ->
      resource.index(
        userId: $rootScope.currentUser?.id
      , (notifications) ->
        cb null, notifications
      , (err) ->
        cb err.data
      ).$premise

    _read = (id, cb) ->
      resource.read(
        id: id
      , ->
        cb null
      , (err) ->
        cb err.data
      ).$premise

    _read_all = (cb) ->
      resource.read_all(
        userId: $rootScope.currentUser?.id
      , ->
        cb null
      , (err) ->
        cb err.data
      ).$premise

    return {
      index: (cb) ->
        _index(cb)
      read: (id, cb) ->
        _read(id, cb)
      read_all: (cb) ->
        _read_all(cb)
    }
