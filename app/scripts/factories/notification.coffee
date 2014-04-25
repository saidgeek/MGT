"use strict"

angular.module("movistarApp")
  .factory "NotificationFactory", (NotificationService, $rootScope) ->
    _clientToken = $rootScope.currentUser.access.clientToken
    _accessToken = $rootScope.currentUser.access.accessToken

    _index = (cb) ->
      NotificationService.index(
        clientToken: _clientToken
        accessToken: _accessToken
        userId: $rootScope.currentUser.id
      , (notifications) ->
        cb null, notifications
      , (err) ->
        cb err.data
      ).$premise

    return {
      index: (cb) ->
        _index(cb)
    }
