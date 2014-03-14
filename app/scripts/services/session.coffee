'use strict'

angular.module('movistarApp')
  .factory 'Session', ($resource) ->
    $resource '/api/session/'
