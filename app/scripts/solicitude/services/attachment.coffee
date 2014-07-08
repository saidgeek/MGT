"use strict"

angular.module("movistarApp")
  .factory "Attachment", ($resource, $rootScope) ->

    resource = $resource "", {},
      index:
        method: 'GET'
        params:
          solicitude_id: '@solicitude_id'
        url: '/api/v1/attachments/:solicitude_id'
        isArray: true

    _index = (solicitude_id, cb) ->
      resource.index(
        solicitude_id: solicitude_id
      , (attachments) ->
        cb null, attachments
      , (err) ->
        cb err
      ).$promise

    return {
      index: (solicitude_id, cb) ->
        _index(solicitude_id, cb)
    }