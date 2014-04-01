"use strict"

angular.module("movistarApp")
  .factory "UserFactory", (UserService, $rootScope) ->

    _clientToken = $rootScope.currentUser.access.clientToken
    _accessToken = $rootScope.currentUser.access.accessToken

    _index = (role, cb) ->
      UserService.index(
          clientToken: _clientToken
          accessToken: _accessToken
          role: role
        , (users) ->
          cb null, users
        , (err) ->
          cb err.data
      ).$promise

    _makeGroups = (groups) ->
      result = {}
      _total = 0
      for g in groups
        result[g._id] = g.count
        _total += g.count
      result['total'] = _total
      result

    _groups = (cb) ->
      UserService.groups(
          clientToken: _clientToken
          accessToken: _accessToken
        , (groups) ->
          groups = _makeGroups(groups)
          cb null, groups
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

    _update = (id, data, cb) ->
      console.log data
      UserService.updateProfile(
        clientToken: _clientToken
        accessToken: _accessToken
        id: id
        user: data
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
      index: (role, cb) ->
        _index(role, cb)
      groups: (cb) ->
        _groups(cb)
      save: (data, cb) ->
        _save(data, cb)
      update: (id, data, cb) ->
        _update(id, data, cb)
      show: (id, cb) ->
        _show(id, cb)
    }

  .factory 'CategoryFactory', (CategoryService, $rootScope) ->

    _clientToken = $rootScope.currentUser.access.clientToken
    _accessToken = $rootScope.currentUser.access.accessToken

    _index = (cb) ->
      CategoryService.index(
          clientToken: _clientToken
          accessToken: _accessToken
        , (categories) ->
          cb null, categories
        , (err) ->
          cb err.data
      ).$promise

    _show = (id, cb) ->
      CategoryService.show(
          clientToken: _clientToken
          accessToken: _accessToken
          id: id
        , (category) ->
          cb null, category
        , (err) ->
          cb err.data
      ).$promise

    _save = (data, cb) ->
      CategoryService.save(
          clientToken: _clientToken
          accessToken: _accessToken
          category: data
        , (category) ->
          cb null, category
        , (err) ->
          cb err.data
      ).$promise

    _update = (id, data, cb) ->
      CategoryService.update(
          clientToken: _clientToken
          accessToken: _accessToken
          id: id
          category: data
        , (category) ->
          cb null, category
        , (err) ->
          cb err.data
      ).$promise

    return {
      index: (cb) ->
        _index(cb)
      show: (id, cb) ->
        _show(id, cb)
      save: (data, cb) ->
        _save(data, cb)
      update: (id, data, cb) ->
        _update(id, data, cb)
    }
