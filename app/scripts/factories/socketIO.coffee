"use strict"

angular.module("movistarApp")
  .factory "IO", (socketFactory) ->
    return socketFactory
      ioSocket: io.connect '/'
