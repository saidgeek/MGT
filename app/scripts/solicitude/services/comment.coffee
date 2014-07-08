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

    _index = (solicitude_id, cb) ->
      resource.index(
        solicitude_id: solicitude_id
      , (comments) ->
        cb null, comments
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

    return {
      index: (solicitude_id, cb) ->
        _index(solicitude_id, cb)
      create: (type, solicitude_id, to, comment, cb) ->
        _create(type, solicitude_id, to, comment, cb)
    }