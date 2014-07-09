"use strict"

angular.module("movistarApp")
  .factory "Comment", ($resource, $rootScope) ->

    resource = $resource "", {},
      index:
        method: 'GET'
        params:
          solicitude_id: '@solicitude_id'
        url: '/api/v1/comments/:solicitude_id'
        isArray: true

      show:
        method: 'GET'
        params:
          id: '@id'
        url: '/api/v1/comment/:id'

      create:
        method: 'POST'
        params: 
          type: '@type'
          solicitude_id: '@solicitude_id'
          to: '@to'
        data:
          comment: '@comment'
          createdBy: '@createdBy'
        url: '/api/v1/comments/:type/:solicitude_id/:to'

      index_task:
        method: 'GET'
        params:
          id: '@id'
        url: '/api/v1/comments/task/:id'
        isArray: true

      task:
        method: 'POST'
        params:
          solicitude_id: '@solicitude_id'
          task_id: '@task_id'
        data:
          comment: '@comment'
          createdBy: '@createdBy'
        url: '/api/v1/comments/:solicitude_id/:task_id'

    _index = (solicitude_id, cb) ->
      resource.index(
        solicitude_id: solicitude_id
      , (comments) ->
        cb null, comments
      , (err) ->
        cb err
      ).$promise

    _show = (id, cb) ->
      resource.show(
        id: id
      , (comment) ->
        cb null, comment
      , (err) ->
        cb err
      ).$promise

    _create = (type, solicitude_id, to, comment, cb) ->
      resource.create(
        type: type
        solicitude_id: solicitude_id,
        to: to,
        comment: comment,
        createdBy: $rootScope.currentUser.id
      , (comment) ->
        cb null, comment
      , (err) ->
        cb err
      ).$promise

    _index_task = (id, cb) ->
      resource.index_task(
        id: id
      , (comments) ->
        cb null, comments
      , (err) ->
        cb err
      ).$promise

    _task = (solicitude_id, task_id, comment, cb) ->
      resource.task(
        solicitude_id: solicitude_id
        task_id: task_id
        comment: comment
        createdBy: $rootScope.currentUser.id
      , (comment) ->
        cb null, comment
      , (err) ->
        cb err
      ).$promise

    return {
      index: (solicitude_id, cb) ->
        _index(solicitude_id, cb)
      show: (id, cb) ->
        _show(id, cb)
      create: (type, solicitude_id, to, comment, cb) ->
        _create(type, solicitude_id, to, comment, cb)
      task: (solicitude_id, task_id, comment, cb) ->
        _task(solicitude_id, task_id, comment, cb)
      index_task: (id, cb) ->
        _index_task(id, cb)
    }