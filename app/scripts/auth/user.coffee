"use strict"

angular.module("auth_app")
  .factory "UserService", ($resource) ->
    $resource "", {},

      change:
        method: 'PUT'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: '@id'
        data:
          oldPassword: '@oldPassword'
          newPassword: '@newPassword'
          confirmPassword: '@confirmPassword'
        url: '/api/v1/user/:id/change/password'

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
