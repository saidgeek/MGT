"use strict"

angular.module("movistarApp")
  .factory "NotificationService", ($resource) ->
    $resource "", {},
      index:
        method: 'GET'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          userId: '@userId'
        url: '/api/v1/notifications'
        isArray: true
