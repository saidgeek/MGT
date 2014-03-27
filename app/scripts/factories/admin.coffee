"use strict"

angular.module("movistarApp")
  .factory "UserFactory", (UserService, $rootScope) ->

    _clientToken = $rootScope.currentUser.access.clientToken
    _accessToken = $rootScope.currentUser.access.accessToken

    _index = (cb) ->
      UserService.index(
          clientToken: _clientToken
          accessToken: _accessToken
        , (users) ->
          cb null, users
        , (err) ->
          cb err.data
      ).$promise

    _show = (id, cb) ->
      UserService.show(
        clientToken: _clientToken
        accessToken: _accessToken
        id: id
      , (user) ->
        cb null, user
      , (err) ->
        cb err.data
      ).$promise

    _save = (data, cb) ->
      UserService.save(
        clientToken: _clientToken
        accessToken: _accessToken
        user: data
      , (user) ->
        cb null, user
      , (err) ->
        cb err.data
      ).$promise

    return {
      index: (cb) ->
        _index(cb)
      save: (data, cb) ->
        _save(data, cb)
      show: (id, cb) ->
        _show(id, cb)
    }