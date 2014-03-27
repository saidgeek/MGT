"use strict"

angular.module("movistarApp")
  .factory "UserService", ($resource) ->
    $resource "", {},
      update:
        method: "PUT"
        params: 
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
        url: '/api/v1/users'
        isArray: true

      save:
        method: "POST"
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
        data:
          user: '@user'
        url: '/api/v1/user'

