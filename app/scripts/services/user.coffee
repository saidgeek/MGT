"use strict"

angular.module("movistarApp")
  .factory "User", ($resource) ->
    $resource "/api/v1/user/:id",
      id: "@id"
    ,
      update:
        method: "PUT"
        params: {}

      get:
        method: "GET"
        params:
          id: "me"

