"use strict"

angular.module("movistarApp")
  .factory "SolicitudeService", ($resource) ->
    $resource "", {},
      index:
        method: 'GET'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
        data:
          state: '@state'
          category: '@category'
          priority: '@priority'
          involved: '@involved'
        url: '/api/v1/solicitudes'
        isArray: true

      groups:
        method: "GET"
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          states: '@states'
        url: '/api/v1/solicitudes/groups'
        isArray: true

      show:
        method: 'GET'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: '@id'
        url: '/api/v1/solicitude/:id'

      create:
        method: 'POST'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
        data:
          solicitude: '@solicitude'
        url: '/api/v1/solicitude'

      update:
        method: "PUT"
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: "@id"
        data:
          solicitude: '@solicitude'
        url: '/api/v1/solicitude/:id'

      addComments:
        method: 'PUT'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: "@id"
        data:
          comment: '@comment'
        url: '/api/v1/solicitude/:id/add/comments'
