"use strict"

angular.module("movistarApp")
  .factory "Category", ($resource, $rootScope) ->
    resource = $resource "", {},
      index:
        method: "GET"
        url: '/api/v1/categories'
        isArray: true

      show:
        method: 'GET'
        params:
          id: '@id'
        url: '/api/v1/category/:id'

      save:
        method: 'POST'
        data:
          category: '@category'
        url: '/api/v1/category'

      update:
        method: 'PUT'
        params:
          id: '@id'
        data:
          category: '@category'
        url: '/api/v1/category/:id'

      remove:
        method: 'DELETE'
        params:
          id: '@id'
        data:
          category: '@category'
        url: '/api/v1/category/:id'

    _index = (cb) ->
      resource.index(
         {}
        , (categories) ->
          cb null, categories
        , (err) ->
          cb err.data
      ).$promise

    _show = (id, cb) ->
      resource.show(
          id: id
        , (category) ->
          cb null, category
        , (err) ->
          cb err.data
      ).$promise

    _save = (data, cb) ->
      resource.save(
          category: data
        , (category) ->
          cb null, category
        , (err) ->
          cb err.data
      ).$promise

    _update = (id, data, cb) ->
      resource.update(
          id: id
          category: data
        , (category) ->
          cb null, category
        , (err) ->
          cb err.data
      ).$promise

    _remove = (id, category, cb) ->
      resource.remove(
        id: id
        category: category
      , (category) ->
        cb(null, category)
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
      remove: (id, category, cb) ->
        _remove(id, category, cb)
      resource: resource
    }
