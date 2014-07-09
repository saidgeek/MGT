"use strict"

angular.module("movistarApp")
  .factory "Task", ($resource, $rootScope) ->

    resource = $resource "", {},
      index:
        method: 'GET'
        params:
          solicitude_id: '@solicitude_id'
        url: '/api/v1/tasks/:solicitude_id'
        isArray: true

      create:
        method: 'POST'
        params:
          solicitude_id: '@solicitude_id'
        data:
          task: '@task'
          createdBy: '@createdBy'
        url: '/api/v1/tasks/:solicitude_id'

      toggle_completed:
        method: 'PUT'
        params:
          id: '@id'
        url: '/api/v1/tasks/:id'

    _index = (solicitude_id, cb) ->
      resource.index(
        solicitude_id: solicitude_id
      , (tasks) ->
        cb null, tasks
      , (err) ->
        cb err
      ).$promise

    _create = (solicitude_id, task, cb) ->
      resource.create(
        solicitude_id: solicitude_id
        task: task
        createdBy: $rootScope.currentUser.id
      , (task) ->
        cb null, task
      , (err) ->
        cb err
      ).$promise

    _toggle_completed = (id, cb) ->
      resource.toggle_completed(
        id: id
      , ->
        cb null
      , (err) ->
        cb err
      ).$promise

    return {
      index: (solicitude_id, cb) ->
        _index(solicitude_id, cb)
      create: (solicitude_id, task, cb) ->
        _create(solicitude_id, task, cb)
      toggle_completed: (id, cb) ->
        _toggle_completed(id, cb)
    }