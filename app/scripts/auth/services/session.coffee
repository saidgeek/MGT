'use strict'

angular.module('auth_app')
  .factory 'Session', ($resource) ->
    $resource '/session/'
