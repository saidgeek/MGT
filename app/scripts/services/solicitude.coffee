"use strict"

angular.module("movistarApp")
  .factory "SolicitudeService", ($resource) ->
    $resource "", {},
      index:
        method: 'GET'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: '@id'
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
          attachments: '@attachments'
        url: '/api/v1/solicitude/:id/add/comments'

      addTasks:
        method: 'PUT'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: "@id"
        data:
          desc: '@desc'
          attachments: '@attachments'
        url: '/api/v1/solicitude/:id/add/tasks'

      toggleCheckTasks:
        method: 'PUT'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: "@id"
          task: "@task"
        url: '/api/v1/solicitude/:id/check/:task'
