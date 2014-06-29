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

    _index = (cb) ->
      resource.index(
        userId: $rootScope.currentUser?.id
      , (notifications) ->
        cb null, notifications
      , (err) ->
        cb err.data
      ).$premise

    return {
      index: (cb) ->
        _index(cb)
    }
