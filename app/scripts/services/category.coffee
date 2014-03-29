"use strict"

angular.module("movistarApp")
  .factory "CategoryService", ($resource) ->
    $resource "", {},
      index:
        method: "GET"
        params: 
          clientToken: '@clientToken'
          accessToken: '@accessToken'
        url: '/api/v1/categories'
        isArray: true

      show:
        method: 'GET'
        parmas:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: '@id'
        url: '/api/v1/category/:id'

      save:
        method: 'POST'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
        data:
          category: '@category'
        url: '/api/v1/category'

      update: 
        method: 'PUT'
        params:
          clientToken: '@clientToken'
          accessToken: '@accessToken'
          id: '@id'
        data:
          category: '@category'
        url: '/api/v1/category/:id'
        