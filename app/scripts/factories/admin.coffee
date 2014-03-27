"use strict"

angular.module("movistarApp")
  .factory "UserFactory", (UserService, $rootScope) ->

    _index = (cb) ->
      UserService.index(
          clientToken: $rootScope.currentUser.access.clientToken
          accessToken: $rootScope.currentUser.access.accessToken
        , (users) ->
          cb null, users
        , (err) ->
          cb err.data
      ).$promise

    return {
      index: (cb) ->
        _index(cb)
    }