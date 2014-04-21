"use strict"

angular.module("movistarApp")
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


      update:
        method: "PUT"
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
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
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: '@id'
        url: '/api/v1/user/:id'

      index:
        method: "GET"
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
        data:
          role: '@role'
        url: '/api/v1/users'
        isArray: true

      groups:
        method: "GET"
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
        data:
          roles: '@roles'
        url: '/api/v1/users/groups'
        isArray: true

      updateProfile:
        method: 'PUT'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: '@id'
        data:
          user: '@user'
        url: '/api/v1/user/:id/update/profile'

      save:
        method: "POST"
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
        data:
          user: '@user'
        url: '/api/v1/user'
