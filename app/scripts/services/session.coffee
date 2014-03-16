'use strict'

angular.module('movistarApp')
  .factory 'Session', ($resource) ->
    $resource '/session/'
