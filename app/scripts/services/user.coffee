"use strict"

angular.module("movistarApp")
  .factory "User", ($resource) ->
    $resource "",
      id: "@id"
    ,
      update:
        method: "PUT"
        params: {}
        url: '/api/v1/user/:id'

      get:
        method: "GET"
        params:
          id: "me"
        url: '/api/v1/user/:id'

      recovery:
        method: "PUT"
        params: {}
        url: "/api/v1/user/recovery"

