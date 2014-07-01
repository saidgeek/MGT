"use strict"

angular.module("movistarApp")
  .factory "User", ($resource, $rootScope) ->
    resource = $resource "", {},
      change:
        method: 'PUT'
        params:
          id: '@id'
        data:
          oldPassword: '@oldPassword'
          newPassword: '@newPassword'
          confirmPassword: '@confirmPassword'
        url: '/api/v1/user/:id/change/password'


      update:
        method: "PUT"
        params:
          id: "@id"
        url: '/api/v1/user/:id'
      get:
        method: "GET"
        params:
          id: "me"
        url: '/api/v1/user/:id'
      recovery:
        method: "PUT"
        params:
          id: "@id"
        url: "/api/v1/user/recovery"

      show:
        method: 'GET'
        params:
          id: '@id'
        url: '/api/v1/user/:id'

      index:
        method: "GET"
        data:
          role: '@role'
        url: '/api/v1/users'
        isArray: true

      groups:
        method: "GET"
        data:
          roles: '@roles'
        url: '/api/v1/users/groups'
        isArray: true

      updateProfile:
        method: 'PUT'
        params:
          id: '@id'
        data:
          user: '@user'
        url: '/api/v1/user/:id/update/profile'

      save:
        method: "POST"
        data:
          user: '@user'
        url: '/api/v1/user'

    _index = (role, cb) ->
      resource.index(
          role: role || $rootScope.currentUser?.permissions.roles
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
      resource.groups(
          roles: $rootScope.currentUser?.permissions.roles
        , (groups) ->
          groups = _makeGroups(groups)
          cb null, groups
        , (err) ->
          cb err.data
      ).$promise

    _show = (id, cb) ->
      resource.show(
        id: id
      , (user) ->
        cb null, user
      , (err) ->
        cb err.data
      ).$promise

    _update = (id, data, cb) ->
      resource.updateProfile(
        id: id
        user: data
      , (user) ->
        cb null, user
      , (err) ->
        cb err.data
      ).$promise

    _save = (data, cb) ->
      resource.save(
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
      resource: resource
    }

